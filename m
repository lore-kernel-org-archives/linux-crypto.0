Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9781E4F55AE
	for <linux-crypto@vger.kernel.org>; Thu,  8 Oct 2026 18:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484130; cv=none; b=mYKlvGhF+UmIdOYD8uur2idysml0r4Az+saPdXXPRt8CtbcSqPRAvSr0Cek68u90BkKWrj5KQ5O+XSac6tezso7iy5nGHrmPIDcRn6EQvrrfBHoU6L9nZG7N8WIbYLOUhhVMmYP1NI91xNso4JMS4DSgz3lSiJipd3GA/iR/ZQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484130; c=relaxed/simple;
	bh=25uNfJVo7Y+Sfi7XhXghjxn885YmIU5R70j6mEoOG00=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gyw9BfeKnatpIpWmYXCOHiAu8xzZ7gG6gJJmtY06MAzstpO3Hjdes1EEQb1zd8PegAVx6kNmrz0T1YyfOIg7ogHkpzpBuSmNc1EwaRvr1061LLmszWJmYg3L7lcB8Nnp/URavZkMbHIRdYPTBfgSqL3KEZz32DCRNexHKXy3vIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lDrR5d0Q; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lDrR5d0Q"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1419d3416ceso10781253c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 08 Oct 2026 11:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484112; x=1792088912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=lDrR5d0Q7w42QPYmwLmikK+7xskqMexlGula09iIMV/F3yGjFA8Fsl/JvPtgiTqIGz
         hfvoNuY2re8QlQigo4A+pf1hTr5X3bMI5depSKwzUHlCIS5LSPoxUZ+KqU3AHtP1Xn1g
         MeElIcbmOFGecyB2ym3DZWdXcmyrs69FAttdqmHpkT0BwJw4GLb4fbT1CJmKhAjOX6r5
         NA1GqbERwAXpKR+u63281LFuGi6JG1q6Aq/OgHZjmRbVJ9iT987BVncgDaqHp5bkY84t
         v69+93+vXAXJgAxIuGinRuGdrcPvp6IN8uA1xeXraVp7T+FKupDLvT/LpdUnMTSwe/dn
         Mfrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484112; x=1792088912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=fccGOkkRPfJrZLZ3ivVp+vDTxY07TqD7b8t2eyjmJF4Gj40K5Jd5diAbUnbDevDbNM
         o1ZNw8yBZq2Nu40Fb84FIM4bWJw6zgpzH4lDa4XxjSD1zsEpegbdY2E0fHUjkCQh/gRz
         WlBwBQjv53yUXuf0w68wmN1Hhj/HHj9XdQSJNtlAJBO1Zio5OBun82CU53Sr6kVjzqSK
         doiUQPHPanjISEOlQH8MeNF4drXafS49LOZgPpRZGNoYzbPnNdAoIU0NbJfzXPDCPVzg
         MtaCHhOKMBvIVGApCp0O/mF27bnEon3bDCraXIS5XMBdIX8l6JOUvpFESUNnKiAHb2RW
         09mw==
X-Forwarded-Encrypted: i=1; AKwUvBzV8YFcqD02O40pXxoY8Pb/BrB66d9TrGqJqxU0oygYiSYge8A79Bs/v0uzoGi1pZADcwouKyibDH582Hc=@vger.kernel.org
X-Gm-Message-State: AFuF++lDuEdMHlI1Z6E5uKDDF08YHT3IKqY/b9d9Xhmcm+4n7oWQm5im
	u5KTSVjLhktkmt1RspreBepHYzbyrC+lmgIG3IxZOvR9BtIyPFFKwWa1
X-Gm-Gg: AYBFou2EeCYPRiOA/tmAKML3TT/eA97C95VdSgw1R2EORDZIDrcphrV9ERxZ1yvvDNy
	FPKvleTH/V//7H7Yfx0y6zTomfZP3i6TDUdbSxmHtPXSvuAz376pbkQp6ote6kfdnUSDpbKa8CL
	vTqBNk+mkcHyszbtpm8tBIFL86WGFzanXLgSzuApWXS1TONjga0OhZar74LxeKpUHYZFXV1xaYA
	3W3E2D9VAAq/FccLH36WRRFacQ8x3tTbBSjnyZY0S8LSCkabrpY5AjmRB29roaLUc8dQV8Qz3oX
	UoAspJncib4F/9vIigVGDl90dSMwEZfRT+tW0DMD2IYy+hum9bkLJDUe6EE3zwqDN5rGuEbGyWt
	cHwmxWILx0/kW1UJ82u4PITrns0knZyg3EK/Np0O2McOrWIi3v9TRaWqryu4nN1DuZyxHbQdyyb
	ltKuE05X2Lm9uNc03jfSJkA66ClrgDntukqL9or/zm9Zw2TOepowTUoOdOSVlTS5DQquf6/1u2H
	U++a6IM1AlcTSXWToZJpQ==
X-Received: by 2002:a05:7022:f115:b0:14f:fb87:cf62 with SMTP id a92af1059eb24-16205cc1b15mr6242946c88.27.1791484111604;
        Thu, 08 Oct 2026 11:28:31 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:31 -0700 (PDT)
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
Subject: [PATCH v1 2/8] crypto: acomp - Add bit to indicate segmentation support.
Date: Thu,  8 Oct 2026 11:28:08 -0700
Message-Id: <20261008182814.27450-3-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
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

