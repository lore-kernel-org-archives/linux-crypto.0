Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792994153;
	b=Ei3SwNNBTBdIDcIRnkJEtjwuYT08t7Sp1HMGY9ZAjJBYUYJC8Vi29cluzb2fMhyiIdZV
	 fKYvNNEOFomT2Ft8sfckspLUKG4kutvKZdHXUio9Oli2KThEb83RApuwhqXZNoPzt7p1X
	 4s3RAhMuBxz98yhYlKPwkk2ZFryChg3G3eq9bUyPZv/HR5yMQQTKqd+VfdKo594bgxafK
	 TfbmlHjFiwU5/UzUbexRTlyKMMkmsdhZKCyBrwO6OXI9/lEqE4nZzG6qYNjeMz6C4MQbz
	 m7we9hcHLFGhUOIMscZBiEce88X/MPBcjskFAfM7ZU7kh8mK8gfCP0qaKDW8tEyx1XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792994153;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=J99lBD4evd9jf6O7lEpj1LdKQ7rC6JRoejeQMN2sZ2Q=;
	b=fVIyB0r5zcS5KlRTs4wXGLJoVTKHxR6fntfLaQlyjMj1S3OIZC4xaybwRmNBa39UM4rk
	 KwRIT+N2w9phVOTJb3I1jvVa47J4gH6smDOIf35vkiLV6nstxIb6Gdm5lxmpm+s8z/XQB
	 axuTq443o/Fr5ThFzvmHN+GKGXWdhaynLxFMIj3IS753qheH9l6zdh7dLEflVlhdywuY1
	 v5iTd0eJ62UDarB87Nt6hU1oDjhPXSj+m1hRoCoBKmxUf+0klXZd20n3cuGq3z+jEW3L9
	 p3fLH7OASVxAbxKpr2+PtIlNTe3hcFGimKcrahJ7KTXbh3QVYvv92Ft8QeGsGZobS/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b="f/dUaDfh";
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AEC606A31B;
	Mon, 26 Oct 2026 05:55:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10AEC606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=f/dUaDfh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=J99lBD4evd9jf6O7lEpj1LdKQ7rC6JRoejeQMN2sZ2Q=; 
	b=f/dUaDfhaW7MzRMf6zykxlB2hNjPmv0qM08auruz6ggBSXDBPUx/KZQlWdjgMNJXyPuHUKqpBzu
	7wtf+myRq/GHkHSD86J56Fb+4+VsLXzqb0pEAHyGn7a0cFMbowjdksVuRBuw+Np4z456UWojxaItT
	eL3n7RGfEBSA1WsxStKyaJtQWp0E0/Axna5SYXNWkikGCbhII4twIVXJOWWJCDtPmZ9cutLpb275g
	xHf55cDVntcgxBaa6+n+hPItHUtJCxgM1M+BtdJbH75KnFebgkg5ITzuyHq5ESb7ggmSWNX8F3Xaq
	1OLxIHBUd2ghk4bx6b2yLROepPn0mH1m3aDg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xLDgN-00000007YXz-2KIw;
	Mon, 26 Oct 2026 13:55:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 Oct 2026 13:55:43 +0800
Date: Mon, 26 Oct 2026 13:55:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Hadar Gat <hadar.gat@arm.com>, Olivia Mackall <olivia@selenic.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: cctrng - Lock read and writer of circular buffer
Message-ID: <at7rX1rkRAzHYwCB@gondor.apana.org.au>
References: <20261015103933.337335-2-blum@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015103933.337335-2-blum@kernel.org>

On Thu, Oct 15, 2026 at 12:39:34PM +0200, Thorsten Blum wrote:
> cctrng_read() copies random data in two steps when a read wraps around
> the end of the circular buffer.
> 
> Use the correct destination offset for the second copy instead of
> overwriting the start of the destination buffer.
> 
> Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/cctrng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Sashiko complained about the lack of memory barries in the circular
buffer code.  This is taking a spinlock on the read-path, so it might
as well do it for both reading and writing.

I've also changed it to a mutex and added support for the wait flag.

---8<---
The circular buffer handling in cctrng is buggy as it doesn't use
any synchronisation mechanism between the reader and the writer.

As this isn't performance-critical, simply change it to use a mutex
that covers both reading and writing.

While adding an inclusion for linux/err.h and linux/mutex.h, also
sort the headers alphabetically to avoid potential duplicates.

Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 03401ee59a8e..ef49e0195ee9 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -1,21 +1,23 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (C) 2019-2020 ARM Limited or its affiliates. */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/bitfield.h>
+#include <linux/circ_buf.h>
 #include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/err.h>
+#include <linux/fips.h>
+#include <linux/kernel.h>
 #include <linux/hw_random.h>
+#include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/irqreturn.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
-#include <linux/interrupt.h>
-#include <linux/irqreturn.h>
 #include <linux/workqueue.h>
-#include <linux/circ_buf.h>
-#include <linux/completion.h>
-#include <linux/of.h>
-#include <linux/bitfield.h>
-#include <linux/fips.h>
 
 #include "cctrng.h"
 
@@ -68,8 +70,8 @@ struct cctrng_drvdata {
 	/* pending_hw - 1 when HW is pending, 0 when it is idle */
 	atomic_t pending_hw;
 
-	/* protects against multiple concurrent consumers of data_buf */
-	spinlock_t read_lock;
+	/* protects data_buf */
+	struct mutex lock;
 };
 
 
@@ -213,11 +215,8 @@ static int cctrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 	size_t size;
 	size_t left;
 
-	if (!spin_trylock(&drvdata->read_lock)) {
-		/* concurrent consumers from data_buf cannot be served */
-		dev_dbg_ratelimited(dev, "unable to hold lock\n");
-		return 0;
-	}
+	if (mutex_lock_interruptible(&drvdata->lock))
+		return -ERESTARTSYS;
 
 	/* copy till end of data buffer (without wrap back) */
 	cnt_w = CIRC_CNT_TO_END(drvdata->circ.head,
@@ -237,7 +236,7 @@ static int cctrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 		circ_idx_inc(&drvdata->circ.tail, size);
 	}
 
-	spin_unlock(&drvdata->read_lock);
+	mutex_unlock(&drvdata->lock);
 
 	if (circ_buf_space(drvdata) >= CC_TRNG_EHR_IN_WORDS) {
 		if (atomic_cmpxchg(&drvdata->pending_hw, 0, 1) == 0) {
@@ -347,6 +346,7 @@ static void cc_trng_compwork_handler(struct work_struct *w)
 	}
 
 	/* read EHR data from registers */
+	mutex_lock(&drvdata->lock);
 	for (i = 0; i < CC_TRNG_EHR_IN_WORDS; i++) {
 		/* calc word ptr in data_buf */
 		u32 *buf = (u32 *)drvdata->circ.buf;
@@ -358,6 +358,7 @@ static void cc_trng_compwork_handler(struct work_struct *w)
 		 * returned, restart the entropy collection.
 		 */
 		if (buf[drvdata->circ.head] == 0) {
+			mutex_unlock(&drvdata->lock);
 			dev_dbg(dev, "Got 0 value in EHR. active_rosc %u\n",
 				drvdata->active_rosc);
 			goto next_rosc;
@@ -365,6 +366,7 @@ static void cc_trng_compwork_handler(struct work_struct *w)
 
 		circ_idx_inc(&drvdata->circ.head, 1<<2);
 	}
+	mutex_unlock(&drvdata->lock);
 
 	atomic_set(&drvdata->pending_hw, 0);
 
@@ -499,7 +501,7 @@ static int cctrng_probe(struct platform_device *pdev)
 
 	INIT_WORK(&drvdata->compwork, cc_trng_compwork_handler);
 	INIT_WORK(&drvdata->startwork, cc_trng_startwork_handler);
-	spin_lock_init(&drvdata->read_lock);
+	mutex_init(&drvdata->lock);
 
 	/* register the driver isr function */
 	rc = devm_request_irq(dev, irq, cc_isr, IRQF_SHARED, "cctrng", drvdata);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
