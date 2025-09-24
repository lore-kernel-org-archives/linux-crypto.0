Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2D61EE019
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 06:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758694656; cv=none; b=TXEhYsr7XjS6E54o0+zjMfxtXPiOvBNwKeLoCoRc7dC4dyyLJwrS0BxHg9WjVMFkyNgzbgNRDiPsiZ+qTitOtdeUVrveUZvheZRLzy6SLophgmnQr09DfvFuj7wvbnxFOV4h/QBgMRVznWOPi3NN02NvIwAT6E2OzEvi6r6Qavg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758694656; c=relaxed/simple;
	bh=PckVkjVIHmHqtDvxZzcDiEQw5wOKZpgKyeDyTLIwb9o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iUnIFp8id1vyIrtBHIT2jKxtHuxUd1sQizjxML9FlCxpiLaDN8bdf8BR2pr1wQd3Al6glCC5+IiKCQ2/yxLalWVApzhhzYdpjN+4TfScls2oLiO7zi1VRdZiE4kDtueClTWF6q6HYqhjHB0miCK5pz3mLVlqygrlu5LpWIo0iDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=PkYXkjMN; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PkYXkjMN"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-32326e2f0b3so5525027a91.2
        for <linux-crypto@vger.kernel.org>; Tue, 23 Sep 2025 23:17:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758694653; x=1759299453;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ymWB1hrEQwy+qhGGeeTAshnrOMJoU7hn+WhGD+V50Sw=;
        b=NThE/EXU3h11P6s9yecnv2VLknBE2JgbSvcHaw7md5O+bkVEQOtqALeig3teCf6b0a
         QAZYkzCVNz1xQzBwNTiwZChefmmPdp1LRyi75QvedOopE61XELoOo5BwOf0NflEqHxg2
         pUW+fmbeTGCrFj3GpxY8USoeozj/WsaYcm5xK9zd73bsGnqJCZTXG+Y0T0mdE83ec+YN
         sOISrgGnI85Qyn7QOT60+cbmbYUiGX32pihPMS+X4fHJLZtzuAXFtj6WRzoAmUDxy+cD
         qpRSQ8OUmeWlWPLHmvi1eaJ9muLLYDytwlqW0VjChdsLuQenMXuXin0MSFjcRY41GqTz
         JHMg==
X-Forwarded-Encrypted: i=1; AJvYcCUm8YBSqo+eytdrwnDfKm/3GRUPwH8pXNMVdRmzoXgx/yvWG96+ssGLAJTRvV/KOXwBHIN327udMhdws0s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwD7K1CWCctp7Gw+Djxf+ya2Jii5cl1PP25q6+QTaBU8ryeCoee
	4vkfiFQ+tpm9iH+l3i3sxGcjNGu+Nj59i+hP/c8SiUz1376YoqaWI8bQkbqZ1Xle+xlQe2WiSA8
	uIN6/B7LpJQzctiMzR9Ss+jrklScMCpB6lu9XFMUr5H5zajCjz5y1WgEpzT7HNskTH+sPZdTOI0
	v2vNViPkhmEefnUoQWK5VO9C2bW6XBj73Q32HDjocWEQgZitgHqekyQQhCL1vJD55DODCg4e3xC
	nGAoLAFERt/QUOrS7wM2i5Zzw==
X-Gm-Gg: ASbGncs+pGhQC+NNUByocEdl/oWccCQ3H4ChqUV7ps50deE6lcX+/AZnwPcUzih3T1R
	c/jqqYDJrY1Z2p0t385lJvQcFbezyd7SdrYQUabimmIgvxazVxo7uXdUcJYzitTVko4RzIALb4A
	iyp5O8d192zFvmTk2vQiKtzRkENgr6aW+0IfLQPdhZnl5wNdgIP3O93ihuuG0kh5LeToBV7Ecrp
	jZ3AiwfLhqrL8CjkenRaA2d0dfGpxbEL5qT/KV2SUZ9Xkq9JWMoK8pNLJDjDZ21gwhqBOxbjVdc
	COIamp+1Ewz9klJM3RSDklt+bU8L9rTtnz4M5lcJJcxs+Mm4uROSmjaaw7uMPXMyx4Ds5lRknVV
	ZZPnIV5RA+yCqpIMgtgeGTc8qGqP82SdYvYp/zELIiHQomhQfl/ShmVfiLFaOYgrjm6cMhH6JkJ
	YGPH/O+Q==
X-Google-Smtp-Source: AGHT+IGNa7gR+zh5B0xShlQnTHKTdiMVZkPz6xIHS10yh2I6STmiiSPALFO3Hyc5cCUuy7eX8Uy8vx0TBq1Y
X-Received: by 2002:a17:90b:394a:b0:32f:469:954c with SMTP id 98e67ed59e1d1-332a96fb67fmr5482778a91.34.1758694652998;
        Tue, 23 Sep 2025 23:17:32 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3341bdd7a0esm79561a91.8.2025.09.23.23.17.32
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Sep 2025 23:17:32 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-329cb4c3f78so5591242a91.2
        for <linux-crypto@vger.kernel.org>; Tue, 23 Sep 2025 23:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1758694651; x=1759299451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ymWB1hrEQwy+qhGGeeTAshnrOMJoU7hn+WhGD+V50Sw=;
        b=PkYXkjMNesfU/mxfWVIa/hbHW4oLg7kyyYzpmI0J9nfPQykIxCj/lZYBpugmTGy+f/
         UYgIMKZin9obQnHTGQHtNUAIPz6JATT4qKt2ID0b5c8Vq3Tp8q8FpCUCnBFWLqcJ/E7r
         ZqxTz98W7aBMVibvTMNZGjglH/4/UDwNz1SAQ=
X-Forwarded-Encrypted: i=1; AJvYcCVytsKD0EmVsmMpD2W/2EKn59usu4CSsLuxwXxjTLeRFKcYU3jYj0+m+aVCzdat8aYbrFnI7I4wlc9XLM8=@vger.kernel.org
X-Received: by 2002:a17:90a:d2cf:b0:32b:d8bf:c785 with SMTP id 98e67ed59e1d1-332a95bc6eemr6454710a91.20.1758694651126;
        Tue, 23 Sep 2025 23:17:31 -0700 (PDT)
X-Received: by 2002:a17:90a:d2cf:b0:32b:d8bf:c785 with SMTP id 98e67ed59e1d1-332a95bc6eemr6454689a91.20.1758694650630;
        Tue, 23 Sep 2025 23:17:30 -0700 (PDT)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b5576e90efesm1180580a12.3.2025.09.23.23.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 23:17:29 -0700 (PDT)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	smueller@chronox.de,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: bcm-kernel-feedback-list@broadcom.com,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	tapas.kundu@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	srinidhi.rao@broadcom.com,
	Shivani Agarwal <shivani.agarwal@broadcom.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] crypto: zero initialize memory allocated via sock_kmalloc
Date: Tue, 23 Sep 2025 23:01:48 -0700
Message-Id: <20250924060148.299749-1-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Several crypto user API contexts and requests allocated with
sock_kmalloc() were left uninitialized, relying on callers to
set fields explicitly. This resulted in the use of uninitialized
data in certain error paths or when new fields are added in the
future.

The ACVP patches also contain two user-space interface files:
algif_kpp.c and algif_akcipher.c. These too rely on proper
initialization of their context structures.

A particular issue has been observed with the newly added
'inflight' variable introduced in af_alg_ctx by commit:

  67b164a871af ("crypto: af_alg - Disallow multiple in-flight AIO requests")

Because the context is not memset to zero after allocation,
the inflight variable has contained garbage values. As a result,
af_alg_alloc_areq() has incorrectly returned -EBUSY randomly when
the garbage value was interpreted as true:

  https://github.com/gregkh/linux/blame/master/crypto/af_alg.c#L1209

The check directly tests ctx->inflight without explicitly
comparing against true/false. Since inflight is only ever set to
true or false later, an uninitialized value has triggered
-EBUSY failures. Zero-initializing memory allocated with
sock_kmalloc() ensures inflight and other fields start in a known
state, removing random issues caused by uninitialized data.

Fixes: fe869cdb89c9 ("crypto: algif_hash - User-space interface for hash operations")
Fixes: 5afdfd22e6ba ("crypto: algif_rng - add random number generator support")
Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")
Fixes: 67b164a871af ("crypto: af_alg - Disallow multiple in-flight AIO requests")
Cc: stable@vger.kernel.org
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
---
Changes in v2:
- Dropped algif_skcipher_export changes, The ctx->state will immediately
be overwritten by crypto_skcipher_export.
- No other changes.
---
 crypto/af_alg.c     | 5 ++---
 crypto/algif_hash.c | 3 +--
 crypto/algif_rng.c  | 3 +--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index ca6fdcc6c54a..6c271e55f44d 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1212,15 +1212,14 @@ struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
 	if (unlikely(!areq))
 		return ERR_PTR(-ENOMEM);
 
+	memset(areq, 0, areqlen);
+
 	ctx->inflight = true;
 
 	areq->areqlen = areqlen;
 	areq->sk = sk;
 	areq->first_rsgl.sgl.sgt.sgl = areq->first_rsgl.sgl.sgl;
-	areq->last_rsgl = NULL;
 	INIT_LIST_HEAD(&areq->rsgl_list);
-	areq->tsgl = NULL;
-	areq->tsgl_entries = 0;
 
 	return areq;
 }
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index e3f1a4852737..4d3dfc60a16a 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -416,9 +416,8 @@ static int hash_accept_parent_nokey(void *private, struct sock *sk)
 	if (!ctx)
 		return -ENOMEM;
 
-	ctx->result = NULL;
+	memset(ctx, 0, len);
 	ctx->len = len;
-	ctx->more = false;
 	crypto_init_wait(&ctx->wait);
 
 	ask->private = ctx;
diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 10c41adac3b1..1a86e40c8372 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -248,9 +248,8 @@ static int rng_accept_parent(void *private, struct sock *sk)
 	if (!ctx)
 		return -ENOMEM;
 
+	memset(ctx, 0, len);
 	ctx->len = len;
-	ctx->addtl = NULL;
-	ctx->addtl_len = 0;
 
 	/*
 	 * No seeding done at that point -- if multiple accepts are
-- 
2.40.4

