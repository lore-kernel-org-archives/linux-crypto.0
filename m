Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C777C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jul 2022 10:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbiGLKIs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Jul 2022 06:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbiGLKIq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Jul 2022 06:08:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3007D62C1;
        Tue, 12 Jul 2022 03:08:36 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26C9r4Xd000665;
        Tue, 12 Jul 2022 10:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=eSHq/Lw6xlRnQULwNWDUKbvDA5yek8lzHeyD2Alq7Os=;
 b=kNrxpHlKV4m2pzFmEFD8SQDw9/JUx4mwodwnb5DAsLpYbBPZfqtsYPHjVsYrXkxXhxLD
 CFrh92Vw/PSFOL19Qrl1yYu/7bTM+PhKN9CcuPIZzVWxKXAjjrHTU0zHhypnBwoVRkqk
 Zen9MDCuYgoYl4oPoHGGjV8hAt9cBCFYq4GDBdEJtcvDq7xhieaRAZbKNhUTuCnGSXkW
 /NTCfY+Ar8TGWSSdRZLJ1zUX95O3CVF6syoiASpE9C/rAFiiao7NF5sinyXOPAUF0uNy
 c2nv6zlu8qvUaRlQ14WhidTXsbqVe8mrxnNm+sTDQxLre0GsAjw2pPp87PK5+AYVwXhg rw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h96qf8bc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 10:08:34 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26CA8Qmw010559;
        Tue, 12 Jul 2022 10:08:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3h71a8v04x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 10:08:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26CA8T1724510848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 10:08:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE4F7AE04D;
        Tue, 12 Jul 2022 10:08:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB813AE045;
        Tue, 12 Jul 2022 10:08:29 +0000 (GMT)
Received: from funtu.com (unknown [9.145.19.45])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jul 2022 10:08:29 +0000 (GMT)
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason@zx2c4.com
Cc:     jchrist@linux.ibm.com, dengler@linux.ibm.com
Subject: [PATCH] s390/archrandom: remove CPACF trng invocations in interrupt context
Date:   Tue, 12 Jul 2022 12:08:29 +0200
Message-Id: <20220712100829.128574-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6bpfoqfIB9h3LWTuQnWx8WLEUUnpHFpI
X-Proofpoint-GUID: 6bpfoqfIB9h3LWTuQnWx8WLEUUnpHFpI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_05,2022-07-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1015
 suspectscore=0 mlxscore=0 mlxlogscore=719 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120035
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch introduces two things:
1) The arch_get_random_seed_int() implementation now always
   returns false. There is no user in the whole kernel using
   this function.
2) For the arch_get_random_seed_long() make sure the CPACF trng
   instruction is never called in any interrupt context. This
   is done by adding an additional condition in_task().

Justification for 2):

There are some constrains to satisfy for the invocation of the
arch_get_random_seed_long() function:
- It should provide good random data during kernel initialization.
- It should not be called in interrupt context as the instruction
  is relatively heavy weight and may for example make some network
  loads cause to timeout and buck.

However, it was not clear what kind of interrupt context is exactly
encountered during kernel init or network traffic eventually calling
arch_get_random_seed_long().

After some days of investigations it is clear that the s390
start_kernel function is not running in any interrupt context and
so the trng is called:

Jul 11 18:33:39 t35lp54 kernel:  [<00000001064e90ca>] arch_get_random_seed_long.part.0+0x32/0x70
Jul 11 18:33:39 t35lp54 kernel:  [<000000010715f246>] random_init+0xf6/0x238
Jul 11 18:33:39 t35lp54 kernel:  [<000000010712545c>] start_kernel+0x4a4/0x628
Jul 11 18:33:39 t35lp54 kernel:  [<000000010590402a>] startup_continue+0x2a/0x40

The condition in_task() is true and the CPACF trng provides random data
during kernel startup.

The network traffic however, is more difficult. A typical call stack
looks like this:

Jul 06 17:37:07 t35lp54 kernel:  [<000000008b5600fc>] extract_entropy.constprop.0+0x23c/0x240
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b560136>] crng_reseed+0x36/0xd8
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b5604b8>] crng_make_state+0x78/0x340
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b5607e0>] _get_random_bytes+0x60/0xf8
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b56108a>] get_random_u32+0xda/0x248
Jul 06 17:37:07 t35lp54 kernel:  [<000000008aefe7a8>] kfence_guarded_alloc+0x48/0x4b8
Jul 06 17:37:07 t35lp54 kernel:  [<000000008aeff35e>] __kfence_alloc+0x18e/0x1b8
Jul 06 17:37:07 t35lp54 kernel:  [<000000008aef7f10>] __kmalloc_node_track_caller+0x368/0x4d8
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b611eac>] kmalloc_reserve+0x44/0xa0
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b611f98>] __alloc_skb+0x90/0x178
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b6120dc>] __napi_alloc_skb+0x5c/0x118
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b8f06b4>] qeth_extract_skb+0x13c/0x680
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b8f6526>] qeth_poll+0x256/0x3f8
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b63d76e>] __napi_poll.constprop.0+0x46/0x2f8
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b63dbec>] net_rx_action+0x1cc/0x408
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b937302>] __do_softirq+0x132/0x6b0
Jul 06 17:37:07 t35lp54 kernel:  [<000000008abf46ce>] __irq_exit_rcu+0x13e/0x170
Jul 06 17:37:07 t35lp54 kernel:  [<000000008abf531a>] irq_exit_rcu+0x22/0x50
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b922506>] do_io_irq+0xe6/0x198
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b935826>] io_int_handler+0xd6/0x110
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b9358a6>] psw_idle_exit+0x0/0xa
Jul 06 17:37:07 t35lp54 kernel: ([<000000008ab9c59a>] arch_cpu_idle+0x52/0xe0)
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b933cfe>] default_idle_call+0x6e/0xd0
Jul 06 17:37:07 t35lp54 kernel:  [<000000008ac59f4e>] do_idle+0xf6/0x1b0
Jul 06 17:37:07 t35lp54 kernel:  [<000000008ac5a28e>] cpu_startup_entry+0x36/0x40
Jul 06 17:37:07 t35lp54 kernel:  [<000000008abb0d90>] smp_start_secondary+0x148/0x158
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b935b9e>] restart_int_handler+0x6e/0x90

which confirms that the call is in softirq context. So in_task() covers exactly
the cases where we want to have CPACF trng called: not in nmi, not in hard irq,
not in soft irq but in normal task context and during kernel init.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 arch/s390/include/asm/archrandom.h | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
index 2c6e1c6ecbe7..9662c9fa7683 100644
--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -2,7 +2,7 @@
 /*
  * Kernel interface for the s390 arch_random_* functions
  *
- * Copyright IBM Corp. 2017, 2020
+ * Copyright IBM Corp. 2017, 2022
  *
  * Author: Harald Freudenberger <freude@de.ibm.com>
  *
@@ -14,6 +14,7 @@
 #ifdef CONFIG_ARCH_RANDOM
 
 #include <linux/static_key.h>
+#include <linux/preempt.h>
 #include <linux/atomic.h>
 #include <asm/cpacf.h>
 
@@ -33,20 +34,17 @@ static inline bool __must_check arch_get_random_int(unsigned int *v)
 static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
 	if (static_branch_likely(&s390_arch_random_available)) {
-		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
-		atomic64_add(sizeof(*v), &s390_arch_random_counter);
-		return true;
+		if (in_task()) {
+			cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
+			atomic64_add(sizeof(*v), &s390_arch_random_counter);
+			return true;
+		}
 	}
 	return false;
 }
 
 static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
-	if (static_branch_likely(&s390_arch_random_available)) {
-		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
-		atomic64_add(sizeof(*v), &s390_arch_random_counter);
-		return true;
-	}
 	return false;
 }
 
-- 
2.25.1

