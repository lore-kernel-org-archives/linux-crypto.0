Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D619019B5AF;
	Mon, 24 Jun 2024 16:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719246118; cv=none; b=gfuArFkW27imGEelZnpqD9T8VjFQMI1yPM6ewDRK6Tm8qg3Qm3/njfNlpNA/bL22uJXIav0498aalCsG5UwzIWH1z+dlyh3sKPWZGcNTiiggzD1NICUgMCfA4kEgopnYJzdxxeHJ7vExO2ZiuWeJrzJdE5NbNQRBiL70TNo7ewY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719246118; c=relaxed/simple;
	bh=tUK00xKqvOijEUvn4/25P+icPcM73AmxS1/boRQuHwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRjBuKHd4ycF0Rx37n2TVVp3pnpnc9Oa3FrR6WkoS4S2alp/M4GsY75c6KLqsTt7pv4PoFe1tAxf/aBi4hrbbRGAjy4+aZO68pbwUtKvwPlIN+fCI27VCdArRhNmH9rWkmZ5yVdjS/rN0Fx5/mrezths52wLx8QX71drjypzRtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a7245453319so269108966b.1;
        Mon, 24 Jun 2024 09:21:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719246115; x=1719850915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ShLo8usNRCEFu5wG7vvAmQF6Nr70DMxisgaHAPu+cb8=;
        b=QX05SSDDhinlpiPZr58ffCTT9wSIVD/TLL31wPkAdvx1435dccFbf1qFZT3sOt3QwN
         bfABsFc4t5F6RbVsT1azd40b4UbNxO1fjG7uA6zZt1ZeArluoX0tzqluw5d2lFeJYwt0
         AJKXkqOCV+I8n8guBk88eK/4yQRaIgAh0iTr2VqAcgWggRzN09lw0vN/xg2QwXVIW9WW
         53nnmPgFsNRUryX78tiMzgFBUzPxir1yZcvMV2W4yITvj2SrWC2IVdf9xxUDgYYBza3k
         vktklvv6u1Den7PTkgHkFoElLsKuzsTKqVGMZOmsbr5ur5orIH+Ut9URG9VEEOa2CjaO
         uoAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsCIcXaa2QobAM9wy9zynz94oBL1kapqBNvT1ibFzp3QBkyU7G/9hFyJdh+gw+bdMfiQPgLqc8c9/Jrzej1bf0ONE9mf50+Sd6o/a9eq+Zf+IZEZNPg7acs3HSjEaG4FSQijsxOi8eMxsVDvMg4RKG4SIR11q+lrcD0WZmVeFuPALU
X-Gm-Message-State: AOJu0Yw/NCeaJJYpOrTFqJw3Pz+41UktpoAchoSNk7MnUJZ7GTL3Xlp4
	/zS5h9j6bI0ei2tFLv1+cVPIYbVtp/CGCdQEJEplHIEFwlvNS2N/
X-Google-Smtp-Source: AGHT+IHtN7PVpKI1Bv6EZwPIbNhldtK+jt6XAQQqnMxsDG/fcv/XeasNmP2zn3fSmCQDg4rud7njSg==
X-Received: by 2002:a17:906:c0c9:b0:a6f:dcb6:223d with SMTP id a640c23a62f3a-a6ffe27056amr503424866b.8.1719246115138;
        Mon, 24 Jun 2024 09:21:55 -0700 (PDT)
Received: from localhost (fwdproxy-lla-113.fbsv.net. [2a03:2880:30ff:71::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57d30535005sm4848954a12.69.2024.06.24.09.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 09:21:54 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: linuxppc-dev@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org,
	netdev@vger.kernel.org,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: kuba@kernel.org,
	horms@kernel.org,
	Roy.Pledge@nxp.com,
	linux-crypto@vger.kernel.org (open list:FREESCALE CAAM (Cryptographic Acceleration and...),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/4] crypto: caam: Depend on COMPILE_TEST also
Date: Mon, 24 Jun 2024 09:21:20 -0700
Message-ID: <20240624162128.1665620-2-leitao@debian.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240624162128.1665620-1-leitao@debian.org>
References: <20240624162128.1665620-1-leitao@debian.org>
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

