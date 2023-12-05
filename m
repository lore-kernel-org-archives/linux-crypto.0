Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="PPBdSIMs"
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89327181
	for <linux-crypto@vger.kernel.org>; Tue,  5 Dec 2023 01:28:29 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id 5614622812f47-3b2e330033fso3072445b6e.3
        for <linux-crypto@vger.kernel.org>; Tue, 05 Dec 2023 01:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701768508; x=1702373308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I9NcydlPjJuZdBvk47SliSWRPXO51iH+ClRWgIXdngI=;
        b=PPBdSIMsiEiHJtO9YF1DSrwoPWPWwDY0lsXcg4j+Y51g526eF34dm5awrHZ23cMmZf
         OpRi+1KVrTZp3F+UsdMKOHsRsfxIzegbcoODaiDj6vbg0Yd+UqhOTOIeVYD6MfHEZH/p
         G59V4KhcWb2H4Zf5DLhHzcRc84wIgXFwJ+rAwJ4LzRw42gDkV1fzbbKNqXIS4jNZqtxe
         +cB33zA05jv1vvEAjtKFaPl/MzDy6bShulOXkmaPyEDG6mXkerKAdW6lECPueppU+blh
         vxf/vuecRsGO6qiMVMFaUMLT9t9nMHuw/P1FoFwfafAfx532BBB/CCWqQr5ujiwDbjTk
         Vqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701768508; x=1702373308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I9NcydlPjJuZdBvk47SliSWRPXO51iH+ClRWgIXdngI=;
        b=V6SdiVoaEDSP+my/sW1tgRiwDtDkp29/HBS99nngYj0s0fTGWOXCcvRS90AMGPv3Ik
         1tbjFlWyRvTiCHt3sCGsyKbwlGL6v5wiCRDqkv/7XRHv9j4I/7aIQbbGju9pUwDB2eFm
         d7F4/SIDgJhc0Mw+8Q1UbYyuXwLP3L7P+C13IwTVPrHhvTRedA040wN57xVUVjb4Aa0i
         x13eJupZmRfzQeN0VRGeMj1CdFsK9EHLcdNW4z5L6km3JXfTxbuQt8O69Lu2WBU9gvUU
         wIHV/fmQUVbx3h4oVnTPPWcIttd231iBMJizzPkJ53ugJFNYozcnwQYUyEMbfOJpcrhW
         4cIQ==
X-Gm-Message-State: AOJu0Yw+hCU2ejWIOwZQnFP3/PGDAAO2Se2a8ha6TjJ4b1O8UhMdPJnQ
	vJqvbSHFCxeth5Jw5G965NHrhw==
X-Google-Smtp-Source: AGHT+IHZ3EK+AWz07LHe5BsDXoplI+8JX1FVHrlgMUB8wBmoWXqufxaT2Ka9FS50Dim4x8aDAfAYQQ==
X-Received: by 2002:a05:6808:16a7:b0:3b8:44dc:7ce0 with SMTP id bb39-20020a05680816a700b003b844dc7ce0mr7330943oib.2.1701768508622;
        Tue, 05 Dec 2023 01:28:28 -0800 (PST)
Received: from localhost.localdomain ([101.10.93.135])
        by smtp.gmail.com with ESMTPSA id l6-20020a056a00140600b006cdd723bb6fsm8858788pfu.115.2023.12.05.01.28.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Dec 2023 01:28:28 -0800 (PST)
From: Jerry Shih <jerry.shih@sifive.com>
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	conor.dooley@microchip.com,
	ebiggers@kernel.org,
	ardb@kernel.org,
	conor@kernel.org
Cc: heiko@sntech.de,
	phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v3 05/12] crypto: simd - Update `walksize` in simd skcipher
Date: Tue,  5 Dec 2023 17:27:54 +0800
Message-Id: <20231205092801.1335-6-jerry.shih@sifive.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20231205092801.1335-1-jerry.shih@sifive.com>
References: <20231205092801.1335-1-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The `walksize` assignment is missed in simd skcipher.

Signed-off-by: Jerry Shih <jerry.shih@sifive.com>
---
 crypto/cryptd.c | 1 +
 crypto/simd.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index bbcc368b6a55..253d13504ccb 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -405,6 +405,7 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
 		(alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
 	inst->alg.ivsize = crypto_skcipher_alg_ivsize(alg);
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
+	inst->alg.walksize = crypto_skcipher_alg_walksize(alg);
 	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
 	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg);
 
diff --git a/crypto/simd.c b/crypto/simd.c
index edaa479a1ec5..ea0caabf90f1 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -181,6 +181,7 @@ struct simd_skcipher_alg *simd_skcipher_create_compat(const char *algname,
 
 	alg->ivsize = ialg->ivsize;
 	alg->chunksize = ialg->chunksize;
+	alg->walksize = ialg->walksize;
 	alg->min_keysize = ialg->min_keysize;
 	alg->max_keysize = ialg->max_keysize;
 
-- 
2.28.0

