Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ACB1991B2;
	Wed,  4 Jun 2025 20:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749070068; cv=none; b=eONZiesMCtW4ywVnXtebLXxlsuT+15ZQxS4qvRf7sTRnxaIOeitnRb9vqNpo1htCpobY/oBK6ygB0fyOdufg1QFMcCWXyt5r84ChsOAH/SDGfIEeldh/RHTBE+grezGl+nzO77yti6UoY4gH1hYlV9VGN0FAhFwWX0E6f54nyF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749070068; c=relaxed/simple;
	bh=jq0mJcRTZfVWPVZJ0q5moAk3SNLPOHGYllNcbo2Dk0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNdBsu8tQ/lnkgnBX6x2mAMdrjqLmdEU/fpHgxWjlFHpkZPVCDTuymPQvI44hSZukXmkcwuX91ep2xTYWpNBHTaRnxSB2zK7onk0+m9WpAFiUUHj5tBOYgNtxz0miYvOFUK34Wh1QOytmDSE3Ftm1gT7CpEh0zJNiB22ZJlhDlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=arIy5d8y; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="arIy5d8y"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-70e447507a0so3103677b3.0;
        Wed, 04 Jun 2025 13:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749070066; x=1749674866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VnLuJi81jYOYtHY6H9BJUZiDmCvEueD8G16moADExgw=;
        b=arIy5d8yDDMvAPauRuUlgTiJz4Y+cZ+NO7fuAkFM4YqSNg+GcrnID5LkisW6rad6/C
         BnVT+mdAl6wPADR+ESVJcxkyRPmwxOrfCLdfS2mVrPdY6lOkXe54UpKdxxR/5l/QCXME
         tKyoOXEjXRC9v38GArqfmoHcbe8+x+8vV5VWL+cwifkvH/eHOSsTtuxc0HZgc5mj5KtE
         XcQf3ZO71Y/HnEIFaoTfP4DbWujeTtRoyPzw9j0V8Km7lGyyDLTMHNUfP0T38ECpyv0k
         xlyoh79WN0aRPkrKNkPu3YDiy7xzIca/yGzLeUqA5uNZjPzOaxIruhJ/Cq4ntO46ka59
         j1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749070066; x=1749674866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VnLuJi81jYOYtHY6H9BJUZiDmCvEueD8G16moADExgw=;
        b=ZW7Hq1nbvzgQ/FSJ8Vap95FRSjpoGEE/blS9KZ/HhSO022tFOEHolhpyBgSCocYkaJ
         HG5nRT8RKla0woUP6DvqCKPMWKt+eSDRD/TWw20anPSoISzb9p0MwMOsx5ooB7ocILhv
         Tv6hYBNAwU3WxeKpMlD1GBVw8oA8zLt+mOOWyygyrQXq5RA+VCkTmmcEKqhODaiSnWrm
         1Dk7+OblUfZpSFHUGdpV0DWFJmZAsJhvvvUSV0hip+bzFSevrTEGpYC6tPIcTb909cfL
         tONXPE7TvyyRZ6aiv+XqGWcuH0d/eqRlspr0ywInCVVCJdgrv9Nj1kv+HcTiL9KRhR+c
         mKBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJMWAw0BEO7J2r7gbezP/TJcilCQkMfK72kU3h4jqeK00r5tiALp8XSa65oTb6rCVe/uQ2XnpIX845dR4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbkRN+0GMBitTauoN3eAHJ9GbZyrdwLMtHBoZd2Fv9tmbiHBKB
	TBLOmf30ICrdRF2c0LqgagrpbxA6dunfv5ToN6b2dY68DKSH9Je80hD1JJa3Rg==
X-Gm-Gg: ASbGncv+N4IjnqRrvGCrg5rPLtPsCsvsOZX214OtEUPvQMQmj6+KsSgYcifxTY/xLMo
	Kw2E3QyaUahxniiFJsNcLXaOyjwT0NB6STzw8n2ICIFgEWskzN8OSy+DGjslzpeXsvB8e3hSdaX
	0CODN7iPY45M0AsOMkyFATJulPerxX0VPudkPVjol06F/ESDxDn/8M2YDY4DJruL2ly7AmX6DnX
	emoxSNoKnEre9bohZ4IreU4ckbPIML/jvta3Lp2Myy5yDkOHhtqsldJYBpkCOg9yG3tLy0uJpHd
	jRCIJ71R75Q7XcbWJwqyprBPL0n6XXfO/i/N+NLbOBeOQMklaogoTUliZohDe5Jc8yK0zEWcmBx
	ubeVdJw9PlyE=
X-Google-Smtp-Source: AGHT+IFRGCS4OMkR70kokmyKiV6UlZ3z5bDnt5MnHwrXjTB8gLqidEVhNq9ar+to3naWMvi+zpCk8A==
X-Received: by 2002:a05:690c:3609:b0:70e:16a3:ce96 with SMTP id 00721157ae682-710d9e5376dmr67442957b3.26.1749070065900;
        Wed, 04 Jun 2025 13:47:45 -0700 (PDT)
Received: from localhost (c-73-224-175-84.hsd1.fl.comcast.net. [73.224.175.84])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-70f8ad005besm31774817b3.106.2025.06.04.13.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 13:47:45 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>
Cc: "Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Subject: [PATCH 1/2] crypto: pcrypt: Optimize pcrypt_aead_init_tfm()
Date: Wed,  4 Jun 2025 16:47:40 -0400
Message-ID: <20250604204742.21183-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250604204742.21183-1-yury.norov@gmail.com>
References: <20250604204742.21183-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yury Norov [NVIDIA] <yury.norov@gmail.com>

The function opencodes cpumask_nth(). The dedicated helper is faster
than an open for-loop.

Signed-off-by: Yury Norov [NVIDIA] <yury.norov@gmail.com>
---
 crypto/pcrypt.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index c33d29a523e0..c3a9d4f2995c 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -178,7 +178,7 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 
 static int pcrypt_aead_init_tfm(struct crypto_aead *tfm)
 {
-	int cpu, cpu_index;
+	int cpu_index;
 	struct aead_instance *inst = aead_alg_instance(tfm);
 	struct pcrypt_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -187,10 +187,7 @@ static int pcrypt_aead_init_tfm(struct crypto_aead *tfm)
 	cpu_index = (unsigned int)atomic_inc_return(&ictx->tfm_count) %
 		    cpumask_weight(cpu_online_mask);
 
-	ctx->cb_cpu = cpumask_first(cpu_online_mask);
-	for (cpu = 0; cpu < cpu_index; cpu++)
-		ctx->cb_cpu = cpumask_next(ctx->cb_cpu, cpu_online_mask);
-
+	ctx->cb_cpu = cpumask_nth(cpu_index, cpu_online_mask);
 	cipher = crypto_spawn_aead(&ictx->spawn);
 
 	if (IS_ERR(cipher))
-- 
2.43.0

