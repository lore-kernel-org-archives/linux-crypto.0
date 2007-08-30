From: Eran Ben-Avi <eranpublic@yahoo.com>
Subject: Re: Openswan 2.4.9 - tasklet or workqueue ?
Date: Thu, 30 Aug 2007 00:58:00 -0700 (PDT)
Message-ID: <440337.35301.qm@web62504.mail.re1.yahoo.com>
References: <20070827224021.GA23450@securecomputing.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1750485280-1188460680=:35301"
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: David McCullough <David_Mccullough@securecomputing.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from web62504.mail.re1.yahoo.com ([69.147.75.96]:30967 "HELO
	web62504.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752298AbXH3H6B (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 03:58:01 -0400
In-Reply-To: <20070827224021.GA23450@securecomputing.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--0-1750485280-1188460680=:35301
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline


--- David McCullough
<David_Mccullough@securecomputing.com> wrote:

> 
> 
> 
> Jivin Eran Ben-Avi lays it down ...
> > Hi,
> > 
> > I tested IPSec(tunnel mode) routing performance
> between 2 GbE ports using packet generator(SMARTBIT)
>  on ARM 500MHz with latest OCF patched on
> Openswan2.4.9 and I noticed the callback functions
> are using workqueue.
> > Since RX was performed in NAPI mode with higher
> priority then TX (in workqueue), the callback
> function(in ipsec_ocf.c) was starved with zero
> routing.
> > The problem was solved after I switched to use
> tasklet instead of the workqueue.
> > Is there a room for updating next OCF release ?
> 
> Sure,  send in a patch. This is against
> ocf-linux-20070727 right ?
Yes.
Can you please estimate when next release will be
ready?

Thanks. 

> 
> Cheers,
> Davidm
> 
> -- 
> David McCullough, 
> david_mccullough@securecomputing.com,   Ph:+61
> 734352815
> Secure Computing - SnapGear  http://www.uCdot.org
> http://www.cyberguard.com
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> 



       
____________________________________________________________________________________
Got a little couch potato? 
Check out fun summer activities for kids.
http://search.yahoo.com/search?fr=oni_on_mail&p=summer+activities+for+kids&cs=bz 
--0-1750485280-1188460680=:35301
Content-Type: text/plain; name="use_tasklet.patch"
Content-Description: 3642874744-use_tasklet.patch
Content-Disposition: inline; filename="use_tasklet.patch"

--- openswan-2.4.9/linux/net/ipsec/ipsec_ocf.c	2007-08-30 10:29:39.000000000 -0200
+++ openswan-2.4.9_last/linux/net/ipsec/ipsec_ocf.c	2007-08-30 10:39:42.000000000 -0200
@@ -53,10 +53,10 @@
  * Tuning parameters,  the settings below appear best for
  * the IXP
  */
-#define USE_BATCH 1	/* enable batch mode */
-#define USE_CBIMM 1	/* enable immediate callbacks */
-#define FORCE_QS  0	/* force use of queues for continuation of state machine */
-
+#define USE_BATCH   1	/* enable batch mode */
+#define USE_CBIMM   1	/* enable immediate callbacks */
+#define FORCE_QS    0	/* force use of queues for continuation of state machine */
+#define USE_TASKLET 1  /* force use of tasklet for continuation of state machine */
 /*
  * Because some OCF operations are synchronous (ie., software encryption)
  * we need to protect ourselves from distructive re-entry.  All we do
@@ -83,7 +83,11 @@
 		(*sm)(arg); \
 	})
 
-#if FORCE_QS == 0
+#if USE_TASKLET == 1
+	#define PROCESS_NEXT(tskl, sm, arg) \
+		tasklet_init(&tskl,(void (*)(unsigned long)) sm, (unsigned long)arg);\
+		tasklet_schedule(&tskl);
+#elif FORCE_QS == 0
 	#define PROCESS_NEXT(wq, wqsm, sm, arg) \
 		if (in_interrupt()) { \
 			PROCESS_LATER(wq, wqsm, arg); \
@@ -218,6 +222,7 @@
 	return 1;
 }
 
+#if USE_TASKLET == 0
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
 static void
 ipsec_rsm_wq(struct work_struct *work)
@@ -228,6 +233,7 @@
 #else
 #define	ipsec_rsm_wq	ipsec_rsm
 #endif
+#endif /* USE_TASKLET */
 
 static int
 ipsec_ocf_rcv_cb(struct cryptop *crp)
@@ -235,7 +241,6 @@
 	struct ipsec_rcv_state *irs = (struct ipsec_rcv_state *)crp->crp_opaque;
 
 	KLIPS_PRINT(debug_rcv, "klips_debug:ipsec_ocf_rcv_cb\n");
-
 	if (irs == NULL) {
 		KLIPS_PRINT(debug_rcv, "klips_debug:ipsec_ocf_rcv_cb: "
 				"NULL irs in callback\n");
@@ -273,7 +278,11 @@
 	crp = NULL;
 
 	/* setup the rest of the processing now */
+#if USE_TASKLET == 1
+	PROCESS_NEXT(irs->tasklet, ipsec_rsm, irs);
+#else
 	PROCESS_NEXT(irs->workq, ipsec_rsm_wq, ipsec_rsm, irs);
+#endif
 	return 0;
 }
 
@@ -396,6 +405,7 @@
 	return(IPSEC_RCV_PENDING);
 }
 
+#if USE_TASKLET == 0
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
 static void
 ipsec_xsm_wq(struct work_struct *work)
@@ -406,6 +416,7 @@
 #else
 #define	ipsec_xsm_wq	ipsec_xsm
 #endif
+#endif /* USE_TASKLET */
 
 static int
 ipsec_ocf_xmit_cb(struct cryptop *crp)
@@ -445,7 +456,11 @@
 	crp = NULL;
 
 	/* setup the rest of the processing now */
+#if USE_TASKLET == 1
+	PROCESS_NEXT(ixs->tasklet, ipsec_xsm, ixs);
+#else
 	PROCESS_NEXT(ixs->workq, ipsec_xsm_wq, ipsec_xsm, ixs);
+#endif
 	return 0;
 }
 

--0-1750485280-1188460680=:35301--
