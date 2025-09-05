Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3914F1D6DA9;
	Fri,  5 Sep 2025 11:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757073204; cv=none; b=JLp1P8fthOTKqIasJs0C8xfYA+dNGKpuPTDMCXRRFyUFEP9ww2VRhnF2XtlrnMwrvqWIGlEvak62qPBEkK+k6VA36qyYa1kmRnGG88TxgjocgrCT6UAyFDSLh0hUCaoZKW+vIo4HU41k+3wMmwgbF5cgcDtEl0cBMdSjPIcBiPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757073204; c=relaxed/simple;
	bh=GZfXG8CWYAUuUjKr7KhOpe/JWJt9mfIwt/Gv0dRMHKs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OGH3Xm/76gUigey8Hw3DSAuF4oq4gFlMavotaD7x16nnHDu8gVqmx3IVEFmUni2JG3pemMU59EL4HDejQiN8SiW2mJw+craFf5j60ZnttwUE1EeF62d5y+HyZqXIXaWt6DGwRvwGrVzGBqVtzNBzKaVtocx2SOYiIx8E+G51e/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TwH6WZ2S; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TwH6WZ2S"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3cd151c38ceso199814f8f.3;
        Fri, 05 Sep 2025 04:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757073201; x=1757678001; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ibSd1EIrnlf1T65R99x8NmkSqz8ymnGekDTIZaoFiU0=;
        b=TwH6WZ2SY2sO99mfp4mATjAAzKjO4KgexhUMXnvKaLYTOoZUEVkc0d570BaKYAB1ec
         kxc8k1YJbNtzt6MUVKasbWssN9ZGO/kfpE0wUhNjuqSIRahLKOkfX4MJRR2g3VlqrNqq
         gR/SgP0aWF/E2FGIVfAnlvgx9nxS7JSmPOxfDFaOnAxPRdO7ssQ+xBvqpD0ram1rT0zQ
         59bPEJwI3Kw7chCv3Rgod7NnGx53nle8uN0CAk14YRpgTF89+7HljvLiswnU5PdKiQ0r
         zT+KdYI++xGdeNYw4Fz4hrSQOOUPCLl8gtPSLVrHhw7KSPZWqLB2xm+nOEYVftgxWDQs
         4QoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757073201; x=1757678001;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ibSd1EIrnlf1T65R99x8NmkSqz8ymnGekDTIZaoFiU0=;
        b=W5j4knI6guDWMDQNE9WVmSkPcjikowilibpS8giCQmDSahdXDwVBSq9APP3HTcM4qr
         QXM0l1LhyPv4/1E/gO3v4Ax1GzqUy33U6JlRUTz7CTPecWgMC9t5DWdCe7ZTIe+cgFT9
         OkwD4hYsMqm+XM62+kQDUw7zNCHmFht00pZ5vgfqGsVCe2XxMMF4Lwn0gE2iFC4wCpFN
         zNmWNAJagxqkviZOfZXP1z3V+xKJVGVwKKwIxLPjSa7mQGKTAB6jw2dyiVS+Qjyszg5H
         sg/JqYlJjRY6jdsehI4a5kJTM8capKip/fUFm5uK1rLI8OHNxYMJflA9F1/+faXViokv
         n0CA==
X-Forwarded-Encrypted: i=1; AJvYcCUletoVxSR3nCsO4CKPDcfFzbW+Wp+ff/BkEAwIttuXwfSKRmp6F21a5KQKF8tWoCwtRa0Nd6AE@vger.kernel.org, AJvYcCUm58FWmiys5g+I0FbGd+SO38hJsVGyob84HV7g0/xsF3ZiQTEqoICGGkJFfR4U9Dg32C7DJN9uFSb4eFU=@vger.kernel.org, AJvYcCVwuO8xmw6ymGpuVhi6zr4hlvXwHKJuXQzVGTNMCYTq6VXXI4hWbdqGaZWpJ6hxMwx+zOGskMw/UJ1xmodj@vger.kernel.org
X-Gm-Message-State: AOJu0YxlsIHLtXKw/C7nhINgzdyWGhr2nfNbz0ZejZGKAU/mGeCE6hTv
	b1j6eDgWPCoWXrMTyi7QN2uvLdiLMasv6G5rJBoY+w15dEf6bJ7/ZA+2
X-Gm-Gg: ASbGncvA0E9OOkdccJ1iC3LZclShGSVL1/btoVhWr1fcN4FiEPfC3B6Z1rag3dl6ZGI
	RjMZsCQ2RJRacvOao9PSBlZeDxfc85uAVT+YFUylLZ96FblpTuC/yd75QOA01rfixQ2g1BBRRfZ
	8+diXVh9rfEIJDbUX6Fpzgeu2S65AvWp2ckBTKfwCK3tXt7Z8BPiCF4K3t2vFS2pyV2nrRRH5yu
	NAJXuSqP8AoCT3cNDChGNvZyhTlxBlc7uevEkHLqqq7q3sn27wO+kkqhztAHRHAOYEZcSNfLNd6
	wxJZs9u8evSQYEljpPb4uORLb5HhU8RJoAm6sYV66sbBLzQMiq05pzNFAUz4WebQ+uij2ZSHJJd
	LkIghOXTYLx3i6okCMHb51+y7YNfm+mgVmSX/mxjFqNCdpvS3rmMqsxPAEcKsZUc8Wb2/MVND
X-Google-Smtp-Source: AGHT+IFgyUVRsNnagZ84Pf1RIyYo5EbfYhRyDK79C1hAlhHc/Tz4Dui23mAaHaZv4EihvJszPYZfqQ==
X-Received: by 2002:a05:600c:3110:b0:45c:b659:6fd8 with SMTP id 5b1f17b1804b1-45cb6597198mr40677645e9.3.1757073200933;
        Fri, 05 Sep 2025 04:53:20 -0700 (PDT)
Received: from thomas-precision3591.imag.fr ([2001:660:5301:24:999e:a0c8:e30c:983a])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3e411219ddfsm1903897f8f.57.2025.09.05.04.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 04:53:20 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	stable@vger.kernel.org,
	Neal Liu <neal_liu@aspeedtech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Dhananjay Phadke <dphadke@linux.microsoft.com>,
	Johnny Huang <johnny_huang@aspeedtech.com>,
	linux-aspeed@lists.ozlabs.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: aspeed - Fix dma_unmap_sg() direction
Date: Fri,  5 Sep 2025 13:51:11 +0200
Message-ID: <20250905115112.26309-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It seems like everywhere in this file, when the request is not
bidirectional, req->src is mapped with DMA_TO_DEVICE and req->src is
mapped with DMA_FROM_DEVICE.

Fixes: 62f58b1637b7 ("crypto: aspeed - add HACE crypto driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/crypto/aspeed/aspeed-hace-crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-crypto.c b/drivers/crypto/aspeed/aspeed-hace-crypto.c
index a72dfebc53ff..fa201dae1f81 100644
--- a/drivers/crypto/aspeed/aspeed-hace-crypto.c
+++ b/drivers/crypto/aspeed/aspeed-hace-crypto.c
@@ -346,7 +346,7 @@ static int aspeed_sk_start_sg(struct aspeed_hace_dev *hace_dev)
 
 	} else {
 		dma_unmap_sg(hace_dev->dev, req->dst, rctx->dst_nents,
-			     DMA_TO_DEVICE);
+			     DMA_FROM_DEVICE);
 		dma_unmap_sg(hace_dev->dev, req->src, rctx->src_nents,
 			     DMA_TO_DEVICE);
 	}
-- 
2.43.0

