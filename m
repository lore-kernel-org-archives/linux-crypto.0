Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2112423ABB0;
	Wed, 16 Jul 2025 12:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752668454; cv=none; b=btNvFn20WL/76IIswSF83eVKun63lhf6gdm+686waQkYyahpgwVBsBrV5RukxzhRehMI1MPvZCeE84bIxTvSb/aMoKddQAUt9W79ETGvumfaEZZVoWE+Y1YHWj7F1Z8S9HCM1Us+JLvAZ8p6+9lDKfD45Qu9TDx9XzOVb0ssLxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752668454; c=relaxed/simple;
	bh=r9Eh43lxsCr9NXbVxPzQeaeyjY8VUBqaBu7EBTbs/vI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HSR28WUd413XfssDlhTBi2VoqSPRDsc2vETpiiV7fbUJ0DYA9spiUfo0rW2AlwM4ot61TnZQ+ltfpw7TejAtzdqdHOMhpJycqIeTXHc/lvRLkZWa7yxhjai+HJpWaL+9p2A5pUPa5ZiU15bZlKWYC3SM8fMi5C0hrgC44fE0FNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ir4IKXv2; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ir4IKXv2"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a4f64cdc2dso940244f8f.1;
        Wed, 16 Jul 2025 05:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752668451; x=1753273251; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HTvFcul8NKcWMdWlziGMaHDkoCiPByzp6tnbIhkOSuI=;
        b=Ir4IKXv2frQXVgNKSwW+ecWrv2evPougjgHhzIP2gsLGSGvRogfdesYowrtmPyp44i
         f3k7EPQtzAkewtFNxdoapd+hRshhEiLtVM+kTKsZH3asjjAQ4vD09qxBEd4cUUgVMot8
         xhTp92bxKJwNKI8SJ9EHiqTMO2D1Ph3EIaRdTASHvvM2/Nm0A3Ur0fcRoBL3EYkD/L6i
         fGvxp0ozMebemy7gYE5lkoxC6l5ZJbssJf9qtmBznHEj4tO17UGefyY1eRfc/7Czaytt
         A6iZpm0Dj03YLBhYXFeBNWSi6vb+zt6iLPaEn0ZCMjMCmX9zmLa5P9PxS9ZazVYgmClB
         NWoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752668451; x=1753273251;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HTvFcul8NKcWMdWlziGMaHDkoCiPByzp6tnbIhkOSuI=;
        b=QnwHG9QK5ejV7XHdc61ke+g3p10qqgxgpnSYUDfvfW/Kiwxn+yFe1sX9gCi69dm2Ld
         6CdlMLg0OyfP6uPnHnUlaSavGYmFxAE2eZTfApd0I5zrfh1pg8QRHZ/2XpB2pFkvB+ZV
         wRSvAufpcuicPigbZVV3/X95KeechU/p2QHGnhVdDbVmQxUtwBDW87LbtShjstyaG0gq
         HhK2yJ1hpWc9vLOuIoyfy18Yl54z41JUKhl/Q7kt9weSu3UoG8S445bLmzrZgYHBOc7A
         eD3w6MOgpMb7njD5ZQvBZloLvuLkhmKvWpuoWBAsDE/PQi/s4zyG+wcFRuzhakRPrbHg
         vWJA==
X-Forwarded-Encrypted: i=1; AJvYcCUBlLaDUGsuyl077S9iGMyOesxkg3RQV2febaIHdk/0nt6fpsAXi3cLAMKnskTn5fFVUIpFiU/+edj1Qfg=@vger.kernel.org, AJvYcCX0AAUxhJpiJz67fGvwZEyB+7TapkPNjMjAzoCCM4fU8+gA+D7hxGcoXY9ybM0QcnXS609MwX6e3P9RiuOI@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh4qK/N+BrkITV4uXpPcVygYXXaaL3STa8JW1/U0NdZxOrYfbK
	rTBP7Yaf+TWOibZvaSkiqlCL57To2dE4IOmLRLDUQ69wAvR/sROrRrmf
X-Gm-Gg: ASbGncta6jT6+5fkpj3tNVIb5g0Kaw80zSLBheNKirNSWgHha6UBG9to6I4w6eISPAY
	hq6kWJklAG5V9SRawOztAZ2n+5+YfZHiDo+96fze5dUgwg8qumqESylorkhfeZ+WpJW+Zt2Sm6q
	9zLPDuw+ss/g3/ZcMTLWWdpDvfgA/gTmgrGLYv1CtkauwruLogUxWJgaQ8I+fDVFo43c9kscHva
	bLCm/CmcBbhw+Dd/G2cNx5qqDaE1nhTXLcv9osTwB+EFk0jCkW/bYkj/UWDi36drcchkxjQqyXJ
	FdYBi1MjPKIjwV0kmgUpgIUkMOpHfhmU7x7aGOHCERtMD4TlTzA+zpOUqIGD+FDSuZl5cAv6+5C
	JNCdwk/BtaaiNByngqrtzt3tCoyk5Sv2cd9ayLVdOk0B/jwaZXq4=
X-Google-Smtp-Source: AGHT+IFYU0Htw3qzUvc9TdV7GG/h1UbVXTtzrCXjSwdFi2LM3+46esIomoJFNxgKSLEOix559SoD0w==
X-Received: by 2002:a05:6000:1a8a:b0:3a3:5c97:70c with SMTP id ffacd0b85a97d-3b60dd8176amr1088465f8f.14.1752668451324;
        Wed, 16 Jul 2025 05:20:51 -0700 (PDT)
Received: from thomas-precision3591.imag.fr ([2001:660:5301:24:1dbb:ef25:3e5c:8636])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3b5e8e14cfcsm17938598f8f.67.2025.07.16.05.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 05:20:51 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
	Declan Murphy <declan.murphy@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Mark Gross <mgross@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: keembay - Add missing check after sg_nents_for_len()
Date: Wed, 16 Jul 2025 14:20:19 +0200
Message-ID: <20250716122023.67129-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sg_nents_for_len() returns an int which is negative in case of error.

Fixes: 472b04444cd3 ("crypto: keembay - Add Keem Bay OCS HCU driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
index 8f9e21ced0fe..c75fd7c68fd7 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
@@ -232,7 +232,7 @@ static int kmb_ocs_dma_prepare(struct ahash_request *req)
 	struct device *dev = rctx->hcu_dev->dev;
 	unsigned int remainder = 0;
 	unsigned int total;
-	size_t nents;
+	int nents;
 	size_t count;
 	int rc;
 	int i;
@@ -253,6 +253,9 @@ static int kmb_ocs_dma_prepare(struct ahash_request *req)
 	/* Determine the number of scatter gather list entries to process. */
 	nents = sg_nents_for_len(req->src, rctx->sg_data_total - remainder);
 
+	if (nents < 0)
+		return -nents;
+
 	/* If there are entries to process, map them. */
 	if (nents) {
 		rctx->sg_dma_nents = dma_map_sg(dev, req->src, nents,
-- 
2.43.0

