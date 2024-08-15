Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78AB7DA72
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 11:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723720828; cv=none; b=MFsiT/2H5dmlfY6f+wO+KECh3B+fXw1Veff+8pX7BbG0yoDZxHRc5yBHg6xYG49aTuGJNWLZwIkKFoFWGFG0nIxLg9xD095WBsF599O/+syZmWcNaQ2qB9Pwh7SSJ+M08Vo0cCKvaHEYyu/ncsBbc2I5tl0geRaRt6BdidEFrgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723720828; c=relaxed/simple;
	bh=HxwqfPal+HPnTS7U68L/EgIg3QGgE3PaIdmgWW1fsUI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=fNrFxTCDUCOFST45tfBKYGB1uQJ4QZDdqlwoouyomN1xElQcoIE1e457QSFPcPBA9RWfuOcVxtYjr7+jGe/T/kyUfSKE1fKJBfJ4MboLy18STfjZHtPJNzlZYfJoiQogysilaU1JlcMDvHNKNesf6Bg7CXW567Q000BH/my92pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hFsYbilS; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hFsYbilS"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3717de33d58so457924f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 04:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723720825; x=1724325625; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3oz0pMrv8IB6uL3g45VQLGPvoAVDEFZ62Di96CP+YN8=;
        b=hFsYbilSkn2+G8hqXmr5f+XljEDJuPAUaBUpv1KfN/Px+BgYc7MTg6fnw6ElAyfAMu
         mBZaTAfKtjXJ2FAujNegPtRvS8xo7uT8YFgFIUmtb/A+rFvURX1nP4+IVKz9tuLO06FD
         MHfE5npycI5q4Pf7sf4nFJCZ2pZtY+xKSmkLN5oxq3Il5685zI4WAVBcfCYuqcRi6Fbs
         FNISH7SF+oexHCqcIu7I/ZWyhigfM286VssbkOCu3XdteJyhsGJOP99T14K2KZ2QS+d9
         oXS5XcHnISt4qELYF2Cb6tJvXtbaNLifAbCCsoB2+5B6l68+g/QvCsWPfgOmdRQwbKMa
         rEJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723720825; x=1724325625;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3oz0pMrv8IB6uL3g45VQLGPvoAVDEFZ62Di96CP+YN8=;
        b=ElVTi76+fEAhrVmpkn30kTV19D39Mof/WULDmDJDtE7pDX/2h3qIb2wjddiOs3N19+
         6IfelC4DNUTsGln4dyN1XdyoF5FTevWnwmL3284PotuY3ewbJB3gGvVRB6+9S7Bt+faR
         qx3J7YpN6SP6sUzShcYNO75IKy6umbzRnLmZRimircTY7TAsEC2j6//vjYKEv7BWpBzb
         DgVDLDOOhKKzNl/zyl06cy3vDuDWC9xHkHTKg6ntUNDQfLpS6uZcxjmZqrQng9KrGzGL
         r+N+4oaTsj/ileMzTZJHUbk9uxMjqZlD4JEGkwqvsvNobzKsgvOyXP059ZTXZrzVtGCd
         ZJKA==
X-Forwarded-Encrypted: i=1; AJvYcCWief1cJ3NAdKEOp6iDK2VGEqQpA1xslO46M31fVuxi2aMO+RkIP1PpFGMrOL+KVai2ots8ir1pr2H7uzFexb9NzTsweVNMeBBltNyo
X-Gm-Message-State: AOJu0Yx2Wz6Gnm8JL9Od7mj8duPn2UKj7EreqtE7JIGiy9KcK4Hfs4ss
	Qh72ycfscHNoLzpjL2VkwEzeDaJ9DPr+RcFskuhE3eGX9dpdF2zTBFULKIc7Xos=
X-Google-Smtp-Source: AGHT+IEtSZncKJsrNhscDuBg2ooT2R3yBeExJ8WkgH59BQVHeShDTmQBJQR5acthD/BW5B0kKMMQEw==
X-Received: by 2002:a5d:5f45:0:b0:367:35d7:bf11 with SMTP id ffacd0b85a97d-371777968d8mr4691884f8f.25.1723720825209;
        Thu, 15 Aug 2024 04:20:25 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37189897029sm1246243f8f.74.2024.08.15.04.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 04:20:24 -0700 (PDT)
Date: Thu, 15 Aug 2024 14:20:20 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bhoomika K <bhoomikak@vayavyalabs.com>,
	Ruud Derwig <Ruud.Derwig@synopsys.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] crypto: spacc - Check for allocation failure in
 spacc_skcipher_fallback()
Message-ID: <2d0fd293-31a0-4116-a3ed-5e259864e561@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c352e73-714a-476e-8e71-eef750f22902@stanley.mountain>

Check for crypto_alloc_skcipher() failure.

Fixes: c8981d9230d8 ("crypto: spacc - Add SPAcc Skcipher support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/crypto/dwc-spacc/spacc_skcipher.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/dwc-spacc/spacc_skcipher.c b/drivers/crypto/dwc-spacc/spacc_skcipher.c
index 488c03ff6c36..8c698b75dd92 100644
--- a/drivers/crypto/dwc-spacc/spacc_skcipher.c
+++ b/drivers/crypto/dwc-spacc/spacc_skcipher.c
@@ -67,6 +67,8 @@ static int spacc_skcipher_fallback(unsigned char *name,
 	tctx->fb.cipher = crypto_alloc_skcipher(name,
 						CRYPTO_ALG_TYPE_SKCIPHER,
 						CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(tctx->fb.cipher))
+		return PTR_ERR(tctx->fb.cipher);
 
 	crypto_skcipher_set_reqsize(reqtfm,
 				    sizeof(struct spacc_crypto_reqctx) +
-- 
2.43.0

