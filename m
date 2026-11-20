Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795148360;
	b=0QXdiMC+m2Pdr5Mx5Qq0EfvJPo/WFlHi8vZbH2qxDKdQUQSFgdaMQUTlFFqR1LDNztL4
	 m2CbSjHgVF7ONY3iMhDngwdooRP04FEgx01xedU6Jt3i1ZMACUN8fmKXeFEIG0qwJQ7Y1
	 6UnqMOpPCEDKkMoT+IVSHTH05PtQKtF0vZtF3Xs8nQb7Qy4f4Tmhyk6GvKb48NGeATFP2
	 ixGpZxpanVxVDGDD9JmWkn276rEF+A7c2pBvTs1UffmexifPqA3dhfXJtO5sOZLSIl+O2
	 o+QP2KuRTimjELThYwFznwSwZ5W7PnRw6Dk2MeLbJD9DBnHyoI/dbAQOFjhR5JQnCrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795148360;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
	b=hiHlmfk12nOyPLOVOxSMx5vc2YGY3q8UUIrW7z1OlaxpnpxYQVYv2IK4UeCbjsFXBNLN
	 kpK/Vkcw7fo8e2ePoJdgro1vGm7CL+1607Zjhex3oC1t3CJZ16kFaG14xbntMqPjCah/8
	 jx/ixlnb+L/2J2eNFnyJ31xRkA/ghXtPyWcNiJ9S/w89GtBJgDs9nJAKbnE6H0SY50gzq
	 hGvlxFfbVEkb+t2u5ZRMRqWguUDujtxY34BmRbpV3Gb05L7GpSqIrkUJCsbZL9EM+B+Nd
	 IOBtIIVUajntWIr2w4FKSxaw+B11mnc1pbTCYopTSOtkjYkdCWeXjFt/5oOK3BC6O1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uNegSPzX;
	arc=none smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B4960A2607
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 04:19:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61B4960A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uNegSPzX
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1a8cc11ac42so676970c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2026 20:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148359; x=1795753159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=uNegSPzXnDVSp6U+PQgVpDwSdYRu4V/jg1FcRakX55BuZjFeTj6bX4kZLWOULCnxiL
         g4d9XJX2Ddj+8qpJfeT3dZxokf647N/G7Z8COkeh4peFUYmeLby9cLzRn0YTt6GU3ZCe
         2/5q6ME9OKXglnxHTvjqC9beGaVVlJP0E7x6dd1M9Xqwz0C4/QbbLeLZQ7BhYtzcKbDn
         V+tQ8fk2e1mGtB290AQn8rdPCBQJvUJDmVMWpRJadi4OrNd1FYyoekSQ3MaG/mRjUA/J
         8stXY7zdQ/S1c6P6jgGV9OhWRXXTf4i8SVbySX43Ab9sdNakt2DuCB1aHIpQBHSojL4L
         sRLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148359; x=1795753159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=r7gSGb+jrT+q9AtZp8W5uEgu/WD1O7AwBBrbDYqnEsCtqPAb2F8ZPsrJbWwpcemuMv
         qkbDMEeG2b7BQtDB0km4mzxF+zQ4uVlLjdcz3k6FEZSs6+d3hTFpSu90NTjzlkKDpK2b
         IdIFMkm+rZBps6Svajp0tOWWD7jGADzt7aInWvtb6TbpcpCCck6CJ+UlaG1lvA5ZFPWD
         EV42KWspTZQ42JZgBVEY4YrHwgL6tC+Hkc8RMgtXFtiQbzvB91LmtrKsEdyO8pkGUw5b
         vjAVefi7NySEoMkBAk1HvKVRl1guFP/x001j2c2IpEzOAYVX2+SNfFfKz8nxJ08TIphX
         7siw==
X-Forwarded-Encrypted: i=1; AL+hErEVKWV038C2pLB0xt3aenpKzEm44cDomVMXtq6OIS4TmKYrmNrrwhRw8+36TKxLaYncUZhI8nHa6p1IFOM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+Uz+teHuHVzIMS/X0Fom5fiJ6aoyN5lGBHzVn1t35p9GV5P2kn
	Y8HYzOVVdihmxeeSQuLzQdFM/DYDXhg/7GYRMwjJETMnQPtgsWXmsoUz
X-Gm-Gg: AYBFou26saERu0lbO+NLNvAMGUsAM31oRafbcle1ulhJHdVWury0Cz2fmGWBvsCYTWI
	2OQisedEBhYTo6aJajcXBtlhxOlfiXvSoLWErngUWRG2wCsLewxHNkWyiPaqf2xjMtwMLWtSJSQ
	ogauu0ki3uJk2t918AZSE8pAU4h2fHdktjvFtWPU71dNz6oWBeRdELMyumbuZGZIXw3ys0FE5az
	fAReWvttOIGKB01gcsbChqX50VdESZelradmcev9hy9Exe3T7atCXQewKYta+uYlxQPRyruo8wZ
	7TAOLLcVQJOitPjD6/mnOZcgYEjc1w7rfp8UFvneeomkD3Nh5GmgIxwI0DZk3FX5OoVKQRwrwmI
	WM9L+IOzEpZjHhGKU6m31NbVSj7tWUjj1+9w59QNOJoYNVfV4z0AeSUBe4kRQL1R+ROFS+3CHt3
	sJ/kmUfFlj/9gtLUOpoKhbFHd2Tf8zcqyAODT2E3uihwRDEJTz1LgJTOhsy1dqeF6fBbbI2ybi+
	1LewLh8hpaE+QsRUgjkrgtUg4bjcQ/pM2D3B0GnlyilIgriMuJPbjNU7/Zm5ddP2wIlRfil8oCJ
	CVOyEzA5BeHAlpDibdSctsAp+oK1FsNsGj1gTPZHjw==
X-Received: by 2002:a05:7023:a8b:b0:1b0:430d:d81c with SMTP id a92af1059eb24-1b5568feb77mr1636832c88.25.1795148359482;
        Thu, 19 Nov 2026 20:19:19 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:18 -0800 (PST)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v4 2/8] crypto: acomp - Add bit to indicate segmentation support.
Date: Thu, 19 Nov 2026 20:19:00 -0800
Message-Id: <20261120041906.5785-3-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds segmentation support for compression.

Add a bit to the crypto_alg flags to indicate support for segmentation.
Also add a helper for acomp to test whether a given tfm supports
segmentation.

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 include/crypto/algapi.h             | 5 +++++
 include/crypto/internal/acompress.h | 5 +++++
 include/linux/crypto.h              | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 05deea9dac5e..7d406cfe5751 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -280,6 +280,11 @@ static inline bool crypto_tfm_req_virt(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_VIRT;
 }
 
+static inline bool crypto_tfm_req_seg(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_SEG;
+}
+
 static inline u32 crypto_request_flags(struct crypto_async_request *req)
 {
 	return req->flags & ~CRYPTO_TFM_REQ_ON_STACK;
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 9cd37df32dc4..93ae59623f13 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -189,6 +189,11 @@ static inline bool crypto_acomp_req_virt(struct crypto_acomp *tfm)
 	return crypto_tfm_req_virt(&tfm->base);
 }
 
+static inline bool crypto_acomp_req_seg(struct crypto_acomp *tfm)
+{
+	return crypto_tfm_req_seg(&tfm->base);
+}
+
 void crypto_acomp_free_streams(struct crypto_acomp_streams *s);
 int crypto_acomp_alloc_streams(struct crypto_acomp_streams *s);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b7c97f1c47c9..78c699ac3f82 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -139,6 +139,9 @@
 /* Set if the algorithm cannot have a fallback (e.g., phmac). */
 #define CRYPTO_ALG_NO_FALLBACK		0x00080000
 
+/* Set if the algorithm supports segmentation. */
+#define CRYPTO_ALG_REQ_SEG		0x00100000
+
 /* The high bits 0xff000000 are reserved for type-specific flags. */
 
 /*
-- 
2.39.5

