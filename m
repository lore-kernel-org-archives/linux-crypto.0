Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156717;
	b=lzmyuBevtNiH6cX9t+Tc4H37f3TsSHHjfpbzqbBGqGGJhJYjmn1AE3vTFscr8p+e2Mpf
	 ckH3yOQ5qnt6j13xhCjgv83UiK1lP2Wm18OCE1oHayt7+7KKoARSftMnpkW3zP9n5ghj7
	 rxgfQhM3QL3as618H+aXjRIXPEUHXqKb3Lza9v6UX8naSccfAYQtq2eiCXad/VGhRpPTD
	 2/2khgA8MKa2A9ZTghb3ZBpJ6qvJQx9TpHyiU08lLO9ZkbsDkytVBlKZHU82d/6ssp5dH
	 ubakhiwqDGanU17wLYT0S3RXuFUd1Mjb1XEvOO+tYqVlbbPM7QfXpS3fXFc29RSPrKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156717;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6azg2ZIUW0JXRWtBfLZZ7HNRUXzOL/ZgPLL5NXPpASo=;
	b=lo0tHqPfiUNixhFeFGaqCDvFVWUhesnm1Xk0hL41h9PDj0Nm3onoTBx8bP7WNS/5PX6o
	 e554Vuzbpae20cmWMSwBHCc2QLm6HZDytnaMll+Yu1oChgpeqyiWtAjO4elosw6bDiYG/
	 PUdJ3fAyLnVuCX/uxvL7CDjixLZwuFMnGrzXNg1Tmhm7IIyxm1T9p8Eo6lp6G9A6lDooX
	 yWNsgsYHJszns+wbu3FYjQmdhDnPPiqpwzMVa4BzPbeubZ6jY4p9dRJMJ/DVq8R9iL8fx
	 x1lT4z5a7gQnHiawDDbPljjb+UC9AuhzItLLdpFy0BBsp1CRPWC4A8O2dsRk2rFDsXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sefrKQ8s;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D058606A323
	for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 03:05:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D058606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sefrKQ8s
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-156cbe59622so570273c88.0
        for <linux-crypto@vger.kernel.org>; Tue, 27 Oct 2026 20:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156717; x=1793761517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6azg2ZIUW0JXRWtBfLZZ7HNRUXzOL/ZgPLL5NXPpASo=;
        b=sefrKQ8sKRzJ/P6M/DreAi6oi0wGbc223zvIhQtUpr13/ouBnT8elIwsDFNTTjYu3X
         ew5pi34nH+MGVXQsjqz7SXJ9lQgmerNc2gKTWtzw9RGPDpfq+RnIkrjF6spLSd0yqj+g
         ypThZ9C4xO4Zso8y4Sm7+b0Bq+uoFNOrngFmF/WTCd0Yup83Dk9jFvHUMzIQJcd6EtZs
         669P4jMHOoE6WvXUSpYeFC9nLnVsAElfepx9C2iM6+p6QF8qbWkAVHno1/jD5Zg8P3Vf
         WDRe/ugbgvIPuKr6edaUW6Tng7zBGEGWnMALyDzP2tolkv2ESJyl2UygRTUaI4MKCpAX
         Ni8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156717; x=1793761517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6azg2ZIUW0JXRWtBfLZZ7HNRUXzOL/ZgPLL5NXPpASo=;
        b=LtAI9elFEuMlRifv1CtKP8xroUoXqjj54klRXBvpYfq7J1SYFgePbruWcJKkZlHPL3
         jqa3ld/jW+pJzwIT+OkCGl+809l1d4nWzZj4EkQEaQJ16qd/TLFy0p41UcY5KjVFZGdN
         cjzgejbXhfDaUxRBgRM/ySWdRADT81REJ3zjpLUNtSzCOMDQxDW5awcfDcA/LAuW8g+h
         btSEoNQqOGEkh8NM8MRBZB5pMTUju4+Kb9sirvEbl2uIK0Z/xkk9fdPWpX3xX8bA8xAD
         vJE7b1wB98g3U9OLZVMst50bfiPj408gffrfatzYZSreydkueClkd1HSOwqKgcyVgEp3
         DHhg==
X-Forwarded-Encrypted: i=1; AKwUvByM4VakhSRpTWM8zzrEInA+CGNeVB1G+A0AxUYy0iAWg+8AVhak2wjVsbPtRqlLoiTg/2el9oTSYp35/lo=@vger.kernel.org
X-Gm-Message-State: AFq9FYIRK1GLYzjz/h5vTS0/U64x1JdKXEHiuAuzvcaMCm2fzlyf4tDC
	nhTMVYxCvwJU5tzIa8msGPnTe7g01f6yCbKKEKsR2mezlMCZywGM6fNj
X-Gm-Gg: AYBFou1ePDTA7oIc2ylvq9mU7MsJB8Q4c/HTO9+pp9HOrcnBoP3I/qfPQt0ZL1dmof0
	BP2QsQuWrFozSwMARhTM10ue17xr5A875RPk4D8RsZxqalf+TgJRhw17S5TenZuTfYCLyDF3IE3
	Xv2wDfLr6sXnWPflIip2npRya1fS5EMHyttKcw0kV3eUjmtsKbkvYqONgpIRapMNAvctmMTvcmS
	Zd9pgOoZm3tUdkpyF/yHYlZaiTnto6DfsM9j0FIJfohxHVpGE8Nf/fP+JY8eTCnK1QOAX7Da/5U
	29qOMqwwdEjp32ZHOu23mRSliV6NW766amUAkurRTJWzhcc7XAKWwf9Sj0q04J/D+DCnRaPGm5N
	nOy+TXsxQkwZZ7hEOTW0w3RpxSAUS+eYbNRBWIysdn+pi/Q68r38zWvMvcUXchBqDLitSj35bxh
	LKEKWBIkanqPFVFfPMr8/RIhwg4oirm83/vZbucQnREIH97nwyKweP06d+2swuRl2qalvucy1vU
	8wMgm0mkfoXX4IZcgUw2JzL46h673dfyyCHAZjOvB0Jo9CkYN8fGfkGL1Eu6d5/qJ71pXn5+inj
	vMH+JCNuWd8VZYsiwtBUM8nRgZEbTbFEbN7TKWGKjQ==
X-Received: by 2002:a05:7022:6989:b0:183:7d42:cfb5 with SMTP id a92af1059eb24-1a6cfa0c476mr1988744c88.19.1793156716397;
        Tue, 27 Oct 2026 20:05:16 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:15 -0700 (PDT)
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
Subject: [PATCH v2 4/8] crypto: acomp - Add API to get a compression algorithm's batch-size.
Date: Tue, 27 Oct 2026 20:04:59 -0700
Message-Id: <20261028030503.17923-5-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
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

This commit adds a @batch_size data member to struct acomp_alg.

An acomp_alg compression algorithm that supports batching of
compressions and decompressions must provide a @batch_size greater
than 1, representing the maximum batch-size that the compressor
supports, so that kernel users of crypto_acomp, such as zswap, can
allocate resources for submitting multiple compress/decompress jobs that
can be batched, and invoke batching of [de]compressions.

The new crypto_acomp_batch_size() API queries the crypto_acomp's
acomp_alg for the batch-size. If the acomp_alg has registered a
@batch_size greater than 1, this is returned. If not, a default of "1"
is returned.

zswap can invoke crypto_acomp_batch_size() to query the maximum number
of requests that can be batch [de]compressed. Based on this, zswap
can use the minimum of any zswap-specific upper limits for batch-size
and the compressor's max @batch_size, to allocate batching resources.

This enables zswap to compress/decompress multiple pages as a batch
to improve swapout/swapin performance and memory savings.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 crypto/acompress.c                  | 14 ++++++++++++++
 include/crypto/acompress.h          | 12 ++++++++++++
 include/crypto/internal/acompress.h |  3 +++
 3 files changed, 29 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index c55b0e8eff3d..8e285cb7477e 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -326,6 +326,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
 
+unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
+{
+	if (acomp_is_async(tfm) &&
+		(crypto_comp_alg_common(tfm)->base.cra_flags & CRYPTO_ALG_TYPE_ACOMPRESS)) {
+		struct acomp_alg *alg = crypto_acomp_alg(tfm);
+
+		if (alg && alg->batch_size > 1)
+			return alg->batch_size;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(crypto_acomp_batch_size);
+
 void comp_prepare_alg(struct comp_alg_common *alg)
 {
 	struct crypto_alg *base = &alg->base;
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index e64cf422510b..a71532ccb8dc 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -593,6 +593,18 @@ int crypto_acomp_compress(struct acomp_req *req);
  */
 int crypto_acomp_decompress(struct acomp_req *req);
 
+/**
+ * crypto_acomp_batch_size() -- Get the algorithm's batch size
+ *
+ * Function returns the algorithm's batch size for batching operations
+ *
+ * @tfm:	ACOMPRESS tfm handle allocated with crypto_alloc_acomp()
+ *
+ * Return:	@tfm's acomp_alg's @batch_size, if it has defined a
+ *		@batch_size greater than 1; else return 1.
+ */
+unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm);
+
 static inline struct acomp_req *acomp_request_on_stack_init(
 	char *buf, struct crypto_acomp *tfm)
 {
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 0c0d3fc8a9fc..2d4d302d1b3f 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -28,6 +28,8 @@
  *
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @batch_size:	Maximum batch-size for batching compress/decompress
+ *		operations.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -47,6 +49,7 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int batch_size;
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
 
-- 
2.39.5

