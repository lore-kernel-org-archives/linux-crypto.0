Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05951CE098;
	Tue,  2 Jul 2024 18:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719946617; cv=none; b=riYUy7S2RU2u7kJsI5JUwL7+bqFxQNqJkKwW8MVY5ULiZy6IcuACjLwa86YCBQTjXiF/U2xa89CM+uWd+3yea4l+tcRKpXoe0Rz96vqsWw8szIayWubbMdyyn7xkl65ZK9BrMkU7Me7Zw7pkI174q0zXF4HwvqZ06kX5YaHpCd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719946617; c=relaxed/simple;
	bh=tUK00xKqvOijEUvn4/25P+icPcM73AmxS1/boRQuHwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZW2OPoin/rPqwJK1HjEoyc+mL6UOS2fW9fjCO46vtxIpqUgxp75Vn3/AHzXalgXnJ2BB8qxgsnWR8ahuKey5Xck8gzh8DimHd6EqxAMxBixHDC1tX+6LoVi1hUCgKEJiBrDlzsaN6POYyqbl6jTW5rIWMQdEFqCroWLHLvcZ140=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a72459d8d6aso464763566b.0;
        Tue, 02 Jul 2024 11:56:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719946614; x=1720551414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ShLo8usNRCEFu5wG7vvAmQF6Nr70DMxisgaHAPu+cb8=;
        b=neYyWR8k+capayAPsrWL1TeAujC2Eq5V7Mgyz95mjioLur3i9vErR9Co/gK9fz+iAO
         yb1qYkZmYAdptH6QFQJv/Oi5ptxr0pxttqaQ9OD8KvKwJVpga6a+jPJUmtk4NQNe623C
         RfUzqx7riZAC46MXqHjmoTuWq52Wl101tOFgTSNOPhFawf4x8JsQThXVI3rHFXZ+QBgU
         SgM7yRSjAJP8P32DQAeqoloo1/94IaWth50cXwcZUwxIkxbqqWrf35PQTvnQDP3K6fgc
         HrWYzkV+AZmAe/hKIjuqgcJNpLKSy9fPOLGvs39oAmLUPbXddyGc5Ra2T7jBlmqG2fF4
         Xh2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWevRKMCmF/LngZ7UKidQE8XbrdsTDfeFAap3CpPORtzTa0s289VcEdbQ3zyvikoL9T/mjhxfpiFTfInJP25krwcLLdH5i5mSulN7KJKlsCW0EjMy4A1FTbGrrdmxYwSrMTDChL+IvkjXXDUk6CGn1UlcqXBtb+Y4IqcuSwHP/O0emy
X-Gm-Message-State: AOJu0YyC8ISEsFFCpsa7AZhplkpFmtL8VFGFfExmnoqDxJXPUvB6pRnG
	j3Ptbv4zKJv4jKmN2s7cI/nDT6ijSmhMsFZr5a2s3nkuY/hqlLHP
X-Google-Smtp-Source: AGHT+IFijCxDVh8MOClU9v30A+rRP4QeKP6ELLHnbBxcyBbAktP/k9hezkG+J7/Leq5NDhzL6eU9Gg==
X-Received: by 2002:a17:906:a0c2:b0:a72:6f10:52da with SMTP id a640c23a62f3a-a75144a28bemr666287966b.59.1719946613978;
        Tue, 02 Jul 2024 11:56:53 -0700 (PDT)
Received: from localhost (fwdproxy-lla-001.fbsv.net. [2a03:2880:30ff:1::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72ab0656a0sm444457066b.113.2024.07.02.11.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 11:56:53 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: kuba@kernel.org,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: horms@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 2/4] crypto: caam: Make CRYPTO_DEV_FSL_CAAM dependent of COMPILE_TEST
Date: Tue,  2 Jul 2024 11:55:52 -0700
Message-ID: <20240702185557.3699991-3-leitao@debian.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240702185557.3699991-1-leitao@debian.org>
References: <20240702185557.3699991-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As most of the drivers that depend on ARCH_LAYERSCAPE, make
CRYPTO_DEV_FSL_CAAM depend on COMPILE_TEST for compilation and testing.

    # grep -r depends.\*ARCH_LAYERSCAPE.\*COMPILE_TEST | wc -l
    29

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/crypto/caam/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index c631f99e415f..05210a0edb8a 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -10,7 +10,7 @@ config CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC
 
 config CRYPTO_DEV_FSL_CAAM
 	tristate "Freescale CAAM-Multicore platform driver backend"
-	depends on FSL_SOC || ARCH_MXC || ARCH_LAYERSCAPE
+	depends on FSL_SOC || ARCH_MXC || ARCH_LAYERSCAPE || COMPILE_TEST
 	select SOC_BUS
 	select CRYPTO_DEV_FSL_CAAM_COMMON
 	imply FSL_MC_BUS
-- 
2.43.0

