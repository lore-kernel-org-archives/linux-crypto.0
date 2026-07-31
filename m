Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB543C1D77;
	Fri, 31 Jul 2026 08:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487233; cv=none; b=hv3G/f7SUaAwRYGh+nQOwvv7U/Tz+Ae+a0/p4bLqonp5G9q1wu+JOTQbhmYWXe4xY8+uBoJtSPDkhng1xygpd9+IlveGT38RfwClteL0547pESRo3V0aPtOMYMy8dxc1S92ivVSLEZLBsCK2o+Hs6WodGgoa7Ph1PaTifB6NZwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487233; c=relaxed/simple;
	bh=ds44iI28Wc4D66IfcDT8c4FdgbnPw77gSmI1wjKpFiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kLdzsxzeFE74TnMDW5H2FZY3rnATigzkJZPVjULyAWRXKedepmFodNzLx3e7WAFjpu+NFTtfyAMefCcapsQniMTD7tgOms0A3bpwt0m+RdrtT1pIgNQiEAR5FYlv/720n6IyYTZxrpiKnXpEnZojNktx2f5psThcsHelSa1b3lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uAUBq1iF; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uAUBq1iF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r/qGoNIohrY8ij2fwbNJ/9+VeZ6hLMfnsAJ2pWL10YM=; b=uAUBq1iFgqWHEFFMCTFLwNHiRU
	yI4/VNxp4SvmfMJpz3uUiHSCwRPdqDyGDe5eeQmfYjkm//ybxnr4sd1iOpxRRGdXMr702jsahK2id
	R+rCuijl6eRizt6Gk1vvDILFOkKFrjoKaDCbLaDJlu+5yjkn1nXZ+hcvxnpBREpOua5k/163x/ulv
	ne2D67ZtwcJwCB3uRi/tLHgAJKrX9moXMD1fxiybzaOGQZ3UKSy9FMChBZasepC+8q65IgT5jadoR
	7YjEVUR0aC5C/BQp5TBBKdvoaZpY+KHcZCld6lEm6eRXldGuJL9m8WIR86dksZ0/JID4wJ+PrtrG6
	sTdM6GGQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpin5-0000000FUqI-2l2R;
	Fri, 31 Jul 2026 08:40:27 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 11CD83004C9; Fri, 31 Jul 2026 10:40:27 +0200 (CEST)
Date: Fri, 31 Jul 2026 10:40:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 1/4] s390/crypto: Replace cond_resched() with msleep(1)
Message-ID: <20260731084027.GE776954@noisy.programming.kicks-ass.net>
References: <20260730052907.2607026-1-hca@linux.ibm.com>
 <20260730052907.2607026-2-hca@linux.ibm.com>
 <20260730101157.GQ49951@noisy.programming.kicks-ass.net>
 <39570813-27b0-40f9-89c5-8e2dce05e2f0@linux.ibm.com>
 <20260730124819.GA776954@noisy.programming.kicks-ass.net>
 <18c36e42-8f96-479c-8152-2da3f5034f04@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18c36e42-8f96-479c-8152-2da3f5034f04@linux.ibm.com>

On Fri, Jul 31, 2026 at 09:44:57AM +0200, Holger Dengler wrote:

> > Yes, guest migration is very likely far more disruptive than most
> > anything else. Perhaps clarify the code comment to include some of this
> > explanation?
> 
> I agree, the comment is not telling all main key points. What about the
> following?
> 
> /*
>  * Protected key expired due to relocation to another
>  * host. The long runnning re-wrap has no asynchronous
>  * completion notification, so polling is required.
>  * Trigger a re-schedule of this request by returning
>  * -ENOSPC ("hardware queue full") to the crypto engine.
>  * To avoid immediately re-invocation of this callback,
>  * tell scheduler to voluntarily give up the CPU here.
>  */
> 
> (I would leave it up to Heiko to merge the comment in his series, or let
> Harald/me do it in a separate patch)

Right, perhaps something like so, avoiding the endless copy/paste ?

---
diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 8cfe6166c193..973436592318 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -548,16 +548,7 @@ static int ecb_paes_do_one_request(struct crypto_engine *engine, void *areq)
 
 	rc = ecb_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
-		/*
-		 * Protected key expired, conversion is in process.
-		 * Trigger a re-schedule of this request by returning
-		 * -ENOSPC ("hardware queue is full") to the crypto engine.
-		 * To avoid immediately re-invocation of this callback,
-		 * tell the scheduler to voluntarily give up the CPU here.
-		 */
-		cond_resched();
-		pr_debug("rescheduling request\n");
-		return -ENOSPC;
+		return pkey_handle_expired();
 	} else if (rc) {
 		skcipher_walk_done(walk, rc);
 	}
@@ -814,16 +805,7 @@ static int cbc_paes_do_one_request(struct crypto_engine *engine, void *areq)
 
 	rc = cbc_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
-		/*
-		 * Protected key expired, conversion is in process.
-		 * Trigger a re-schedule of this request by returning
-		 * -ENOSPC ("hardware queue is full") to the crypto engine.
-		 * To avoid immediately re-invocation of this callback,
-		 * tell the scheduler to voluntarily give up the CPU here.
-		 */
-		cond_resched();
-		pr_debug("rescheduling request\n");
-		return -ENOSPC;
+		return pkey_handle_expired();
 	} else if (rc) {
 		skcipher_walk_done(walk, rc);
 	}
@@ -1122,16 +1104,7 @@ static int ctr_paes_do_one_request(struct crypto_engine *engine, void *areq)
 
 	rc = ctr_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
-		/*
-		 * Protected key expired, conversion is in process.
-		 * Trigger a re-schedule of this request by returning
-		 * -ENOSPC ("hardware queue is full") to the crypto engine.
-		 * To avoid immediately re-invocation of this callback,
-		 * tell the scheduler to voluntarily give up the CPU here.
-		 */
-		cond_resched();
-		pr_debug("rescheduling request\n");
-		return -ENOSPC;
+		return pkey_handle_expired();
 	} else if (rc) {
 		skcipher_walk_done(walk, rc);
 	}
@@ -1565,16 +1538,7 @@ static int xts_paes_do_one_request(struct crypto_engine *engine, void *areq)
 
 	rc = xts_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
-		/*
-		 * Protected key expired, conversion is in process.
-		 * Trigger a re-schedule of this request by returning
-		 * -ENOSPC ("hardware queue is full") to the crypto engine.
-		 * To avoid immediately re-invocation of this callback,
-		 * tell the scheduler to voluntarily give up the CPU here.
-		 */
-		cond_resched();
-		pr_debug("rescheduling request\n");
-		return -ENOSPC;
+		return pkey_handle_expired();
 	} else if (rc) {
 		skcipher_walk_done(walk, rc);
 	}
diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 03ca33ffe6cc..020a1beb2e22 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -887,16 +887,7 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 	case OP_FINUP:
 		rc = phmac_kmac_update(req, true);
 		if (rc == -EKEYEXPIRED) {
-			/*
-			 * Protected key expired, conversion is in process.
-			 * Trigger a re-schedule of this request by returning
-			 * -ENOSPC ("hardware queue full") to the crypto engine.
-			 * To avoid immediately re-invocation of this callback,
-			 * tell scheduler to voluntarily give up the CPU here.
-			 */
-			pr_debug("rescheduling request\n");
-			cond_resched();
-			return -ENOSPC;
+			return pkey_handle_expired();
 		} else if (rc) {
 			hwh_advance(hwh, rc);
 			goto out;
@@ -907,18 +898,8 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 		fallthrough;
 	case OP_FINAL:
 		rc = phmac_kmac_final(req, true);
-		if (rc == -EKEYEXPIRED) {
-			/*
-			 * Protected key expired, conversion is in process.
-			 * Trigger a re-schedule of this request by returning
-			 * -ENOSPC ("hardware queue full") to the crypto engine.
-			 * To avoid immediately re-invocation of this callback,
-			 * tell scheduler to voluntarily give up the CPU here.
-			 */
-			pr_debug("rescheduling request\n");
-			cond_resched();
-			return -ENOSPC;
-		}
+		if (rc == -EKEYEXPIRED)
+			return pkey_handle_expired();
 		break;
 	default:
 		/* unknown/unsupported/unimplemented asynch op */
diff --git a/arch/s390/include/asm/pkey.h b/arch/s390/include/asm/pkey.h
index 0af5ac4f646b..9c5f31b50bc8 100644
--- a/arch/s390/include/asm/pkey.h
+++ b/arch/s390/include/asm/pkey.h
@@ -13,6 +13,7 @@
 
 #include <linux/ioctl.h>
 #include <linux/types.h>
+#include <linux/delay.h>
 #include <uapi/asm/pkey.h>
 
 /*
@@ -44,4 +45,20 @@ int pkey_key2protkey(const u8 *key, u32 keylen,
  */
 #define PKEY_XFLAG_NOCLEARKEY 0x0002
 
+static inline int pkey_handle_expired(void)
+{
+	/*
+	 * Protected key expired due to relocation to another
+	 * host. The long runnning re-wrap has no asynchronous
+	 * completion notification, so polling is required.
+	 * Trigger a re-schedule of this request by returning
+	 * -ENOSPC ("hardware queue full") to the crypto engine.
+	 * To avoid immediately re-invocation of this callback,
+	 * tell scheduler to voluntarily give up the CPU here.
+	 */
+	msleep(1);
+	pr_debug("rescheduling request\n");
+	return -ENOSPC;
+}
+
 #endif /* _KAPI_PKEY_H */
