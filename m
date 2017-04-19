From: Samuel Holland <samuel@sholland.org>
Subject: padata & workqueue list corruption
Date: Tue, 18 Apr 2017 22:08:33 -0500
Message-ID: <3d02118b-73cc-2140-8c20-ee1535bfe68c@sholland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, jiangshanlai@gmail.com, jason@zx2c4.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        steffen.klassert@secunet.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43983 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759293AbdDSDIf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 23:08:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Steffen & Workqueue People,

As Jason wrote about here a few weeks ago, we've been having issues
with padata. After spending considerable time working to rule out
the possibility that our code was doing something wrong, I've begun
to debug padata and the workqueue subsystems. I've gotten some
potentially useful backtraces and was hoping somebody here might
read them and have an "ah ha!" moment.

We've been using the padata library for some high-throughput
encryption/decryption workloads, and on a relatively weak CPU (Celeron
J1800), we have run into list corruption that results in all workqueues
getting stalled, and occasional panics. I can reproduce this fairly
easily, albeit after several hours of load.

Representative backtraces follow (the warnings come in sets). I have
kernel .configs and extended netconsole output from several occurrences
available upon request.

WARNING: CPU: 1 PID: 0 at lib/list_debug.c:33 __list_add+0x89/0xb0
list_add corruption. prev->next should be next (ffff99f135016a90), but
was ffffd34affc03b10. (prev=ffffd34affc03b10).
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G           O    4.9.20+ #1
Call Trace:
  <IRQ>
  dump_stack+0x67/0x92
  __warn+0xc6/0xe0
  warn_slowpath_fmt+0x5a/0x80
  __list_add+0x89/0xb0
  insert_work+0x3c/0xc0
  __queue_work+0x18a/0x600
  queue_work_on+0x33/0x70
  padata_do_parallel+0x14f/0x240
  ? padata_index_to_cpu+0x50/0x50
  ? packet_receive+0x140/0x140 [wireguard]
  packet_consume_data+0x1b9/0x2b0 [wireguard]
  ? packet_create_data+0x6b0/0x6b0 [wireguard]
  ? get_partial_node.isra.72+0x47/0x250
  ? skb_prepare_header+0xd5/0x3f0 [wireguard]
  ? packet_receive+0x140/0x140 [wireguard]
  packet_receive+0x79/0x140 [wireguard]
  ? __udp4_lib_lookup+0x147/0x2d0
  receive+0x1a/0x30 [wireguard]
  udp_queue_rcv_skb+0x34a/0x5b0
  __udp4_lib_rcv+0x468/0xb40
  ? ip_local_deliver_finish+0x21/0x370
  udp_rcv+0x15/0x20
  ip_local_deliver_finish+0xb7/0x370
  ? ip_local_deliver_finish+0x21/0x370
  ip_local_deliver+0x1e6/0x230
  ? ip_local_deliver+0x62/0x230
  ? ip_rcv_finish+0x670/0x670
  ip_rcv_finish+0x1ae/0x670
  ip_rcv+0x366/0x4d0
  ? ip_rcv+0x26a/0x4d0
  ? inet_del_offload+0x40/0x40
  __netif_receive_skb_core+0xae1/0xc80
  ? inet_del_offload+0x40/0x40
  ? netif_receive_skb_internal+0x29/0x200
  __netif_receive_skb+0x18/0x60
  netif_receive_skb_internal+0x7b/0x200
  ? netif_receive_skb_internal+0x29/0x200
  netif_receive_skb+0xcd/0x130
  br_pass_frame_up+0x2b1/0x2c0
  ? br_pass_frame_up+0xad/0x2c0
  ? br_allowed_ingress+0x38a/0x5d0
  ? br_allowed_ingress+0x1f5/0x5d0
  br_handle_frame_finish+0x28f/0x5a0
  ? br_handle_frame+0x1c1/0x5e0
  br_handle_frame+0x2c5/0x5e0
  ? br_handle_frame+0x1c1/0x5e0
  ? vlan_do_receive+0x37/0x380
  ? br_handle_frame_finish+0x5a0/0x5a0
  __netif_receive_skb_core+0x1e6/0xc80
  ? netif_receive_skb_internal+0x29/0x200
  __netif_receive_skb+0x18/0x60
  netif_receive_skb_internal+0x7b/0x200
  ? netif_receive_skb_internal+0x29/0x200
  napi_gro_receive+0x148/0x200
  igb_poll+0x67b/0xdb0
  ? net_rx_action+0xe5/0x450
  net_rx_action+0x224/0x450
  __do_softirq+0x1a9/0x4a0
  irq_exit+0xbe/0xd0
  do_IRQ+0x65/0x110
  common_interrupt+0x89/0x89
  <EOI>

This add looks to be racing with a deletion of the last item in the
list, because in the actual list prev->next = prev.

WARNING: CPU: 1 PID: 0 at lib/list_debug.c:36 __list_add+0xac/0xb0
list_add double add: new=ffffd34affc03b10, prev=ffffd34affc03b10,
next=ffff99f135016a90.
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W  O    4.9.20+ #1
Call Trace:
  <IRQ>
  dump_stack+0x67/0x92
  __warn+0xc6/0xe0
  warn_slowpath_fmt+0x5a/0x80
  __list_add+0xac/0xb0
  insert_work+0x3c/0xc0
  __queue_work+0x18a/0x600
  queue_work_on+0x33/0x70
  padata_do_parallel+0x14f/0x240
  ? padata_index_to_cpu+0x50/0x50
  ? packet_receive+0x140/0x140 [wireguard]
  packet_consume_data+0x1b9/0x2b0 [wireguard]
  ? packet_create_data+0x6b0/0x6b0 [wireguard]
  ? get_partial_node.isra.72+0x47/0x250
  ? skb_prepare_header+0xd5/0x3f0 [wireguard]
  ? packet_receive+0x140/0x140 [wireguard]
  packet_receive+0x79/0x140 [wireguard]
  ? __udp4_lib_lookup+0x147/0x2d0
  receive+0x1a/0x30 [wireguard]
  udp_queue_rcv_skb+0x34a/0x5b0
  __udp4_lib_rcv+0x468/0xb40
  ? ip_local_deliver_finish+0x21/0x370
  udp_rcv+0x15/0x20
  ip_local_deliver_finish+0xb7/0x370
  ? ip_local_deliver_finish+0x21/0x370
  ip_local_deliver+0x1e6/0x230
  ? ip_local_deliver+0x62/0x230
  ? ip_rcv_finish+0x670/0x670
  ip_rcv_finish+0x1ae/0x670
  ip_rcv+0x366/0x4d0
  ? ip_rcv+0x26a/0x4d0
  ? inet_del_offload+0x40/0x40
  __netif_receive_skb_core+0xae1/0xc80
  ? inet_del_offload+0x40/0x40
  ? netif_receive_skb_internal+0x29/0x200
  __netif_receive_skb+0x18/0x60
  netif_receive_skb_internal+0x7b/0x200
  ? netif_receive_skb_internal+0x29/0x200
  netif_receive_skb+0xcd/0x130
  br_pass_frame_up+0x2b1/0x2c0
  ? br_pass_frame_up+0xad/0x2c0
  ? br_allowed_ingress+0x38a/0x5d0
  ? br_allowed_ingress+0x1f5/0x5d0
  br_handle_frame_finish+0x28f/0x5a0
  ? br_handle_frame+0x1c1/0x5e0
  br_handle_frame+0x2c5/0x5e0
  ? br_handle_frame+0x1c1/0x5e0
  ? vlan_do_receive+0x37/0x380
  ? br_handle_frame_finish+0x5a0/0x5a0
  __netif_receive_skb_core+0x1e6/0xc80
  ? netif_receive_skb_internal+0x29/0x200
  __netif_receive_skb+0x18/0x60
  netif_receive_skb_internal+0x7b/0x200
  ? netif_receive_skb_internal+0x29/0x200
  napi_gro_receive+0x148/0x200
  igb_poll+0x67b/0xdb0
  ? net_rx_action+0xe5/0x450
  net_rx_action+0x224/0x450
  __do_softirq+0x1a9/0x4a0
  irq_exit+0xbe/0xd0
  do_IRQ+0x65/0x110
  common_interrupt+0x89/0x89
  <EOI>

And finally:

WARNING: CPU: 0 PID: 0 at lib/list_debug.c:33 __list_add+0x89/0xb0
list_add corruption. prev->next should be next (ffff99f135016a90), but
was ffffd34affc03b10. (prev=ffffd34affc03b10).
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W  O    4.9.20+ #1
Call Trace:
  <IRQ>
  dump_stack+0x67/0x92
  __warn+0xc6/0xe0
  warn_slowpath_fmt+0x5a/0x80
  __list_add+0x89/0xb0
  insert_work+0x3c/0xc0
  __queue_work+0x18a/0x600
  ? execute_in_process_context+0x90/0x90
  delayed_work_timer_fn+0x19/0x20
  call_timer_fn+0xa8/0x340
  ? process_timeout+0x10/0x10
  ? execute_in_process_context+0x90/0x90
  run_timer_softirq+0x1bf/0x6b0
  ? ktime_get+0x91/0x120
  ? clockevents_program_event+0x42/0x120
  ? clockevents_program_event+0x7d/0x120
  __do_softirq+0x1a9/0x4a0
  irq_exit+0xbe/0xd0
  smp_apic_timer_interrupt+0x3d/0x50
  apic_timer_interrupt+0x89/0x90
  <EOI>

Note that this third warning is on the other CPU. All three warnings are
immediately consecutive in the kernel logs (within 1 second).

Looking at the workqueue code and documentation, it should be fine to
call queue_work_on() on an already-queued work item, as padata is doing.

I've also triggered a related warning in the workqueue code a few times:

WARNING at kernel/workqueue.c:1440 __queue_work+0x1d6/0x450
CPU: 1 PID: 1013 Comm: kworker/1:2 Tainted: G        W  O    4.9.17 #1
Call Trace:
  dump_stack+0x4d/0x65
  __warn+0xc6/0xe0
  warn_slowpath_null+0x18/0x20
  __queue_work+0x1d6/0x450
  queue_work_on+0x14/0x30
  padata_reorder+0xb2/0x160
  padata_do_serial+0x51/0x60
  timers_uninit_peer+0x275/0xa20 [wireguard]
  padata_parallel_worker+0x77/0xa0
  process_one_work+0x154/0x410
  worker_thread+0x46/0x470
  ? process_one_work+0x410/0x410
  kthread+0xc5/0xe0
  ? kthread_park+0x60/0x60
  ? kthread_park+0x60/0x60
  ret_from_fork+0x22/0x30

FWIW I'm also sometimes seeing similar list corruption in the padata
queues, usually in padata_reorder(), as well as with lists in the timer
subsystem relating to padata's reorder timer. Lockdep does not complain
about anything, and I've manually checked the locking all three
subsystems to no avail, so I suspect this may ultimately be a deeper
synchronization or memory corruption issue.

If you have any immediate ideas, I'd be very grateful. If not, we'll
keep debugging, of course.

Thanks for any insight,
Samuel
