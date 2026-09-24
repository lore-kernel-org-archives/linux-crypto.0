Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5A03D0BED;
	Thu, 24 Sep 2026 07:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790236739; cv=none; b=tcuyWNTtXlyqDK5XRhi+FwmM8RR4hGh3vP4JFsuI7lwL2LaVhIV3hxXoWXVXm/LbL3jySJdVaiQIVezFCQZhgmBqJ/TctYEhsIqajw0ziUazf2VWND+0TDyWxaAww6CWgqOVCZ5nj0uRSw7vXwPh+H7afNVUkVMUTmne0qWhlLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790236739; c=relaxed/simple;
	bh=uRLD90ofwdcRaXkT7+31WCE21OuL6RWJmucs1E7Ny7c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ik7vB1wUbthSmyc2ja+tgm7o1fazPRKAZJsu9dBBw3ZXT5WbnMD0Sh6rENTQjqqWRWQ7QibOwkYSOnf3p0QMxv420zgYnNHX4j1TJwJGCwimnwWsljHZiQlcHCehCANIU+JS4gnzXuhI/LVLpViVhA3Z4j0R+ZNf8wgeMPkmmF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=lfADdIiM; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="lfADdIiM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790236738; x=1821772738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xR6D4Fpn8Lfnsy+EDTn4FQrP1m5sYBEibA/5npG+Mc8=;
  b=lfADdIiMGXYwqaPGylVgHju07jHXSR+jfJsusSwmclF/9MPidutCLMSt
   OalhVkRRbYKQ9ViRKzY/UqXWMp2CBoOuGaXmlcvVWpx7t1vA+HGdc34ct
   bUmupoeB2adpn03T+vvO9PzRb7QdD72V9u4y+vWKPqCYJDlKK1zybGavg
   ZS9T8FwLz7Zb5+bh8KxiborLxgtt603YLNRaLtM8K1jT54ZOIzxQ3y5WA
   uCr6s1BkMg1o6Bh91dOmETn2bT4CrClaLCtvaX+CHm81HYV/df5asi0jw
   Tn+ILOBRKd2CiSm8xKjyKDIScNfoKlSIc4QjP1YiwIXlfQfaNrpHioGOH
   A==;
X-CSE-ConnectionGUID: 3RL2gkWdRcCNEBEcKXg8rQ==
X-CSE-MsgGUID: kVIwJgbDTQu99lBcCPEs2A==
X-IronPort-AV: E=Sophos;i="6.27,120,1787011200"; 
   d="scan'208";a="29512013"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 07:58:55 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:3528]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.27:2525] with esmtp (Farcaster)
 id 33ce8e2e-4efa-4114-afe2-7bbf48d6b324; Thu, 24 Sep 2026 07:58:55 +0000 (UTC)
X-Farcaster-Flow-ID: 33ce8e2e-4efa-4114-afe2-7bbf48d6b324
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 07:58:55 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 07:58:53 +0000
From: Leonid Ravich <lravich@amazon.com>
To: <linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ebiggers@kernel.org>, <agk@redhat.com>, <snitzer@kernel.org>,
	<mpatocka@redhat.com>, <bmarzins@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 1/6] crypto: skcipher - add per-request unit_size
Date: Thu, 24 Sep 2026 07:58:41 +0000
Message-ID: <20260924075846.28203-2-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260924075846.28203-1-lravich@amazon.com>
References: <20260924075846.28203-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D040UWB002.ant.amazon.com (10.13.138.89) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add a unit_size field to struct skcipher_request, mirroring the acomp
unit_size (and its setter), so a caller can submit several data units
in one request: cryptlen / unit_size units sharing one starting IV,
with per-unit IVs derived from the IV as a 64-bit little-endian
data-unit-number counter held in its low 8 bytes.

unit_size == 0 (the default) means a normal single-unit request;
skcipher_request_set_tfm() and the on-stack request initializer zero
the field, so existing callers and reused requests are unaffected.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 include/crypto/skcipher.h | 46 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 4efe2ca8c4d1..2d7805409140 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -31,6 +31,17 @@ struct scatterlist;
 /**
  *	struct skcipher_request - Symmetric key cipher request
  *	@cryptlen: Number of bytes to encrypt or decrypt
+ *	@unit_size: Size in bytes of each data unit, or 0 for a
+ *		single-unit request (the default).  When non-zero, must be a
+ *		multiple of the cipher block size and @cryptlen must be a
+ *		positive multiple of it.  The data-unit number is a 64-bit
+ *		little-endian counter in the low 8 bytes of @iv, incremented
+ *		once per unit and wrapping at 2^64; the remaining IV bytes are
+ *		left unchanged (any other on-disk IV layout is produced by a
+ *		template wrapping the algorithm).  @iv itself is not modified
+ *		by the request.  An algorithm that advertises
+ *		CRYPTO_ALG_REQ_SEG handles the whole request natively and must
+ *		follow this same counter and @iv-preservation convention.
  *	@iv: Initialisation Vector
  *	@src: Source SG list
  *	@dst: Destination SG list
@@ -39,6 +50,7 @@ struct scatterlist;
  */
 struct skcipher_request {
 	unsigned int cryptlen;
+	unsigned int unit_size;
 
 	u8 *iv;
 
@@ -225,6 +237,7 @@ struct lskcipher_alg {
 	struct skcipher_request *name = \
 		(((struct skcipher_request *)__##name##_desc)->base.tfm = \
 			crypto_sync_skcipher_tfm((_tfm)), \
+		 ((struct skcipher_request *)__##name##_desc)->unit_size = 0, \
 		 (void *)__##name##_desc)
 
 /**
@@ -819,6 +832,8 @@ static inline void skcipher_request_set_tfm(struct skcipher_request *req,
 					    struct crypto_skcipher *tfm)
 {
 	req->base.tfm = crypto_skcipher_tfm(tfm);
+	/* New tfm, new request: default to single-unit. */
+	req->unit_size = 0;
 }
 
 static inline void skcipher_request_set_sync_tfm(struct skcipher_request *req,
@@ -908,6 +923,10 @@ static inline void skcipher_request_set_callback(struct skcipher_request *req,
 	req->base.complete = compl;
 	req->base.data = data;
 	req->base.flags = flags;
+	/* Reset the per-op multi-unit control; a reused request defaults to
+	 * single-unit until skcipher_request_set_unit_size() opts back in.
+	 */
+	req->unit_size = 0;
 }
 
 /**
@@ -937,5 +956,32 @@ static inline void skcipher_request_set_crypt(
 	req->iv = iv;
 }
 
+/**
+ * skcipher_request_set_unit_size() - submit as multiple data units
+ * @req: request handle
+ * @unit_size: unit size in bytes (a multiple of the cipher block size),
+ *	       or 0 to disable
+ *
+ * Process @req as @cryptlen / @unit_size data units sharing one starting
+ * @iv, with per-unit IVs derived by treating @iv as a wide counter (the
+ * data-unit-number convention).  @cryptlen must be a positive multiple of
+ * @unit_size.  If the algorithm does not handle multiple units natively,
+ * the API transparently splits the request into one call per unit; that
+ * split additionally requires an ivsize that is a non-zero multiple of 8
+ * and at most 32 bytes, and rejects a violating request with -EINVAL.  An
+ * algorithm advertising CRYPTO_ALG_REQ_SEG receives the whole request and
+ * enforces its own constraints.
+ *
+ * This function must be called after skcipher_request_set_tfm() and
+ * skcipher_request_set_callback(), both of which reset @req->unit_size
+ * to 0.
+ */
+static inline void
+skcipher_request_set_unit_size(struct skcipher_request *req,
+			       unsigned int unit_size)
+{
+	req->unit_size = unit_size;
+}
+
 #endif	/* _CRYPTO_SKCIPHER_H */
 
-- 
2.47.3

