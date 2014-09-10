From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] crypto: talitos: Avoid excessive loops in softirq context
Date: Wed, 10 Sep 2014 10:34:47 +0200
Message-ID: <1410338087-5317-1-git-send-email-helmut.schaa@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:43141 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaIJIxZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Sep 2014 04:53:25 -0400
Received: by mail-qg0-f54.google.com with SMTP id z60so3283191qgd.13
        for <linux-crypto@vger.kernel.org>; Wed, 10 Sep 2014 01:53:24 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The talitos driver can cause starvation of other softirqs and as such
it can also cause rcu stalls like:

INFO: rcu_sched self-detected stall on CPU { 1}  (t=15001 jiffies g=6799 c=6798 q=728)
INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=15002 jiffies, g=6799, c=6798, q=728)
Task dump for CPU 1:
ovs-vswitchd    R running      0  3225      1 0x00000004
Call Trace:
[c68879a0] [00000002] 0x2 (unreliable)
[c6887a60] [00000000]   (null)
CPU: 1 PID: 3225 Comm: ovs-vswitchd Tainted: G        W    3.10.36 #2
Call Trace:
[effe9900] [c0006b08] show_stack+0x44/0x15c (unreliable)
[effe9940] [c0072eb0] rcu_check_callbacks+0x21c/0x668
[effe99a0] [c0030f48] update_process_times+0x44/0x70
[effe99c0] [c005fdac] tick_sched_timer+0x2d4/0x314
[effe9a00] [c00466f4] __run_hrtimer.isra.29+0x54/0xf8
[effe9a20] [c0047110] hrtimer_interrupt+0x1a4/0x3bc
[effe9aa0] [c000827c] timer_interrupt+0x15c/0x1a4
[effe9ad0] [c000d470] ret_from_except+0x0/0x18
 --- Exception: 901 at memcpy+0x1c/0x9c
LR = pskb_expand_head+0x94/0x298
[effe9b90] [c02260c0] pskb_expand_head+0x68/0x298 (unreliable)
[effe9bc0] [f159d20c] 0xf159d20c
[effe9bd0] [c02344f4] dev_hard_start_xmit+0x2b8/0x454
[effe9c00] [c024d330] sch_direct_xmit+0x70/0x1e8
[effe9c20] [c0234914] dev_queue_xmit+0x284/0x4fc
[effe9c50] [c02cf3b0] vlan_dev_hard_start_xmit+0xa8/0x178
[effe9c60] [c02344f4] dev_hard_start_xmit+0x2b8/0x454
[effe9c90] [c0234a64] dev_queue_xmit+0x3d4/0x4fc
[effe9cc0] [f14cb2c4] ovs_netdev_get_name+0xac/0x404 [openvswitch]
[effe9ce0] [f14c9698] ovs_vport_send+0x28/0xe8 [openvswitch]
[effe9d00] [f14c0000] 0xf14c0000
[effe9d10] [f14c0b84] 0xf14c0b84
[effe9d90] [f14c0c74] ovs_execute_actions+0xa4/0x1270 [openvswitch]
[effe9dc0] [f14c3a30] ovs_dp_process_received_packet+0xd0/0x11c [openvswitch]
[effe9e70] [f14ca3f0] ovs_vport_deferred_free+0xc98/0xd78 [openvswitch]
[effe9e80] [c02344f4] dev_hard_start_xmit+0x2b8/0x454
[effe9eb0] [c0234a64] dev_queue_xmit+0x3d4/0x4fc
[effe9ee0] [c0266924] ip_finish_output+0x450/0x4b4
[effe9f10] [f13a8920] talitos_submit+0x2d8/0x3f1c [talitos]
[effe9f60] [f13a8aa4] talitos_submit+0x45c/0x3f1c [talitos]
[effe9f70] [c002aa9c] tasklet_action+0xe4/0x178
[effe9fa0] [c002ac18] __do_softirq+0xe8/0x1ac
[effe9ff0] [c000b974] call_do_softirq+0x14/0x24
[c6887ee0] [c0004498] do_softirq+0x84/0xc4
[c6887f00] [c002ae2c] irq_exit+0x64/0x7c
[c6887f10] [c0004268] do_IRQ+0x12c/0x154
[c6887f40] [c000d470] ret_from_except+0x0/0x18

Work around this by processing a maximum amount of 16 finished requests
and rescheduling the done-tasklet if any work is left.

This allows other softirqs to run.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/crypto/talitos.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 624b8be..e0f03da 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -244,17 +244,18 @@ EXPORT_SYMBOL(talitos_submit);
 /*
  * process what was done, notify callback of error if not
  */
-static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
+static int flush_channel(struct device *dev, int ch, int error, int reset_ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_request *request, saved_req;
 	unsigned long flags;
 	int tail, status;
+	int cnt = 16;
 
 	spin_lock_irqsave(&priv->chan[ch].tail_lock, flags);
 
 	tail = priv->chan[ch].tail;
-	while (priv->chan[ch].fifo[tail].desc) {
+	while (priv->chan[ch].fifo[tail].desc && (--cnt > 0)) {
 		request = &priv->chan[ch].fifo[tail];
 
 		/* descriptors with their done bits set don't get the error */
@@ -291,36 +292,46 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 				   status);
 		/* channel may resume processing in single desc error case */
 		if (error && !reset_ch && status == error)
-			return;
+			return 0;
 		spin_lock_irqsave(&priv->chan[ch].tail_lock, flags);
 		tail = priv->chan[ch].tail;
 	}
 
 	spin_unlock_irqrestore(&priv->chan[ch].tail_lock, flags);
+
+	if (cnt == 0)
+		return 1; /* Need to reschedule */
+	return 0;
 }
 
 /*
  * process completed requests for channels that have done status
  */
-#define DEF_TALITOS_DONE(name, ch_done_mask)				\
+#define DEF_TALITOS_DONE(name, ch_done_mask, tlet)				\
 static void talitos_done_##name(unsigned long data)			\
 {									\
 	struct device *dev = (struct device *)data;			\
 	struct talitos_private *priv = dev_get_drvdata(dev);		\
 	unsigned long flags;						\
+	int resched = 0;						\
 									\
 	if (ch_done_mask & 1)						\
-		flush_channel(dev, 0, 0, 0);				\
+		resched += flush_channel(dev, 0, 0, 0);			\
 	if (priv->num_channels == 1)					\
 		goto out;						\
 	if (ch_done_mask & (1 << 2))					\
-		flush_channel(dev, 1, 0, 0);				\
+		resched += flush_channel(dev, 1, 0, 0);			\
 	if (ch_done_mask & (1 << 4))					\
-		flush_channel(dev, 2, 0, 0);				\
+		resched += flush_channel(dev, 2, 0, 0);			\
 	if (ch_done_mask & (1 << 6))					\
-		flush_channel(dev, 3, 0, 0);				\
+		resched += flush_channel(dev, 3, 0, 0);			\
 									\
 out:									\
+	if (resched) {							\
+		tasklet_schedule(&priv->done_task[tlet]);		\
+		return;							\
+	}								\
+									\
 	/* At this point, all completed channels have been processed */	\
 	/* Unmask done interrupts for channels completed later on. */	\
 	spin_lock_irqsave(&priv->reg_lock, flags);			\
@@ -328,9 +339,9 @@ out:									\
 	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);	\
 	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
 }
-DEF_TALITOS_DONE(4ch, TALITOS_ISR_4CHDONE)
-DEF_TALITOS_DONE(ch0_2, TALITOS_ISR_CH_0_2_DONE)
-DEF_TALITOS_DONE(ch1_3, TALITOS_ISR_CH_1_3_DONE)
+DEF_TALITOS_DONE(4ch, TALITOS_ISR_4CHDONE, 0)
+DEF_TALITOS_DONE(ch0_2, TALITOS_ISR_CH_0_2_DONE, 0)
+DEF_TALITOS_DONE(ch1_3, TALITOS_ISR_CH_1_3_DONE, 1)
 
 /*
  * locate current (offending) descriptor
@@ -489,7 +500,7 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 		if (v_lo & TALITOS_CCPSR_LO_SRL)
 			dev_err(dev, "scatter return/length error\n");
 
-		flush_channel(dev, ch, error, reset_ch);
+		while (flush_channel(dev, ch, error, reset_ch));
 
 		if (reset_ch) {
 			reset_channel(dev, ch);
-- 
1.8.4.5
