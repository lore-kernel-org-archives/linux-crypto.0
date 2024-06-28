Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DFB15886A;
	Fri, 28 Jun 2024 16:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719591307; cv=none; b=cCx21UhdKb69vp58cRuNLScFTL7ZqBVGRR65tRHzyoi+IbY/J2NBto+ZCBouUu/bUzsGGshQ4BwS+5VM3F4Y6UW5ZcSV1osrM+/HfkIjj6HxLbQfJoIuHknOOvJiNGUJC1m/7JAYElIKiTTkS3DSDJNQ8T0QqNbS/pvwYnuCufg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719591307; c=relaxed/simple;
	bh=tUK00xKqvOijEUvn4/25P+icPcM73AmxS1/boRQuHwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXhznBrw735mD9JshcB4UNcbaKN8L/9IHRjcuFG9lM7MppCMRQZZq5hzl8vojfx95Q5Ebj51gJzHwOaFGvwq8talg7Tt63rVPqSOF2PkrWcb58bbosupqwIz644llUMbouwaHb5JMF40l+ImhN4GMs9ETcLy4zOx9q39qMYCrQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-57d05e0017aso1067092a12.1;
        Fri, 28 Jun 2024 09:15:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719591304; x=1720196104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ShLo8usNRCEFu5wG7vvAmQF6Nr70DMxisgaHAPu+cb8=;
        b=FDY3rCsOYV/ZsmSfdgrmgBbQlg61wmO6874Ev6RbHz7+/iesWquQkh85DPxY6W8WQh
         umCe4qxh6DLr0a/VyMVZhYRnD3sD3+9J5v+SV+ZltZXkV6aeamcNiT3cFtPM4tBNmqvw
         CrI1B7tgur25EatvExPAKke0Se0fgd5NqYKaQjJx9MGg2cxwH3+vhudHQMDoIWCwGJLM
         Oi0WXU0oM1ucT3gjuV6xYxcUYWNbWFqe0UV+3J6Vk1zhl+5gxAQEr6RGt/yKL8LFvVs1
         9zRqbPvGe8jp7jMQK/f/U2Jo0IzDPwPi4Bbd40s4wjMJTG8kFtZsiGfQxm4y02qx2rAk
         fEiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWALCW0vGyTtUm9wvglXXQnFgfYMqkWudhsEulLydTX2OeIUYx0CyKatQI8nowwdCMo9FTwrF8yI9WDP3HBL8sUFriMlAx0pFd+RTb4zWuJZTNg0m4Ad+QZT2EaggcACYUA/orlzokhQDNjpXqwoSXxnXXs3KQVDFL46LtdbG09Py7/
X-Gm-Message-State: AOJu0YxYL1ioVxMR70FBR7ogOldb5Y59C1o9Q2UnhQSGeUBktRIMzT+h
	xW4e+07XikIsCRRnihqGfjtpgtZrVu9OP5E8ESLn291KnBC6kKh1
X-Google-Smtp-Source: AGHT+IG9e32ZpU2sSOr4NoYwkTjv69pMnMp35j6JTBXqmqEXfxSEiwIChiqNvpQvpsPsPD0faNwKDA==
X-Received: by 2002:a50:9e25:0:b0:57d:1e27:65ea with SMTP id 4fb4d7f45d1cf-57d457f5fbamr11989886a12.34.1719591304324;
        Fri, 28 Jun 2024 09:15:04 -0700 (PDT)
Received: from localhost (fwdproxy-lla-006.fbsv.net. [2a03:2880:30ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58614d50441sm1208758a12.75.2024.06.28.09.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 09:15:03 -0700 (PDT)
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
Subject: [PATCH net-next v2 1/3] crypto: caam: Make CRYPTO_DEV_FSL_CAAM dependent of COMPILE_TEST
Date: Fri, 28 Jun 2024 09:14:46 -0700
Message-ID: <20240628161450.2541367-2-leitao@debian.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240628161450.2541367-1-leitao@debian.org>
References: <20240628161450.2541367-1-leitao@debian.org>
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

