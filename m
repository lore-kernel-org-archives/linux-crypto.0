Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BA12C15AB;
	Tue, 30 Jun 2026 08:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782808488; cv=none; b=Uuo2A3EtqpihcGHwIFEk8HUaq2mFhddLaB/inOrKZf7cmX56bh+9bY66RIx/p/os65TUrJdLO9NsZuX12ol+XSZZlle2WFptFTxbVsWr5OuhHOMAxfA/JXaQVYbHPwXRUcEYEnp/EgGzr17J+2n83NSqTJqeD6N6nSrv0DNeqzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782808488; c=relaxed/simple;
	bh=xKDP/+V3jnaiSpuEcD818Sp9Q4KVwjkkPoAHCQlJrnA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tw/9y6CTTBT+fdbOvXvvWRiKbq1SwGixcHOlQmcO3GeMiFvprO/Yvn2sICm4nTme/2v97cWKbsZGy3b50dGjjsVmEd2dZ/d20N+Gq2vs4UokeVjSlvxNbi7P+qOQgGhEkhGbYLhrsP7W7KyCUEo67uGp3uvzvubiIOuq16wMmGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=GRYANt2s; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="GRYANt2s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1782808487; x=1814344487;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x6HnoWCjSlNulaMCuXnLhg8pbxgY0nSAvFotzYJDa44=;
  b=GRYANt2sCx3uSeAd7UeAznrIW51HpBkzwfT0ivKRtTA6OpfI1SZDhfaO
   cG5v8XbeH8WdaHsv8G1OWDQTwHIfn5IR2FYb1iTR01z0iY2jW4QDGwDlS
   wJqUNOOPo1DJBUMfZvMdOguqQ+JA9oDcdHUzYeZikoCj0hkJ+USWW7HQ3
   jFu41eXgMGzhnD1oi6tYBeg5H/UpfW7fnXPwZXCBVxOFA/wb5t4a42IYe
   cd7hnXuD/JCluXZdLNOP7NzVp/QeHRycchfHuAWnzGg5tbOG7rlr2dRfz
   yBRqnkaNuAft1ZBnOdKgYXhY/oA189YN9ZdZW7MAXJ7SY+fw1tCFMEGjo
   A==;
X-CSE-ConnectionGUID: jRkMF5cmQfirAiI3vkE8GA==
X-CSE-MsgGUID: rn+3vEbwSQuwUJMxM8EkSA==
X-IronPort-AV: E=Sophos;i="6.24,233,1774310400"; 
   d="scan'208";a="22751780"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 08:34:42 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:27690]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.142:2525] with esmtp (Farcaster)
 id 67011798-3020-490a-a0d7-2940c15a8805; Tue, 30 Jun 2026 08:34:42 +0000 (UTC)
X-Farcaster-Flow-ID: 67011798-3020-490a-a0d7-2940c15a8805
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 30 Jun 2026 08:34:42 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 30 Jun 2026 08:34:40 +0000
From: Leonid Ravich <lravich@amazon.com>
To: <linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>
CC: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ebiggers@kernel.org>,
	<snitzer@kernel.org>, <mpatocka@redhat.com>, <axboe@kernel.dk>
Subject: [PATCH v5 1/5] crypto: skcipher - add per-request data_unit_size
Date: Tue, 30 Jun 2026 08:34:27 +0000
Message-ID: <20260630083431.2772-2-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630083431.2772-1-lravich@amazon.com>
References: <20260630083431.2772-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWA001.ant.amazon.com (10.13.139.100) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add a data_unit_size field to struct skcipher_request.  When non-zero,
the request covers cryptlen / data_unit_size data units that share one
starting IV; per-unit IVs are derived from the request IV as a wide
data-unit-number counter (the convention also used by blk-crypto for
inline encryption).  cryptlen must be a positive multiple of
data_unit_size.

The field is honoured by an skcipher that understands data units -- an
instance of the dun(...) template (added next), or a driver that handles
a whole multi-DU request natively.  A plain skcipher ignores it, so the
field is inert for every existing caller; the core en/decrypt path is
unchanged.  skcipher_request_set_tfm() and the on-stack request
initialiser reset it to 0 so a reused request defaults to single-DU.

Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 include/crypto/skcipher.h | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 4efe2ca8c4d1..1121be80cb53 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -31,6 +31,13 @@ struct scatterlist;
 /**
  *	struct skcipher_request - Symmetric key cipher request
  *	@cryptlen: Number of bytes to encrypt or decrypt
+ *	@data_unit_size: Size in bytes of each data unit, or 0 for a
+ *		single-data-unit request (the default).  When non-zero,
+ *		must be a multiple of the cipher block size, @cryptlen must
+ *		be a positive multiple of it, and per-DU IVs are derived from
+ *		@iv as a wide counter (the data-unit-number convention); the
+ *		counter width and endianness are chosen by the consumer (e.g.
+ *		the dun() template's second parameter).
  *	@iv: Initialisation Vector
  *	@src: Source SG list
  *	@dst: Destination SG list
@@ -39,6 +46,7 @@ struct scatterlist;
  */
 struct skcipher_request {
 	unsigned int cryptlen;
+	unsigned int data_unit_size;
 
 	u8 *iv;
 
@@ -225,6 +233,7 @@ struct lskcipher_alg {
 	struct skcipher_request *name = \
 		(((struct skcipher_request *)__##name##_desc)->base.tfm = \
 			crypto_sync_skcipher_tfm((_tfm)), \
+		 ((struct skcipher_request *)__##name##_desc)->data_unit_size = 0, \
 		 (void *)__##name##_desc)
 
 /**
@@ -819,6 +828,8 @@ static inline void skcipher_request_set_tfm(struct skcipher_request *req,
 					    struct crypto_skcipher *tfm)
 {
 	req->base.tfm = crypto_skcipher_tfm(tfm);
+	/* Reused requests default to single-data-unit. */
+	req->data_unit_size = 0;
 }
 
 static inline void skcipher_request_set_sync_tfm(struct skcipher_request *req,
@@ -937,5 +948,28 @@ static inline void skcipher_request_set_crypt(
 	req->iv = iv;
 }
 
+/**
+ * skcipher_request_set_data_unit_size() - submit as multiple data units
+ * @req: request handle
+ * @data_unit_size: data-unit size in bytes (a multiple of the cipher block
+ *		    size), or 0 to disable
+ *
+ * Process @req as @cryptlen / @data_unit_size data units sharing one starting
+ * @iv, with per-DU IVs derived by treating @iv as a wide counter (the data-
+ * unit-number convention).  @cryptlen must be a positive multiple of
+ * @data_unit_size.  This is honoured only by a tfm that understands data
+ * units -- an instance of the dun(...) template (which splits the request
+ * into one inner call per unit, with the counter endianness given as its
+ * second parameter), or a driver that consumes a whole multi-DU request
+ * natively, which rejects a request violating these constraints with -EINVAL.
+ * A plain skcipher ignores the field.
+ */
+static inline void
+skcipher_request_set_data_unit_size(struct skcipher_request *req,
+				    unsigned int data_unit_size)
+{
+	req->data_unit_size = data_unit_size;
+}
+
 #endif	/* _CRYPTO_SKCIPHER_H */
 
-- 
2.47.3

