Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="R3bGiBJy"
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF421A7
	for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 23:07:28 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1cfc35090b0so6525655ad.1
        for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 23:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701068848; x=1701673648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I9NcydlPjJuZdBvk47SliSWRPXO51iH+ClRWgIXdngI=;
        b=R3bGiBJyq+uYPEskiMD2ig1vN6/rcwG2a45RUwH5v8t+GhKBASiJ2KCfoRAn8QERwB
         Fwjs7IIY/oCs9P1Eafo/z/2qRS1WfEXf7i210aFCLEDdvsIyNEh2DNin+8kvlzQer6OX
         2M31tXupx7SV+Vk4A7EoPk1pd4hi8K8Xz0T6nxvjeGZk/8oV+5tF2GlstIaMZ2RsLMTY
         bDMXAcsqi5GJY8zab1zE4JaC+pdDFrQeYIb274LosuLyjt66+OddRoUGLI4ru4y4mR0k
         tKiamBKph5O4/sifbbYhaIAcjnXWMxdbn726u8JcDt/QzMCnVllmoRHWmiNIYFFGEomz
         MHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701068848; x=1701673648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I9NcydlPjJuZdBvk47SliSWRPXO51iH+ClRWgIXdngI=;
        b=jvkcovpzb8StDFBZSU7oSSu9Pj59o77upJVzdkHvTPbX7HGpO1vSLgfmgI+oQgVCH8
         AZZO5pW5QwEa8hYj2YscDjZESyMpgZpNWYiPNPaOKOxqRHFl1ps1IQOVQL6DY2pMndMj
         bclns/OMaKCL3Ogd6jUY4uiQtSUhspn88ecueQ1oOGiH+lltbvxxAAmepYhUn/qEPpsw
         F4ZwX8TIWR28jTXG3XjgoM7u5dWJwuOIu46Zb5TIyJrJmSqwDRPBVgSIXSxqik2XmLeH
         Ws3vByHKzQfl0DsK8PMZ63iBbzS4HMWWliXVFiCY7SDJeDLUBWaRYAp0eua/IxRhGJh+
         t38w==
X-Gm-Message-State: AOJu0Yz7POaD1WjaPp72uhzV/RcO1kpYOcEPQifPh1EEex2vlryYNwrk
	/1IHvTLCup9ubJHgFDNaIDOPgA==
X-Google-Smtp-Source: AGHT+IELRS3hxE4VCKaoEswdjN2LTSxsJZBADubHAmIAofnrpOYQED6FfVAgy1DMUxcK/odvBEY6yg==
X-Received: by 2002:a17:903:1d1:b0:1cf:d58b:da39 with SMTP id e17-20020a17090301d100b001cfd58bda39mr1135943plh.64.1701068848370;
        Sun, 26 Nov 2023 23:07:28 -0800 (PST)
Received: from localhost.localdomain ([101.10.45.230])
        by smtp.gmail.com with ESMTPSA id jh15-20020a170903328f00b001cfcd3a764esm1340134plb.77.2023.11.26.23.07.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Nov 2023 23:07:28 -0800 (PST)
From: Jerry Shih <jerry.shih@sifive.com>
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	conor.dooley@microchip.com,
	ebiggers@kernel.org,
	ardb@kernel.org
Cc: heiko@sntech.de,
	phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 05/13] crypto: simd - Update `walksize` in simd skcipher
Date: Mon, 27 Nov 2023 15:06:55 +0800
Message-Id: <20231127070703.1697-6-jerry.shih@sifive.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20231127070703.1697-1-jerry.shih@sifive.com>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
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

