From: kernel test robot <rong.a.chen@intel.com>
Subject: [LKP] [net/sock]  b99259a614:  netperf.Throughput_Mbps -6.6%
 regression
Date: Tue, 18 Sep 2018 17:37:22 +0800
Message-ID: <20180918093722.GS7632@shao2-debian>
References: <20180906192034.8467-1-olof@lixom.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tgGnixv3tJWXBxdL"
Content-Transfer-Encoding: 8bit
Cc: Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net, kernel-team@fb.com,
        Olof Johansson <olof@lixom.net>, lkp@01.org
To: Olof Johansson <olof@lixom.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180906192034.8467-1-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--tgGnixv3tJWXBxdL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Greeting,

FYI, we noticed a -6.6% regression of netperf.Throughput_Mbps due to commit:


commit: b99259a61450bb6403bbbbf279f8754a441eae8b ("[PATCH] net/sock: move memory_allocated over to percpu_counter variables")
url: https://github.com/0day-ci/linux/commits/Olof-Johansson/net-sock-move-memory_allocated-over-to-percpu_counter-variables/20180907-095536


in testcase: netperf
on test machine: 8 threads Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz with 8G memory
with following parameters:

	ip: ipv4
	runtime: 300s
	nr_threads: 200%
	cluster: cs-localhost
	send_size: 5K
	test: TCP_SENDFILE
	ucode: 0x25
	cpufreq_governor: performance

test-description: Netperf is a benchmark that can be use to measure various aspect of networking performance.
test-url: http://www.netperf.org/netperf/

In addition to that, the commit also has significant impact on the following tests:

+------------------+-----------------------------------------------------------------------+
| testcase: change | netperf: netperf.Throughput_total_tps -49.3% improvement              |
| test machine     | 88 threads Intel(R) Xeon(R) CPU E5-2699 v4 @ 2.20GHz with 128G memory |
| test parameters  | cluster=cs-localhost                                                  |
|                  | cpufreq_governor=performance                                          |
|                  | ip=ipv4                                                               |
|                  | nr_threads=50%                                                        |
|                  | runtime=300s                                                          |
|                  | test=UDP_RR                                                           |
+------------------+-----------------------------------------------------------------------+
| testcase: change | netperf: netperf.Throughput_total_tps -13.5% improvement              |
| test machine     | 88 threads Intel(R) Xeon(R) CPU E5-2699 v4 @ 2.20GHz with 128G memory |
| test parameters  | cluster=cs-localhost                                                  |
|                  | cpufreq_governor=performance                                          |
|                  | ip=ipv4                                                               |
|                  | nr_threads=25%                                                        |
|                  | runtime=300s                                                          |
|                  | test=UDP_RR                                                           |
+------------------+-----------------------------------------------------------------------+


Details are as below:
-------------------------------------------------------------------------------------------------->


To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp install job.yaml  # job file is attached in this email
        bin/lkp run     job.yaml

=========================================================================================
cluster/compiler/cpufreq_governor/ip/kconfig/nr_threads/rootfs/runtime/send_size/tbox_group/test/testcase/ucode:
  cs-localhost/gcc-7/performance/ipv4/x86_64-rhel-7.2/200%/debian-x86_64-2018-04-03.cgz/300s/5K/lkp-hsw-d01/TCP_SENDFILE/netperf/0x25

commit: 
  6da410d97f (" mlx5e-fixes-2018-09-05")
  b99259a614 ("net/sock: move memory_allocated over to percpu_counter variables")

6da410d97ffa486e b99259a61450bb6403bbbbf279 
---------------- -------------------------- 
       fail:runs  %reproduction    fail:runs
           |             |             |    
          1:4          -25%            :4     dmesg.RIP:drm_wait_one_vblank[drm]
          1:4          -25%            :4     dmesg.WARNING:at_drivers/gpu/drm/drm_vblank.c:#drm_wait_one_vblank[drm]
           :4           25%           1:4     dmesg.WARNING:at_ip_fsnotify/0x
          1:4          -25%            :4     kmsg.drm:drm_atomic_helper_wait_for_dependencies[drm_kms_helper]]*ERROR*[CONNECTOR:#:VGA-#]flip_done_timed_out
          1:4          -25%            :4     kmsg.drm:drm_atomic_helper_wait_for_dependencies[drm_kms_helper]]*ERROR*[CRTC:#:pipe_A]flip_done_timed_out
          1:4          -25%            :4     kmsg.drm:drm_atomic_helper_wait_for_dependencies[drm_kms_helper]]*ERROR*[PLANE:#:primary_A]flip_done_timed_out
          1:4          -25%            :4     kmsg.drm:drm_atomic_helper_wait_for_flip_done[drm_kms_helper]]*ERROR*[CRTC:#:pipe_A]flip_done_timed_out
          0:4            0%           0:4     perf-profile.children.cycles-pp.schedule_timeout
         %stddev     %change         %stddev
             \          |                \  
      7990            -6.6%       7460        netperf.Throughput_Mbps
    127841            -6.6%     119362        netperf.Throughput_total_Mbps
   1874683            -2.1%    1835777        netperf.time.involuntary_context_switches
    643.25            +1.3%     651.50        netperf.time.percent_of_cpu_this_job_got
      1792            +2.1%       1830        netperf.time.system_time
    144.93            -8.1%     133.19        netperf.time.user_time
   1099277            -7.7%    1014302        netperf.time.voluntary_context_switches
 9.363e+08            -6.6%  8.742e+08        netperf.workload
     30722            -4.2%      29428        vmstat.system.cs
     25888 ± 31%     +77.6%      45981 ± 25%  sched_debug.cfs_rq:/.min_vruntime.stddev
     25888 ± 31%     +77.6%      45981 ± 25%  sched_debug.cfs_rq:/.spread0.stddev
      7151 ±  4%     -20.0%       5720 ±  5%  slabinfo.anon_vma_chain.active_objs
      7409 ±  3%     -21.7%       5804 ±  6%  slabinfo.anon_vma_chain.num_objs
     38618 ± 10%     -31.7%      26365 ± 22%  turbostat.C1E
      0.13 ± 15%      -0.1        0.08 ± 44%  turbostat.C1E%
    161917 ±  4%     -24.6%     122121 ± 15%  cpuidle.C1.time
   3215895 ± 15%     -38.8%    1966692 ± 43%  cpuidle.C1E.time
     38639 ± 10%     -31.8%      26368 ± 22%  cpuidle.C1E.usage
 1.305e+12            -1.4%  1.287e+12        perf-stat.branch-instructions
      3.00            -0.0        2.97        perf-stat.branch-miss-rate%
  3.92e+10            -2.5%  3.822e+10        perf-stat.branch-misses
      0.69 ±  9%      -0.2        0.51 ± 14%  perf-stat.cache-miss-rate%
   2.1e+10           +17.9%  2.477e+10        perf-stat.cache-references
   9364894            -4.2%    8976073        perf-stat.context-switches
      1.31            +2.0%       1.33        perf-stat.cpi
      0.09            -0.0        0.08        perf-stat.dTLB-load-miss-rate%
  2.02e+09           -15.8%  1.701e+09        perf-stat.dTLB-load-misses
 2.201e+12            -3.0%  2.135e+12        perf-stat.dTLB-loads
  1.38e+12            -4.1%  1.325e+12        perf-stat.dTLB-stores
 4.827e+08 ±  8%     -19.0%  3.908e+08 ±  9%  perf-stat.iTLB-loads
 6.749e+12            -1.9%   6.62e+12        perf-stat.instructions
      0.76            -1.9%       0.75        perf-stat.ipc
      7207            +5.1%       7572        perf-stat.path-length
     18.44            -1.4       17.04        perf-profile.calltrace.cycles-pp.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
     18.46            -1.4       17.06        perf-profile.calltrace.cycles-pp.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
     18.25            -1.4       16.86        perf-profile.calltrace.cycles-pp.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
     18.17            -1.4       16.80        perf-profile.calltrace.cycles-pp.tcp_recvmsg.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64
     13.45            -1.2       12.24        perf-profile.calltrace.cycles-pp.skb_copy_datagram_iter.tcp_recvmsg.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom
     12.68            -1.1       11.57        perf-profile.calltrace.cycles-pp.copy_page_to_iter.skb_copy_datagram_iter.tcp_recvmsg.inet_recvmsg.__sys_recvfrom
     11.95            -0.9       11.00 ±  2%  perf-profile.calltrace.cycles-pp.generic_file_splice_read.splice_direct_to_actor.do_splice_direct.do_sendfile.__x64_sys_sendfile64
      9.53 ±  2%      -0.9        8.68        perf-profile.calltrace.cycles-pp.copyout.copy_page_to_iter.skb_copy_datagram_iter.tcp_recvmsg.inet_recvmsg
      9.35 ±  2%      -0.8        8.54        perf-profile.calltrace.cycles-pp.copy_user_enhanced_fast_string.copyout.copy_page_to_iter.skb_copy_datagram_iter.tcp_recvmsg
      9.50            -0.8        8.73 ±  2%  perf-profile.calltrace.cycles-pp.generic_file_read_iter.generic_file_splice_read.splice_direct_to_actor.do_splice_direct.do_sendfile
     10.73 ±  2%      -0.5       10.21        perf-profile.calltrace.cycles-pp.__tcp_push_pending_frames.do_tcp_sendpages.tcp_sendpage_locked.tcp_sendpage.inet_sendpage
     10.56 ±  2%      -0.4       10.11        perf-profile.calltrace.cycles-pp.tcp_write_xmit.__tcp_push_pending_frames.do_tcp_sendpages.tcp_sendpage_locked.tcp_sendpage
      2.99 ±  3%      -0.4        2.59 ±  4%  perf-profile.calltrace.cycles-pp.security_file_permission.do_splice_direct.do_sendfile.__x64_sys_sendfile64.do_syscall_64
      4.94 ±  2%      -0.3        4.60 ±  3%  perf-profile.calltrace.cycles-pp.security_file_permission.do_sendfile.__x64_sys_sendfile64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.70 ± 14%      -0.3        0.43 ± 58%  perf-profile.calltrace.cycles-pp.__inode_security_revalidate.selinux_file_permission.security_file_permission.do_splice_direct.do_sendfile
      3.04 ±  2%      -0.3        2.77 ±  4%  perf-profile.calltrace.cycles-pp.do_splice_to.splice_direct_to_actor.do_splice_direct.do_sendfile.__x64_sys_sendfile64
      2.62 ±  3%      -0.2        2.39 ±  2%  perf-profile.calltrace.cycles-pp.pagecache_get_page.generic_file_read_iter.generic_file_splice_read.splice_direct_to_actor.do_splice_direct
      2.31 ±  2%      -0.2        2.09 ±  2%  perf-profile.calltrace.cycles-pp.find_get_entry.pagecache_get_page.generic_file_read_iter.generic_file_splice_read.splice_direct_to_actor
      1.52 ±  5%      -0.2        1.31 ±  8%  perf-profile.calltrace.cycles-pp.selinux_file_permission.security_file_permission.do_splice_direct.do_sendfile.__x64_sys_sendfile64
      1.14 ±  4%      -0.2        0.93 ± 10%  perf-profile.calltrace.cycles-pp.__fget_light.do_sendfile.__x64_sys_sendfile64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.88 ±  2%      -0.2        1.68        perf-profile.calltrace.cycles-pp.lock_sock_nested.tcp_sendpage.inet_sendpage.kernel_sendpage.sock_sendpage
      1.11 ± 16%      -0.2        0.92 ±  3%  perf-profile.calltrace.cycles-pp.__kfree_skb.tcp_recvmsg.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom
      3.21            -0.2        3.02 ±  2%  perf-profile.calltrace.cycles-pp.syscall_return_via_sysret
      0.74 ± 23%      -0.2        0.56 ±  6%  perf-profile.calltrace.cycles-pp.skb_release_data.__kfree_skb.tcp_recvmsg.inet_recvmsg.__sys_recvfrom
      1.19 ±  7%      -0.2        1.02 ±  5%  perf-profile.calltrace.cycles-pp.file_has_perm.security_file_permission.do_splice_direct.do_sendfile.__x64_sys_sendfile64
      1.20 ±  3%      -0.1        1.05 ±  5%  perf-profile.calltrace.cycles-pp.__might_fault.copy_page_to_iter.skb_copy_datagram_iter.tcp_recvmsg.inet_recvmsg
      1.19 ±  5%      -0.1        1.06 ±  6%  perf-profile.calltrace.cycles-pp.file_has_perm.security_file_permission.do_sendfile.__x64_sys_sendfile64.do_syscall_64
      0.80 ±  4%      -0.1        0.68        perf-profile.calltrace.cycles-pp.___might_sleep.__might_fault.copy_page_to_iter.skb_copy_datagram_iter.tcp_recvmsg
      0.90 ±  6%      -0.1        0.78 ±  6%  perf-profile.calltrace.cycles-pp.atime_needs_update.touch_atime.splice_direct_to_actor.do_splice_direct.do_sendfile
      0.71 ±  2%      -0.1        0.61 ±  5%  perf-profile.calltrace.cycles-pp.sched_clock_cpu.tcp_write_xmit.__tcp_push_pending_frames.do_tcp_sendpages.tcp_sendpage_locked
      1.07 ±  3%      -0.1        0.96 ±  3%  perf-profile.calltrace.cycles-pp.radix_tree_lookup_slot.find_get_entry.pagecache_get_page.generic_file_read_iter.generic_file_splice_read
      0.74 ±  6%      -0.1        0.64 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_bh.release_sock.tcp_sendpage.inet_sendpage.kernel_sendpage
      0.63 ±  3%      -0.1        0.55 ±  6%  perf-profile.calltrace.cycles-pp.native_sched_clock.sched_clock.sched_clock_cpu.tcp_write_xmit.__tcp_push_pending_frames
      0.70 ±  3%      -0.1        0.63 ±  4%  perf-profile.calltrace.cycles-pp.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pending_frames.tcp_rcv_established.tcp_v4_do_rcv
      0.78 ±  3%      -0.1        0.71 ±  5%  perf-profile.calltrace.cycles-pp.__radix_tree_lookup.radix_tree_lookup_slot.find_get_entry.pagecache_get_page.generic_file_read_iter
      0.82 ±  3%      -0.1        0.76 ±  3%  perf-profile.calltrace.cycles-pp.__tcp_push_pending_frames.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_rcv.ip_local_deliver_finish
      5.58            +0.1        5.71        perf-profile.calltrace.cycles-pp.net_rx_action.__softirqentry_text_start.do_softirq_own_stack.do_softirq.__local_bh_enable_ip
      5.35            +0.1        5.49        perf-profile.calltrace.cycles-pp.process_backlog.net_rx_action.__softirqentry_text_start.do_softirq_own_stack.do_softirq
      0.91 ±  4%      +0.1        1.04 ±  3%  perf-profile.calltrace.cycles-pp.sk_stream_alloc_skb.do_tcp_sendpages.tcp_sendpage_locked.tcp_sendpage.inet_sendpage
     90.58            +0.4       90.99        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.5        0.55 ±  6%  perf-profile.calltrace.cycles-pp.__release_sock.release_sock.tcp_recvmsg.inet_recvmsg.__sys_recvfrom
      0.00            +0.6        0.60 ±  6%  perf-profile.calltrace.cycles-pp.release_sock.tcp_recvmsg.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom
      0.00            +0.6        0.65 ± 18%  perf-profile.calltrace.cycles-pp.tcp_data_queue.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_rcv.ip_local_deliver_finish
      0.00            +0.7        0.68 ±  2%  perf-profile.calltrace.cycles-pp.find_next_bit.cpumask_next.__percpu_counter_sum.__sk_mem_raise_allocated.__sk_mem_schedule
      0.00            +0.8        0.78 ± 13%  perf-profile.calltrace.cycles-pp.percpu_counter_add_batch.__sk_mem_raise_allocated.__sk_mem_schedule.do_tcp_sendpages.tcp_sendpage_locked
      0.00            +0.8        0.84        perf-profile.calltrace.cycles-pp.cpumask_next.__percpu_counter_sum.__sk_mem_raise_allocated.__sk_mem_schedule.do_tcp_sendpages
      0.00            +1.7        1.65 ±  4%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__percpu_counter_sum.__sk_mem_raise_allocated.__sk_mem_schedule
     70.71            +2.0       72.70        perf-profile.calltrace.cycles-pp.__x64_sys_sendfile64.do_syscall_64.entry_SYSCALL_64_after_hwframe
     68.26            +2.2       70.47        perf-profile.calltrace.cycles-pp.do_sendfile.__x64_sys_sendfile64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +2.8        2.85 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__percpu_counter_sum.__sk_mem_raise_allocated.__sk_mem_schedule.do_tcp_sendpages
     57.51            +3.2       60.70        perf-profile.calltrace.cycles-pp.do_splice_direct.do_sendfile.__x64_sys_sendfile64.do_syscall_64.entry_SYSCALL_64_after_hwframe
     54.10            +3.6       57.72        perf-profile.calltrace.cycles-pp.splice_direct_to_actor.do_splice_direct.do_sendfile.__x64_sys_sendfile64.do_syscall_64
     36.84            +4.9       41.77        perf-profile.calltrace.cycles-pp.direct_splice_actor.splice_direct_to_actor.do_splice_direct.do_sendfile.__x64_sys_sendfile64
     35.89            +5.0       40.88        perf-profile.calltrace.cycles-pp.splice_from_pipe.direct_splice_actor.splice_direct_to_actor.do_splice_direct.do_sendfile
     35.00            +5.0       40.01        perf-profile.calltrace.cycles-pp.__splice_from_pipe.splice_from_pipe.direct_splice_actor.splice_direct_to_actor.do_splice_direct
     30.95            +5.0       36.00        perf-profile.calltrace.cycles-pp.pipe_to_sendpage.__splice_from_pipe.splice_from_pipe.direct_splice_actor.splice_direct_to_actor
     29.68            +5.2       34.87        perf-profile.calltrace.cycles-pp.sock_sendpage.pipe_to_sendpage.__splice_from_pipe.splice_from_pipe.direct_splice_actor
     28.59            +5.3       33.84        perf-profile.calltrace.cycles-pp.inet_sendpage.kernel_sendpage.sock_sendpage.pipe_to_sendpage.__splice_from_pipe
     28.87            +5.3       34.14        perf-profile.calltrace.cycles-pp.kernel_sendpage.sock_sendpage.pipe_to_sendpage.__splice_from_pipe.splice_from_pipe
     27.07            +5.3       32.36        perf-profile.calltrace.cycles-pp.tcp_sendpage.inet_sendpage.kernel_sendpage.sock_sendpage.pipe_to_sendpage
     21.40            +5.7       27.15        perf-profile.calltrace.cycles-pp.tcp_sendpage_locked.tcp_sendpage.inet_sendpage.kernel_sendpage.sock_sendpage
     20.54            +5.8       26.38        perf-profile.calltrace.cycles-pp.do_tcp_sendpages.tcp_sendpage_locked.tcp_sendpage.inet_sendpage.kernel_sendpage
      0.00            +5.9        5.93 ±  4%  perf-profile.calltrace.cycles-pp.__percpu_counter_sum.__sk_mem_raise_allocated.__sk_mem_schedule.do_tcp_sendpages.tcp_sendpage_locked
      1.22 ±  4%      +6.2        7.47 ±  3%  perf-profile.calltrace.cycles-pp.__sk_mem_raise_allocated.__sk_mem_schedule.do_tcp_sendpages.tcp_sendpage_locked.tcp_sendpage
      1.32 ±  3%      +6.3        7.60 ±  3%  perf-profile.calltrace.cycles-pp.__sk_mem_schedule.do_tcp_sendpages.tcp_sendpage_locked.tcp_sendpage.inet_sendpage
     18.44            -1.4       17.04        perf-profile.children.cycles-pp.__sys_recvfrom
     18.46            -1.4       17.06        perf-profile.children.cycles-pp.__x64_sys_recvfrom
     18.25            -1.4       16.86        perf-profile.children.cycles-pp.inet_recvmsg
     18.19            -1.4       16.81        perf-profile.children.cycles-pp.tcp_recvmsg
     15.06            -1.2       13.82        perf-profile.children.cycles-pp.copy_page_to_iter
     13.47            -1.2       12.25        perf-profile.children.cycles-pp.skb_copy_datagram_iter
     12.00            -1.0       11.05 ±  2%  perf-profile.children.cycles-pp.generic_file_splice_read
      9.58 ±  2%      -0.9        8.72        perf-profile.children.cycles-pp.copyout
     10.09            -0.9        9.23 ±  2%  perf-profile.children.cycles-pp.security_file_permission
      9.42 ±  2%      -0.8        8.60        perf-profile.children.cycles-pp.copy_user_enhanced_fast_string
      9.68            -0.8        8.90 ±  2%  perf-profile.children.cycles-pp.generic_file_read_iter
     11.60 ±  2%      -0.6       11.03        perf-profile.children.cycles-pp.__tcp_push_pending_frames
     11.47 ±  2%      -0.5       10.94        perf-profile.children.cycles-pp.tcp_write_xmit
      6.05 ±  2%      -0.5        5.57 ±  2%  perf-profile.children.cycles-pp.selinux_file_permission
      3.54 ±  3%      -0.3        3.24 ±  2%  perf-profile.children.cycles-pp.___might_sleep
      2.50 ±  3%      -0.3        2.21 ±  5%  perf-profile.children.cycles-pp.file_has_perm
      3.05 ±  2%      -0.3        2.78 ±  4%  perf-profile.children.cycles-pp.do_splice_to
      2.06            -0.3        1.81 ±  2%  perf-profile.children.cycles-pp.fsnotify
      2.70 ±  2%      -0.2        2.45 ±  2%  perf-profile.children.cycles-pp.pagecache_get_page
      3.39 ±  3%      -0.2        3.15        perf-profile.children.cycles-pp.touch_atime
      2.10 ±  2%      -0.2        1.87 ±  2%  perf-profile.children.cycles-pp.lock_sock_nested
      1.29 ± 13%      -0.2        1.07 ±  2%  perf-profile.children.cycles-pp.__kfree_skb
      2.57 ±  4%      -0.2        2.35        perf-profile.children.cycles-pp.atime_needs_update
      2.37            -0.2        2.15 ±  3%  perf-profile.children.cycles-pp.__might_fault
      2.34 ±  2%      -0.2        2.13 ±  2%  perf-profile.children.cycles-pp.find_get_entry
      1.21 ±  5%      -0.2        1.00 ±  9%  perf-profile.children.cycles-pp.__fget_light
      3.67            -0.2        3.46 ±  3%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      2.72 ±  4%      -0.2        2.52 ±  2%  perf-profile.children.cycles-pp.__inode_security_revalidate
      1.61 ±  4%      -0.2        1.41 ±  6%  perf-profile.children.cycles-pp._raw_spin_lock_bh
      0.86 ± 20%      -0.2        0.67 ±  5%  perf-profile.children.cycles-pp.skb_release_data
      0.47 ± 18%      -0.2        0.30 ± 28%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.99 ±  5%      -0.2        0.83 ±  5%  perf-profile.children.cycles-pp.__fsnotify_parent
      0.41 ± 21%      -0.2        0.25 ± 33%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.52 ± 16%      -0.2        0.36 ± 24%  perf-profile.children.cycles-pp.smp_apic_timer_interrupt
      0.56 ± 15%      -0.2        0.40 ± 22%  perf-profile.children.cycles-pp.apic_timer_interrupt
      1.49 ±  2%      -0.1        1.34 ±  4%  perf-profile.children.cycles-pp.current_time
      0.32 ± 25%      -0.1        0.18 ± 48%  perf-profile.children.cycles-pp.tick_sched_timer
      1.77 ±  4%      -0.1        1.65 ±  2%  perf-profile.children.cycles-pp.__might_sleep
      1.10 ±  3%      -0.1        0.98 ±  2%  perf-profile.children.cycles-pp.radix_tree_lookup_slot
      0.70 ± 11%      -0.1        0.58 ±  9%  perf-profile.children.cycles-pp.nf_hook_slow
      0.96 ±  2%      -0.1        0.85 ±  4%  perf-profile.children.cycles-pp.sched_clock_cpu
      0.88 ±  2%      -0.1        0.78 ±  3%  perf-profile.children.cycles-pp.sched_clock
      0.85 ±  2%      -0.1        0.75 ±  3%  perf-profile.children.cycles-pp.native_sched_clock
      0.46 ±  4%      -0.1        0.37 ±  8%  perf-profile.children.cycles-pp.selinux_ip_postroute
      0.37 ±  5%      -0.1        0.30 ±  8%  perf-profile.children.cycles-pp.selinux_ip_postroute_compat
      0.44 ±  3%      -0.1        0.38 ±  4%  perf-profile.children.cycles-pp.tcp_rate_check_app_limited
      0.12 ± 27%      -0.1        0.06 ±  6%  perf-profile.children.cycles-pp.__copy_skb_header
      0.20 ± 16%      -0.0        0.15 ± 12%  perf-profile.children.cycles-pp.lock_timer_base
      0.16 ± 13%      -0.0        0.11 ± 18%  perf-profile.children.cycles-pp.ip_rcv_core
      0.21 ±  7%      -0.0        0.17 ±  7%  perf-profile.children.cycles-pp.enqueue_to_backlog
      0.37 ±  3%      -0.0        0.33 ±  6%  perf-profile.children.cycles-pp.generic_splice_sendpage
      0.25 ±  7%      -0.0        0.21 ±  7%  perf-profile.children.cycles-pp.iov_iter_pipe
      0.06 ± 11%      +0.0        0.08 ±  6%  perf-profile.children.cycles-pp.__list_del_entry_valid
      0.06 ± 13%      +0.0        0.08 ±  5%  perf-profile.children.cycles-pp.get_nohz_timer_target
      0.09 ± 18%      +0.0        0.12 ±  6%  perf-profile.children.cycles-pp.sk_stream_wait_memory
      0.09 ± 11%      +0.0        0.12 ± 13%  perf-profile.children.cycles-pp.tcp_rearm_rto
      0.04 ± 60%      +0.1        0.11 ± 14%  perf-profile.children.cycles-pp.splice_from_pipe_next
      0.91 ±  4%      +0.1        1.04 ±  3%  perf-profile.children.cycles-pp.sk_stream_alloc_skb
      0.11 ±  7%      +0.2        0.34 ±  9%  perf-profile.children.cycles-pp.tcp_leave_memory_pressure
      0.33 ± 10%      +0.2        0.58 ±  4%  perf-profile.children.cycles-pp.__release_sock
      3.19 ±  2%      +0.4        3.62 ±  4%  perf-profile.children.cycles-pp.tcp_v4_do_rcv
      0.55 ± 12%      +0.4        0.99 ± 10%  perf-profile.children.cycles-pp.tcp_data_queue
      3.07 ±  2%      +0.4        3.51 ±  5%  perf-profile.children.cycles-pp.tcp_rcv_established
      0.18 ± 27%      +0.4        0.63 ± 15%  perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
     90.71            +0.5       91.20        perf-profile.children.cycles-pp.do_syscall_64
      0.08 ± 13%      +0.5        0.60 ± 12%  perf-profile.children.cycles-pp.tcp_try_rmem_schedule
      0.00            +0.8        0.77 ±  2%  perf-profile.children.cycles-pp.find_next_bit
      0.00            +0.9        0.94 ± 10%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.00            +1.1        1.14 ±  3%  perf-profile.children.cycles-pp.cpumask_next
      0.00            +1.9        1.92 ±  6%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     70.92            +2.0       72.87        perf-profile.children.cycles-pp.__x64_sys_sendfile64
     68.42            +2.2       70.62        perf-profile.children.cycles-pp.do_sendfile
     57.60            +3.2       60.79        perf-profile.children.cycles-pp.do_splice_direct
      0.25 ± 13%      +3.3        3.54 ±  5%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     54.16            +3.6       57.77        perf-profile.children.cycles-pp.splice_direct_to_actor
     36.88            +5.0       41.83        perf-profile.children.cycles-pp.direct_splice_actor
     35.98            +5.0       40.97        perf-profile.children.cycles-pp.splice_from_pipe
     35.13            +5.0       40.13        perf-profile.children.cycles-pp.__splice_from_pipe
     31.00            +5.0       36.03        perf-profile.children.cycles-pp.pipe_to_sendpage
     29.75            +5.2       34.97        perf-profile.children.cycles-pp.sock_sendpage
     28.64            +5.3       33.89        perf-profile.children.cycles-pp.inet_sendpage
     28.94            +5.3       34.22        perf-profile.children.cycles-pp.kernel_sendpage
     27.21            +5.3       32.51        perf-profile.children.cycles-pp.tcp_sendpage
     21.48            +5.7       27.23        perf-profile.children.cycles-pp.tcp_sendpage_locked
     20.69            +5.8       26.53        perf-profile.children.cycles-pp.do_tcp_sendpages
      0.00            +6.7        6.67 ±  4%  perf-profile.children.cycles-pp.__percpu_counter_sum
      1.34 ±  3%      +7.0        8.32 ±  3%  perf-profile.children.cycles-pp.__sk_mem_raise_allocated
      1.46 ±  3%      +7.0        8.46 ±  3%  perf-profile.children.cycles-pp.__sk_mem_schedule
      1.21 ±  3%      -0.8        0.40 ±  9%  perf-profile.self.cycles-pp.__sk_mem_raise_allocated
      9.27            -0.8        8.50        perf-profile.self.cycles-pp.copy_user_enhanced_fast_string
      3.41 ±  3%      -0.3        3.08        perf-profile.self.cycles-pp.___might_sleep
      3.12 ±  3%      -0.3        2.86        perf-profile.self.cycles-pp.selinux_file_permission
      2.01 ±  2%      -0.2        1.76 ±  2%  perf-profile.self.cycles-pp.fsnotify
      2.52            -0.2        2.28        perf-profile.self.cycles-pp.generic_file_read_iter
      2.42            -0.2        2.20 ±  2%  perf-profile.self.cycles-pp.do_sendfile
      3.66            -0.2        3.45 ±  3%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      1.18 ±  5%      -0.2        0.98 ±  9%  perf-profile.self.cycles-pp.__fget_light
      1.62 ±  3%      -0.2        1.45 ±  5%  perf-profile.self.cycles-pp.tcp_write_xmit
      1.19 ±  2%      -0.2        1.02 ±  5%  perf-profile.self.cycles-pp.pipe_to_sendpage
      1.44 ±  5%      -0.2        1.28 ±  6%  perf-profile.self.cycles-pp._raw_spin_lock_bh
      0.89 ±  5%      -0.1        0.74 ±  4%  perf-profile.self.cycles-pp.__fsnotify_parent
      1.12 ±  2%      -0.1        0.98 ±  4%  perf-profile.self.cycles-pp.do_syscall_64
      1.02 ±  3%      -0.1        0.90 ±  5%  perf-profile.self.cycles-pp.__x64_sys_sendfile64
      0.81 ±  7%      -0.1        0.70 ±  6%  perf-profile.self.cycles-pp.file_has_perm
      0.71 ±  7%      -0.1        0.61 ±  7%  perf-profile.self.cycles-pp.skb_copy_datagram_iter
      0.89 ±  6%      -0.1        0.79 ±  6%  perf-profile.self.cycles-pp.tcp_current_mss
      0.14 ±  9%      -0.1        0.04 ± 59%  perf-profile.self.cycles-pp.sched_clock
      0.75 ±  4%      -0.1        0.66 ±  6%  perf-profile.self.cycles-pp.skb_release_data
      0.97 ±  3%      -0.1        0.88 ±  6%  perf-profile.self.cycles-pp.page_cache_pipe_buf_confirm
      0.82            -0.1        0.74 ±  6%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.29 ±  8%      -0.1        0.21 ±  8%  perf-profile.self.cycles-pp.radix_tree_lookup_slot
      0.42 ±  5%      -0.1        0.35 ±  4%  perf-profile.self.cycles-pp.tcp_rate_check_app_limited
      1.57            -0.1        1.51 ±  2%  perf-profile.self.cycles-pp.__might_sleep
      0.12 ± 27%      -0.1        0.06 ±  6%  perf-profile.self.cycles-pp.__copy_skb_header
      0.15 ±  7%      -0.1        0.10 ± 15%  perf-profile.self.cycles-pp.selinux_ip_postroute_compat
      0.15 ± 14%      -0.0        0.11 ± 15%  perf-profile.self.cycles-pp.ip_rcv_core
      0.17 ±  9%      -0.0        0.12 ±  8%  perf-profile.self.cycles-pp.ip_output
      0.32            -0.0        0.28 ±  4%  perf-profile.self.cycles-pp.generic_splice_sendpage
      0.14 ± 10%      -0.0        0.10 ± 14%  perf-profile.self.cycles-pp.enqueue_to_backlog
      0.23 ±  9%      -0.0        0.19 ±  2%  perf-profile.self.cycles-pp.iov_iter_pipe
      0.22 ±  9%      -0.0        0.18 ±  7%  perf-profile.self.cycles-pp.__ip_queue_xmit
      0.11 ± 19%      -0.0        0.08 ±  8%  perf-profile.self.cycles-pp.sock_def_readable
      0.11 ±  4%      -0.0        0.08 ± 10%  perf-profile.self.cycles-pp.bpf_fd_pass
      0.11 ±  7%      +0.0        0.15 ± 10%  perf-profile.self.cycles-pp.tcp_ack
      0.01 ±173%      +0.1        0.10 ±  8%  perf-profile.self.cycles-pp.splice_from_pipe_next
      0.09 ±  7%      +0.2        0.32 ±  9%  perf-profile.self.cycles-pp.tcp_leave_memory_pressure
      0.15 ± 16%      +0.4        0.52 ±  5%  perf-profile.self.cycles-pp._raw_spin_unlock_irqrestore
      0.00            +0.4        0.38 ± 12%  perf-profile.self.cycles-pp.cpumask_next
      0.00            +0.7        0.67 ±  2%  perf-profile.self.cycles-pp.find_next_bit
      0.00            +0.7        0.72 ±  6%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.24 ± 14%      +1.4        1.63 ±  6%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.00            +1.9        1.90 ±  6%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.00            +2.1        2.08 ±  3%  perf-profile.self.cycles-pp.__percpu_counter_sum


                                                                                
                              netperf.Throughput_Mbps                           
                                                                                
  8100 +-+------------------------------------------------------------------+   
       |           ++.+ .++.+++.+                             .++.          |   
  8000 +-+++.++.  +    +         +.++.++.++.++.++.++.+++.++.++    ++.++.++.+|   
  7900 +-+      ++                                                          |   
       |                                                                    |   
  7800 +-+                                                                  |   
       |                                                                    |   
  7700 +-+                                                                  |   
       |                                                                    |   
  7600 +-+                                                                  |   
  7500 +-+         O   O                                                    |   
       |         O  O O  OO OOO OO OO                                       |   
  7400 +-+    O O                                                           |   
       OO OO O                                                              |   
  7300 +-+------------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                            netperf.Throughput_total_Mbps                       
                                                                                
  130000 +-+----------------------------------------------------------------+   
         |          +.+   +.+++.+                              +.+          |   
  128000 +-+++.++.  :  +.+      :  ++.+ +.++.+++.++.+ .+++.++.+   ++.++.++.+|   
         |+       ++            :  :   +             +                      |   
  126000 +-+                    :  :                                        |   
         |                      : :                                         |   
  124000 +-+                     ::                                         |   
         |                       ::                                         |   
  122000 +-+                     ::                                         |   
         |                       :                                          |   
  120000 +-+       OO  O OO O    O                                          |   
         |      O     O      OO O  OO O                                     |   
  118000 O-+OO    O                                                         |   
         |O    O                                                            |   
  116000 +-+----------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                                   netperf.workload                             
                                                                                
  9.5e+08 +-+---------------------------------------------------------------+   
  9.4e+08 +-+        +.++ .++.+++                              +.+          |   
          |+.++.++   :   +      :  +.+++.++.++.+++.++.+++.++.++   +.+++.++.+|   
  9.3e+08 +-+     +.+           :  :                                        |   
  9.2e+08 +-+                    : :                                        |   
          |                      : :                                        |   
  9.1e+08 +-+                    : :                                        |   
    9e+08 +-+                    ::                                         |   
  8.9e+08 +-+                     :                                         |   
          |                       :                                         |   
  8.8e+08 +-+       OO OOO OO     O                                         |   
  8.7e+08 +-+    O            OOO  O OO                                     |   
          O  OO   O                                                         |   
  8.6e+08 +O+   O                                                           |   
  8.5e+08 +-+---------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                              netperf.time.user_time                            
                                                                                
  152 +-+-------------------------------------------------------------------+   
  150 +-+                                                          +        |   
      |                                                            ::       |   
  148 +-+                                                          ::       |   
  146 +-+ +. +                          +              +          :  :+. +.+|   
  144 +-++  + +     .+ .++.+    .++.+   :+ +.++.++.+   :+ +.++. +.+  +  +   |   
  142 +-+      + .++  +     +.++     +.+  +         +.+  +     +            |   
      |         +                                                           |   
  140 +-+                                                                   |   
  138 +-+                                                                   |   
  136 +-+         O                                                         |   
  134 +-+       O  O OO O   O     O                                         |   
      |        O         O O  OO O  O                                       |   
  132 OO+OO OO                                                              |   
  130 +-+-------------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                             netperf.time.system_time                           
                                                                                
  1840 +-+-O----------------------------------------------------------------+   
       |O O   O                                                             |   
  1830 O-+   O  O      O  O  OO O  OO                                       |   
       |           OO       O    O                                          |   
       |         O    O  O                                                  |   
  1820 +-+                                                                  |   
       |                                                                    |   
  1810 +-+                                                                  |   
       |                                                                    |   
  1800 +-+                                                                  |   
       |      +.+     +          +. +. +.+ .++.++. +. ++. +.++.        .+   |   
       | .++.+   +.  + +.   + +  : +  +   +       +  +   +     ++.+ .++  +.+|   
  1790 +-+         ++    + + + +:                                  +        |   
       |                  +     +                                           |   
  1780 +-+------------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                        netperf.time.voluntary_context_switches                 
                                                                                
  1.12e+06 +-+--------------------------------------------------------------+   
           |      +    +    +   +      +       +    +.      .+ : +        .+|   
   1.1e+06 +-+++. :   + +  : + + +.++ + + .++.+ :.+ : + .+++  ::  +.+++.++  |   
  1.08e+06 +-+   + :.+   + :  +      +   +      +  +   +      +             |   
           |       +      +                                                 |   
  1.06e+06 +-+                                                              |   
           |                                                                |   
  1.04e+06 +-+                                                              |   
           |                                                                |   
  1.02e+06 +-+               OO  O OO  O                                    |   
     1e+06 +-+        OO OO O   O    O                                      |   
           |O      O O                                                      |   
    980000 O-+OO O                                                          |   
           |                                                                |   
    960000 +-+----O---------------------------------------------------------+   
                                                                                
                                                                                
[*] bisect-good sample
[O] bisect-bad  sample

***************************************************************************************************
lkp-bdw-ep2: 88 threads Intel(R) Xeon(R) CPU E5-2699 v4 @ 2.20GHz with 128G memory
=========================================================================================
cluster/compiler/cpufreq_governor/ip/kconfig/nr_threads/rootfs/runtime/tbox_group/test/testcase:
  cs-localhost/gcc-7/performance/ipv4/x86_64-rhel-7.2/50%/debian-x86_64-2018-04-03.cgz/300s/lkp-bdw-ep2/UDP_RR/netperf

commit: 
  6da410d97f (" mlx5e-fixes-2018-09-05")
  b99259a614 ("net/sock: move memory_allocated over to percpu_counter variables")

6da410d97ffa486e b99259a61450bb6403bbbbf279 
---------------- -------------------------- 
       fail:runs  %reproduction    fail:runs
           |             |             |    
           :4           25%           1:4     dmesg.WARNING:at#for_ip_interrupt_entry/0x
          1:4          -25%            :4     dmesg.WARNING:at_ip_native_sched_clock/0x
         11:4         -149%           5:4     perf-profile.calltrace.cycles-pp.dequeue_entity.dequeue_task_fair.__sched_text_start.schedule.schedule_timeout
          4:4          -54%           2:4     perf-profile.calltrace.cycles-pp.switch_mm_irqs_off.switch_mm.__sched_text_start.schedule.schedule_timeout
         31:4         -378%          16:4     perf-profile.children.cycles-pp.schedule_timeout
          1:4          -12%           0:4     perf-profile.self.cycles-pp.schedule_timeout
         %stddev     %change         %stddev
             \          |                \  
   3140615 ±  2%     -49.3%    1593635        netperf.Throughput_total_tps
     71377 ±  2%     -49.3%      36218        netperf.Throughput_tps
      6877 ±  4%     +11.8%       7689        netperf.time.involuntary_context_switches
      2795           -10.5%       2501        netperf.time.percent_of_cpu_this_job_got
      7688            -6.4%       7194        netperf.time.system_time
    727.56 ±  3%     -53.7%     336.63 ±  6%  netperf.time.user_time
 9.335e+08 ±  3%     -48.8%  4.781e+08        netperf.time.voluntary_context_switches
 9.422e+08 ±  2%     -49.3%  4.781e+08        netperf.workload
    497.45           -10.7%     444.23        pmeter.Average_Active_Power
    143.48           -43.2%      81.53        pmeter.performance_per_watt
     25025 ± 50%     -50.2%      12452 ± 98%  proc-vmstat.numa_pte_updates
    823677            -1.0%     815119        proc-vmstat.pgfault
     14.68           +19.6       34.31 ±  2%  mpstat.cpu.soft%
     37.84           -21.0       16.88 ±  5%  mpstat.cpu.sys%
      4.73 ±  3%      -2.4        2.30 ±  6%  mpstat.cpu.usr%
    231917 ±  7%     +48.8%     345161 ± 22%  numa-numastat.node0.numa_hit
    458545 ±  3%     -25.1%     343375 ± 24%  numa-numastat.node1.local_node
    467255 ±  4%     -25.0%     350578 ± 22%  numa-numastat.node1.numa_hit
     53.00            -9.4%      48.00        vmstat.procs.r
  12208228 ±  3%     -48.6%    6279977        vmstat.system.cs
    197402            -5.8%     185888        vmstat.system.in
 9.422e+08 ±  2%     -49.3%  4.781e+08        softirqs.NET_RX
   2090351 ± 22%     -23.7%    1595486 ±  3%  softirqs.RCU
   6824307           -13.3%    5915651        softirqs.SCHED
   8055584           +10.9%    8929857        softirqs.TIMER
  7.34e+09           +40.3%   1.03e+10        cpuidle.C1.time
 1.833e+09 ±  3%     -47.4%  9.638e+08        cpuidle.C1.usage
 3.942e+08 ± 63%     -68.5%  1.243e+08 ± 29%  cpuidle.C6.time
    558983 ± 49%     -64.4%     199205 ± 18%  cpuidle.C6.usage
 1.824e+08 ±  3%     -47.9%   95056831        cpuidle.POLL.time
  34485351 ±  5%     -82.4%    6062003        cpuidle.POLL.usage
      1997           -14.5%       1708        turbostat.Avg_MHz
     71.97           -10.8       61.14        turbostat.Busy%
 1.833e+09 ±  3%     -47.4%  9.638e+08        turbostat.C1
     27.42 ±  2%     +11.2       38.62        turbostat.C1%
    556509 ± 50%     -64.8%     196082 ± 18%  turbostat.C6
      1.46 ± 64%      -1.0        0.45 ± 30%  turbostat.C6%
     27.21 ±  2%     +40.7%      38.28        turbostat.CPU%c1
    270.14           -13.5%     233.54        turbostat.PkgWatt
     15.33            +2.1%      15.65        turbostat.RAMWatt
    360260 ± 11%     -57.2%     154078 ±  6%  sched_debug.cfs_rq:/.MIN_vruntime.avg
   2840994           -20.3%    2263123        sched_debug.cfs_rq:/.MIN_vruntime.max
    922773 ±  6%     -40.1%     552528 ±  3%  sched_debug.cfs_rq:/.MIN_vruntime.stddev
    360260 ± 11%     -57.2%     154078 ±  6%  sched_debug.cfs_rq:/.max_vruntime.avg
   2840994           -20.3%    2263123        sched_debug.cfs_rq:/.max_vruntime.max
    922773 ±  6%     -40.1%     552528 ±  3%  sched_debug.cfs_rq:/.max_vruntime.stddev
   2804769 ±  2%     -19.7%    2251378        sched_debug.cfs_rq:/.min_vruntime.avg
   2905503           -20.3%    2314293        sched_debug.cfs_rq:/.min_vruntime.max
   2731218 ±  3%     -18.3%    2232433        sched_debug.cfs_rq:/.min_vruntime.min
     29631 ± 28%     -61.3%      11469 ± 21%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.58 ±  4%      -9.9%       0.52 ±  3%  sched_debug.cfs_rq:/.nr_running.avg
     10.43 ±  9%     -15.4%       8.83 ±  2%  sched_debug.cfs_rq:/.runnable_load_avg.avg
     29606 ± 28%     -61.3%      11465 ± 21%  sched_debug.cfs_rq:/.spread0.stddev
    387.56           -21.9%     302.54 ±  4%  sched_debug.cfs_rq:/.util_est_enqueued.avg
    356998 ± 25%     -45.1%     196064 ±  3%  sched_debug.cpu.avg_idle.max
     58785 ± 15%     -30.2%      41011 ±  2%  sched_debug.cpu.avg_idle.stddev
      0.46 ± 15%     -81.8%       0.08 ± 99%  sched_debug.cpu.cpu_load[1].min
      2.25 ±  8%     -42.6%       1.29 ± 10%  sched_debug.cpu.cpu_load[2].min
      4.17 ± 14%     -21.0%       3.29 ±  4%  sched_debug.cpu.cpu_load[3].min
  21059143 ±  3%     -49.0%   10741980        sched_debug.cpu.nr_switches.avg
  21578752 ±  2%     -49.7%   10846007        sched_debug.cpu.nr_switches.max
  20097461 ±  6%     -47.8%   10493962        sched_debug.cpu.nr_switches.min
    262381 ± 31%     -79.3%      54430 ± 13%  sched_debug.cpu.nr_switches.stddev
 5.784e+12 ±  2%     -27.2%  4.212e+12        perf-stat.branch-instructions
      2.76            -0.8        1.96        perf-stat.branch-miss-rate%
 1.599e+11 ±  2%     -48.2%  8.276e+10        perf-stat.branch-misses
      0.73 ±  8%      +0.4        1.14        perf-stat.cache-miss-rate%
 2.527e+09 ±  7%     +11.0%  2.805e+09        perf-stat.cache-misses
 3.482e+11           -29.1%   2.47e+11        perf-stat.cache-references
 3.733e+09 ±  3%     -48.8%  1.912e+09        perf-stat.context-switches
      1.93           +20.0%       2.32        perf-stat.cpi
 5.633e+13           -17.5%  4.646e+13        perf-stat.cpu-cycles
 7.772e+09 ±  4%     -43.6%  4.386e+09 ± 15%  perf-stat.dTLB-load-misses
 8.521e+12 ±  2%     -33.9%   5.63e+12        perf-stat.dTLB-loads
      0.00 ±  8%      +0.0        0.00 ±  7%  perf-stat.dTLB-store-miss-rate%
 1.095e+08 ±  9%     -13.5%   94683885 ±  7%  perf-stat.dTLB-store-misses
  5.49e+12 ±  2%     -48.1%  2.851e+12        perf-stat.dTLB-stores
     10.06 ±  5%      +3.6       13.65 ± 14%  perf-stat.iTLB-load-miss-rate%
 9.169e+09 ±  5%     -36.1%  5.859e+09 ± 16%  perf-stat.iTLB-load-misses
 8.203e+10 ±  3%     -54.9%  3.696e+10        perf-stat.iTLB-loads
 2.915e+13 ±  2%     -31.3%  2.002e+13        perf-stat.instructions
      0.52           -16.7%       0.43        perf-stat.ipc
    801554            -1.1%     792718        perf-stat.minor-faults
 7.603e+08 ±  5%    +108.2%  1.583e+09        perf-stat.node-load-misses
     93.23 ±  3%     -35.4       57.88 ±  2%  perf-stat.node-store-miss-rate%
 1.072e+09 ±  5%     -40.6%  6.373e+08 ±  2%  perf-stat.node-store-misses
  80515351 ± 49%    +476.1%  4.638e+08 ±  3%  perf-stat.node-stores
    801557            -1.1%     792720        perf-stat.page-faults
     30931           +35.4%      41869        perf-stat.path-length
     15.38            -7.4        7.94        perf-profile.calltrace.cycles-pp.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
     15.18            -7.3        7.85        perf-profile.calltrace.cycles-pp.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.40            -6.5        6.93        perf-profile.calltrace.cycles-pp.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.14            -6.3        6.82        perf-profile.calltrace.cycles-pp.udp_recvmsg.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64
      8.62 ±  6%      -5.9        2.74        perf-profile.calltrace.cycles-pp.ip_make_skb.udp_sendmsg.sock_sendmsg.__sys_sendto.__x64_sys_sendto
     10.50            -5.1        5.43        perf-profile.calltrace.cycles-pp.__skb_recv_udp.udp_recvmsg.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom
      8.98 ±  2%      -4.4        4.62        perf-profile.calltrace.cycles-pp.__skb_wait_for_more_packets.__skb_recv_udp.udp_recvmsg.inet_recvmsg.__sys_recvfrom
      5.03 ± 12%      -4.2        0.88 ±  3%  perf-profile.calltrace.cycles-pp.__ip_make_skb.ip_make_skb.udp_sendmsg.sock_sendmsg.__sys_sendto
      9.64            -3.9        5.70        perf-profile.calltrace.cycles-pp.sock_def_readable.__udp_enqueue_schedule_skb.udp_queue_rcv_skb.__udp4_lib_rcv.ip_local_deliver_finish
      9.42            -3.9        5.49        perf-profile.calltrace.cycles-pp.__wake_up_common_lock.sock_def_readable.__udp_enqueue_schedule_skb.udp_queue_rcv_skb.__udp4_lib_rcv
      4.54 ± 13%      -3.9        0.65 ±  4%  perf-profile.calltrace.cycles-pp.__ip_select_ident.__ip_make_skb.ip_make_skb.udp_sendmsg.sock_sendmsg
     44.22            -3.9       40.32        perf-profile.calltrace.cycles-pp.secondary_startup_64
      4.46 ± 13%      -3.9        0.60 ±  5%  perf-profile.calltrace.cycles-pp.ip_idents_reserve.__ip_select_ident.__ip_make_skb.ip_make_skb.udp_sendmsg
     43.77            -3.8       39.95        perf-profile.calltrace.cycles-pp.start_secondary.secondary_startup_64
     43.76            -3.8       39.94        perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.secondary_startup_64
      7.84 ±  2%      -3.8        4.06        perf-profile.calltrace.cycles-pp.schedule_timeout.__skb_wait_for_more_packets.__skb_recv_udp.udp_recvmsg.inet_recvmsg
     43.66            -3.8       39.89        perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
      8.92            -3.7        5.20        perf-profile.calltrace.cycles-pp.__wake_up_common.__wake_up_common_lock.sock_def_readable.__udp_enqueue_schedule_skb.udp_queue_rcv_skb
      7.58 ±  2%      -3.7        3.91        perf-profile.calltrace.cycles-pp.schedule.schedule_timeout.__skb_wait_for_more_packets.__skb_recv_udp.udp_recvmsg
      7.46 ±  2%      -3.6        3.82        perf-profile.calltrace.cycles-pp.__sched_text_start.schedule.schedule_timeout.__skb_wait_for_more_packets.__skb_recv_udp
      8.60            -3.6        5.00        perf-profile.calltrace.cycles-pp.autoremove_wake_function.__wake_up_common.__wake_up_common_lock.sock_def_readable.__udp_enqueue_schedule_skb
      8.49            -3.6        4.94        perf-profile.calltrace.cycles-pp.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_common_lock.sock_def_readable
      6.10            -2.8        3.27        perf-profile.calltrace.cycles-pp.schedule_idle.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
      5.95            -2.7        3.20        perf-profile.calltrace.cycles-pp.__sched_text_start.schedule_idle.do_idle.cpu_startup_entry.start_secondary
      4.93            -2.1        2.88        perf-profile.calltrace.cycles-pp.ttwu_do_activate.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_common_lock
      4.64            -1.9        2.69        perf-profile.calltrace.cycles-pp.enqueue_task_fair.ttwu_do_activate.try_to_wake_up.autoremove_wake_function.__wake_up_common
      3.65            -1.8        1.84        perf-profile.calltrace.cycles-pp.menu_select.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
      4.00            -1.7        2.31        perf-profile.calltrace.cycles-pp.enqueue_entity.enqueue_task_fair.ttwu_do_activate.try_to_wake_up.autoremove_wake_function
      3.24 ±  2%      -1.6        1.63        perf-profile.calltrace.cycles-pp.dequeue_task_fair.__sched_text_start.schedule.schedule_timeout.__skb_wait_for_more_packets
      3.27            -1.6        1.69        perf-profile.calltrace.cycles-pp.__ip_append_data.ip_make_skb.udp_sendmsg.sock_sendmsg.__sys_sendto
      2.52            -1.3        1.19        perf-profile.calltrace.cycles-pp.__entry_SYSCALL_64_trampoline
      2.48 ±  2%      -1.3        1.20        perf-profile.calltrace.cycles-pp.tick_nohz_get_sleep_length.menu_select.do_idle.cpu_startup_entry.start_secondary
      2.23 ±  4%      -1.1        1.12 ±  8%  perf-profile.calltrace.cycles-pp.__dev_queue_xmit.ip_finish_output2.ip_output.ip_send_skb.udp_send_skb
      2.24            -1.1        1.18        perf-profile.calltrace.cycles-pp.pick_next_task_fair.__sched_text_start.schedule_idle.do_idle.cpu_startup_entry
      2.16 ±  2%      -1.0        1.17        perf-profile.calltrace.cycles-pp.sock_alloc_send_pskb.__ip_append_data.ip_make_skb.udp_sendmsg.sock_sendmsg
      1.94 ±  2%      -1.0        0.96        perf-profile.calltrace.cycles-pp.tick_nohz_next_event.tick_nohz_get_sleep_length.menu_select.do_idle.cpu_startup_entry
      1.66 ±  5%      -0.8        0.84 ± 10%  perf-profile.calltrace.cycles-pp.dev_hard_start_xmit.__dev_queue_xmit.ip_finish_output2.ip_output.ip_send_skb
      1.57 ±  5%      -0.8        0.78 ± 10%  perf-profile.calltrace.cycles-pp.loopback_xmit.dev_hard_start_xmit.__dev_queue_xmit.ip_finish_output2.ip_output
      1.55 ±  2%      -0.8        0.78        perf-profile.calltrace.cycles-pp.get_next_timer_interrupt.tick_nohz_next_event.tick_nohz_get_sleep_length.menu_select.do_idle
      1.65 ±  2%      -0.8        0.90        perf-profile.calltrace.cycles-pp.alloc_skb_with_frags.sock_alloc_send_pskb.__ip_append_data.ip_make_skb.udp_sendmsg
      1.52            -0.7        0.77        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret
      1.57 ±  2%      -0.7        0.85        perf-profile.calltrace.cycles-pp.__alloc_skb.alloc_skb_with_frags.sock_alloc_send_pskb.__ip_append_data.ip_make_skb
      1.46            -0.7        0.79        perf-profile.calltrace.cycles-pp.set_next_entity.pick_next_task_fair.__sched_text_start.schedule_idle.do_idle
      1.29 ±  5%      -0.6        0.65 ±  7%  perf-profile.calltrace.cycles-pp.ip_route_output_flow.udp_sendmsg.sock_sendmsg.__sys_sendto.__x64_sys_sendto
      0.89 ±  2%      -0.6        0.25 ±100%  perf-profile.calltrace.cycles-pp.resched_curr.check_preempt_curr.ttwu_do_wakeup.try_to_wake_up.autoremove_wake_function
      1.26 ±  5%      -0.6        0.62 ±  7%  perf-profile.calltrace.cycles-pp.ip_route_output_key_hash.ip_route_output_flow.udp_sendmsg.sock_sendmsg.__sys_sendto
      1.46            -0.6        0.86        perf-profile.calltrace.cycles-pp.update_load_avg.enqueue_entity.enqueue_task_fair.ttwu_do_activate.try_to_wake_up
      1.20 ±  5%      -0.6        0.60 ±  7%  perf-profile.calltrace.cycles-pp.ip_route_output_key_hash_rcu.ip_route_output_key_hash.ip_route_output_flow.udp_sendmsg.sock_sendmsg
      1.34            -0.6        0.77        perf-profile.calltrace.cycles-pp.switch_mm_irqs_off.__sched_text_start.schedule_idle.do_idle.cpu_startup_entry
      1.20            -0.6        0.63 ±  2%  perf-profile.calltrace.cycles-pp.switch_mm.__sched_text_start.schedule.schedule_timeout.__skb_wait_for_more_packets
      1.00 ±  2%      -0.5        0.52        perf-profile.calltrace.cycles-pp.move_addr_to_user.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.06 ±  2%      -0.5        0.59        perf-profile.calltrace.cycles-pp.ttwu_do_wakeup.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_common_lock
      1.10 ±  3%      -0.5        0.65        perf-profile.calltrace.cycles-pp.select_task_rq_fair.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_common_lock
      0.95 ±  3%      -0.4        0.54 ±  2%  perf-profile.calltrace.cycles-pp.check_preempt_curr.ttwu_do_wakeup.try_to_wake_up.autoremove_wake_function.__wake_up_common
     30.84            +2.3       33.16        perf-profile.calltrace.cycles-pp.cpuidle_enter_state.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
     29.71            +2.7       32.39        perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.do_idle.cpu_startup_entry.start_secondary
     49.06            +7.3       56.32        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
     48.63            +7.5       56.11        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
     32.67           +15.2       47.87        perf-profile.calltrace.cycles-pp.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe
     32.48           +15.3       47.77        perf-profile.calltrace.cycles-pp.__sys_sendto.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe
     31.55           +15.7       47.30        perf-profile.calltrace.cycles-pp.sock_sendmsg.__sys_sendto.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe
     30.98           +16.0       47.02        perf-profile.calltrace.cycles-pp.udp_sendmsg.sock_sendmsg.__sys_sendto.__x64_sys_sendto.do_syscall_64
     20.10           +23.1       43.17        perf-profile.calltrace.cycles-pp.udp_send_skb.udp_sendmsg.sock_sendmsg.__sys_sendto.__x64_sys_sendto
     19.82           +23.2       43.02        perf-profile.calltrace.cycles-pp.ip_send_skb.udp_send_skb.udp_sendmsg.sock_sendmsg.__sys_sendto
     19.32           +23.4       42.76        perf-profile.calltrace.cycles-pp.ip_output.ip_send_skb.udp_send_skb.udp_sendmsg.sock_sendmsg
     17.83           +24.2       42.03        perf-profile.calltrace.cycles-pp.ip_finish_output2.ip_output.ip_send_skb.udp_send_skb.udp_sendmsg
     15.21           +25.5       40.72        perf-profile.calltrace.cycles-pp.__local_bh_enable_ip.ip_finish_output2.ip_output.ip_send_skb.udp_send_skb
     15.07           +25.6       40.64        perf-profile.calltrace.cycles-pp.do_softirq.__local_bh_enable_ip.ip_finish_output2.ip_output.ip_send_skb
     14.83           +25.7       40.52        perf-profile.calltrace.cycles-pp.do_softirq_own_stack.do_softirq.__local_bh_enable_ip.ip_finish_output2.ip_output
     14.73           +25.7       40.45        perf-profile.calltrace.cycles-pp.__softirqentry_text_start.do_softirq_own_stack.do_softirq.__local_bh_enable_ip.ip_finish_output2
     14.31           +25.9       40.17        perf-profile.calltrace.cycles-pp.net_rx_action.__softirqentry_text_start.do_softirq_own_stack.do_softirq.__local_bh_enable_ip
     13.95           +26.0       39.97        perf-profile.calltrace.cycles-pp.process_backlog.net_rx_action.__softirqentry_text_start.do_softirq_own_stack.do_softirq
     13.17           +26.4       39.61        perf-profile.calltrace.cycles-pp.__netif_receive_skb_one_core.process_backlog.net_rx_action.__softirqentry_text_start.do_softirq_own_stack
     12.85           +26.6       39.43        perf-profile.calltrace.cycles-pp.ip_rcv.__netif_receive_skb_one_core.process_backlog.net_rx_action.__softirqentry_text_start
     12.43           +26.7       39.16        perf-profile.calltrace.cycles-pp.ip_local_deliver.ip_rcv.__netif_receive_skb_one_core.process_backlog.net_rx_action
     12.27           +26.8       39.07        perf-profile.calltrace.cycles-pp.ip_local_deliver_finish.ip_local_deliver.ip_rcv.__netif_receive_skb_one_core.process_backlog
     11.92           +27.0       38.90        perf-profile.calltrace.cycles-pp.__udp4_lib_rcv.ip_local_deliver_finish.ip_local_deliver.ip_rcv.__netif_receive_skb_one_core
     11.37           +27.2       38.58        perf-profile.calltrace.cycles-pp.udp_queue_rcv_skb.__udp4_lib_rcv.ip_local_deliver_finish.ip_local_deliver.ip_rcv
     10.29           +27.7       38.01        perf-profile.calltrace.cycles-pp.__udp_enqueue_schedule_skb.udp_queue_rcv_skb.__udp4_lib_rcv.ip_local_deliver_finish.ip_local_deliver
      0.00           +30.3       30.29        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__percpu_counter_sum.__sk_mem_raise_allocated.__udp_enqueue_schedule_skb
      0.00           +30.5       30.48        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__percpu_counter_sum.__sk_mem_raise_allocated.__udp_enqueue_schedule_skb.udp_queue_rcv_skb
      0.00           +31.8       31.84        perf-profile.calltrace.cycles-pp.__percpu_counter_sum.__sk_mem_raise_allocated.__udp_enqueue_schedule_skb.udp_queue_rcv_skb.__udp4_lib_rcv
      0.00           +32.0       31.98        perf-profile.calltrace.cycles-pp.__sk_mem_raise_allocated.__udp_enqueue_schedule_skb.udp_queue_rcv_skb.__udp4_lib_rcv.ip_local_deliver_finish
     15.40            -7.4        7.96        perf-profile.children.cycles-pp.__x64_sys_recvfrom
     15.20            -7.3        7.85        perf-profile.children.cycles-pp.__sys_recvfrom
     13.61            -6.5        7.12        perf-profile.children.cycles-pp.__sched_text_start
     13.40            -6.5        6.94        perf-profile.children.cycles-pp.inet_recvmsg
     13.15            -6.3        6.83        perf-profile.children.cycles-pp.udp_recvmsg
      8.64 ±  6%      -5.9        2.75        perf-profile.children.cycles-pp.ip_make_skb
     10.53            -5.1        5.44        perf-profile.children.cycles-pp.__skb_recv_udp
      8.98 ±  2%      -4.4        4.63        perf-profile.children.cycles-pp.__skb_wait_for_more_packets
      5.04 ± 12%      -4.2        0.88 ±  3%  perf-profile.children.cycles-pp.__ip_make_skb
      9.65            -3.9        5.71        perf-profile.children.cycles-pp.sock_def_readable
      9.43            -3.9        5.49        perf-profile.children.cycles-pp.__wake_up_common_lock
      4.54 ± 13%      -3.9        0.65 ±  4%  perf-profile.children.cycles-pp.__ip_select_ident
     44.22            -3.9       40.32        perf-profile.children.cycles-pp.secondary_startup_64
     44.22            -3.9       40.32        perf-profile.children.cycles-pp.cpu_startup_entry
     44.20            -3.9       40.31        perf-profile.children.cycles-pp.do_idle
      4.46 ± 13%      -3.9        0.60 ±  5%  perf-profile.children.cycles-pp.ip_idents_reserve
     43.77            -3.8       39.95        perf-profile.children.cycles-pp.start_secondary
      8.93            -3.7        5.20        perf-profile.children.cycles-pp.__wake_up_common
      7.59 ±  2%      -3.7        3.92        perf-profile.children.cycles-pp.schedule
      8.61            -3.6        5.01        perf-profile.children.cycles-pp.autoremove_wake_function
      8.51            -3.6        4.95        perf-profile.children.cycles-pp.try_to_wake_up
      6.16            -2.9        3.31        perf-profile.children.cycles-pp.schedule_idle
      4.93            -2.1        2.88        perf-profile.children.cycles-pp.ttwu_do_activate
      4.64            -1.9        2.69        perf-profile.children.cycles-pp.enqueue_task_fair
      3.70            -1.8        1.87        perf-profile.children.cycles-pp.menu_select
      4.09            -1.7        2.36        perf-profile.children.cycles-pp.enqueue_entity
      3.32 ±  2%      -1.7        1.67        perf-profile.children.cycles-pp.dequeue_task_fair
      3.28            -1.6        1.69        perf-profile.children.cycles-pp.__ip_append_data
      2.98            -1.5        1.44 ±  2%  perf-profile.children.cycles-pp.__entry_SYSCALL_64_trampoline
      3.02 ±  2%      -1.5        1.51        perf-profile.children.cycles-pp.dequeue_entity
      2.93            -1.3        1.61        perf-profile.children.cycles-pp.update_load_avg
      2.78            -1.3        1.47        perf-profile.children.cycles-pp.pick_next_task_fair
      2.51            -1.3        1.22        perf-profile.children.cycles-pp.tick_nohz_get_sleep_length
      2.52            -1.1        1.38        perf-profile.children.cycles-pp.switch_mm_irqs_off
      2.24 ±  4%      -1.1        1.13 ±  8%  perf-profile.children.cycles-pp.__dev_queue_xmit
      1.97 ±  2%      -1.0        0.97        perf-profile.children.cycles-pp.tick_nohz_next_event
      2.16            -1.0        1.18        perf-profile.children.cycles-pp.sock_alloc_send_pskb
      1.74            -0.8        0.89        perf-profile.children.cycles-pp.syscall_return_via_sysret
      1.67 ±  4%      -0.8        0.84 ± 10%  perf-profile.children.cycles-pp.dev_hard_start_xmit
      1.58 ±  5%      -0.8        0.79 ± 11%  perf-profile.children.cycles-pp.loopback_xmit
      1.57 ±  2%      -0.8        0.79        perf-profile.children.cycles-pp.get_next_timer_interrupt
      1.46            -0.8        0.70        perf-profile.children.cycles-pp._raw_spin_lock
      1.65 ±  2%      -0.8        0.90        perf-profile.children.cycles-pp.alloc_skb_with_frags
      1.58 ±  2%      -0.7        0.85        perf-profile.children.cycles-pp.__alloc_skb
      1.49            -0.7        0.80        perf-profile.children.cycles-pp.set_next_entity
      1.36 ±  2%      -0.7        0.67        perf-profile.children.cycles-pp.load_new_mm_cr3
      1.29 ±  5%      -0.6        0.65 ±  7%  perf-profile.children.cycles-pp.ip_route_output_flow
      1.26 ±  5%      -0.6        0.63 ±  7%  perf-profile.children.cycles-pp.ip_route_output_key_hash
      1.21 ±  5%      -0.6        0.60 ±  7%  perf-profile.children.cycles-pp.ip_route_output_key_hash_rcu
      1.24 ±  2%      -0.6        0.65        perf-profile.children.cycles-pp.switch_mm
      1.17            -0.6        0.59        perf-profile.children.cycles-pp.update_curr
      1.10 ±  3%      -0.6        0.54 ±  3%  perf-profile.children.cycles-pp.nf_hook_slow
      1.08 ±  3%      -0.6        0.52        perf-profile.children.cycles-pp.__next_timer_interrupt
      1.09            -0.5        0.60 ±  2%  perf-profile.children.cycles-pp.__update_load_avg_cfs_rq
      0.95 ±  2%      -0.5        0.45 ±  3%  perf-profile.children.cycles-pp.___perf_sw_event
      1.01 ±  2%      -0.5        0.52        perf-profile.children.cycles-pp.move_addr_to_user
      1.06 ±  2%      -0.5        0.59        perf-profile.children.cycles-pp.ttwu_do_wakeup
      1.10 ±  3%      -0.5        0.65        perf-profile.children.cycles-pp.select_task_rq_fair
      1.02 ±  2%      -0.4        0.57        perf-profile.children.cycles-pp.check_preempt_curr
      0.83 ±  2%      -0.4        0.41 ±  2%  perf-profile.children.cycles-pp.__switch_to_asm
      0.87 ±  2%      -0.4        0.46 ±  3%  perf-profile.children.cycles-pp._copy_to_iter
      0.77 ±  5%      -0.4        0.37 ±  3%  perf-profile.children.cycles-pp.selinux_ip_postroute
      0.84            -0.4        0.45 ±  3%  perf-profile.children.cycles-pp.sk_filter_trim_cap
      0.89 ±  2%      -0.4        0.50 ±  2%  perf-profile.children.cycles-pp.resched_curr
      0.87 ±  2%      -0.4        0.48        perf-profile.children.cycles-pp.__consume_stateless_skb
      0.75 ±  2%      -0.4        0.36 ±  2%  perf-profile.children.cycles-pp.__switch_to
      0.79            -0.4        0.42 ±  2%  perf-profile.children.cycles-pp.security_sock_rcv_skb
      0.72 ±  7%      -0.4        0.36 ±  3%  perf-profile.children.cycles-pp.update_cfs_group
      0.64 ±  2%      -0.4        0.29        perf-profile.children.cycles-pp.ip_generic_getfrag
      0.73 ±  3%      -0.4        0.38 ±  2%  perf-profile.children.cycles-pp.tick_nohz_idle_exit
      0.72            -0.3        0.37 ±  3%  perf-profile.children.cycles-pp.finish_task_switch
      0.73            -0.3        0.39 ±  4%  perf-profile.children.cycles-pp.sock_wfree
      0.74            -0.3        0.40 ±  3%  perf-profile.children.cycles-pp.selinux_socket_sock_rcv_skb
      0.69 ± 10%      -0.3        0.35 ± 12%  perf-profile.children.cycles-pp.fib_table_lookup
      0.72 ±  2%      -0.3        0.39 ±  3%  perf-profile.children.cycles-pp.copy_user_generic_unrolled
      0.62 ±  5%      -0.3        0.30 ±  4%  perf-profile.children.cycles-pp.selinux_ip_postroute_compat
      0.73            -0.3        0.42        perf-profile.children.cycles-pp._raw_spin_lock_bh
      0.67 ±  2%      -0.3        0.35 ±  3%  perf-profile.children.cycles-pp.__slab_free
      0.53 ±  2%      -0.3        0.23 ±  3%  perf-profile.children.cycles-pp._copy_from_iter_full
      0.61 ±  2%      -0.3        0.33 ±  2%  perf-profile.children.cycles-pp.sched_clock_cpu
      0.69 ±  3%      -0.3        0.40        perf-profile.children.cycles-pp.poll_idle
      0.61 ±  2%      -0.3        0.34 ±  5%  perf-profile.children.cycles-pp.account_entity_enqueue
      0.56 ±  2%      -0.3        0.30 ±  3%  perf-profile.children.cycles-pp.sched_clock
      0.47 ± 21%      -0.3        0.20 ± 30%  perf-profile.children.cycles-pp.netif_rx_internal
      0.51 ±  3%      -0.3        0.25 ±  4%  perf-profile.children.cycles-pp.sockfd_lookup_light
      0.54 ±  2%      -0.3        0.28 ±  2%  perf-profile.children.cycles-pp.native_sched_clock
      0.46 ±  4%      -0.2        0.21 ±  3%  perf-profile.children.cycles-pp.pick_next_task_idle
      0.55            -0.2        0.30 ±  4%  perf-profile.children.cycles-pp.ktime_get
      0.48 ±  3%      -0.2        0.24        perf-profile.children.cycles-pp.__might_fault
      0.43 ±  4%      -0.2        0.18 ±  2%  perf-profile.children.cycles-pp.hrtimer_next_event_without
      0.54            -0.2        0.30 ±  2%  perf-profile.children.cycles-pp.reweight_entity
      0.53            -0.2        0.29        perf-profile.children.cycles-pp.prepare_to_wait_exclusive
      0.56 ±  2%      -0.2        0.33        perf-profile.children.cycles-pp.__update_load_avg_se
      0.72 ±  4%      -0.2        0.51        perf-profile.children.cycles-pp.find_next_bit
      0.46 ±  3%      -0.2        0.24        perf-profile.children.cycles-pp.tick_nohz_idle_enter
      0.41 ± 10%      -0.2        0.19 ±  7%  perf-profile.children.cycles-pp.avc_has_perm
      0.41 ±  2%      -0.2        0.20 ±  4%  perf-profile.children.cycles-pp.__fget_light
      0.43 ± 10%      -0.2        0.21 ± 11%  perf-profile.children.cycles-pp.read_tsc
      0.51 ±  3%      -0.2        0.30 ±  2%  perf-profile.children.cycles-pp.update_rq_clock
      0.48            -0.2        0.27 ±  3%  perf-profile.children.cycles-pp.selinux_sock_rcv_skb_compat
      0.45 ±  2%      -0.2        0.25        perf-profile.children.cycles-pp.native_write_msr
      0.46 ±  2%      -0.2        0.26 ±  4%  perf-profile.children.cycles-pp.sock_def_write_space
      0.38            -0.2        0.18 ±  2%  perf-profile.children.cycles-pp.kmem_cache_alloc_node
      0.49 ±  2%      -0.2        0.30 ±  2%  perf-profile.children.cycles-pp.__kmalloc_reserve
      0.42 ±  2%      -0.2        0.23 ±  2%  perf-profile.children.cycles-pp.update_ts_time_stats
      0.46 ±  4%      -0.2        0.27 ±  3%  perf-profile.children.cycles-pp.copyout
      0.40 ±  2%      -0.2        0.21 ±  4%  perf-profile.children.cycles-pp.ip_local_out
      0.42            -0.2        0.23        perf-profile.children.cycles-pp.skb_set_owner_w
      0.36            -0.2        0.18 ±  4%  perf-profile.children.cycles-pp.pick_next_entity
      0.36 ±  3%      -0.2        0.18 ±  4%  perf-profile.children.cycles-pp.__ip_local_out
      0.33 ±  2%      -0.2        0.16 ±  5%  perf-profile.children.cycles-pp.validate_xmit_skb
      0.32 ±  2%      -0.2        0.15 ±  3%  perf-profile.children.cycles-pp.enqueue_to_backlog
      0.31 ±  3%      -0.2        0.15 ±  3%  perf-profile.children.cycles-pp.put_prev_task_fair
      0.39 ±  7%      -0.2        0.23 ±  4%  perf-profile.children.cycles-pp.ksize
      0.44            -0.2        0.28        perf-profile.children.cycles-pp.__kmalloc_node_track_caller
      0.41 ±  7%      -0.2        0.26        perf-profile.children.cycles-pp.select_idle_sibling
      0.34 ±  2%      -0.2        0.19 ±  6%  perf-profile.children.cycles-pp.ipv4_mtu
      0.30 ±  2%      -0.1        0.15 ±  3%  perf-profile.children.cycles-pp.___might_sleep
      0.35 ±  3%      -0.1        0.21 ±  2%  perf-profile.children.cycles-pp.nr_iowait_cpu
      0.28            -0.1        0.14 ±  3%  perf-profile.children.cycles-pp.__skb_try_recv_from_queue
      0.27 ±  5%      -0.1        0.12 ±  8%  perf-profile.children.cycles-pp.security_socket_sendmsg
      0.29 ±  2%      -0.1        0.15 ±  5%  perf-profile.children.cycles-pp.__udp4_lib_lookup
      0.24 ±  3%      -0.1        0.10        perf-profile.children.cycles-pp.copyin
      0.32 ±  3%      -0.1        0.18 ±  3%  perf-profile.children.cycles-pp.hrtimer_get_next_event
      0.25 ±  4%      -0.1        0.11 ±  4%  perf-profile.children.cycles-pp.kmem_cache_free
      0.24 ±  2%      -0.1        0.11 ±  4%  perf-profile.children.cycles-pp.entry_SYSCALL_64_stage2
      0.28 ±  2%      -0.1        0.15 ±  2%  perf-profile.children.cycles-pp.move_addr_to_kernel
      0.27 ±  4%      -0.1        0.14 ±  3%  perf-profile.children.cycles-pp.sock_has_perm
      0.28            -0.1        0.15 ±  5%  perf-profile.children.cycles-pp.selinux_parse_skb
      0.35 ±  3%      -0.1        0.23 ±  3%  perf-profile.children.cycles-pp.available_idle_cpu
      0.25            -0.1        0.12 ±  4%  perf-profile.children.cycles-pp._copy_from_user
      0.27 ± 20%      -0.1        0.15 ±  7%  perf-profile.children.cycles-pp.__netif_receive_skb_core
      0.29 ±  2%      -0.1        0.17 ±  2%  perf-profile.children.cycles-pp.__list_del_entry_valid
      0.20 ±  8%      -0.1        0.08 ±  5%  perf-profile.children.cycles-pp.__hrtimer_next_event_base
      0.22 ±  4%      -0.1        0.11 ±  4%  perf-profile.children.cycles-pp.account_entity_dequeue
      0.32            -0.1        0.20 ±  5%  perf-profile.children.cycles-pp.__enqueue_entity
      0.29 ±  2%      -0.1        0.17 ±  2%  perf-profile.children.cycles-pp.skb_release_data
      0.22 ±  3%      -0.1        0.11        perf-profile.children.cycles-pp._copy_to_user
      0.20 ±  4%      -0.1        0.09 ±  5%  perf-profile.children.cycles-pp.menu_reflect
      0.21 ±  2%      -0.1        0.10 ±  4%  perf-profile.children.cycles-pp.put_prev_entity
      0.23            -0.1        0.12 ±  3%  perf-profile.children.cycles-pp.cpuidle_governor_latency_req
      0.22 ±  3%      -0.1        0.11 ±  3%  perf-profile.children.cycles-pp.copy_user_enhanced_fast_string
      0.22 ±  3%      -0.1        0.11 ±  4%  perf-profile.children.cycles-pp.rcu_idle_exit
      0.21 ±  2%      -0.1        0.10 ±  4%  perf-profile.children.cycles-pp.security_sk_classify_flow
      0.21 ±  3%      -0.1        0.11 ±  4%  perf-profile.children.cycles-pp.sock_recvmsg
      0.18 ±  3%      -0.1        0.08 ±  5%  perf-profile.children.cycles-pp.__get_user_4
      0.51 ±  3%      -0.1        0.41 ±  2%  perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      0.22            -0.1        0.12 ±  8%  perf-profile.children.cycles-pp.ip_setup_cork
      0.19 ±  4%      -0.1        0.09 ±  4%  perf-profile.children.cycles-pp.inet_sendmsg
      0.21 ±  3%      -0.1        0.11 ±  3%  perf-profile.children.cycles-pp.__might_sleep
      0.20 ±  2%      -0.1        0.10        perf-profile.children.cycles-pp.__calc_delta
      0.18 ±  2%      -0.1        0.09 ±  4%  perf-profile.children.cycles-pp.security_socket_recvmsg
      0.18 ±  2%      -0.1        0.08 ±  5%  perf-profile.children.cycles-pp.call_cpuidle
      0.23 ±  2%      -0.1        0.14 ±  8%  perf-profile.children.cycles-pp.__list_add_valid
      0.12 ±  4%      -0.1        0.04 ± 57%  perf-profile.children.cycles-pp.sched_ttwu_pending
      0.19 ±  3%      -0.1        0.10 ±  4%  perf-profile.children.cycles-pp.rcu_eqs_enter
      0.23 ±  3%      -0.1        0.15 ±  4%  perf-profile.children.cycles-pp.activate_task
      0.18 ±  2%      -0.1        0.10 ±  7%  perf-profile.children.cycles-pp.netif_skb_features
      0.18 ±  4%      -0.1        0.10 ±  4%  perf-profile.children.cycles-pp.rb_erase_cached
      0.15 ±  2%      -0.1        0.07 ±  5%  perf-profile.children.cycles-pp.rcu_needs_cpu
      0.17 ±  4%      -0.1        0.11 ±  4%  perf-profile.children.cycles-pp.ip_finish_output
      0.16 ±  2%      -0.1        0.10        perf-profile.children.cycles-pp.ip_rcv_core
      0.13 ±  3%      -0.1        0.07 ±  5%  perf-profile.children.cycles-pp.selinux_ipv4_output
      0.13            -0.1        0.07        perf-profile.children.cycles-pp.selinux_sk_getsecid
      0.11 ±  6%      -0.1        0.05        perf-profile.children.cycles-pp.update_min_vruntime
      0.08 ±  5%      -0.1        0.03 ±100%  perf-profile.children.cycles-pp.ip_send_check
      0.12 ±  9%      -0.1        0.06 ± 11%  perf-profile.children.cycles-pp.compute_score
      0.10 ±  5%      -0.1        0.04 ± 57%  perf-profile.children.cycles-pp.deactivate_task
      0.11 ±  6%      -0.1        0.05 ±  8%  perf-profile.children.cycles-pp.ipv4_pktinfo_prepare
      0.11            -0.1        0.06 ±  9%  perf-profile.children.cycles-pp.dst_release
      0.08 ±  8%      -0.1        0.03 ±100%  perf-profile.children.cycles-pp.__slab_alloc
      0.11 ±  4%      -0.1        0.06 ± 11%  perf-profile.children.cycles-pp.pm_qos_request
      0.10 ±  4%      -0.1        0.05        perf-profile.children.cycles-pp.udp_rcv
      0.10 ±  8%      -0.1        0.05        perf-profile.children.cycles-pp.__update_idle_core
      0.13 ± 10%      -0.1        0.08 ±  6%  perf-profile.children.cycles-pp.import_single_range
      0.10 ±  4%      -0.0        0.05        perf-profile.children.cycles-pp.rcu_eqs_exit
      0.11 ±  7%      -0.0        0.07        perf-profile.children.cycles-pp.rb_insert_color_cached
      0.08 ±  8%      -0.0        0.04 ± 58%  perf-profile.children.cycles-pp.tick_check_broadcast_expired
      0.13            -0.0        0.10 ±  4%  perf-profile.children.cycles-pp.irq_exit
      0.07 ±  5%      -0.0        0.05        perf-profile.children.cycles-pp.rebalance_domains
      0.07 ±  5%      -0.0        0.05 ±  9%  perf-profile.children.cycles-pp.receiver_wake_function
      0.00            +0.1        0.10 ±  5%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.00            +0.3        0.28        perf-profile.children.cycles-pp.cpumask_next
     31.18            +2.3       33.50        perf-profile.children.cycles-pp.cpuidle_enter_state
     30.02            +2.7       32.70        perf-profile.children.cycles-pp.intel_idle
     49.12            +7.3       56.39        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     48.68            +7.5       56.17        perf-profile.children.cycles-pp.do_syscall_64
     32.69           +15.2       47.88        perf-profile.children.cycles-pp.__x64_sys_sendto
     32.49           +15.3       47.77        perf-profile.children.cycles-pp.__sys_sendto
     31.56           +15.7       47.30        perf-profile.children.cycles-pp.sock_sendmsg
     31.00           +16.0       47.03        perf-profile.children.cycles-pp.udp_sendmsg
     20.10           +23.1       43.18        perf-profile.children.cycles-pp.udp_send_skb
     19.82           +23.2       43.03        perf-profile.children.cycles-pp.ip_send_skb
     19.33           +23.4       42.77        perf-profile.children.cycles-pp.ip_output
     17.85           +24.2       42.05        perf-profile.children.cycles-pp.ip_finish_output2
     15.28           +25.5       40.76        perf-profile.children.cycles-pp.__local_bh_enable_ip
     15.10           +25.6       40.66        perf-profile.children.cycles-pp.do_softirq
     14.84           +25.7       40.52        perf-profile.children.cycles-pp.do_softirq_own_stack
     14.85           +25.7       40.54        perf-profile.children.cycles-pp.__softirqentry_text_start
     14.32           +25.9       40.18        perf-profile.children.cycles-pp.net_rx_action
     13.96           +26.0       39.98        perf-profile.children.cycles-pp.process_backlog
     13.18           +26.4       39.61        perf-profile.children.cycles-pp.__netif_receive_skb_one_core
     12.86           +26.6       39.44        perf-profile.children.cycles-pp.ip_rcv
     12.43           +26.7       39.16        perf-profile.children.cycles-pp.ip_local_deliver
     12.27           +26.8       39.08        perf-profile.children.cycles-pp.ip_local_deliver_finish
     11.93           +27.0       38.90        perf-profile.children.cycles-pp.__udp4_lib_rcv
     11.38           +27.2       38.59        perf-profile.children.cycles-pp.udp_queue_rcv_skb
     10.30           +27.7       38.02        perf-profile.children.cycles-pp.__udp_enqueue_schedule_skb
      1.43 ±  3%     +29.9       31.29        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.06 ± 87%     +30.2       30.31        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      0.15 ±  3%     +31.8       31.98        perf-profile.children.cycles-pp.__sk_mem_raise_allocated
      0.00           +31.9       31.87        perf-profile.children.cycles-pp.__percpu_counter_sum
      4.44 ± 13%      -3.8        0.60 ±  5%  perf-profile.self.cycles-pp.ip_idents_reserve
      2.90            -1.5        1.39        perf-profile.self.cycles-pp.__entry_SYSCALL_64_trampoline
      2.17            -1.0        1.20        perf-profile.self.cycles-pp.__sched_text_start
      1.74            -0.8        0.89        perf-profile.self.cycles-pp.syscall_return_via_sysret
      1.39            -0.7        0.67        perf-profile.self.cycles-pp._raw_spin_lock
      1.36 ±  2%      -0.7        0.67        perf-profile.self.cycles-pp.load_new_mm_cr3
      1.25            -0.6        0.67        perf-profile.self.cycles-pp.update_load_avg
      1.08 ±  2%      -0.5        0.59 ±  2%  perf-profile.self.cycles-pp.__update_load_avg_cfs_rq
      0.87 ±  2%      -0.5        0.41 ±  3%  perf-profile.self.cycles-pp.___perf_sw_event
      1.16            -0.4        0.71        perf-profile.self.cycles-pp.switch_mm_irqs_off
      0.83 ±  2%      -0.4        0.41 ±  2%  perf-profile.self.cycles-pp.__switch_to_asm
      0.85            -0.4        0.43 ±  2%  perf-profile.self.cycles-pp.update_curr
      1.38 ±  2%      -0.4        0.98        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.89 ±  2%      -0.4        0.49        perf-profile.self.cycles-pp.menu_select
      0.71 ±  2%      -0.4        0.35 ±  2%  perf-profile.self.cycles-pp.__switch_to
      0.79            -0.4        0.43        perf-profile.self.cycles-pp.do_idle
      0.82 ±  3%      -0.4        0.46 ±  2%  perf-profile.self.cycles-pp.resched_curr
      0.68 ±  2%      -0.4        0.32 ±  3%  perf-profile.self.cycles-pp.udp_sendmsg
      0.70 ±  7%      -0.3        0.35 ±  3%  perf-profile.self.cycles-pp.update_cfs_group
      0.68 ± 11%      -0.3        0.35 ± 12%  perf-profile.self.cycles-pp.fib_table_lookup
      0.71            -0.3        0.41        perf-profile.self.cycles-pp._raw_spin_lock_bh
      0.68 ±  3%      -0.3        0.38 ±  2%  perf-profile.self.cycles-pp.copy_user_generic_unrolled
      0.66 ±  2%      -0.3        0.35 ±  3%  perf-profile.self.cycles-pp.__slab_free
      0.62            -0.3        0.32 ±  2%  perf-profile.self.cycles-pp.pick_next_task_fair
      0.67 ±  2%      -0.3        0.38        perf-profile.self.cycles-pp.select_task_rq_fair
      0.65            -0.3        0.36        perf-profile.self.cycles-pp.set_next_entity
      0.59            -0.3        0.32        perf-profile.self.cycles-pp.udp_recvmsg
      0.57            -0.3        0.30 ±  2%  perf-profile.self.cycles-pp.finish_task_switch
      0.65            -0.3        0.39        perf-profile.self.cycles-pp.enqueue_entity
      0.51 ±  2%      -0.3        0.26 ±  3%  perf-profile.self.cycles-pp.do_syscall_64
      0.49            -0.3        0.24 ±  3%  perf-profile.self.cycles-pp.ip_route_output_key_hash_rcu
      0.52 ±  2%      -0.2        0.27 ±  2%  perf-profile.self.cycles-pp.native_sched_clock
      0.54 ±  3%      -0.2        0.29 ±  2%  perf-profile.self.cycles-pp.dequeue_entity
      0.54            -0.2        0.30 ±  2%  perf-profile.self.cycles-pp.reweight_entity
      0.45 ±  2%      -0.2        0.21 ±  7%  perf-profile.self.cycles-pp.__ip_append_data
      0.47 ±  3%      -0.2        0.24        perf-profile.self.cycles-pp.__next_timer_interrupt
      0.57 ±  3%      -0.2        0.34 ±  3%  perf-profile.self.cycles-pp.poll_idle
      0.42 ±  2%      -0.2        0.19 ±  3%  perf-profile.self.cycles-pp.__skb_wait_for_more_packets
      0.54 ±  2%      -0.2        0.32        perf-profile.self.cycles-pp.__update_load_avg_se
      0.44            -0.2        0.21 ±  2%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.39 ±  2%      -0.2        0.16 ±  6%  perf-profile.self.cycles-pp.ip_output
      0.55            -0.2        0.33 ±  2%  perf-profile.self.cycles-pp.enqueue_task_fair
      0.41 ±  3%      -0.2        0.20 ±  4%  perf-profile.self.cycles-pp.__fget_light
      0.40 ± 10%      -0.2        0.18 ±  6%  perf-profile.self.cycles-pp.avc_has_perm
      0.48            -0.2        0.28        perf-profile.self.cycles-pp.move_addr_to_user
      0.45            -0.2        0.24 ±  2%  perf-profile.self.cycles-pp.native_write_msr
      0.40 ± 10%      -0.2        0.20 ± 13%  perf-profile.self.cycles-pp.read_tsc
      0.36 ±  4%      -0.2        0.16 ±  4%  perf-profile.self.cycles-pp.__skb_recv_udp
      0.45 ±  2%      -0.2        0.25 ±  5%  perf-profile.self.cycles-pp.sock_def_write_space
      0.42 ±  2%      -0.2        0.23 ±  2%  perf-profile.self.cycles-pp.account_entity_enqueue
      0.38 ±  5%      -0.2        0.19 ±  2%  perf-profile.self.cycles-pp.dequeue_task_fair
      0.39 ±  8%      -0.2        0.20 ±  3%  perf-profile.self.cycles-pp.ip_finish_output2
      0.41            -0.2        0.23        perf-profile.self.cycles-pp.skb_set_owner_w
      0.60 ±  4%      -0.2        0.42        perf-profile.self.cycles-pp.find_next_bit
      0.34            -0.2        0.17 ±  3%  perf-profile.self.cycles-pp.__ip_make_skb
      0.36 ±  3%      -0.2        0.19 ±  2%  perf-profile.self.cycles-pp.process_backlog
      0.45 ±  4%      -0.2        0.28        perf-profile.self.cycles-pp._raw_spin_unlock_irqrestore
      0.31 ±  2%      -0.2        0.15 ±  2%  perf-profile.self.cycles-pp.__alloc_skb
      0.33            -0.2        0.17 ±  4%  perf-profile.self.cycles-pp.pick_next_entity
      0.38 ±  6%      -0.2        0.22 ±  3%  perf-profile.self.cycles-pp.ksize
      0.38 ±  4%      -0.2        0.22 ±  3%  perf-profile.self.cycles-pp.__softirqentry_text_start
      0.31 ±  2%      -0.2        0.15 ±  2%  perf-profile.self.cycles-pp.__sys_sendto
      0.29 ±  3%      -0.2        0.14 ±  8%  perf-profile.self.cycles-pp._copy_to_iter
      0.30 ±  3%      -0.1        0.15        perf-profile.self.cycles-pp.___might_sleep
      0.27            -0.1        0.12 ±  5%  perf-profile.self.cycles-pp.sock_wfree
      0.40 ±  2%      -0.1        0.26 ±  3%  perf-profile.self.cycles-pp.__udp_enqueue_schedule_skb
      0.27 ±  3%      -0.1        0.13 ±  3%  perf-profile.self.cycles-pp.__sys_recvfrom
      0.31            -0.1        0.17 ±  6%  perf-profile.self.cycles-pp.ipv4_mtu
      0.34 ±  3%      -0.1        0.21 ±  2%  perf-profile.self.cycles-pp.nr_iowait_cpu
      0.27 ±  4%      -0.1        0.13 ±  3%  perf-profile.self.cycles-pp.sock_has_perm
      0.29            -0.1        0.16 ±  5%  perf-profile.self.cycles-pp.net_rx_action
      0.24 ±  3%      -0.1        0.10 ±  4%  perf-profile.self.cycles-pp.entry_SYSCALL_64_stage2
      0.28 ±  2%      -0.1        0.15 ±  4%  perf-profile.self.cycles-pp.loopback_xmit
      0.24 ±  3%      -0.1        0.11 ±  4%  perf-profile.self.cycles-pp.inet_recvmsg
      0.27            -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.do_softirq
      0.27            -0.1        0.15 ±  5%  perf-profile.self.cycles-pp.selinux_parse_skb
      0.27 ± 20%      -0.1        0.15 ±  5%  perf-profile.self.cycles-pp.__netif_receive_skb_core
      0.35 ±  4%      -0.1        0.23        perf-profile.self.cycles-pp.available_idle_cpu
      0.31 ±  2%      -0.1        0.19 ±  3%  perf-profile.self.cycles-pp.__enqueue_entity
      0.24            -0.1        0.12 ±  3%  perf-profile.self.cycles-pp.selinux_socket_sock_rcv_skb
      0.29 ±  3%      -0.1        0.17 ±  4%  perf-profile.self.cycles-pp.__list_del_entry_valid
      0.28 ±  3%      -0.1        0.17 ±  3%  perf-profile.self.cycles-pp.skb_release_data
      0.27 ±  2%      -0.1        0.16 ±  4%  perf-profile.self.cycles-pp.__udp4_lib_rcv
      0.21 ±  5%      -0.1        0.10 ±  5%  perf-profile.self.cycles-pp.account_entity_dequeue
      0.21 ±  2%      -0.1        0.10 ±  4%  perf-profile.self.cycles-pp.kmem_cache_alloc_node
      0.18 ±  4%      -0.1        0.08 ±  5%  perf-profile.self.cycles-pp.tick_nohz_next_event
      0.23            -0.1        0.12 ±  4%  perf-profile.self.cycles-pp.udp_send_skb
      0.21 ±  3%      -0.1        0.10 ±  4%  perf-profile.self.cycles-pp.copy_user_enhanced_fast_string
      0.26            -0.1        0.16 ±  4%  perf-profile.self.cycles-pp.try_to_wake_up
      0.20 ±  4%      -0.1        0.09 ±  4%  perf-profile.self.cycles-pp.put_prev_task_fair
      0.24 ±  3%      -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.__wake_up_common
      0.20 ±  4%      -0.1        0.10 ±  4%  perf-profile.self.cycles-pp.__x64_sys_recvfrom
      0.18 ±  3%      -0.1        0.08 ±  5%  perf-profile.self.cycles-pp.selinux_ip_postroute_compat
      0.18 ±  2%      -0.1        0.08 ±  5%  perf-profile.self.cycles-pp.__get_user_4
      0.20 ±  8%      -0.1        0.11 ±  4%  perf-profile.self.cycles-pp.__dev_queue_xmit
      0.26 ±  5%      -0.1        0.16 ±  2%  perf-profile.self.cycles-pp.update_rq_clock
      0.26            -0.1        0.16 ±  4%  perf-profile.self.cycles-pp.__kmalloc_node_track_caller
      0.20 ±  2%      -0.1        0.10 ±  4%  perf-profile.self.cycles-pp.__local_bh_enable_ip
      0.19 ±  3%      -0.1        0.10 ±  4%  perf-profile.self.cycles-pp.enqueue_to_backlog
      0.18 ±  2%      -0.1        0.08 ±  5%  perf-profile.self.cycles-pp.call_cpuidle
      0.22 ±  3%      -0.1        0.13 ±  9%  perf-profile.self.cycles-pp.__list_add_valid
      0.19 ±  3%      -0.1        0.10        perf-profile.self.cycles-pp.__calc_delta
      0.17 ±  2%      -0.1        0.08 ±  5%  perf-profile.self.cycles-pp.inet_sendmsg
      0.20 ±  4%      -0.1        0.11 ±  6%  perf-profile.self.cycles-pp.__x64_sys_sendto
      0.19 ±  3%      -0.1        0.10 ±  4%  perf-profile.self.cycles-pp.rcu_eqs_enter
      0.12 ±  4%      -0.1        0.04 ± 57%  perf-profile.self.cycles-pp.sched_ttwu_pending
      0.23 ±  3%      -0.1        0.15 ±  4%  perf-profile.self.cycles-pp.activate_task
      0.19 ±  4%      -0.1        0.11 ±  4%  perf-profile.self.cycles-pp.check_preempt_curr
      0.18 ±  2%      -0.1        0.10        perf-profile.self.cycles-pp.__might_sleep
      0.18 ±  2%      -0.1        0.09 ±  4%  perf-profile.self.cycles-pp.__udp4_lib_lookup
      0.19 ±  6%      -0.1        0.11 ± 18%  perf-profile.self.cycles-pp.ktime_get
      0.14 ±  3%      -0.1        0.06 ± 15%  perf-profile.self.cycles-pp.validate_xmit_skb
      0.16 ±  2%      -0.1        0.08 ±  5%  perf-profile.self.cycles-pp.selinux_sock_rcv_skb_compat
      0.15 ±  4%      -0.1        0.07 ±  5%  perf-profile.self.cycles-pp.selinux_ip_postroute
      0.13 ±  3%      -0.1        0.05        perf-profile.self.cycles-pp._copy_from_iter_full
      0.15 ±  3%      -0.1        0.07 ± 10%  perf-profile.self.cycles-pp.rcu_needs_cpu
      0.16 ±  2%      -0.1        0.08 ±  5%  perf-profile.self.cycles-pp.prepare_to_wait_exclusive
      0.17 ±  5%      -0.1        0.09 ±  4%  perf-profile.self.cycles-pp.ip_local_deliver_finish
      0.14 ±  5%      -0.1        0.07 ± 10%  perf-profile.self.cycles-pp.netif_skb_features
      0.10 ±  4%      -0.1        0.03 ±100%  perf-profile.self.cycles-pp.put_prev_entity
      0.14 ±  3%      -0.1        0.07 ±  7%  perf-profile.self.cycles-pp.__might_fault
      0.14 ±  3%      -0.1        0.07 ±  6%  perf-profile.self.cycles-pp.menu_reflect
      0.16 ±  5%      -0.1        0.09        perf-profile.self.cycles-pp.rb_erase_cached
      0.16 ±  2%      -0.1        0.10 ±  5%  perf-profile.self.cycles-pp.ip_rcv_core
      0.15 ±  3%      -0.1        0.08 ±  5%  perf-profile.self.cycles-pp.ip_rcv
      0.09 ±  4%      -0.1        0.03 ±100%  perf-profile.self.cycles-pp.udp_rcv
      0.15            -0.1        0.08 ±  5%  perf-profile.self.cycles-pp.ip_local_deliver
      0.13 ±  3%      -0.1        0.07 ±  6%  perf-profile.self.cycles-pp.__hrtimer_next_event_base
      0.09            -0.1        0.03 ±100%  perf-profile.self.cycles-pp.selinux_ipv4_output
      0.09 ±  7%      -0.1        0.03 ±100%  perf-profile.self.cycles-pp.deactivate_task
      0.12 ±  3%      -0.1        0.06 ±  6%  perf-profile.self.cycles-pp.rcu_idle_exit
      0.12            -0.1        0.06        perf-profile.self.cycles-pp.selinux_sk_getsecid
      0.11 ±  4%      -0.1        0.05        perf-profile.self.cycles-pp.ip_make_skb
      0.10 ± 11%      -0.1        0.04 ± 57%  perf-profile.self.cycles-pp.__update_idle_core
      0.08            -0.1        0.03 ±100%  perf-profile.self.cycles-pp.ip_send_check
      0.11 ±  4%      -0.1        0.06 ± 11%  perf-profile.self.cycles-pp.pm_qos_request
      0.11 ±  7%      -0.1        0.06 ± 11%  perf-profile.self.cycles-pp.compute_score
      0.11 ±  7%      -0.1        0.05 ±  9%  perf-profile.self.cycles-pp.sock_sendmsg
      0.11 ±  7%      -0.1        0.06 ±  9%  perf-profile.self.cycles-pp.ip_generic_getfrag
      0.11 ±  3%      -0.1        0.06        perf-profile.self.cycles-pp.switch_mm
      0.11 ±  4%      -0.1        0.06 ±  9%  perf-profile.self.cycles-pp.nf_hook_slow
      0.08 ±  6%      -0.1        0.03 ±100%  perf-profile.self.cycles-pp.alloc_skb_with_frags
      0.10 ±  7%      -0.1        0.05        perf-profile.self.cycles-pp.__skb_try_recv_from_queue
      0.10            -0.1        0.05        perf-profile.self.cycles-pp.dst_release
      0.12 ± 10%      -0.0        0.07        perf-profile.self.cycles-pp.import_single_range
      0.11 ±  6%      -0.0        0.06        perf-profile.self.cycles-pp.rb_insert_color_cached
      0.10 ±  4%      -0.0        0.05 ±  8%  perf-profile.self.cycles-pp.sock_alloc_send_pskb
      0.12 ±  5%      -0.0        0.08 ±  6%  perf-profile.self.cycles-pp.cpuidle_enter_state
      0.09 ±  4%      -0.0        0.05        perf-profile.self.cycles-pp.ip_finish_output
      0.10            -0.0        0.06        perf-profile.self.cycles-pp.ip_send_skb
      0.09 ±  7%      -0.0        0.05        perf-profile.self.cycles-pp.schedule_idle
      0.09 ±  4%      -0.0        0.05        perf-profile.self.cycles-pp.get_next_timer_interrupt
      0.09 ±  4%      -0.0        0.06 ±  9%  perf-profile.self.cycles-pp.udp_queue_rcv_skb
      0.08 ±  6%      -0.0        0.04 ± 58%  perf-profile.self.cycles-pp.tick_check_broadcast_expired
      0.09 ±  5%      -0.0        0.05        perf-profile.self.cycles-pp.dev_hard_start_xmit
      0.08 ±  5%      -0.0        0.05        perf-profile.self.cycles-pp.ip_setup_cork
      0.10 ±  7%      -0.0        0.07 ±  6%  perf-profile.self.cycles-pp.do_softirq_own_stack
      0.07            -0.0        0.05        perf-profile.self.cycles-pp.receiver_wake_function
      0.00            +0.1        0.10 ±  5%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.00            +0.1        0.10 ±  4%  perf-profile.self.cycles-pp.cpumask_next
      0.00            +1.0        1.01        perf-profile.self.cycles-pp.__percpu_counter_sum
     30.01            +2.7       32.69        perf-profile.self.cycles-pp.intel_idle
      0.06 ± 87%     +30.2       30.31        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath



***************************************************************************************************
lkp-bdw-ep2: 88 threads Intel(R) Xeon(R) CPU E5-2699 v4 @ 2.20GHz with 128G memory
=========================================================================================
cluster/compiler/cpufreq_governor/ip/kconfig/nr_threads/rootfs/runtime/tbox_group/test/testcase:
  cs-localhost/gcc-7/performance/ipv4/x86_64-rhel-7.2/25%/debian-x86_64-2018-04-03.cgz/300s/lkp-bdw-ep2/UDP_RR/netperf

commit: 
  6da410d97f (" mlx5e-fixes-2018-09-05")
  b99259a614 ("net/sock: move memory_allocated over to percpu_counter variables")

6da410d97ffa486e b99259a61450bb6403bbbbf279 
---------------- -------------------------- 
       fail:runs  %reproduction    fail:runs
           |             |             |    
           :4           25%           1:4     dmesg.WARNING:at#for_ip_interrupt_entry/0x
          9:4          -43%           7:4     perf-profile.calltrace.cycles-pp.dequeue_entity.dequeue_task_fair.__sched_text_start.schedule.schedule_timeout
          3:4          -15%           3:4     perf-profile.calltrace.cycles-pp.switch_mm_irqs_off.switch_mm.__sched_text_start.schedule.schedule_timeout
         26:4         -109%          21:4     perf-profile.children.cycles-pp.schedule_timeout
          1:4          -11%           1:4     perf-profile.self.cycles-pp.schedule_timeout
         %stddev     %change         %stddev
             \          |                \  
   1930589           -13.5%    1670226        netperf.Throughput_total_tps
     87754           -13.5%      75919        netperf.Throughput_tps
      1426            -3.9%       1371 ±  2%  netperf.time.percent_of_cpu_this_job_got
      3911            -2.6%       3809 ±  2%  netperf.time.system_time
    385.12           -17.0%     319.68 ±  4%  netperf.time.user_time
 5.792e+08           -13.5%  5.011e+08        netperf.time.voluntary_context_switches
 5.792e+08           -13.5%  5.011e+08        netperf.workload
 5.792e+08           -12.5%  5.068e+08        softirqs.NET_RX
   7590488           -13.1%    6595363        vmstat.system.cs
      2095 ± 50%    +740.9%      17617 ± 87%  numa-meminfo.node0.Shmem
     40809 ±  4%     -14.3%      34971 ± 11%  numa-meminfo.node1.SReclaimable
    415.39            -1.8%     408.09        pmeter.Average_Active_Power
    211.25           -11.9%     186.02        pmeter.performance_per_watt
     18997 ±  6%      +8.2%      20555 ±  3%  sched_debug.cpu.load.avg
  13008831           -13.3%   11273636        sched_debug.cpu.nr_switches.avg
 1.133e+09           -12.8%  9.877e+08        cpuidle.C1.usage
 8.879e+09 ± 18%     -43.5%  5.013e+09 ± 54%  cpuidle.C6.time
  25831364 ±  3%     -27.4%   18752863        cpuidle.POLL.usage
      7.97            +2.5       10.43        mpstat.cpu.soft%
     17.09            -2.4       14.66        mpstat.cpu.sys%
      2.34            -0.3        2.00 ±  2%  mpstat.cpu.usr%
      1037            -3.8%     998.50        turbostat.Avg_MHz
 1.133e+09           -12.8%  9.877e+08        turbostat.C1
     33.21 ± 18%     -14.4       18.80 ± 55%  turbostat.C6%
      0.96 ± 96%    +201.3%       2.88 ± 30%  turbostat.CPU%c3
    216.23            -2.2%     211.46        turbostat.PkgWatt
    523.00 ± 50%    +742.2%       4404 ± 87%  numa-vmstat.node0.nr_shmem
    471766 ± 12%     +27.2%     600222 ±  6%  numa-vmstat.node0.numa_hit
    454541 ± 12%     +28.6%     584644 ±  7%  numa-vmstat.node0.numa_local
     10202 ±  4%     -14.3%       8743 ± 11%  numa-vmstat.node1.nr_slab_reclaimable
    665328 ±  9%     -20.2%     530868 ±  7%  numa-vmstat.node1.numa_hit
    532036 ± 11%     -25.5%     396167 ±  9%  numa-vmstat.node1.numa_local
 3.597e+12            -6.9%  3.348e+12        perf-stat.branch-instructions
      2.70            -0.2        2.54        perf-stat.branch-miss-rate%
 9.714e+10           -12.4%  8.509e+10        perf-stat.branch-misses
 3.173e+11 ±  2%     -14.9%  2.701e+11        perf-stat.cache-references
 2.317e+09           -13.3%   2.01e+09        perf-stat.context-switches
      1.59            +3.4%       1.64        perf-stat.cpi
 2.871e+13            -4.5%  2.742e+13        perf-stat.cpu-cycles
      0.09            -0.0        0.09        perf-stat.dTLB-load-miss-rate%
 4.816e+09           -10.7%  4.302e+09        perf-stat.dTLB-load-misses
  5.29e+12            -8.4%  4.846e+12        perf-stat.dTLB-loads
      0.00 ± 27%      +0.0        0.00 ±  9%  perf-stat.dTLB-store-miss-rate%
  50665696 ± 27%     +87.6%   95071493 ±  9%  perf-stat.dTLB-store-misses
 3.418e+12           -11.6%  3.023e+12        perf-stat.dTLB-stores
     11.55 ±  5%      +1.9       13.47 ±  7%  perf-stat.iTLB-load-miss-rate%
 4.068e+10           -16.8%  3.384e+10 ±  2%  perf-stat.iTLB-loads
  1.81e+13            -7.6%  1.673e+13        perf-stat.instructions
      0.63            -3.3%       0.61        perf-stat.ipc
  7.63e+08 ± 20%     +87.8%  1.433e+09 ±  3%  perf-stat.node-load-misses
     86.73 ±  2%     -27.7       59.01        perf-stat.node-store-miss-rate%
 5.359e+08 ±  9%     +17.5%  6.296e+08        perf-stat.node-store-misses
  83392223 ± 25%    +424.4%  4.373e+08        perf-stat.node-stores
     31255            +6.8%      33385        perf-stat.path-length
     13.66 ±  2%      -2.4       11.21 ±  6%  perf-profile.calltrace.cycles-pp.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.45 ±  2%      -2.4       11.05 ±  6%  perf-profile.calltrace.cycles-pp.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
     11.88 ±  2%      -2.1        9.73 ±  6%  perf-profile.calltrace.cycles-pp.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
     11.67 ±  2%      -2.1        9.58 ±  6%  perf-profile.calltrace.cycles-pp.udp_recvmsg.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64
      9.09 ±  2%      -1.6        7.45 ±  7%  perf-profile.calltrace.cycles-pp.__skb_recv_udp.udp_recvmsg.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom
      7.67 ±  2%      -1.4        6.27 ±  7%  perf-profile.calltrace.cycles-pp.__skb_wait_for_more_packets.__skb_recv_udp.udp_recvmsg.inet_recvmsg.__sys_recvfrom
      9.02 ±  2%      -1.3        7.69 ±  6%  perf-profile.calltrace.cycles-pp.__wake_up_common_lock.sock_def_readable.__udp_enqueue_schedule_skb.udp_queue_rcv_skb.__udp4_lib_rcv
      9.25 ±  2%      -1.3        7.99 ±  6%  perf-profile.calltrace.cycles-pp.sock_def_readable.__udp_enqueue_schedule_skb.udp_queue_rcv_skb.__udp4_lib_rcv.ip_local_deliver_finish
      8.48 ±  2%      -1.2        7.24 ±  7%  perf-profile.calltrace.cycles-pp.__wake_up_common.__wake_up_common_lock.sock_def_readable.__udp_enqueue_schedule_skb.udp_queue_rcv_skb
      8.14 ±  3%      -1.1        6.99 ±  7%  perf-profile.calltrace.cycles-pp.autoremove_wake_function.__wake_up_common.__wake_up_common_lock.sock_def_readable.__udp_enqueue_schedule_skb
      8.03 ±  3%      -1.1        6.89 ±  7%  perf-profile.calltrace.cycles-pp.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_common_lock.sock_def_readable
      6.50 ±  2%      -1.1        5.41 ±  7%  perf-profile.calltrace.cycles-pp.schedule_timeout.__skb_wait_for_more_packets.__skb_recv_udp.udp_recvmsg.inet_recvmsg
      6.11 ±  2%      -1.0        5.12 ±  7%  perf-profile.calltrace.cycles-pp.schedule.schedule_timeout.__skb_wait_for_more_packets.__skb_recv_udp.udp_recvmsg
      5.97 ±  2%      -1.0        5.02 ±  7%  perf-profile.calltrace.cycles-pp.__sched_text_start.schedule.schedule_timeout.__skb_wait_for_more_packets.__skb_recv_udp
      5.49            -0.9        4.60 ±  5%  perf-profile.calltrace.cycles-pp.schedule_idle.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
      5.35            -0.9        4.48 ±  5%  perf-profile.calltrace.cycles-pp.__sched_text_start.schedule_idle.do_idle.cpu_startup_entry.start_secondary
      4.79            -0.8        3.96 ±  6%  perf-profile.calltrace.cycles-pp.ip_make_skb.udp_sendmsg.sock_sendmsg.__sys_sendto.__x64_sys_sendto
      4.50 ±  2%      -0.7        3.85 ±  7%  perf-profile.calltrace.cycles-pp.ttwu_do_activate.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_common_lock
      4.24 ±  2%      -0.6        3.62 ±  8%  perf-profile.calltrace.cycles-pp.enqueue_task_fair.ttwu_do_activate.try_to_wake_up.autoremove_wake_function.__wake_up_common
      3.50 ±  3%      -0.5        2.99 ±  8%  perf-profile.calltrace.cycles-pp.enqueue_entity.enqueue_task_fair.ttwu_do_activate.try_to_wake_up.autoremove_wake_function
      2.62 ±  2%      -0.5        2.16 ±  7%  perf-profile.calltrace.cycles-pp.dequeue_task_fair.__sched_text_start.schedule.schedule_timeout.__skb_wait_for_more_packets
      2.88            -0.4        2.46 ±  6%  perf-profile.calltrace.cycles-pp.__ip_append_data.ip_make_skb.udp_sendmsg.sock_sendmsg.__sys_sendto
      1.68            -0.4        1.29 ±  4%  perf-profile.calltrace.cycles-pp.__ip_make_skb.ip_make_skb.udp_sendmsg.sock_sendmsg.__sys_sendto
      2.78 ±  3%      -0.4        2.42 ±  7%  perf-profile.calltrace.cycles-pp.menu_select.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
      1.84            -0.4        1.48 ±  6%  perf-profile.calltrace.cycles-pp.pick_next_task_fair.__sched_text_start.schedule_idle.do_idle.cpu_startup_entry
      0.64 ±  3%      -0.4        0.28 ±100%  perf-profile.calltrace.cycles-pp.__next_timer_interrupt.get_next_timer_interrupt.tick_nohz_next_event.tick_nohz_get_sleep_length.menu_select
      1.89 ±  3%      -0.3        1.56 ±  7%  perf-profile.calltrace.cycles-pp.__entry_SYSCALL_64_trampoline
      2.04 ±  4%      -0.3        1.73 ±  8%  perf-profile.calltrace.cycles-pp.__dev_queue_xmit.ip_finish_output2.ip_output.ip_send_skb.udp_send_skb
      1.29 ±  2%      -0.3        1.00 ±  4%  perf-profile.calltrace.cycles-pp.__ip_select_ident.__ip_make_skb.ip_make_skb.udp_sendmsg.sock_sendmsg
      1.22 ±  2%      -0.3        0.94 ±  4%  perf-profile.calltrace.cycles-pp.ip_idents_reserve.__ip_select_ident.__ip_make_skb.ip_make_skb.udp_sendmsg
      1.32            -0.3        1.04 ±  6%  perf-profile.calltrace.cycles-pp.set_next_entity.pick_next_task_fair.__sched_text_start.schedule_idle.do_idle
      2.11 ±  2%      -0.3        1.83 ±  6%  perf-profile.calltrace.cycles-pp.sock_alloc_send_pskb.__ip_append_data.ip_make_skb.udp_sendmsg.sock_sendmsg
      1.77 ±  3%      -0.3        1.50 ±  8%  perf-profile.calltrace.cycles-pp.tick_nohz_get_sleep_length.menu_select.do_idle.cpu_startup_entry.start_secondary
      1.49            -0.3        1.22 ±  5%  perf-profile.calltrace.cycles-pp.syscall_return_via_sysret
      1.58 ±  4%      -0.2        1.36 ±  7%  perf-profile.calltrace.cycles-pp.dev_hard_start_xmit.__dev_queue_xmit.ip_finish_output2.ip_output.ip_send_skb
      1.60            -0.2        1.40 ±  4%  perf-profile.calltrace.cycles-pp.switch_mm_irqs_off.__sched_text_start.schedule_idle.do_idle.cpu_startup_entry
      1.50 ±  4%      -0.2        1.30 ±  7%  perf-profile.calltrace.cycles-pp.loopback_xmit.dev_hard_start_xmit.__dev_queue_xmit.ip_finish_output2.ip_output
      0.60 ±  2%      -0.2        0.41 ± 58%  perf-profile.calltrace.cycles-pp.selinux_socket_sock_rcv_skb.security_sock_rcv_skb.sk_filter_trim_cap.udp_queue_rcv_skb.__udp4_lib_rcv
      1.48 ±  2%      -0.2        1.29 ±  7%  perf-profile.calltrace.cycles-pp.alloc_skb_with_frags.sock_alloc_send_pskb.__ip_append_data.ip_make_skb.udp_sendmsg
      1.41 ±  2%      -0.2        1.23 ±  7%  perf-profile.calltrace.cycles-pp.__alloc_skb.alloc_skb_with_frags.sock_alloc_send_pskb.__ip_append_data.ip_make_skb
      0.90            -0.2        0.73 ±  4%  perf-profile.calltrace.cycles-pp._copy_to_iter.udp_recvmsg.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom
      1.09 ±  3%      -0.2        0.93 ±  8%  perf-profile.calltrace.cycles-pp.get_next_timer_interrupt.tick_nohz_next_event.tick_nohz_get_sleep_length.menu_select.do_idle
      0.81 ±  3%      -0.2        0.66 ±  4%  perf-profile.calltrace.cycles-pp.sock_wfree.loopback_xmit.dev_hard_start_xmit.__dev_queue_xmit.ip_finish_output2
      1.02 ±  3%      -0.2        0.87 ±  7%  perf-profile.calltrace.cycles-pp.switch_mm.__sched_text_start.schedule.schedule_timeout.__skb_wait_for_more_packets
      0.94            -0.2        0.79 ±  6%  perf-profile.calltrace.cycles-pp.move_addr_to_user.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.72            -0.2        0.57 ±  4%  perf-profile.calltrace.cycles-pp.__switch_to_asm
      0.90 ±  3%      -0.2        0.75 ±  5%  perf-profile.calltrace.cycles-pp.__consume_stateless_skb.udp_recvmsg.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom
      0.70 ±  3%      -0.2        0.54 ±  4%  perf-profile.calltrace.cycles-pp.tick_nohz_idle_exit.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
      0.71 ±  2%      -0.1        0.58 ±  9%  perf-profile.calltrace.cycles-pp.nf_hook_slow.ip_output.ip_send_skb.udp_send_skb.udp_sendmsg
      0.94 ±  3%      -0.1        0.82 ±  8%  perf-profile.calltrace.cycles-pp.select_task_rq_fair.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_common_lock
      0.99 ±  4%      -0.1        0.88 ±  5%  perf-profile.calltrace.cycles-pp.ip_route_output_flow.udp_sendmsg.sock_sendmsg.__sys_sendto.__x64_sys_sendto
      1.07 ±  5%      -0.1        0.96 ±  5%  perf-profile.calltrace.cycles-pp.ttwu_do_wakeup.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_common_lock
      0.73 ±  3%      -0.1        0.62 ±  4%  perf-profile.calltrace.cycles-pp.poll_idle.cpuidle_enter_state.do_idle.cpu_startup_entry.start_secondary
      1.02 ±  5%      -0.1        0.92 ±  5%  perf-profile.calltrace.cycles-pp.check_preempt_curr.ttwu_do_wakeup.try_to_wake_up.autoremove_wake_function.__wake_up_common
      0.68 ±  2%      -0.1        0.59 ±  7%  perf-profile.calltrace.cycles-pp.sk_filter_trim_cap.udp_queue_rcv_skb.__udp4_lib_rcv.ip_local_deliver_finish.ip_local_deliver
      0.69 ±  4%      -0.1        0.60 ±  8%  perf-profile.calltrace.cycles-pp._raw_spin_lock_bh.__skb_recv_udp.udp_recvmsg.inet_recvmsg.__sys_recvfrom
      0.64 ±  2%      -0.1        0.55 ±  6%  perf-profile.calltrace.cycles-pp.security_sock_rcv_skb.sk_filter_trim_cap.udp_queue_rcv_skb.__udp4_lib_rcv.ip_local_deliver_finish
     26.69 ±  2%      +1.9       28.61 ±  5%  perf-profile.calltrace.cycles-pp.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe
     26.51 ±  2%      +1.9       28.45 ±  5%  perf-profile.calltrace.cycles-pp.__sys_sendto.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe
     25.75 ±  2%      +2.1       27.80 ±  5%  perf-profile.calltrace.cycles-pp.sock_sendmsg.__sys_sendto.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe
     25.20 ±  2%      +2.2       27.38 ±  5%  perf-profile.calltrace.cycles-pp.udp_sendmsg.sock_sendmsg.__sys_sendto.__x64_sys_sendto.do_syscall_64
     18.57 ±  2%      +3.3       21.89 ±  5%  perf-profile.calltrace.cycles-pp.udp_send_skb.udp_sendmsg.sock_sendmsg.__sys_sendto.__x64_sys_sendto
     18.32 ±  2%      +3.4       21.68 ±  5%  perf-profile.calltrace.cycles-pp.ip_send_skb.udp_send_skb.udp_sendmsg.sock_sendmsg.__sys_sendto
     17.95 ±  2%      +3.4       21.32 ±  5%  perf-profile.calltrace.cycles-pp.ip_output.ip_send_skb.udp_send_skb.udp_sendmsg.sock_sendmsg
     16.70 ±  2%      +3.6       20.34 ±  5%  perf-profile.calltrace.cycles-pp.ip_finish_output2.ip_output.ip_send_skb.udp_send_skb.udp_sendmsg
     14.36 ±  2%      +4.0       18.32 ±  5%  perf-profile.calltrace.cycles-pp.__local_bh_enable_ip.ip_finish_output2.ip_output.ip_send_skb.udp_send_skb
     14.21 ±  2%      +4.0       18.22 ±  5%  perf-profile.calltrace.cycles-pp.do_softirq.__local_bh_enable_ip.ip_finish_output2.ip_output.ip_send_skb
     13.99 ±  2%      +4.0       18.01 ±  5%  perf-profile.calltrace.cycles-pp.__softirqentry_text_start.do_softirq_own_stack.do_softirq.__local_bh_enable_ip.ip_finish_output2
     14.04 ±  2%      +4.0       18.07 ±  5%  perf-profile.calltrace.cycles-pp.do_softirq_own_stack.do_softirq.__local_bh_enable_ip.ip_finish_output2.ip_output
     13.60 ±  2%      +4.1       17.66 ±  5%  perf-profile.calltrace.cycles-pp.net_rx_action.__softirqentry_text_start.do_softirq_own_stack.do_softirq.__local_bh_enable_ip
     13.30 ±  2%      +4.1       17.42 ±  5%  perf-profile.calltrace.cycles-pp.process_backlog.net_rx_action.__softirqentry_text_start.do_softirq_own_stack.do_softirq
      0.00            +4.1        4.14 ±  5%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__percpu_counter_sum.__sk_mem_raise_allocated.__udp_enqueue_schedule_skb
     12.53 ±  2%      +4.2       16.77 ±  5%  perf-profile.calltrace.cycles-pp.__netif_receive_skb_one_core.process_backlog.net_rx_action.__softirqentry_text_start.do_softirq_own_stack
     12.28 ±  2%      +4.2       16.52 ±  5%  perf-profile.calltrace.cycles-pp.ip_rcv.__netif_receive_skb_one_core.process_backlog.net_rx_action.__softirqentry_text_start
     11.88 ±  3%      +4.3       16.14 ±  5%  perf-profile.calltrace.cycles-pp.ip_local_deliver.ip_rcv.__netif_receive_skb_one_core.process_backlog.net_rx_action
     11.73 ±  3%      +4.3       16.00 ±  5%  perf-profile.calltrace.cycles-pp.ip_local_deliver_finish.ip_local_deliver.ip_rcv.__netif_receive_skb_one_core.process_backlog
     11.40 ±  2%      +4.4       15.77 ±  6%  perf-profile.calltrace.cycles-pp.__udp4_lib_rcv.ip_local_deliver_finish.ip_local_deliver.ip_rcv.__netif_receive_skb_one_core
      0.00            +4.4        4.44 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__percpu_counter_sum.__sk_mem_raise_allocated.__udp_enqueue_schedule_skb.udp_queue_rcv_skb
     10.89 ±  2%      +4.4       15.34 ±  6%  perf-profile.calltrace.cycles-pp.udp_queue_rcv_skb.__udp4_lib_rcv.ip_local_deliver_finish.ip_local_deliver.ip_rcv
      9.96 ±  2%      +4.6       14.57 ±  6%  perf-profile.calltrace.cycles-pp.__udp_enqueue_schedule_skb.udp_queue_rcv_skb.__udp4_lib_rcv.ip_local_deliver_finish.ip_local_deliver
      0.00            +5.8        5.80 ±  5%  perf-profile.calltrace.cycles-pp.__percpu_counter_sum.__sk_mem_raise_allocated.__udp_enqueue_schedule_skb.udp_queue_rcv_skb.__udp4_lib_rcv
      0.00            +6.0        6.01 ±  5%  perf-profile.calltrace.cycles-pp.__sk_mem_raise_allocated.__udp_enqueue_schedule_skb.udp_queue_rcv_skb.__udp4_lib_rcv.ip_local_deliver_finish
     13.67 ±  2%      -2.5       11.22 ±  6%  perf-profile.children.cycles-pp.__x64_sys_recvfrom
     13.46 ±  2%      -2.4       11.06 ±  6%  perf-profile.children.cycles-pp.__sys_recvfrom
     11.88 ±  2%      -2.1        9.73 ±  6%  perf-profile.children.cycles-pp.inet_recvmsg
     11.69 ±  2%      -2.1        9.59 ±  6%  perf-profile.children.cycles-pp.udp_recvmsg
     11.45            -1.8        9.62 ±  6%  perf-profile.children.cycles-pp.__sched_text_start
      9.11 ±  2%      -1.6        7.47 ±  7%  perf-profile.children.cycles-pp.__skb_recv_udp
      7.67 ±  2%      -1.4        6.28 ±  7%  perf-profile.children.cycles-pp.__skb_wait_for_more_packets
      9.03 ±  2%      -1.3        7.70 ±  6%  perf-profile.children.cycles-pp.__wake_up_common_lock
      9.25 ±  3%      -1.3        7.99 ±  6%  perf-profile.children.cycles-pp.sock_def_readable
      8.48 ±  2%      -1.2        7.24 ±  7%  perf-profile.children.cycles-pp.__wake_up_common
      8.06 ±  3%      -1.2        6.90 ±  7%  perf-profile.children.cycles-pp.try_to_wake_up
      8.15 ±  3%      -1.1        7.00 ±  7%  perf-profile.children.cycles-pp.autoremove_wake_function
      6.11 ±  2%      -1.0        5.12 ±  7%  perf-profile.children.cycles-pp.schedule
      5.51            -0.9        4.62 ±  5%  perf-profile.children.cycles-pp.schedule_idle
      4.80            -0.8        3.96 ±  6%  perf-profile.children.cycles-pp.ip_make_skb
      4.50 ±  2%      -0.6        3.86 ±  7%  perf-profile.children.cycles-pp.ttwu_do_activate
      4.25 ±  2%      -0.6        3.63 ±  8%  perf-profile.children.cycles-pp.enqueue_task_fair
      3.66 ±  3%      -0.5        3.14 ±  8%  perf-profile.children.cycles-pp.enqueue_entity
      2.65 ±  2%      -0.5        2.18 ±  7%  perf-profile.children.cycles-pp.dequeue_task_fair
      2.32 ±  2%      -0.4        1.88 ±  7%  perf-profile.children.cycles-pp.pick_next_task_fair
      2.38 ±  2%      -0.4        1.95 ±  8%  perf-profile.children.cycles-pp.dequeue_entity
      2.90            -0.4        2.47 ±  6%  perf-profile.children.cycles-pp.__ip_append_data
      2.31 ±  3%      -0.4        1.91 ±  6%  perf-profile.children.cycles-pp.__entry_SYSCALL_64_trampoline
      1.68            -0.4        1.29 ±  4%  perf-profile.children.cycles-pp.__ip_make_skb
      2.81 ±  3%      -0.4        2.44 ±  7%  perf-profile.children.cycles-pp.menu_select
      2.60            -0.4        2.24 ±  5%  perf-profile.children.cycles-pp.switch_mm_irqs_off
      2.42 ±  3%      -0.3        2.11 ±  8%  perf-profile.children.cycles-pp.update_load_avg
      2.04 ±  4%      -0.3        1.74 ±  7%  perf-profile.children.cycles-pp.__dev_queue_xmit
      1.69 ±  2%      -0.3        1.40 ±  5%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      1.29 ±  2%      -0.3        1.00 ±  4%  perf-profile.children.cycles-pp.__ip_select_ident
      1.23 ±  2%      -0.3        0.94 ±  4%  perf-profile.children.cycles-pp.ip_idents_reserve
      1.34            -0.3        1.06 ±  6%  perf-profile.children.cycles-pp.set_next_entity
      2.12 ±  2%      -0.3        1.84 ±  6%  perf-profile.children.cycles-pp.sock_alloc_send_pskb
      1.79 ±  3%      -0.3        1.52 ±  8%  perf-profile.children.cycles-pp.tick_nohz_get_sleep_length
      1.48 ±  2%      -0.3        1.23 ±  3%  perf-profile.children.cycles-pp._raw_spin_lock
      1.24 ±  2%      -0.2        1.03 ±  6%  perf-profile.children.cycles-pp.load_new_mm_cr3
      1.58 ±  4%      -0.2        1.37 ±  7%  perf-profile.children.cycles-pp.dev_hard_start_xmit
      1.51 ±  4%      -0.2        1.31 ±  7%  perf-profile.children.cycles-pp.loopback_xmit
      1.48 ±  2%      -0.2        1.29 ±  7%  perf-profile.children.cycles-pp.alloc_skb_with_frags
      0.83 ±  3%      -0.2        0.66 ±  8%  perf-profile.children.cycles-pp.update_curr
      1.42 ±  2%      -0.2        1.24 ±  7%  perf-profile.children.cycles-pp.__alloc_skb
      0.73 ±  3%      -0.2        0.55 ±  4%  perf-profile.children.cycles-pp.tick_nohz_idle_exit
      0.91            -0.2        0.73 ±  4%  perf-profile.children.cycles-pp._copy_to_iter
      1.07 ±  2%      -0.2        0.90 ±  6%  perf-profile.children.cycles-pp.switch_mm
      1.10 ±  3%      -0.2        0.94 ±  8%  perf-profile.children.cycles-pp.get_next_timer_interrupt
      0.81 ±  3%      -0.2        0.66 ±  4%  perf-profile.children.cycles-pp.sock_wfree
      0.95            -0.2        0.80 ±  6%  perf-profile.children.cycles-pp.move_addr_to_user
      0.90 ±  2%      -0.2        0.75 ±  5%  perf-profile.children.cycles-pp.__consume_stateless_skb
      0.74            -0.2        0.59 ±  4%  perf-profile.children.cycles-pp.__switch_to_asm
      0.78            -0.1        0.64 ±  6%  perf-profile.children.cycles-pp.copy_user_generic_unrolled
      0.49            -0.1        0.35 ±  5%  perf-profile.children.cycles-pp.update_ts_time_stats
      0.66 ±  2%      -0.1        0.53 ±  5%  perf-profile.children.cycles-pp.__switch_to
      0.84 ±  3%      -0.1        0.70 ±  8%  perf-profile.children.cycles-pp.nf_hook_slow
      0.71 ±  3%      -0.1        0.58 ±  9%  perf-profile.children.cycles-pp.__next_timer_interrupt
      0.95 ±  3%      -0.1        0.82 ±  7%  perf-profile.children.cycles-pp.select_task_rq_fair
      0.68 ±  3%      -0.1        0.55 ± 12%  perf-profile.children.cycles-pp.update_cfs_group
      0.57 ±  4%      -0.1        0.44 ±  7%  perf-profile.children.cycles-pp.prepare_to_wait_exclusive
      0.43 ±  7%      -0.1        0.31 ± 10%  perf-profile.children.cycles-pp.__enqueue_entity
      0.69 ±  3%      -0.1        0.56 ±  5%  perf-profile.children.cycles-pp.__slab_free
      0.43            -0.1        0.31 ±  7%  perf-profile.children.cycles-pp.ip_generic_getfrag
      0.74 ±  3%      -0.1        0.63 ±  4%  perf-profile.children.cycles-pp.poll_idle
      0.39 ±  2%      -0.1        0.28 ±  7%  perf-profile.children.cycles-pp._copy_from_iter_full
      1.07 ±  5%      -0.1        0.97 ±  5%  perf-profile.children.cycles-pp.ttwu_do_wakeup
      1.04 ±  5%      -0.1        0.94 ±  5%  perf-profile.children.cycles-pp.check_preempt_curr
      0.54            -0.1        0.44 ±  7%  perf-profile.children.cycles-pp.update_rq_clock
      0.57 ±  2%      -0.1        0.47 ±  9%  perf-profile.children.cycles-pp.selinux_ip_postroute
      0.53 ±  2%      -0.1        0.43 ±  4%  perf-profile.children.cycles-pp.sock_def_write_space
      0.68 ±  2%      -0.1        0.59 ±  7%  perf-profile.children.cycles-pp.sk_filter_trim_cap
      0.57            -0.1        0.48 ±  5%  perf-profile.children.cycles-pp.sched_clock_cpu
      0.53            -0.1        0.44 ±  4%  perf-profile.children.cycles-pp.copyout
      0.64 ±  2%      -0.1        0.55 ±  6%  perf-profile.children.cycles-pp.security_sock_rcv_skb
      0.56            -0.1        0.47 ±  4%  perf-profile.children.cycles-pp.skb_set_owner_w
      0.69 ±  5%      -0.1        0.60 ±  8%  perf-profile.children.cycles-pp._raw_spin_lock_bh
      0.53 ±  2%      -0.1        0.44 ±  4%  perf-profile.children.cycles-pp.sched_clock
      0.39 ±  5%      -0.1        0.30 ±  8%  perf-profile.children.cycles-pp.__update_load_avg_se
      0.35 ±  4%      -0.1        0.26 ±  6%  perf-profile.children.cycles-pp.hrtimer_next_event_without
      0.42            -0.1        0.34 ±  5%  perf-profile.children.cycles-pp.tick_nohz_idle_enter
      0.61 ±  2%      -0.1        0.53 ±  6%  perf-profile.children.cycles-pp.selinux_socket_sock_rcv_skb
      0.38 ±  6%      -0.1        0.30 ± 14%  perf-profile.children.cycles-pp.___perf_sw_event
      0.50 ±  2%      -0.1        0.42 ±  5%  perf-profile.children.cycles-pp.native_sched_clock
      0.40 ±  2%      -0.1        0.33 ±  4%  perf-profile.children.cycles-pp.nr_iowait_cpu
      0.41 ±  3%      -0.1        0.34 ±  8%  perf-profile.children.cycles-pp.sockfd_lookup_light
      0.45 ±  3%      -0.1        0.37 ± 11%  perf-profile.children.cycles-pp.selinux_ip_postroute_compat
      0.45            -0.1        0.37 ±  8%  perf-profile.children.cycles-pp.native_write_msr
      0.56 ±  4%      -0.1        0.48 ±  6%  perf-profile.children.cycles-pp.finish_task_switch
      0.43            -0.1        0.36 ±  9%  perf-profile.children.cycles-pp.ksize
      0.30 ±  6%      -0.1        0.23 ±  5%  perf-profile.children.cycles-pp.__udp4_lib_lookup
      0.33 ±  3%      -0.1        0.27 ±  8%  perf-profile.children.cycles-pp.__fget_light
      0.31            -0.1        0.25 ± 11%  perf-profile.children.cycles-pp.kmem_cache_alloc_node
      0.20            -0.1        0.14 ±  3%  perf-profile.children.cycles-pp.copyin
      0.35            -0.1        0.28 ±  8%  perf-profile.children.cycles-pp.__might_fault
      0.28 ±  9%      -0.1        0.22 ±  5%  perf-profile.children.cycles-pp.pick_next_task_idle
      0.21 ±  5%      -0.1        0.15 ±  2%  perf-profile.children.cycles-pp.entry_SYSCALL_64_stage2
      0.49            -0.1        0.43 ±  5%  perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      0.27 ±  3%      -0.1        0.21 ±  7%  perf-profile.children.cycles-pp.validate_xmit_skb
      0.09 ±  8%      -0.1        0.04 ± 57%  perf-profile.children.cycles-pp.kfree
      0.24 ±  5%      -0.1        0.18 ±  6%  perf-profile.children.cycles-pp.rb_erase_cached
      0.44 ±  2%      -0.1        0.39 ±  5%  perf-profile.children.cycles-pp.reweight_entity
      0.26 ±  3%      -0.1        0.21 ±  7%  perf-profile.children.cycles-pp.enqueue_to_backlog
      0.24            -0.0        0.20 ±  5%  perf-profile.children.cycles-pp.security_socket_sendmsg
      0.21 ±  5%      -0.0        0.16 ±  6%  perf-profile.children.cycles-pp.kmem_cache_free
      0.15 ±  7%      -0.0        0.10 ± 10%  perf-profile.children.cycles-pp.__hrtimer_next_event_base
      0.07 ± 12%      -0.0        0.03 ±100%  perf-profile.children.cycles-pp.rb_next
      0.24            -0.0        0.20 ±  9%  perf-profile.children.cycles-pp.___might_sleep
      0.18 ± 12%      -0.0        0.14        perf-profile.children.cycles-pp.inet_sendmsg
      0.20 ±  4%      -0.0        0.16 ±  6%  perf-profile.children.cycles-pp.rcu_idle_exit
      0.19 ±  2%      -0.0        0.15 ±  2%  perf-profile.children.cycles-pp.copy_user_enhanced_fast_string
      0.17 ±  7%      -0.0        0.13 ± 11%  perf-profile.children.cycles-pp.put_prev_task_fair
      0.14 ± 10%      -0.0        0.10 ± 10%  perf-profile.children.cycles-pp.compute_score
      0.22 ±  4%      -0.0        0.19 ± 10%  perf-profile.children.cycles-pp.selinux_parse_skb
      0.29 ±  4%      -0.0        0.25 ±  9%  perf-profile.children.cycles-pp.ipv4_mtu
      0.16 ±  4%      -0.0        0.12 ±  6%  perf-profile.children.cycles-pp.__calc_delta
      0.24            -0.0        0.21 ±  8%  perf-profile.children.cycles-pp.move_addr_to_kernel
      0.22 ±  4%      -0.0        0.19 ±  3%  perf-profile.children.cycles-pp.sock_has_perm
      0.23 ±  3%      -0.0        0.19 ±  9%  perf-profile.children.cycles-pp.__list_del_entry_valid
      0.26 ±  3%      -0.0        0.22 ±  4%  perf-profile.children.cycles-pp.pick_next_entity
      0.21 ±  3%      -0.0        0.18 ±  7%  perf-profile.children.cycles-pp._copy_from_user
      0.19 ±  6%      -0.0        0.16 ±  6%  perf-profile.children.cycles-pp.__skb_try_recv_from_queue
      0.20 ±  2%      -0.0        0.17 ±  5%  perf-profile.children.cycles-pp.rcu_eqs_enter
      0.18 ±  2%      -0.0        0.14 ±  5%  perf-profile.children.cycles-pp.security_sk_classify_flow
      0.15 ±  7%      -0.0        0.11 ±  7%  perf-profile.children.cycles-pp.menu_reflect
      0.10 ±  5%      -0.0        0.07 ±  7%  perf-profile.children.cycles-pp.selinux_socket_sendmsg
      0.19 ±  2%      -0.0        0.16 ±  7%  perf-profile.children.cycles-pp._copy_to_user
      0.19 ±  4%      -0.0        0.16 ±  8%  perf-profile.children.cycles-pp.cpuidle_governor_latency_req
      0.17 ±  4%      -0.0        0.15 ± 11%  perf-profile.children.cycles-pp.__might_sleep
      0.17 ±  6%      -0.0        0.14        perf-profile.children.cycles-pp.sock_recvmsg
      0.10 ±  7%      -0.0        0.08 ±  6%  perf-profile.children.cycles-pp.ipv4_pktinfo_prepare
      0.14 ±  7%      -0.0        0.12        perf-profile.children.cycles-pp.security_socket_recvmsg
      0.13 ±  3%      -0.0        0.11 ±  6%  perf-profile.children.cycles-pp.__get_user_4
      0.13 ±  3%      -0.0        0.11 ±  6%  perf-profile.children.cycles-pp.selinux_sk_getsecid
      0.11 ±  8%      -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.dst_release
      0.10 ±  8%      -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.selinux_ipv4_postroute
      0.11 ±  4%      -0.0        0.10 ± 11%  perf-profile.children.cycles-pp.pm_qos_request
      0.11 ±  4%      -0.0        0.09 ±  4%  perf-profile.children.cycles-pp.udp_rcv
      0.09 ±  4%      -0.0        0.07 ±  5%  perf-profile.children.cycles-pp.ip_send_check
      0.05            +0.0        0.07 ± 13%  perf-profile.children.cycles-pp.selinux_netlbl_sock_rcv_skb
      0.06 ± 11%      +0.0        0.08 ±  6%  perf-profile.children.cycles-pp.rebalance_domains
      0.07 ±  7%      +0.0        0.09 ±  7%  perf-profile.children.cycles-pp.ip_rcv_finish_core
      0.09 ±  4%      +0.0        0.12 ±  3%  perf-profile.children.cycles-pp.ip_rcv_finish
      0.15 ±  8%      +0.0        0.20 ±  8%  perf-profile.children.cycles-pp.irq_exit
      0.11 ± 31%      +0.1        0.16 ± 22%  perf-profile.children.cycles-pp.clockevents_program_event
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.netlbl_enabled
      0.45 ±  5%      +0.1        0.57 ±  7%  perf-profile.children.cycles-pp.find_next_bit
      0.00            +0.2        0.17 ±  4%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.00            +0.3        0.34 ±  5%  perf-profile.children.cycles-pp.cpumask_next
     26.71 ±  2%      +1.9       28.63 ±  5%  perf-profile.children.cycles-pp.__x64_sys_sendto
     26.51 ±  2%      +1.9       28.46 ±  5%  perf-profile.children.cycles-pp.__sys_sendto
     25.75 ±  2%      +2.1       27.81 ±  5%  perf-profile.children.cycles-pp.sock_sendmsg
     25.23 ±  2%      +2.2       27.40 ±  5%  perf-profile.children.cycles-pp.udp_sendmsg
     18.58 ±  2%      +3.3       21.90 ±  5%  perf-profile.children.cycles-pp.udp_send_skb
     18.33 ±  2%      +3.4       21.68 ±  5%  perf-profile.children.cycles-pp.ip_send_skb
     17.95 ±  2%      +3.4       21.33 ±  5%  perf-profile.children.cycles-pp.ip_output
     16.73 ±  2%      +3.6       20.36 ±  5%  perf-profile.children.cycles-pp.ip_finish_output2
     14.40 ±  2%      +4.0       18.36 ±  5%  perf-profile.children.cycles-pp.__local_bh_enable_ip
     14.24 ±  2%      +4.0       18.25 ±  5%  perf-profile.children.cycles-pp.do_softirq
     14.05 ±  2%      +4.0       18.08 ±  5%  perf-profile.children.cycles-pp.do_softirq_own_stack
     14.12 ±  2%      +4.0       18.16 ±  5%  perf-profile.children.cycles-pp.__softirqentry_text_start
     13.61 ±  2%      +4.1       17.67 ±  5%  perf-profile.children.cycles-pp.net_rx_action
     13.31 ±  2%      +4.1       17.43 ±  5%  perf-profile.children.cycles-pp.process_backlog
      1.50 ±  2%      +4.2        5.68 ±  5%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.00            +4.2        4.19 ±  5%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     12.28 ±  2%      +4.2       16.52 ±  5%  perf-profile.children.cycles-pp.ip_rcv
     12.53 ±  2%      +4.2       16.78 ±  5%  perf-profile.children.cycles-pp.__netif_receive_skb_one_core
     11.89 ±  3%      +4.3       16.15 ±  5%  perf-profile.children.cycles-pp.ip_local_deliver
     11.73 ±  3%      +4.3       16.00 ±  5%  perf-profile.children.cycles-pp.ip_local_deliver_finish
     11.41 ±  2%      +4.4       15.78 ±  6%  perf-profile.children.cycles-pp.__udp4_lib_rcv
     10.90 ±  2%      +4.4       15.35 ±  6%  perf-profile.children.cycles-pp.udp_queue_rcv_skb
      9.97 ±  2%      +4.6       14.58 ±  6%  perf-profile.children.cycles-pp.__udp_enqueue_schedule_skb
      0.00            +5.8        5.84 ±  5%  perf-profile.children.cycles-pp.__percpu_counter_sum
      0.15 ±  3%      +5.9        6.01 ±  5%  perf-profile.children.cycles-pp.__sk_mem_raise_allocated
      2.25 ±  3%      -0.4        1.85 ±  6%  perf-profile.self.cycles-pp.__entry_SYSCALL_64_trampoline
      2.20            -0.3        1.89 ±  5%  perf-profile.self.cycles-pp.__sched_text_start
      1.69 ±  2%      -0.3        1.39 ±  5%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      1.22 ±  2%      -0.3        0.93 ±  4%  perf-profile.self.cycles-pp.ip_idents_reserve
      1.43 ±  2%      -0.3        1.16 ±  4%  perf-profile.self.cycles-pp._raw_spin_lock
      1.24 ±  2%      -0.2        1.03 ±  6%  perf-profile.self.cycles-pp.load_new_mm_cr3
      1.01            -0.2        0.82 ±  7%  perf-profile.self.cycles-pp.do_idle
      0.45            -0.2        0.29 ±  5%  perf-profile.self.cycles-pp.__skb_wait_for_more_packets
      1.05 ±  2%      -0.2        0.90 ±  6%  perf-profile.self.cycles-pp.update_load_avg
      0.74            -0.2        0.59 ±  4%  perf-profile.self.cycles-pp.__switch_to_asm
      0.60 ±  2%      -0.1        0.45 ±  6%  perf-profile.self.cycles-pp.udp_sendmsg
      0.76            -0.1        0.62 ±  5%  perf-profile.self.cycles-pp.enqueue_entity
      1.35            -0.1        1.21 ±  5%  perf-profile.self.cycles-pp.switch_mm_irqs_off
      0.63 ±  2%      -0.1        0.50 ±  5%  perf-profile.self.cycles-pp.__switch_to
      0.76            -0.1        0.62 ±  6%  perf-profile.self.cycles-pp.copy_user_generic_unrolled
      0.67 ±  3%      -0.1        0.54 ± 12%  perf-profile.self.cycles-pp.update_cfs_group
      0.56 ±  3%      -0.1        0.44 ±  8%  perf-profile.self.cycles-pp.update_curr
      0.68 ±  3%      -0.1        0.56 ±  5%  perf-profile.self.cycles-pp.__slab_free
      0.42 ±  7%      -0.1        0.30 ± 11%  perf-profile.self.cycles-pp.__enqueue_entity
      0.66            -0.1        0.54 ±  5%  perf-profile.self.cycles-pp.set_next_entity
      0.34 ±  2%      -0.1        0.23 ±  3%  perf-profile.self.cycles-pp.ip_output
      0.59 ±  2%      -0.1        0.49 ±  4%  perf-profile.self.cycles-pp.enqueue_task_fair
      0.53 ±  3%      -0.1        0.42 ±  9%  perf-profile.self.cycles-pp.pick_next_task_fair
      0.51            -0.1        0.42 ±  7%  perf-profile.self.cycles-pp.do_syscall_64
      0.64            -0.1        0.55 ±  4%  perf-profile.self.cycles-pp.poll_idle
      0.54            -0.1        0.45 ±  5%  perf-profile.self.cycles-pp.move_addr_to_user
      0.63 ±  2%      -0.1        0.54 ±  6%  perf-profile.self.cycles-pp.select_task_rq_fair
      0.40 ±  4%      -0.1        0.31 ±  5%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.56            -0.1        0.47 ±  4%  perf-profile.self.cycles-pp.skb_set_owner_w
      0.52 ±  2%      -0.1        0.43 ±  5%  perf-profile.self.cycles-pp.sock_def_write_space
      0.20 ±  6%      -0.1        0.11 ±  7%  perf-profile.self.cycles-pp.check_preempt_curr
      0.68 ±  5%      -0.1        0.60 ±  8%  perf-profile.self.cycles-pp._raw_spin_lock_bh
      0.53 ±  5%      -0.1        0.45 ±  5%  perf-profile.self.cycles-pp.udp_recvmsg
      0.38 ±  5%      -0.1        0.30 ±  8%  perf-profile.self.cycles-pp.__update_load_avg_se
      0.31 ±  2%      -0.1        0.23 ±  8%  perf-profile.self.cycles-pp.__skb_recv_udp
      0.51 ±  2%      -0.1        0.43 ± 10%  perf-profile.self.cycles-pp.dequeue_entity
      0.26 ±  4%      -0.1        0.18 ±  6%  perf-profile.self.cycles-pp.__ip_make_skb
      0.48 ±  2%      -0.1        0.41 ±  4%  perf-profile.self.cycles-pp.native_sched_clock
      0.29 ±  4%      -0.1        0.22 ±  5%  perf-profile.self.cycles-pp._copy_to_iter
      0.44            -0.1        0.37 ±  7%  perf-profile.self.cycles-pp.native_write_msr
      0.44            -0.1        0.37 ±  5%  perf-profile.self.cycles-pp._raw_spin_unlock_irqrestore
      0.40            -0.1        0.33 ±  4%  perf-profile.self.cycles-pp.nr_iowait_cpu
      0.25 ±  4%      -0.1        0.18 ±  8%  perf-profile.self.cycles-pp.__wake_up_common
      0.42            -0.1        0.35 ±  9%  perf-profile.self.cycles-pp.ksize
      0.32            -0.1        0.26 ±  9%  perf-profile.self.cycles-pp.__next_timer_interrupt
      0.28 ±  3%      -0.1        0.21 ±  5%  perf-profile.self.cycles-pp.sock_wfree
      0.32 ±  2%      -0.1        0.26 ±  8%  perf-profile.self.cycles-pp.__fget_light
      0.31            -0.1        0.25 ±  5%  perf-profile.self.cycles-pp.update_rq_clock
      0.49            -0.1        0.43 ±  6%  perf-profile.self.cycles-pp.__udp_enqueue_schedule_skb
      0.21 ±  4%      -0.1        0.15 ±  5%  perf-profile.self.cycles-pp.__sys_recvfrom
      0.29 ±  5%      -0.1        0.24 ±  6%  perf-profile.self.cycles-pp.try_to_wake_up
      0.09 ±  8%      -0.1        0.04 ± 57%  perf-profile.self.cycles-pp.kfree
      0.20 ±  7%      -0.1        0.15 ±  2%  perf-profile.self.cycles-pp.entry_SYSCALL_64_stage2
      0.43 ±  2%      -0.0        0.39 ±  6%  perf-profile.self.cycles-pp.reweight_entity
      0.35 ±  4%      -0.0        0.31 ±  6%  perf-profile.self.cycles-pp.__softirqentry_text_start
      0.17 ±  2%      -0.0        0.12 ±  8%  perf-profile.self.cycles-pp.__local_bh_enable_ip
      0.25 ±  4%      -0.0        0.21 ±  7%  perf-profile.self.cycles-pp.net_rx_action
      0.08 ±  5%      -0.0        0.04 ± 57%  perf-profile.self.cycles-pp.tick_nohz_idle_exit
      0.26 ±  4%      -0.0        0.21 ±  7%  perf-profile.self.cycles-pp.__sys_sendto
      0.20 ±  4%      -0.0        0.16 ±  5%  perf-profile.self.cycles-pp.__x64_sys_recvfrom
      0.12 ±  4%      -0.0        0.08 ±  8%  perf-profile.self.cycles-pp.udp_queue_rcv_skb
      0.27            -0.0        0.22 ±  7%  perf-profile.self.cycles-pp.loopback_xmit
      0.18 ±  7%      -0.0        0.14 ±  5%  perf-profile.self.cycles-pp.inet_recvmsg
      0.14 ± 10%      -0.0        0.10 ±  8%  perf-profile.self.cycles-pp.compute_score
      0.19 ±  6%      -0.0        0.15 ±  8%  perf-profile.self.cycles-pp.selinux_socket_sock_rcv_skb
      0.15 ± 13%      -0.0        0.11 ±  7%  perf-profile.self.cycles-pp.ip_local_deliver_finish
      0.20 ±  4%      -0.0        0.16 ±  7%  perf-profile.self.cycles-pp.rb_erase_cached
      0.22 ±  5%      -0.0        0.18 ±  8%  perf-profile.self.cycles-pp.__alloc_skb
      0.18 ±  2%      -0.0        0.14 ±  9%  perf-profile.self.cycles-pp.kmem_cache_alloc_node
      0.20 ±  2%      -0.0        0.16 ±  8%  perf-profile.self.cycles-pp.rcu_eqs_enter
      0.18 ±  3%      -0.0        0.14 ±  3%  perf-profile.self.cycles-pp.copy_user_enhanced_fast_string
      0.17 ± 15%      -0.0        0.13        perf-profile.self.cycles-pp.inet_sendmsg
      0.29 ±  2%      -0.0        0.26 ±  4%  perf-profile.self.cycles-pp.process_backlog
      0.23 ±  3%      -0.0        0.19 ±  2%  perf-profile.self.cycles-pp.pick_next_entity
      0.15 ±  5%      -0.0        0.11 ±  9%  perf-profile.self.cycles-pp.selinux_ip_postroute_compat
      0.16 ±  6%      -0.0        0.12 ±  6%  perf-profile.self.cycles-pp.__calc_delta
      0.11 ±  3%      -0.0        0.08 ±  8%  perf-profile.self.cycles-pp.validate_xmit_skb
      0.09 ±  5%      -0.0        0.05 ±  9%  perf-profile.self.cycles-pp._copy_from_iter_full
      0.09 ±  5%      -0.0        0.05 ±  9%  perf-profile.self.cycles-pp.selinux_socket_sendmsg
      0.22 ±  5%      -0.0        0.19 ±  3%  perf-profile.self.cycles-pp.sock_has_perm
      0.15 ±  5%      -0.0        0.12 ±  4%  perf-profile.self.cycles-pp.__udp4_lib_lookup
      0.15 ±  4%      -0.0        0.12 ± 10%  perf-profile.self.cycles-pp.__might_sleep
      0.09 ±  4%      -0.0        0.06 ±  6%  perf-profile.self.cycles-pp.nf_hook_slow
      0.13 ±  6%      -0.0        0.10 ±  8%  perf-profile.self.cycles-pp.prepare_to_wait_exclusive
      0.15 ±  2%      -0.0        0.12 ±  5%  perf-profile.self.cycles-pp.enqueue_to_backlog
      0.08 ±  5%      -0.0        0.06 ± 15%  perf-profile.self.cycles-pp.ip_make_skb
      0.14 ±  6%      -0.0        0.11 ±  3%  perf-profile.self.cycles-pp.ip_rcv
      0.13            -0.0        0.11 ±  4%  perf-profile.self.cycles-pp.selinux_ip_postroute
      0.10            -0.0        0.08 ±  6%  perf-profile.self.cycles-pp.sock_sendmsg
      0.10            -0.0        0.08 ± 10%  perf-profile.self.cycles-pp.__might_fault
      0.09 ±  9%      -0.0        0.07 ± 13%  perf-profile.self.cycles-pp.put_prev_task_fair
      0.12 ±  3%      -0.0        0.10 ±  5%  perf-profile.self.cycles-pp.rcu_idle_exit
      0.12 ±  8%      -0.0        0.10 ±  7%  perf-profile.self.cycles-pp.menu_reflect
      0.06            -0.0        0.04 ± 57%  perf-profile.self.cycles-pp.__ip_local_out
      0.13 ±  3%      -0.0        0.11 ±  7%  perf-profile.self.cycles-pp.selinux_sock_rcv_skb_compat
      0.08 ±  5%      -0.0        0.06 ± 14%  perf-profile.self.cycles-pp.__skb_try_recv_from_queue
      0.09 ±  4%      -0.0        0.07 ±  5%  perf-profile.self.cycles-pp.selinux_ipv4_postroute
      0.10 ±  9%      -0.0        0.08 ±  6%  perf-profile.self.cycles-pp.dst_release
      0.08 ±  5%      -0.0        0.07 ±  7%  perf-profile.self.cycles-pp.schedule
      0.13 ±  6%      -0.0        0.11 ±  6%  perf-profile.self.cycles-pp.__get_user_4
      0.11 ±  7%      -0.0        0.09 ±  7%  perf-profile.self.cycles-pp.netif_skb_features
      0.11 ±  7%      -0.0        0.09 ±  7%  perf-profile.self.cycles-pp.__hrtimer_next_event_base
      0.18 ±  4%      -0.0        0.17 ±  5%  perf-profile.self.cycles-pp.__x64_sys_sendto
      0.11 ±  3%      -0.0        0.10 ±  5%  perf-profile.self.cycles-pp.switch_mm
      0.12 ±  3%      -0.0        0.10 ±  7%  perf-profile.self.cycles-pp.selinux_sk_getsecid
      0.09 ±  4%      -0.0        0.08 ±  6%  perf-profile.self.cycles-pp.udp_rcv
      0.07            -0.0        0.05 ±  9%  perf-profile.self.cycles-pp.update_min_vruntime
      0.09 ±  5%      -0.0        0.07        perf-profile.self.cycles-pp.ip_send_check
      0.08 ± 10%      -0.0        0.06 ±  6%  perf-profile.self.cycles-pp.sockfd_lookup_light
      0.06 ± 11%      +0.0        0.09 ±  7%  perf-profile.self.cycles-pp.ip_rcv_finish_core
      0.00            +0.1        0.06 ±  9%  perf-profile.self.cycles-pp.netlbl_enabled
      0.00            +0.1        0.06 ± 15%  perf-profile.self.cycles-pp.hrtimer_get_next_event
      0.21 ±  7%      +0.1        0.29 ±  3%  perf-profile.self.cycles-pp.sock_def_readable
      0.00            +0.1        0.11 ±  7%  perf-profile.self.cycles-pp.cpumask_next
      0.38 ±  6%      +0.1        0.50 ±  7%  perf-profile.self.cycles-pp.find_next_bit
      0.00            +0.2        0.17 ±  4%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.00            +1.1        1.07 ±  5%  perf-profile.self.cycles-pp.__percpu_counter_sum
      0.00            +4.2        4.19 ±  5%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


Thanks,
Rong Chen

--tgGnixv3tJWXBxdL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-4.19.0-rc2-00128-gb99259a"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 4.19.0-rc2 Kernel Configuration
#

#
# Compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
#
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=70300
CONFIG_CLANG_VERSION=0
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_USELIB=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_BPF_SYSCALL=y
# CONFIG_BPF_JIT_ALWAYS_ON is not set
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_RSEQ=y
# CONFIG_DEBUG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_MEMCG_SYSFS_ON is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
# CONFIG_SLAB_FREELIST_RANDOM is not set
# CONFIG_SLAB_FREELIST_HARDENED is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=4
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
CONFIG_INTEL_RDT=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_QUEUED_LOCK_STAT is not set
CONFIG_XEN=y
CONFIG_XEN_PV=y
CONFIG_XEN_PV_SMP=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_PVHVM_SMP=y
CONFIG_XEN_512GB=y
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_PERF_EVENTS_AMD_POWER is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_X86_5LEVEL is not set
CONFIG_X86_DIRECT_GBPAGES=y
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_INTEL_UMIP=y
CONFIG_X86_INTEL_MPX=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_EFI_MIXED is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_KEXEC_FILE is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
# CONFIG_LIVEPATCH is not set
CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_TAD is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=m
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NFIT=m
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_ERST_DEBUG=y
# CONFIG_DPTF_POWER is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_X86_PM_TIMER=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
# CONFIG_PCIE_DPC is not set
# CONFIG_PCIE_PTM is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_PCI_PF_STUB is not set
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
# CONFIG_PCI_HYPERV is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# PCI controller drivers
#

#
# Cadence PCIe controllers support
#
# CONFIG_VMD is not set

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_HAVE_GENERIC_GUP=y

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
# CONFIG_FW_CFG_SYSFS is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
# CONFIG_APPLE_PROPERTIES is not set
# CONFIG_RESET_ATTACK_MITIGATION is not set
CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y

#
# Tegra firmware driver
#
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_KVM_MMU_AUDIT=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
# CONFIG_VHOST_VSOCK is not set
CONFIG_VHOST=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_RCU_TABLE_FREE=y
CONFIG_HAVE_RCU_TABLE_INVALIDATE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_CC_HAS_STACKPROTECTOR_NONE=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_ARCH_HAS_REFCOUNT=y
# CONFIG_REFCOUNT_FULL is not set
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
CONFIG_PLUGIN_HOSTCC="g++"
CONFIG_HAVE_GCC_PLUGINS=y
# CONFIG_GCC_PLUGINS is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
# CONFIG_MODULE_COMPRESS is not set
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
# CONFIG_BLK_WBT is not set
# CONFIG_BLK_CGROUP_IOLATENCY is not set
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
# CONFIG_IOSCHED_BFQ is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_AREAS=7
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_ZSWAP=y
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_DEFERRED_STRUCT_PAGE_INIT is not set
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_ZONE_DEVICE=y
CONFIG_ZONE_DEVICE=y
CONFIG_ARCH_HAS_HMM=y
CONFIG_DEV_PAGEMAP_OPS=y
# CONFIG_HMM_MIRROR is not set
# CONFIG_DEVICE_PRIVATE is not set
# CONFIG_DEVICE_PUBLIC is not set
CONFIG_FRAME_VECTOR=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_BENCHMARK is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
# CONFIG_TLS is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_XDP_SOCKETS is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
CONFIG_NET_FOU=m
CONFIG_NET_FOU_IP_TUNNELS=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
# CONFIG_INET_ESP_OFFLOAD is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
# CONFIG_INET_RAW_DIAG is not set
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
# CONFIG_TCP_CONG_NV is not set
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_TCP_CONG_DCTCP is not set
# CONFIG_TCP_CONG_CDG is not set
# CONFIG_TCP_CONG_BBR is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
# CONFIG_INET6_ESP_OFFLOAD is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_FOU=m
CONFIG_IPV6_FOU_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
# CONFIG_IPV6_SEG6_HMAC is not set
CONFIG_IPV6_SEG6_BPF=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_COMMON=m
# CONFIG_NF_LOG_NETDEV is not set
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
# CONFIG_NETFILTER_NETLINK_GLUE_CT is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_NF_NAT_PROTO_DCCP=y
CONFIG_NF_NAT_PROTO_UDPLITE=y
CONFIG_NF_NAT_PROTO_SCTP=y
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
# CONFIG_NF_TABLES_SET is not set
# CONFIG_NF_TABLES_INET is not set
# CONFIG_NF_TABLES_NETDEV is not set
# CONFIG_NFT_NUMGEN is not set
CONFIG_NFT_CT=m
CONFIG_NFT_COUNTER=m
# CONFIG_NFT_CONNLIMIT is not set
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
# CONFIG_NFT_MASQ is not set
# CONFIG_NFT_REDIR is not set
CONFIG_NFT_NAT=m
# CONFIG_NFT_TUNNEL is not set
# CONFIG_NFT_OBJREF is not set
# CONFIG_NFT_QUEUE is not set
# CONFIG_NFT_QUOTA is not set
# CONFIG_NFT_REJECT is not set
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
# CONFIG_NFT_SOCKET is not set
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NF_FLOW_TABLE is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
# CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
CONFIG_NETFILTER_XT_MATCH_L2TP=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
# CONFIG_NETFILTER_XT_MATCH_SOCKET is not set
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
# CONFIG_IP_SET_HASH_IPMARK is not set
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
# CONFIG_IP_SET_HASH_IPMAC is not set
# CONFIG_IP_SET_HASH_MAC is not set
# CONFIG_IP_SET_HASH_NETPORTNET is not set
CONFIG_IP_SET_HASH_NET=m
# CONFIG_IP_SET_HASH_NETNET is not set
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
# CONFIG_IP_VS_FO is not set
# CONFIG_IP_VS_OVF is not set
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
# CONFIG_NF_SOCKET_IPV4 is not set
CONFIG_NF_TPROXY_IPV4=m
# CONFIG_NF_TABLES_IPV4 is not set
# CONFIG_NF_TABLES_ARP is not set
CONFIG_NF_DUP_IPV4=m
# CONFIG_NF_LOG_ARP is not set
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_IPV4=m
CONFIG_NF_NAT_MASQUERADE_IPV4=y
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_SOCKET_IPV6 is not set
CONFIG_NF_TPROXY_IPV6=m
# CONFIG_NF_TABLES_IPV6 is not set
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_NF_NAT_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
# CONFIG_IP6_NF_NAT is not set
CONFIG_NF_DEFRAG_IPV6=m
# CONFIG_NF_TABLES_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_6LOWPAN is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
# CONFIG_NET_SCH_ETF is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
# CONFIG_NET_SCH_CAKE is not set
# CONFIG_NET_SCH_FQ is not set
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m
# CONFIG_NET_SCH_DEFAULT is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
# CONFIG_NET_CLS_FLOWER is not set
# CONFIG_NET_CLS_MATCHALL is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_EMATCH_IPSET=m
# CONFIG_NET_EMATCH_IPT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
# CONFIG_NET_ACT_SAMPLE is not set
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
# CONFIG_NET_ACT_VLAN is not set
# CONFIG_NET_ACT_BPF is not set
# CONFIG_NET_ACT_CONNMARK is not set
# CONFIG_NET_ACT_SKBMOD is not set
# CONFIG_NET_ACT_IFE is not set
# CONFIG_NET_ACT_TUNNEL_KEY is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
# CONFIG_VIRTIO_VSOCKETS is not set
# CONFIG_HYPERV_VSOCKETS is not set
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=m
# CONFIG_MPLS_ROUTING is not set
CONFIG_NET_NSH=m
# CONFIG_HSR is not set
# CONFIG_NET_SWITCHDEV is not set
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_NET_NCSI is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
# CONFIG_CAN_SJA1000 is not set
# CONFIG_CAN_SOFTING is not set

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set

#
# CAN USB interfaces
#
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_GS_USB is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_MCBA_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_UCAN is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
# CONFIG_MAC80211_RC_MINSTREL_VHT is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
# CONFIG_PSAMPLE is not set
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
# CONFIG_NET_DEVLINK is not set
CONFIG_MAY_USE_DEVLINK=y
CONFIG_FAILOVER=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_SYS_HYPERVISOR=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=200
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_GNSS is not set
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# Partition parsers
#

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_MCHP23K256 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# CONFIG_MTD_ONENAND is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_SPI_NAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION=y
CONFIG_BLK_DEV_FD=m
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
# CONFIG_ZRAM is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_XEN_BLKDEV_FRONTEND=m
# CONFIG_XEN_BLKDEV_BACKEND is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_VIRTIO_BLK_SCSI is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_RSXX=m

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
CONFIG_NVME_FABRICS=m
# CONFIG_NVME_FC is not set
CONFIG_NVME_TARGET=m
CONFIG_NVME_TARGET_LOOP=m
# CONFIG_NVME_TARGET_FC is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_VMWARE_VMCI=m

#
# Intel MIC & related support
#

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# SCIF Bus Driver
#
# CONFIG_SCIF_BUS is not set

#
# VOP Bus Driver
#
# CONFIG_VOP_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#

#
# VOP Driver
#
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_MISC_RTSX_PCI is not set
# CONFIG_MISC_RTSX_USB is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_MQ_DEFAULT is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_CXGB3_ISCSI=m
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=m
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=m
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=m
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=m
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS=m
# CONFIG_SCSI_SMARTPQI is not set
CONFIG_SCSI_UFSHCD=m
CONFIG_SCSI_UFSHCD_PCI=m
# CONFIG_SCSI_UFS_DWC_TC_PCI is not set
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
CONFIG_SCSI_HPTIOP=m
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_VMWARE_PVSCSI=m
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=m
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=m
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_STEX=m
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=m
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
# CONFIG_TCM_QLA2XXX is not set
CONFIG_SCSI_QLA_ISCSI=m
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
CONFIG_SCSI_PM8001=m
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=m
CONFIG_SCSI_CHELSIO_FCOE=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=m
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=m
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=m
CONFIG_PATA_IT821X=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=m
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=m
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=m
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_TOSHIBA=m
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=m
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=m
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
# CONFIG_MD_CLUSTER is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_MQ_DEFAULT is not set
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
# CONFIG_DM_WRITECACHE is not set
# CONFIG_DM_ERA is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
# CONFIG_DM_INTEGRITY is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
# CONFIG_TCM_USER2 is not set
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
# CONFIG_ISCSI_TARGET_CXGB4 is not set
# CONFIG_SBP_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_IFB=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
# CONFIG_IPVLAN is not set
CONFIG_VXLAN=m
# CONFIG_GENEVE is not set
# CONFIG_GTP is not set
CONFIG_MACSEC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
CONFIG_TAP=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=y
CONFIG_NLMON=m
CONFIG_NET_VRF=y
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_ENA_ETHERNET is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_ALX=m
# CONFIG_NET_VENDOR_AURORA is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BCMGENET is not set
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=y
CONFIG_TIGON3_HWMON=y
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=m
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
# CONFIG_LIQUIDIO is not set
# CONFIG_LIQUIDIO_VF is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4=m
# CONFIG_CHELSIO_T4_DCB is not set
CONFIG_CHELSIO_T4VF=m
CONFIG_CHELSIO_LIB=m
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_CX_ECAT is not set
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
CONFIG_BE2NET_HWMON=y
CONFIG_BE2NET_BE2=y
CONFIG_BE2NET_BE3=y
CONFIG_BE2NET_LANCER=y
CONFIG_BE2NET_SKYHAWK=y
CONFIG_NET_VENDOR_EZCHIP=y
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGBVF=m
CONFIG_IXGB=m
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=m
CONFIG_I40E=m
# CONFIG_I40E_DCB is not set
# CONFIG_I40EVF is not set
# CONFIG_ICE is not set
# CONFIG_FM10K is not set
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=m
CONFIG_SKGE=m
CONFIG_SKGE_DEBUG=y
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=m
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_MLX4_CORE_GEN2=y
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
# CONFIG_NFP is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_ETHOC=m
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=m
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
CONFIG_QLCNIC=m
CONFIG_QLCNIC_SRIOV=y
CONFIG_QLCNIC_DCB=y
CONFIG_QLCNIC_HWMON=y
CONFIG_QLGE=m
CONFIG_NETXEN_NIC=m
# CONFIG_QED is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_SFC_MCDI_LOGGING=y
# CONFIG_SFC_FALCON is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_EPIC100=m
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=m
CONFIG_NET_VENDOR_SOCIONEXT=y
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
# CONFIG_MDIO_BCM_UNIMAC is not set
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
# CONFIG_MDIO_MSCC_MIIM is not set
# CONFIG_MDIO_THUNDER is not set
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=m
# CONFIG_AQUANTIA_PHY is not set
# CONFIG_ASIX_PHY is not set
CONFIG_AT803X_PHY=m
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=m
CONFIG_BCM_NET_PHYLIB=m
CONFIG_BROADCOM_PHY=m
CONFIG_CICADA_PHY=m
# CONFIG_CORTINA_PHY is not set
CONFIG_DAVICOM_PHY=m
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_ICPLUS_PHY=m
# CONFIG_INTEL_XWAY_PHY is not set
CONFIG_LSI_ET1011C_PHY=m
CONFIG_LXT_PHY=m
CONFIG_MARVELL_PHY=m
# CONFIG_MARVELL_10G_PHY is not set
CONFIG_MICREL_PHY=m
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
CONFIG_NATIONAL_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
CONFIG_SMSC_PHY=m
CONFIG_STE10XP=m
# CONFIG_TERANETICS_PHY is not set
CONFIG_VITESSE_PHY=m
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_USB_NET_DRIVERS=y
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=m
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=m
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET_ENABLE=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=m
# CONFIG_USB_NET_CH9200 is not set
CONFIG_WLAN=y
# CONFIG_WIRELESS_WDS is not set
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
# CONFIG_MT7601U is not set
# CONFIG_MT76x0U is not set
# CONFIG_MT76x2E is not set
# CONFIG_MT76x2U is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_RTL8XXXU is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PEARL_PCIE is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_USB_NET_RNDIS_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
# CONFIG_DSCC4 is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKELB=m
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set
CONFIG_XEN_NETDEV_FRONTEND=m
# CONFIG_XEN_NETDEV_BACKEND is not set
CONFIG_VMXNET3=m
# CONFIG_FUJITSU_ES is not set
CONFIG_HYPERV_NET=m
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set
CONFIG_ISDN_CAPI=m
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPIDRV=m
# CONFIG_ISDN_CAPI_CAPIDRV_VERBOSE is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_CAPI=y
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
CONFIG_MISDN_HFCUSB=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
CONFIG_MISDN_W6692=m
CONFIG_MISDN_NETJET=m
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_ISDN_HDLC=m
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
# CONFIG_MOUSE_PS2_VMMOUSE is not set
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
# CONFIG_MOUSE_ELAN_I2C is not set
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
# CONFIG_TABLET_USB_PEGASUS is not set
# CONFIG_TABLET_SERIAL_WACOM4 is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_PROPERTIES=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_BU21029 is not set
# CONFIG_TOUCHSCREEN_CHIPONE_ICN8505 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX_SERIAL is not set
# CONFIG_TOUCHSCREEN_EXC3000 is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GOODIX is not set
# CONFIG_TOUCHSCREEN_HIDEEP is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_S6SY761 is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_EKTF2127 is not set
# CONFIG_TOUCHSCREEN_ELAN is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MELFAS_MIP4 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WDT87XX_I2C is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2004 is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_RM_TS is not set
# CONFIG_TOUCHSCREEN_SILEAD is not set
# CONFIG_TOUCHSCREEN_SIS_I2C is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMFTS is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_SURFACE3_SPI is not set
# CONFIG_TOUCHSCREEN_SX8654 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZET6223 is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_TOUCHSCREEN_ROHM_BU21023 is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_DECODER is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
# CONFIG_INPUT_PWM_VIBRA is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set
# CONFIG_RMI4_CORE is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_HYPERV_KEYBOARD=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
# CONFIG_SERIAL_8250_MOXA is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_SSIF is not set
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
# CONFIG_TCG_TIS_ST33ZP24_I2C is not set
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set
# CONFIG_RANDOM_TRUST_CPU is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
# CONFIG_I2C_MUX_MLXCPLD is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PCI=m
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_MLXCPLD is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set
# CONFIG_SPI_DW_MMIO is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=m
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=m
CONFIG_PTP_1588_CLOCK_KVM=y
CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_BROXTON is not set
# CONFIG_PINCTRL_CANNONLAKE is not set
# CONFIG_PINCTRL_CEDARFORK is not set
# CONFIG_PINCTRL_DENVERTON is not set
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_LEWISBURG is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_AMDPT is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_LYNXPOINT=m
# CONFIG_GPIO_MB86S7X is not set
CONFIG_GPIO_MOCKUP=y
# CONFIG_GPIO_VX855 is not set

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set

#
# MFD GPIO expanders
#

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set

#
# USB GPIO expanders
#
# CONFIG_GPIO_VIPERBOARD is not set
# CONFIG_W1 is not set
# CONFIG_POWER_AVS is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LTC3651 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ25890 is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_CHARGER_RT9455 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_I5500 is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2990 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_IR35221 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_CLOCK_THERMAL is not set
# CONFIG_DEVFREQ_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
CONFIG_INTEL_PCH_THERMAL=m
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
# CONFIG_WATCHDOG_SYSFS is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_INTEL_MEI_WDT is not set
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set
CONFIG_XEN_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC is not set
# CONFIG_INTEL_SOC_PMIC_CHTWC is not set
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
# CONFIG_MFD_INTEL_LPSS_PCI is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=m
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS68470 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
# CONFIG_LIRC is not set
CONFIG_RC_DECODERS=y
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_XMP_DECODER=m
# CONFIG_IR_IMON_DECODER is not set
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=m
CONFIG_IR_ENE=m
CONFIG_IR_IMON=m
# CONFIG_IR_IMON_RAW is not set
CONFIG_IR_MCEUSB=m
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
CONFIG_IR_REDRAT3=m
CONFIG_IR_STREAMZAP=m
CONFIG_IR_WINBOND_CIR=m
# CONFIG_IR_IGORPLUGUSB is not set
CONFIG_IR_IGUANA=m
CONFIG_IR_TTUSBIR=m
CONFIG_RC_LOOPBACK=m
# CONFIG_IR_SERIAL is not set
# CONFIG_IR_SIR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_CEC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_DVB_CORE=m
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
# CONFIG_DVB_ULE_DEBUG is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_DTCS033 is not set
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
# CONFIG_USB_GSPCA_KINECT is not set
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
# CONFIG_USB_GSPCA_TOUPTEK is not set
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
# CONFIG_VIDEO_CPIA2 is not set
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
# CONFIG_VIDEO_USBTV is not set

#
# Analog TV USB devices
#
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_USBVISION=m
# CONFIG_VIDEO_STK1160_COMMON is not set
# CONFIG_VIDEO_GO7007 is not set

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_AU0828_V4L2=y
# CONFIG_VIDEO_AU0828_RC is not set
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_TM6000=m
CONFIG_VIDEO_TM6000_ALSA=m
CONFIG_VIDEO_TM6000_DVB=m

#
# Digital TV USB devices
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_DIB3000MC=m
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_PCTV452E=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_AZ6027=m
CONFIG_DVB_USB_TECHNISAT_USB2=m
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_AF9035=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_AZ6007=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_LME2510=m
CONFIG_DVB_USB_MXL111SF=m
CONFIG_DVB_USB_RTL28XXU=m
# CONFIG_DVB_USB_DVBSKY is not set
# CONFIG_DVB_USB_ZD1301 is not set
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_SMS_USB_DRV=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set
# CONFIG_DVB_AS102 is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
# CONFIG_VIDEO_EM28XX_V4L2 is not set
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_EM28XX_RC=m
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
# CONFIG_VIDEO_MEYE is not set
# CONFIG_VIDEO_SOLO6X10 is not set
# CONFIG_VIDEO_TW5864 is not set
# CONFIG_VIDEO_TW68 is not set
# CONFIG_VIDEO_TW686X is not set

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=m
# CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS is not set
# CONFIG_VIDEO_IVTV_ALSA is not set
CONFIG_VIDEO_FB_IVTV=m
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DT3155 is not set

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_CX23885=m
CONFIG_MEDIA_ALTERA_CI=m
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_ENABLE_VP3054=y
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_BT848=m
CONFIG_DVB_BT8XX=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_SAA7164=m

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110_IR=y
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
# CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
CONFIG_DVB_PLUTO2=m
CONFIG_DVB_DM1105=m
CONFIG_DVB_PT1=m
# CONFIG_DVB_PT3 is not set
CONFIG_MANTIS_CORE=m
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=m
CONFIG_DVB_NGENE=m
CONFIG_DVB_DDBRIDGE=m
# CONFIG_DVB_DDBRIDGE_MSIENABLE is not set
# CONFIG_DVB_SMIPCIE is not set
# CONFIG_DVB_NETUP_UNIDVB is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=m
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=m
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_CYPRESS_FIRMWARE=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_V4L2=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEOBUF2_DMA_SG=m
CONFIG_VIDEOBUF2_DVB=m
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_SMS_SIANO_MDTV=m
CONFIG_SMS_SIANO_RC=y
# CONFIG_SMS_SIANO_DEBUGFS is not set

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS3308=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# SDR tuner chips
#

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#

#
# Media SPI Adapters
#
# CONFIG_CXD2880_SPI_DRV is not set
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA18250=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m
CONFIG_MEDIA_TUNER_QM1D1C0042=m
CONFIG_MEDIA_TUNER_QM1D1B0004=m

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV0910=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_STV6111=m
CONFIG_DVB_MXL5XX=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_CX24120=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_CXD2841ER=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_SI2168=m
CONFIG_DVB_GP8PSK_FE=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LGDT3306A=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBH25=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
# CONFIG_DRM_DP_AUX_CHARDEV is not set
# CONFIG_DRM_DEBUG_SELFTEST is not set
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=m
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set

#
# ACP (Audio CoProcessor) Configuration
#

#
# AMD Library routines
#
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
# CONFIG_DRM_I915_ALPHA_SUPPORT is not set
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
# CONFIG_DRM_I915_GVT is not set

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
CONFIG_DRM_VGEM=m
# CONFIG_DRM_VKMS is not set
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
CONFIG_DRM_UDL=m
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_QXL=m
# CONFIG_DRM_BOCHS is not set
# CONFIG_DRM_VIRTIO_GPU is not set
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# CONFIG_DRM_HISI_HIBMC is not set
# CONFIG_DRM_TINYDRM is not set
# CONFIG_DRM_XEN is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SM712 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_S6E63M0 is not set
# CONFIG_LCD_LD9040 is not set
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_PM8941_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_VGACON_SOFT_SCROLLBACK_PERSISTENT_ENABLE_BY_DEFAULT is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_SEQ_DEVICE=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_PCM_TIMER=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_PROC_FS=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_SEQUENCER_OSS=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_SEQ_MIDI_EVENT=m
CONFIG_SND_SEQ_MIDI=m
CONFIG_SND_SEQ_MIDI_EMUL=m
CONFIG_SND_SEQ_VIRMIDI=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL3_LIB_SEQ=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=5
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_ES1968_RADIO=y
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LOLA=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=m
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=0
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=m
CONFIG_SND_HDA_CODEC_ANALOG=m
CONFIG_SND_HDA_CODEC_SIGMATEL=m
CONFIG_SND_HDA_CODEC_VIA=m
CONFIG_SND_HDA_CODEC_HDMI=m
CONFIG_SND_HDA_CODEC_CIRRUS=m
CONFIG_SND_HDA_CODEC_CONEXANT=m
CONFIG_SND_HDA_CODEC_CA0110=m
CONFIG_SND_HDA_CODEC_CA0132=m
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=m
CONFIG_SND_HDA_CODEC_SI3054=m
CONFIG_SND_HDA_GENERIC=m
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDA_CORE=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_COMPONENT=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_PREALLOC_SIZE=512
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
# CONFIG_SND_USB_HIFACE is not set
# CONFIG_SND_BCD2000 is not set
# CONFIG_SND_USB_POD is not set
# CONFIG_SND_USB_PODHD is not set
# CONFIG_SND_USB_TONEPORT is not set
# CONFIG_SND_USB_VARIAX is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
# CONFIG_SND_DICE is not set
# CONFIG_SND_OXFW is not set
CONFIG_SND_ISIGHT=m
# CONFIG_SND_FIREWORKS is not set
# CONFIG_SND_BEBOB is not set
# CONFIG_SND_FIREWIRE_DIGI00X is not set
# CONFIG_SND_FIREWIRE_TASCAM is not set
# CONFIG_SND_FIREWIRE_MOTU is not set
# CONFIG_SND_FIREFACE is not set
# CONFIG_SND_SOC is not set
CONFIG_SND_X86=y
# CONFIG_HDMI_LPE_AUDIO is not set
CONFIG_SND_SYNTH_EMUX=m
# CONFIG_SND_XEN_FRONTEND is not set
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=m
# CONFIG_HID_ASUS is not set
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=y
# CONFIG_HID_BETOP_FF is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
CONFIG_HID_PRODIKEYS=m
# CONFIG_HID_CMEDIA is not set
# CONFIG_HID_CP2112 is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_GEMBIRD is not set
# CONFIG_HID_GFRM is not set
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_GOOGLE_HAMMER is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
# CONFIG_HID_ITE is not set
# CONFIG_HID_JABRA is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NTI is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=y
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_RMI is not set
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
# CONFIG_HID_SENSOR_HUB is not set
# CONFIG_HID_ALPS is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=m

#
# Intel ISH HID support
#
# CONFIG_INTEL_ISH_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_LEDS_TRIGGER_USBPORT is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=m
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
CONFIG_USB_DWC3_GADGET=y
# CONFIG_USB_DWC3_DUAL_ROLE is not set

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_PCI=y
CONFIG_USB_DWC3_HAPS=y
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
# CONFIG_USB_SERIAL_UPD78F0730 is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
# CONFIG_USB_HUB_USB251XB is not set
CONFIG_USB_HSIC_USB3503=m
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FOTG210_UDC is not set
# CONFIG_USB_GR_UDC is not set
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_PXA27X is not set
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_MV_U3D is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_BDC_UDC is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_MASS_STORAGE=m
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_MASS_STORAGE=m
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
# CONFIG_TYPEC is not set
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SPI is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
# CONFIG_LEDS_MLXCPLD is not set
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
# CONFIG_EDAC_GHES is not set
CONFIG_EDAC_AMD64=m
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
# CONFIG_EDAC_IE31200 is not set
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
# CONFIG_EDAC_SKX is not set
# CONFIG_EDAC_PND2 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV8803 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RX4581 is not set
# CONFIG_RTC_DRV_RX6110 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
CONFIG_RTC_DRV_RV3029_HWMON=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
# CONFIG_INTEL_IDMA64 is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
CONFIG_HSU_DMA=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
CONFIG_AUXDISPLAY=y
# CONFIG_HD44780 is not set
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
# CONFIG_IMG_ASCII_LCD is not set
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_UIO_HV_GENERIC is not set
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO=m
# CONFIG_VFIO_NOIOMMU is not set
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI_IGD=y
# CONFIG_VFIO_MDEV is not set
CONFIG_IRQ_BYPASS_MANAGER=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_INPUT is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_TSCPAGE=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_SELFBALLOONING is not set
# CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
CONFIG_XEN_SCRUB_PAGES=y
CONFIG_XEN_DEV_EVTCHN=m
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=m
CONFIG_XEN_PCIDEV_BACKEND=m
# CONFIG_XEN_PVCALLS_FRONTEND is not set
# CONFIG_XEN_PVCALLS_BACKEND is not set
# CONFIG_XEN_SCSI_BACKEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_ACPI_PROCESSOR=m
# CONFIG_XEN_MCE_LOG is not set
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
CONFIG_XEN_SYMS=y
CONFIG_XEN_HAVE_VPMU=y
CONFIG_STAGING=y
# CONFIG_PRISM2_USB is not set
# CONFIG_COMEDI is not set
# CONFIG_RTL8192U is not set
CONFIG_RTLLIB=m
CONFIG_RTLLIB_CRYPTO_CCMP=m
CONFIG_RTLLIB_CRYPTO_TKIP=m
CONFIG_RTLLIB_CRYPTO_WEP=m
CONFIG_RTL8192E=m
# CONFIG_RTL8723BS is not set
CONFIG_R8712U=m
# CONFIG_R8188EU is not set
# CONFIG_R8822BE is not set
# CONFIG_RTS5208 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_SM750 is not set
# CONFIG_FB_XGI is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_LTE_GDM724X is not set
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
# CONFIG_DGNC is not set
# CONFIG_GS_FPGABOOT is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_FB_TFT is not set
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
# CONFIG_MOST is not set
# CONFIG_KS7010 is not set
# CONFIG_GREYBUS is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_PI433 is not set
# CONFIG_MTK_MMC is not set

#
# Gasket devices
#
# CONFIG_STAGING_GASKET_FRAMEWORK is not set
# CONFIG_XIL_AXIS_FIFO is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACERHDF=m
# CONFIG_ALIENWARE_WMI is not set
CONFIG_ASUS_LAPTOP=m
# CONFIG_DELL_SMBIOS is not set
CONFIG_DELL_WMI_AIO=m
# CONFIG_DELL_WMI_LED is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_DELL_RBTN is not set
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
CONFIG_AMILO_RFKILL=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
# CONFIG_HP_WIRELESS is not set
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=m
# CONFIG_SURFACE3_WMI is not set
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_WMI=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_INTEL_WMI_THUNDERBOLT is not set
CONFIG_MSI_WMI=m
# CONFIG_PEAQ_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
# CONFIG_INTEL_INT0002_VGPIO is not set
# CONFIG_INTEL_HID_EVENT is not set
# CONFIG_INTEL_VBTN is not set
CONFIG_INTEL_IPS=m
# CONFIG_INTEL_PMC_CORE is not set
# CONFIG_IBM_RTL is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
CONFIG_SAMSUNG_Q10=m
CONFIG_APPLE_GMUX=m
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_PVPANIC=y
# CONFIG_INTEL_PMC_IPC is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_MLX_PLATFORM is not set
# CONFIG_INTEL_TURBO_MAX_3 is not set
# CONFIG_I2C_MULTI_INSTANTIATE is not set
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
# CONFIG_MELLANOX_PLATFORM is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_IOVA=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_V2=m
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#

#
# Broadcom SoC drivers
#

#
# NXP/Freescale QorIQ SoC drivers
#

#
# i.MX SoC drivers
#

#
# Qualcomm SoC drivers
#
# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# CONFIG_XILINX_VCU is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set
# CONFIG_DEVFREQ_GOV_PASSIVE is not set

#
# DEVFREQ Drivers
#
# CONFIG_PM_DEVFREQ_EVENT is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_INTEL_INT3496 is not set
# CONFIG_EXTCON_MAX3355 is not set
# CONFIG_EXTCON_RT8973A is not set
# CONFIG_EXTCON_SM5502 is not set
# CONFIG_EXTCON_USB_GPIO is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_NTB_AMD is not set
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
CONFIG_ARM_GIC_MAX_NR=1
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_THUNDERBOLT is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_NVMEM=y

#
# HW tracing support
#
CONFIG_STM=m
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
# CONFIG_INTEL_TH_ACPI is not set
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# CONFIG_FPGA is not set
CONFIG_PM_OPP=y
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_ENCRYPTION=y
CONFIG_EXT4_FS_ENCRYPTION=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_REPAIR=y
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
CONFIG_F2FS_FS_ENCRYPTION=y
# CONFIG_F2FS_IO_TRACE is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_VMCORE_DEVICE_DUMP is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
# CONFIG_CRAMFS_MTD is not set
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EXOFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
# CONFIG_NFSD_SCSILAYOUT is not set
# CONFIG_NFSD_FLEXFILELAYOUT is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_SUNRPC_DEBUG=y
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_ACL=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_COMPAT=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_WRITABLE_HOOKS=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
# CONFIG_HARDENED_USERCOPY is not set
# CONFIG_FORTIFY_SOURCE is not set
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_APPARMOR_HASH_DEFAULT=y
# CONFIG_SECURITY_APPARMOR_DEBUG is not set
# CONFIG_SECURITY_LOADPIN is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_WRITE_POLICY is not set
# CONFIG_IMA_READ_POLICY is not set
CONFIG_IMA_APPRAISE=y
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_RSA=y
# CONFIG_CRYPTO_DH is not set
# CONFIG_CRYPTO_ECDH is not set
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_MCRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_SIMD=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m
CONFIG_CRYPTO_ENGINE=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128L is not set
# CONFIG_CRYPTO_AEGIS256 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
# CONFIG_CRYPTO_AEGIS128L_AESNI_SSE2 is not set
# CONFIG_CRYPTO_AEGIS256_AESNI_SSE2 is not set
# CONFIG_CRYPTO_MORUS640 is not set
# CONFIG_CRYPTO_MORUS640_SSE2 is not set
# CONFIG_CRYPTO_MORUS1280 is not set
# CONFIG_CRYPTO_MORUS1280_SSE2 is not set
# CONFIG_CRYPTO_MORUS1280_AVX2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CFB is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y
# CONFIG_CRYPTO_KEYWRAP is not set

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_POLY1305 is not set
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256_SSSE3=m
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA1_MB=m
CONFIG_CRYPTO_SHA256_MB=m
CONFIG_CRYPTO_SHA512_MB=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3 is not set
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_CHACHA20 is not set
# CONFIG_CRYPTO_CHACHA20_X86_64 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4 is not set
# CONFIG_CRYPTO_SPECK is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_USER_API_RNG is not set
# CONFIG_CRYPTO_USER_API_AEAD is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXX is not set
# CONFIG_CRYPTO_DEV_QAT_C62X is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCCVF is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXXVF is not set
# CONFIG_CRYPTO_DEV_QAT_C62XVF is not set
# CONFIG_CRYPTO_DEV_NITROX_CNN55XX is not set
# CONFIG_CRYPTO_DEV_CHELSIO is not set
CONFIG_CRYPTO_DEV_VIRTIO=m
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
# CONFIG_SIGNED_PE_FILE_VERIFICATION is not set

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
# CONFIG_SYSTEM_BLACKLIST_KEYRING is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC64 is not set
# CONFIG_CRC4 is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
CONFIG_XXHASH=m
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=m
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
CONFIG_INTERVAL_TREE=y
CONFIG_RADIX_TREE_MULTIORDER=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DMA_DIRECT_OPS=y
CONFIG_SWIOTLB=y
CONFIG_SGL_ALLOC=y
CONFIG_IOMMU_HELPER=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
# CONFIG_DDR is not set
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_UACCESS_MCSAFE=y
CONFIG_SBITMAP=y
# CONFIG_STRING_SELFTEST is not set

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_GDB_SCRIPTS is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_PAGE_OWNER is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_STACK_VALIDATION=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KASAN=y
# CONFIG_KASAN is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
# CONFIG_WW_MUTEX_SELFTEST is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=m
# CONFIG_RCU_PERF_TEST is not set
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAIL_FUNCTION is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_PREEMPTIRQ_EVENTS is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_HWLAT_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_TRACING_MAP=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_TRACE_EVAL_MAP_FILE is not set
CONFIG_TRACING_EVENTS_GPIO=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_RUNTIME_TESTING_MENU=y
CONFIG_LKDTM=m
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=m
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=m
CONFIG_TEST_PRINTF=m
CONFIG_TEST_BITMAP=m
# CONFIG_TEST_BITFIELD is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
# CONFIG_FIND_BIT_BENCHMARK is not set
CONFIG_TEST_FIRMWARE=m
CONFIG_TEST_SYSCTL=m
CONFIG_TEST_UDELAY=m
CONFIG_TEST_STATIC_KEYS=m
CONFIG_TEST_KMOD=m
# CONFIG_MEMTEST is not set
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_EARLY_PRINTK_EFI is not set
# CONFIG_EARLY_PRINTK_USB_XDBC is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_WX is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_FPU=y
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# CONFIG_UNWINDER_GUESS is not set

--tgGnixv3tJWXBxdL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='netperf'
	export testcase='netperf'
	export category='benchmark'
	export disable_latency_stats=1
	export set_nic_irq_affinity=1
	export ip='ipv4'
	export runtime=300
	export nr_threads=16
	export cluster='cs-localhost'
	export job_origin='/lkp/lkp/.src-20180914-145348/allot/cyclic:p1:linux-devel:devel-hourly/lkp-hsw-d01/netperf-full-threads.yaml'
	export queue='validate'
	export testbox='lkp-hsw-d01'
	export tbox_group='lkp-hsw-d01'
	export submit_id='5b9d1ea20b9a933a12f20b4b'
	export job_file='/lkp/jobs/scheduled/lkp-hsw-d01/netperf-ipv4-300s-200%-cs-localhost-5K-TCP_SENDFILE-ucode=0x25-performance-debian-x86_64-2018-04-03.cgz-b99259a61450bb6403bbbbf279f8754a441eae8b-20180915-80402-17gtf0m-3.yaml'
	export id='0d982d28e382cf175382c12a6929d88acac202d2'
	export model='Haswell'
	export nr_node=1
	export nr_cpu=8
	export memory='8G'
	export hdd_partitions=
	export swap_partitions=
	export rootfs_partition=
	export brand='Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz'
	export ucode='0x25'
	export commit='b99259a61450bb6403bbbbf279f8754a441eae8b'
	export kconfig='x86_64-rhel-7.2'
	export compiler='gcc-7'
	export rootfs='debian-x86_64-2018-04-03.cgz'
	export enqueue_time='2018-09-15 23:00:50 +0800'
	export _id='5b9d1ea20b9a933a12f20b4c'
	export _rt='/result/netperf/ipv4-300s-200%-cs-localhost-5K-TCP_SENDFILE-ucode=0x25-performance/lkp-hsw-d01/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.2/gcc-7/b99259a61450bb6403bbbbf279f8754a441eae8b'
	export user='lkp'
	export head_commit='3bdb2056ecbbd3200665aef9593f322df72c5ba6'
	export base_commit='11da3a7f84f19c26da6f86af878298694ede0804'
	export branch='linux-devel/devel-hourly-2018091411'
	export result_root='/result/netperf/ipv4-300s-200%-cs-localhost-5K-TCP_SENDFILE-ucode=0x25-performance/lkp-hsw-d01/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.2/gcc-7/b99259a61450bb6403bbbbf279f8754a441eae8b/3'
	export LKP_SERVER='inn'
	export max_uptime=1500
	export initrd='/osimage/debian/debian-x86_64-2018-04-03.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/lkp-hsw-d01/netperf-ipv4-300s-200%-cs-localhost-5K-TCP_SENDFILE-ucode=0x25-performance-debian-x86_64-2018-04-03.cgz-b99259a61450bb6403bbbbf279f8754a441eae8b-20180915-80402-17gtf0m-3.yaml
ARCH=x86_64
kconfig=x86_64-rhel-7.2
branch=linux-devel/devel-hourly-2018091411
commit=b99259a61450bb6403bbbbf279f8754a441eae8b
BOOT_IMAGE=/pkg/linux/x86_64-rhel-7.2/gcc-7/b99259a61450bb6403bbbbf279f8754a441eae8b/vmlinuz-4.19.0-rc2-00128-gb99259a
max_uptime=1500
RESULT_ROOT=/result/netperf/ipv4-300s-200%-cs-localhost-5K-TCP_SENDFILE-ucode=0x25-performance/lkp-hsw-d01/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.2/gcc-7/b99259a61450bb6403bbbbf279f8754a441eae8b/3
LKP_SERVER=inn
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-7.2/gcc-7/b99259a61450bb6403bbbbf279f8754a441eae8b/modules.cgz'
	export bm_initrd='/osimage/deps/debian-x86_64-2018-04-03.cgz/run-ipconfig_2018-04-03.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/lkp_2018-04-03.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/rsync-rootfs_2018-04-03.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/netperf_2018-06-28.cgz,/osimage/pkg/debian-x86_64-2018-04-03.cgz/netperf-x86_64-_2018-06-27.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/mpstat_2018-06-19.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/turbostat_2018-05-17.cgz,/osimage/pkg/debian-x86_64-2018-04-03.cgz/turbostat-x86_64-d5256b2_2018-05-18.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/perf_2018-06-26.cgz,/osimage/pkg/debian-x86_64-2018-04-03.cgz/perf-x86_64-6f0d349d922b_2018-06-26.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/hw_2016-11-15.cgz,/osimage/deps/deb
 ian-x86_64-2018-04-03.cgz/cluster_2016-11-24.cgz'
	export lkp_initrd='/lkp/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export repeat_to=4
	export kernel='/pkg/linux/x86_64-rhel-7.2/gcc-7/b99259a61450bb6403bbbbf279f8754a441eae8b/vmlinuz-4.19.0-rc2-00128-gb99259a'
	export dequeue_time='2018-09-15 23:13:43 +0800'
	export node_roles='server client'
	export job_initrd='/lkp/jobs/scheduled/lkp-hsw-d01/netperf-ipv4-300s-200%-cs-localhost-5K-TCP_SENDFILE-ucode=0x25-performance-debian-x86_64-2018-04-03.cgz-b99259a61450bb6403bbbbf279f8754a441eae8b-20180915-80402-17gtf0m-3.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_setup $LKP_SRC/setup/cpufreq_governor 'performance'

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/no-stdout/wrapper boot-time
	run_monitor $LKP_SRC/monitors/wrapper iostat
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper vmstat
	run_monitor $LKP_SRC/monitors/wrapper numa-numastat
	run_monitor $LKP_SRC/monitors/wrapper numa-vmstat
	run_monitor $LKP_SRC/monitors/wrapper numa-meminfo
	run_monitor $LKP_SRC/monitors/wrapper proc-vmstat
	run_monitor $LKP_SRC/monitors/wrapper proc-stat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper slabinfo
	run_monitor $LKP_SRC/monitors/wrapper interrupts
	run_monitor $LKP_SRC/monitors/wrapper lock_stat
	run_monitor $LKP_SRC/monitors/wrapper latency_stats
	run_monitor $LKP_SRC/monitors/wrapper softirqs
	run_monitor $LKP_SRC/monitors/one-shot/wrapper bdi_dev_mapping
	run_monitor $LKP_SRC/monitors/wrapper diskstats
	run_monitor $LKP_SRC/monitors/wrapper nfsstat
	run_monitor $LKP_SRC/monitors/wrapper cpuidle
	run_monitor $LKP_SRC/monitors/wrapper cpufreq-stats
	run_monitor $LKP_SRC/monitors/wrapper turbostat
	run_monitor $LKP_SRC/monitors/wrapper sched_debug
	run_monitor $LKP_SRC/monitors/wrapper perf-stat
	run_monitor $LKP_SRC/monitors/wrapper mpstat
	run_monitor $LKP_SRC/monitors/no-stdout/wrapper perf-profile
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	if role server
	then
		start_daemon $LKP_SRC/daemon/netserver
	fi

	if role client
	then
		run_test send_size='5K' test='TCP_SENDFILE' $LKP_SRC/tests/wrapper netperf
	fi
}

extract_stats()
{
	$LKP_SRC/stats/wrapper netperf
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper boot-time
	$LKP_SRC/stats/wrapper iostat
	$LKP_SRC/stats/wrapper vmstat
	$LKP_SRC/stats/wrapper numa-numastat
	$LKP_SRC/stats/wrapper numa-vmstat
	$LKP_SRC/stats/wrapper numa-meminfo
	$LKP_SRC/stats/wrapper proc-vmstat
	$LKP_SRC/stats/wrapper meminfo
	$LKP_SRC/stats/wrapper slabinfo
	$LKP_SRC/stats/wrapper interrupts
	$LKP_SRC/stats/wrapper lock_stat
	$LKP_SRC/stats/wrapper latency_stats
	$LKP_SRC/stats/wrapper softirqs
	$LKP_SRC/stats/wrapper diskstats
	$LKP_SRC/stats/wrapper nfsstat
	$LKP_SRC/stats/wrapper cpuidle
	$LKP_SRC/stats/wrapper turbostat
	$LKP_SRC/stats/wrapper sched_debug
	$LKP_SRC/stats/wrapper perf-stat
	$LKP_SRC/stats/wrapper mpstat
	$LKP_SRC/stats/wrapper perf-profile

	$LKP_SRC/stats/wrapper time netperf.time
	$LKP_SRC/stats/wrapper time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper last_state
}

"$@"

--tgGnixv3tJWXBxdL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---

#! jobs/netperf-full-threads.yaml
suite: netperf
testcase: netperf
category: benchmark

# upto 90% CPU cycles may be used by latency stats
disable_latency_stats: 1
set_nic_irq_affinity: 1
ip: ipv4
runtime: 300s
nr_threads: 200%
cluster: cs-localhost
if role server:
  netserver: 
if role client:
  netperf:
    send_size: 5K
    test: TCP_SENDFILE
job_origin: "/lkp/lkp/.src-20180914-145348/allot/cyclic:p1:linux-devel:devel-hourly/lkp-hsw-d01/netperf-full-threads.yaml"

#! queue options
queue: bisect
testbox: lkp-hsw-d01
tbox_group: lkp-hsw-d01
submit_id: 5b9cf9240b9a933b4ba2d3ff
job_file: "/lkp/jobs/scheduled/lkp-hsw-d01/netperf-ipv4-300s-200%-cs-localhost-5K-TCP_SENDFILE-ucode=0x25-performance-debian-x86_64-2018-04-03.cgz-b99259a61450bb6403bbbbf279f8754a441eae8b-20180915-80715-16tj7bb-0.yaml"
id: a2ab9601b4e5ef916f138b19f87495726055b8cd

#! hosts/lkp-hsw-d01
model: Haswell
nr_node: 1
nr_cpu: 8
memory: 8G
hdd_partitions: 
swap_partitions: 
rootfs_partition: 
brand: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
ucode: '0x25'

#! include/category/benchmark
kmsg: 
boot-time: 
iostat: 
heartbeat: 
vmstat: 
numa-numastat: 
numa-vmstat: 
numa-meminfo: 
proc-vmstat: 
proc-stat: 
meminfo: 
slabinfo: 
interrupts: 
lock_stat: 
latency_stats: 
softirqs: 
bdi_dev_mapping: 
diskstats: 
nfsstat: 
cpuidle: 
cpufreq-stats: 
turbostat: 
sched_debug: 
perf-stat: 
mpstat: 
perf-profile: 

#! include/category/ALL
cpufreq_governor: performance

#! include/queue/cyclic
commit: b99259a61450bb6403bbbbf279f8754a441eae8b

#! default params
kconfig: x86_64-rhel-7.2
compiler: gcc-7
rootfs: debian-x86_64-2018-04-03.cgz
enqueue_time: 2018-09-15 20:20:52.130273402 +08:00
_id: 5b9cf9240b9a933b4ba2d3ff
_rt: "/result/netperf/ipv4-300s-200%-cs-localhost-5K-TCP_SENDFILE-ucode=0x25-performance/lkp-hsw-d01/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.2/gcc-7/b99259a61450bb6403bbbbf279f8754a441eae8b"

#! schedule options
user: lkp
head_commit: 3bdb2056ecbbd3200665aef9593f322df72c5ba6
base_commit: 11da3a7f84f19c26da6f86af878298694ede0804
branch: linux-devel/devel-hourly-2018091411
result_root: "/result/netperf/ipv4-300s-200%-cs-localhost-5K-TCP_SENDFILE-ucode=0x25-performance/lkp-hsw-d01/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.2/gcc-7/b99259a61450bb6403bbbbf279f8754a441eae8b/0"
LKP_SERVER: inn
max_uptime: 1500
initrd: "/osimage/debian/debian-x86_64-2018-04-03.cgz"
bootloader_append:
- root=/dev/ram0
- user=lkp
- job=/lkp/jobs/scheduled/lkp-hsw-d01/netperf-ipv4-300s-200%-cs-localhost-5K-TCP_SENDFILE-ucode=0x25-performance-debian-x86_64-2018-04-03.cgz-b99259a61450bb6403bbbbf279f8754a441eae8b-20180915-80715-16tj7bb-0.yaml
- ARCH=x86_64
- kconfig=x86_64-rhel-7.2
- branch=linux-devel/devel-hourly-2018091411
- commit=b99259a61450bb6403bbbbf279f8754a441eae8b
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-7.2/gcc-7/b99259a61450bb6403bbbbf279f8754a441eae8b/vmlinuz-4.19.0-rc2-00128-gb99259a
- max_uptime=1500
- RESULT_ROOT=/result/netperf/ipv4-300s-200%-cs-localhost-5K-TCP_SENDFILE-ucode=0x25-performance/lkp-hsw-d01/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.2/gcc-7/b99259a61450bb6403bbbbf279f8754a441eae8b/0
- LKP_SERVER=inn
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- drbd.minor_count=8
- systemd.log_level=err
- ignore_loglevel
- console=tty0
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- vga=normal
- rw
modules_initrd: "/pkg/linux/x86_64-rhel-7.2/gcc-7/b99259a61450bb6403bbbbf279f8754a441eae8b/modules.cgz"
bm_initrd: "/osimage/deps/debian-x86_64-2018-04-03.cgz/run-ipconfig_2018-04-03.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/lkp_2018-04-03.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/rsync-rootfs_2018-04-03.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/netperf_2018-06-28.cgz,/osimage/pkg/debian-x86_64-2018-04-03.cgz/netperf-x86_64-_2018-06-27.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/mpstat_2018-06-19.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/turbostat_2018-05-17.cgz,/osimage/pkg/debian-x86_64-2018-04-03.cgz/turbostat-x86_64-d5256b2_2018-05-18.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/perf_2018-06-26.cgz,/osimage/pkg/debian-x86_64-2018-04-03.cgz/perf-x86_64-6f0d349d922b_2018-06-26.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/hw_2016-11-15.cgz,/osimage/deps/debian-x86
 _64-2018-04-03.cgz/cluster_2016-11-24.cgz"
lkp_initrd: "/lkp/lkp/lkp-x86_64.cgz"
site: inn

#! /lkp/lkp/.src-20180914-145348/include/site/inn
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer: 
watchdog: 

#! runtime status
repeat_to: 2

#! user overrides
kernel: "/pkg/linux/x86_64-rhel-7.2/gcc-7/b99259a61450bb6403bbbbf279f8754a441eae8b/vmlinuz-4.19.0-rc2-00128-gb99259a"
dequeue_time: 2018-09-15 20:25:49.215846934 +08:00

#! /lkp/lkp/.src-20180914-222948/include/site/inn
job_state: finished
loadavg: 21.08 15.35 6.86 1/137 4855
start_time: '1537014402'
end_time: '1537014703'
version: "/lkp/lkp/.src-20180914-222948"

--tgGnixv3tJWXBxdL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce


for cpu_dir in /sys/devices/system/cpu/cpu[0-9]*
do
	online_file="$cpu_dir"/online
	[ -f "$online_file" ] && [ "$(cat "$online_file")" -eq 0 ] && continue

	file="$cpu_dir"/cpufreq/scaling_governor
	[ -f "$file" ] && echo "performance" > "$file"
done

 "netserver" "-4"
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
netperf -4 -H 127.0.0.1 -t TCP_SENDFILE -c -C -l 300 -- -m 5K  &
wait

--tgGnixv3tJWXBxdL--
