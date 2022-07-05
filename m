Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D4BCCA47F
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 11:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiGEL11 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 07:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiGEL1Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 07:27:24 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA3815FD6;
        Tue,  5 Jul 2022 04:27:22 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265BJWul013643;
        Tue, 5 Jul 2022 11:27:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7rvSnh6bkxFJVQ4qt/AmHdO9/5L1gOdBv6GhsOXatE4=;
 b=MIJNjQEKum4288F+zyCbYM4id81E7DxpvKxCBI60mz4CmHWlZ0u6VmgNNS9YJx9cVS76
 aqe92982LjsBYoJ019xg+OcRjIinleeOOvA4dudK/KlBvpw6SBMKbxDGicjxi+mshLeo
 2O2lcLxGu/pztuzVEgmpQjjIlVavOsvRPru9aXJqKeMLFvdMaKJa3iH8QgDvtW+Uglrt
 PmdUYUaxJvmQ6nQxfyse7u/4obnTPp2KIWkcax8DyGns1sk0WDMP3EkXdFgF3bFQ1Sq/
 ITBHZdaYj8VMdeJBWPmkj1Rwyed6rOzRdOc6qqPPnI9079DLDAgz2dUqzQOszCACDd2d Ng== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4m3gra9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 11:27:21 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 265BKlAF026294;
        Tue, 5 Jul 2022 11:27:19 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3h2dn92xkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 11:27:19 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 265BQ2i021037360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 11:26:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFCC411C04A;
        Tue,  5 Jul 2022 11:27:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80C0911C04C;
        Tue,  5 Jul 2022 11:27:15 +0000 (GMT)
Received: from ibm.com (unknown [9.171.9.129])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 11:27:15 +0000 (GMT)
From:   Holger Dengler <dengler@linux.ibm.com>
To:     "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Juergen Christ <jchrist@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1 1/1] s390/arch_random: Buffer true random data
Date:   Tue,  5 Jul 2022 13:27:12 +0200
Message-Id: <20220705112712.4433-2-dengler@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220705112712.4433-1-dengler@linux.ibm.com>
References: <20220705112712.4433-1-dengler@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H6Xhb3yG47vLXRxALT9Q42tcc9S6b31e
X-Proofpoint-GUID: H6Xhb3yG47vLXRxALT9Q42tcc9S6b31e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxscore=0 mlxlogscore=942 clxscore=1011 priorityscore=1501 spamscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207050044
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The trng instruction is very expensive and has a constant runtime for
getting 0 to 32 bytes of (conditioned) true random data. Calling trng for
in arch_get_random_seed_long() for each 8 bytes is too time-consuming,
especially if it is called in interrupt context.

This implementation buffers the trng data and deliver parts of it to the
callers. This reduces the costs by factor 4.

Drop the implementation for arch_get_random_seed_int(), because there are
no callers.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
---
 arch/s390/crypto/arch_random.c     | 51 +++++++++++++++++++++++++++++-
 arch/s390/include/asm/archrandom.h | 17 ++++------
 2 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/arch/s390/crypto/arch_random.c b/arch/s390/crypto/arch_random.c
index 1f2d40993c4d..07abd09ec759 100644
--- a/arch/s390/crypto/arch_random.c
+++ b/arch/s390/crypto/arch_random.c
@@ -2,17 +2,66 @@
 /*
  * s390 arch random implementation.
  *
- * Copyright IBM Corp. 2017, 2020
+ * Copyright IBM Corp. 2017, 2022
  * Author(s): Harald Freudenberger
+ *            Holger Dengler <dengler@linux.ibm.com>
+ *
+ * The trng instruction on s390 is very expensive and has a constant runtime
+ * for up to 32 bytes. Each trng call will get 32 bytes of (conditioned) true
+ * random data, which are buffered in a lock-protected array and delivered to
+ * up to four callers. To avoid long running trng calls in the interrupt
+ * context, a refill is skipped there. Also prevent the blocking of callers in
+ * interrupt context by a refill.
  */
 
 #include <linux/kernel.h>
 #include <linux/atomic.h>
 #include <linux/random.h>
+#include <linux/spinlock.h>
 #include <linux/static_key.h>
 #include <asm/cpacf.h>
 
 DEFINE_STATIC_KEY_FALSE(s390_arch_random_available);
 
+static struct {
+	unsigned long data[BITS_TO_LONGS(32 * BITS_PER_BYTE)];
+	int idx;
+} trngbuf;
+static DEFINE_SPINLOCK(trngbuf_lock);
+
 atomic64_t s390_arch_random_counter = ATOMIC64_INIT(0);
 EXPORT_SYMBOL(s390_arch_random_counter);
+
+bool s390_get_random_seed_long(unsigned long *v)
+{
+	unsigned long flags;
+
+	if (in_interrupt()) {
+		if (!spin_trylock_irqsave(&trngbuf_lock, flags))
+			return false;
+	} else {
+		spin_lock_irqsave(&trngbuf_lock, flags);
+	}
+	/* trngbuf is locked */
+
+	if (--trngbuf.idx < 0) {
+		/* buffer empty */
+		if (in_interrupt()) {
+			/* delegate refill to another caller */
+			spin_unlock_irqrestore(&trngbuf_lock, flags);
+			return false;
+		}
+
+		/* refill buffer */
+		cpacf_trng(NULL, 0, (u8 *)trngbuf.data, sizeof(trngbuf.data));
+		trngbuf.idx = ARRAY_SIZE(trngbuf.data) - 1;
+	}
+
+	/* deliver buffered random data */
+	*v = trngbuf.data[trngbuf.idx];
+	spin_unlock_irqrestore(&trngbuf_lock, flags);
+
+	atomic64_add(sizeof(long), &s390_arch_random_counter);
+	return true;
+}
+EXPORT_SYMBOL(s390_get_random_seed_long);
diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
index 2c6e1c6ecbe7..a1e365de6b33 100644
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
@@ -20,6 +20,8 @@
 DECLARE_STATIC_KEY_FALSE(s390_arch_random_available);
 extern atomic64_t s390_arch_random_counter;
 
+bool s390_get_random_seed_long(unsigned long *v);
+
 static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
 	return false;
@@ -32,21 +34,14 @@ static inline bool __must_check arch_get_random_int(unsigned int *v)
 
 static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
-	if (static_branch_likely(&s390_arch_random_available)) {
-		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
-		atomic64_add(sizeof(*v), &s390_arch_random_counter);
-		return true;
-	}
+	if (static_branch_likely(&s390_arch_random_available))
+		return s390_get_random_seed_long(v);
+
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
2.36.1

