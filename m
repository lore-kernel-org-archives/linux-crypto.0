Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793949862;
	b=ZCvJeRBP5j6wmzSbR2CBk7fNxhEtGWqaKs0U1f9SeUxBsCwme5KOz90sN2Oycm+c+CXT
	 ou5LefHdC/+zIT2KudvEWW6D1zTpj7cBB6ahUNZJLmYzA0udjlveh67Dy4X4HuibEMfRK
	 Nck/oL7xi45arQ723XteUMM3rTLGSlasHB1mfyRAE2co6qQpRYSoZAhd1Fs9cCVYakkpB
	 JSg44WLh+7VJxyti9CAAJ9SZ7kFTcOxhRej7ahMifo8mdW0hfUvzr1DHge7HSQGJHGu77
	 XRuptgjzF2q5e+QDl5p/XVvAO/+7AtiYz1atQuZJ1N7FdopH/uRY916UdW7LeP+aybg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793949862;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
	b=fKyjrtk6e0beLw7J8XKroQ+52TecWMdOny1NOVy6tCwvg1NgpjHfivWO51nFzjThWy8H
	 STONX5A+y1oSs5CYa9rEK5H7YQmv8/4DkiI3Dq7ura0Jhn0aAXghB7BMq5x3YsiAAgHbR
	 ja9JSjYyAkrhrUwKqctCyrFJLLV+fTqwvcQeVvomU58kRAtt6BzprQ7yxIeXFsc4HUCqg
	 dHXR+QsnBpS/b135Mp2bhndyNdx/FrFOuQz2z5uFQDMrTVhnB+jHuq4K33DvwxhPZP1zK
	 1zN5FotwrUsukBLMuAFlmDT29uOKuuim3oXMLUppA8hU0kySa7txHODkXL3PAk/M1qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cNJ1ebuo;
	arc=none smtp.remote-ip=74.125.82.51
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE773606D806
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 07:24:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE773606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cNJ1ebuo
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1a2761c69fbso902154c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 23:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949861; x=1794554661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=cNJ1ebuohMEZg1mB2uHM2RP7mOVAcfGmGJe2jbMcDpp0e4ZkN7p36+9BogpS9wEEPH
         qA8c4Gw+DVk9X84mQutFDAtJAET0KZ7L5zhllzDec82OiNyudxhgoo2eWwf3Nmpq6uP5
         Q09nMoxHABH8Yc3hpDQn9jfVAv3/lRF5nBH6bS2/ROpgFANvAvvu+Btf+UWPOvzF0vIF
         G1D0YhtSHpbkHrQLJ3Sz3ozTFk1RAbVOaoVZFgebCW/mWb5/2gganGsbp/5R9Ambkxx8
         0BhL7QS5Vds2zxXi+Civ1nRtekCxmPHdFwVYwEJBurklg+jFw2QnVh+WKc1oZRvcB1Rv
         V6tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949861; x=1794554661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=fiYVd6oGOynUYBkCIa12HJoOMvx/7gByWo6NBqmVMpD8PqnJW76GeodRj67YyKbpBA
         Gep9/2vUNQvIv3tNsLn+YdkfKLGlvLCNSIi4wIAEF3Tgn7neuu9MVm8+QLayeHbgx6uo
         ofWyMdxz57chhldIsc/EdSM/McoApfyFm8RIFtfQ2aFs5itiBvJhXBC48H5DEPH1hlob
         drDLN6f4WDqi0NB5q3sxMHow0hMzpzbZwpmSA25RJXAN3IKQAZMbGO3Tg0ha/xPqpjWN
         r2trynuocoj9r8xUbTPd4FLI63yci7vso8bSMMCI8LeUWS+y86mMoLRl8aM5gVR8JNq2
         h0Ng==
X-Forwarded-Encrypted: i=1; AKwUvBwd/S0mBse6K2IbV1ced58MOzyvxLprKy5HPKfkXABjo9ZgZNlrqtxbr/GYcT7TNwl6qeY4wZEhbY6yNL0=@vger.kernel.org
X-Gm-Message-State: APuU4Z9qo4LOt1pd3lFtlwQpL2YGstqF0wRSwy+hqtfdfHCpCEwTkhVs
	uB4Oxcpd9kRPAhs+P4FP5XilWBGfFL9nqnHDRB12xlFTgcQwK27BpixF
X-Gm-Gg: AYBFou3+7S8Cp4msm0UvgRM5EGmIpnkBGycCFUFPrd+4ssiZKZ4Jg9VoMa3TlNN3+a1
	Yt+KAVk2XxkpQAwo/QgZaQAnC+9YQqAETM7iQcjbCm0rkBFo2thQZXabMCblsm/7FkINSo7B19N
	fYtaqlFnx2YJUlJzz8TIatuuG+MgWQH7JOBIDxyuLgFujdJSVIIJg8K9KtUjVWG/rgfK1uYBCW0
	olP7u3+8GeykC41hsHDrQZHlEs/nZX090eshOO9oyrPfpIBpxK3JhIE5RjjKvGA0mRaceNz2KHb
	iWvBTVPF4HrOP33bBq2XwxPx/8aYGAo4J5R6nMQ0jTetcfbaVVBlL2CfWkIG8a8mFn12/a/55yA
	ESpynhwU9kDH3qNVbvjgWWdJJYHqYlsMGsVblgichzNceAvsa9uOk6TjAgzGiLqH8UWN8ohyKCG
	4kg8Fk4yhnUiWLP3JuEroTa+JakPKtq7YZRsF/GJ4/SCWKt9f5d8/7G4DC6JjLxPHfgWkgLhrHF
	M90em35xZoClHLbk4TRPOJwna6a2JVO+9hKNnBlieop53ukBwo06YEGN0DFV2mScunkGGSMElkO
	BmWVXxpeWOGhe58thMNI1sw+/mGiVDGNybjRdjAa9A==
X-Received: by 2002:a05:7022:ea8c:b0:19b:98bc:326f with SMTP id a92af1059eb24-1b25d31f475mr2175998c88.18.1793949860685;
        Thu, 05 Nov 2026 23:24:20 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:20 -0800 (PST)
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
Subject: [PATCH v3 2/8] crypto: acomp - Add bit to indicate segmentation support.
Date: Thu,  5 Nov 2026 23:24:06 -0800
Message-Id: <20261106072412.7909-3-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
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

