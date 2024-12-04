<template>
  <div class="stats-container">
    <el-card class="chart-card">
      <template #header>
        <div class="card-header">
          <span>任务完成情况</span>
          <el-button-group>
            <el-button :type="timeRange === 'week' ? 'primary' : ''" @click="timeRange = 'week'">周</el-button>
            <el-button :type="timeRange === 'month' ? 'primary' : ''" @click="timeRange = 'month'">月</el-button>
          </el-button-group>
        </div>
      </template>
      <div ref="completionChart" style="height: 300px;"></div>
    </el-card>

    <div class="stats-grid">
      <el-card class="stat-card">
        <template #header>
          <div class="card-header">
            <span>任务分布</span>
          </div>
        </template>
        <div ref="distributionChart" style="height: 200px;"></div>
      </el-card>

      <el-card class="stat-card">
        <template #header>
          <div class="card-header">
            <span>完成率趋势</span>
          </div>
        </template>
        <div ref="trendChart" style="height: 200px;"></div>
      </el-card>
    </div>

    <el-card class="summary-card">
      <template #header>
        <div class="card-header">
          <span>统计摘要</span>
        </div>
      </template>
      <el-row :gutter="20">
        <el-col :span="8">
          <el-statistic title="总任务数" :value="totalTasks">
            <template #suffix>
              <el-icon><Calendar /></el-icon>
            </template>
          </el-statistic>
        </el-col>
        <el-col :span="8">
          <el-statistic title="完成率" :value="completionRate" :precision="2" suffix="%">
            <template #suffix>
              <el-icon><Check /></el-icon>
            </template>
          </el-statistic>
        </el-col>
        <el-col :span="8">
          <el-statistic title="重要任务" :value="importantTasks">
            <template #suffix>
              <el-icon><Star /></el-icon>
            </template>
          </el-statistic>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
import { ref, onMounted, watch, computed } from 'vue'
import * as echarts from 'echarts'
import { Calendar, Check, Star } from '@element-plus/icons-vue'

export default {
  components: {
    Calendar,
    Check,
    Star
  },
  props: {
    todos: {
      type: Array,
      required: true
    }
  },
  setup(props) {
    const timeRange = ref('week')
    const completionChart = ref(null)
    const distributionChart = ref(null)
    const trendChart = ref(null)
    let charts = []

    // 模拟历史数据
    const generateHistoryData = (days) => {
      const data = []
      const now = new Date()
      for (let i = days - 1; i >= 0; i--) {
        const date = new Date(now)
        date.setDate(date.getDate() - i)
        data.push({
          date: date.toLocaleDateString(),
          completed: Math.floor(Math.random() * 8),
          added: Math.floor(Math.random() * 10)
        })
      }
      return data
    }

    const initCompletionChart = () => {
      const chart = echarts.init(completionChart.value)
      const historyData = generateHistoryData(timeRange.value === 'week' ? 7 : 30)
      
      const option = {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        legend: {
          data: ['新增任务', '完成任务']
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: historyData.map(item => item.date)
        },
        yAxis: {
          type: 'value'
        },
        series: [
          {
            name: '新增任务',
            type: 'bar',
            data: historyData.map(item => item.added),
            color: '#95a5a6'
          },
          {
            name: '完成任务',
            type: 'bar',
            data: historyData.map(item => item.completed),
            color: '#2ecc71'
          }
        ]
      }
      
      chart.setOption(option)
      charts.push(chart)
    }

    const initDistributionChart = () => {
      const chart = echarts.init(distributionChart.value)
      
      const option = {
        tooltip: {
          trigger: 'item'
        },
        legend: {
          orient: 'vertical',
          right: '5%',
          top: 'middle'
        },
        series: [
          {
            name: '任务状态',
            type: 'pie',
            radius: ['40%', '70%'],
            center: ['40%', '50%'],
            data: [
              { value: props.todos.filter(t => t.completed).length, name: '已完成' },
              { value: props.todos.filter(t => !t.completed).length, name: '待完成' },
              { value: props.todos.filter(t => t.important).length, name: '重要' }
            ],
            label: {
              show: true,
              position: 'inside',
              formatter: '{d}%'
            },
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
              }
            }
          }
        ]
      }
      
      chart.setOption(option)
      charts.push(chart)
    }

    const initTrendChart = () => {
      const chart = echarts.init(trendChart.value)
      const historyData = generateHistoryData(7)
      
      const option = {
        tooltip: {
          trigger: 'axis'
        },
        xAxis: {
          type: 'category',
          data: historyData.map(item => item.date)
        },
        yAxis: {
          type: 'value',
          max: 100,
          axisLabel: {
            formatter: '{value}%'
          }
        },
        series: [
          {
            data: historyData.map(() => (Math.random() * 30 + 70).toFixed(2)),
            type: 'line',
            smooth: true,
            areaStyle: {
              opacity: 0.3
            },
            color: '#3498db'
          }
        ]
      }
      
      chart.setOption(option)
      charts.push(chart)
    }

    const initCharts = () => {
      charts.forEach(chart => chart.dispose())
      charts = []
      
      initCompletionChart()
      initDistributionChart()
      initTrendChart()
    }

    onMounted(() => {
      initCharts()
      window.addEventListener('resize', initCharts)
    })

    watch(timeRange, initCharts)
    watch(() => props.todos, initCharts, { deep: true })

    const totalTasks = computed(() => props.todos.length)
    const completionRate = computed(() => {
      if (props.todos.length === 0) return 0
      return (props.todos.filter(t => t.completed).length / props.todos.length * 100).toFixed(2)
    })
    const importantTasks = computed(() => props.todos.filter(t => t.important).length)

    return {
      timeRange,
      completionChart,
      distributionChart,
      trendChart,
      totalTasks,
      completionRate,
      importantTasks
    }
  }
}
</script>

<style scoped>
.stats-container {
  margin-top: 2rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.chart-card {
  margin-bottom: 1rem;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.summary-card {
  margin-top: 1rem;
}

:deep(.el-card__header) {
  padding: 12px 20px;
  font-weight: bold;
}
</style> 