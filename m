Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F801AC88A
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 11:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723720812; cv=none; b=R7eg4+NUv+nv92eCmlqwF2VACkEw1/szzgDoPqUSI3BGqnQDgnnhng9I0DyIzrvGDPMR9lcjix5PI/PM2JFW1j3TmoH96tCWBPp2i4Ldoc4I7mjfRy5BOphBRcQE2/mcLpoccLheAwz7b4cPNsT0GTU/XHzPlMnkCsnrTSRm3L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723720812; c=relaxed/simple;
	bh=+rx9vl+x75FoWyGwCUxTtmzERdKUHmIGH1zDEF/INZk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Ng9uR3SbsYAHWgblU6uy6heXo0APk4vm3CcBQYRReCE5SsUfOFcV+/AV6kB40za+EYjfuvCIN7M1Jwm17nbuHNuk9MzlXLMtsauXt6Uy/spyueP55YWKvuTWUijYEBdYDuHgf/WJnF2Fo52XItCTkwgr061OO15CI2IExPmljcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=unxTl0kP; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="unxTl0kP"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-530e2548dfdso856455e87.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 04:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723720809; x=1724325609; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a5FdodYMUJlHJKuSCp9GX1nhpR2hEhWwQY2UySRkoYk=;
        b=unxTl0kPMZ5GO/YY+N7XNx37vViuN3aXuD7pDT5xXlKwp8vNVNVMLeoVwrFcQ/Rc1U
         HUh5ffJaVK9h8HsSuIkA3a91DOHROS+ZMotKXu4sfoukR9M6t8ay27aGlzslm29bjuvR
         MkfTNungMFwf1CvnBNGAMdtsyh9O1DziH5kYInM1rZ10f5KO+2m+EBAJ1I5Cni1cDBE2
         +w3O5ZsfHHaS5DXY2riSIQEZVDpqf/M/9FIS/AtVAFgQ5NVcNFfo+/iewkLTmszO1tzP
         VEzfHO8yfLe4Lc5am08XU8hCq3rJXCCutTfe96Q9ZWEXX0kawsrTQQIzG7lqzYUjiPQg
         hk6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723720809; x=1724325609;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a5FdodYMUJlHJKuSCp9GX1nhpR2hEhWwQY2UySRkoYk=;
        b=aFBNLSif5x+jiIo8i/SKWZTIo3m19jmHm6ZJI5iBqbOwvPT4cEcnikkuazeem9V+LM
         GozfpSSWK+Tq5/eVK15KY+bjeZUIT3CsnpMuu1xSl/LHIruPO1t3+1I8Bx3X5IQFBDJ9
         n75RPfeZKgaqEfU85MAw4LsgcNz2itIF+knzt/wylbN0/RiWNwwD0rYi58FBTN3S+M1c
         S76SktD+lSHTJ/V7bRP+9kGxhbdQcYaxryg4YlrlvFP9cd34N9zi7RDBxqaUpdckzPen
         QysWe6+wzz5iJDFG6dkqsVvfx8o9OjYx7kGR3TGEtiJOXyTfTX1OfvSECFWZssjj1vSM
         nX5Q==
X-Forwarded-Encrypted: i=1; AJvYcCU7WrqL7seu/yvIBzeYFTUISmvBud0OSOpJYMX9F0biahtvXUUVIU1aTQL8dws7vt4ziMhvB51umrs/xvo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzV/O9ijQFoOu4arBLVOXvl0adivdWZ0NAG4WXcOEbhtHCh7iVk
	oFgX07XRuke8igUII+l0gWtEv7J8eA6oL1TbeVOGa57vJS1A+vLSm5tz5N60Wqw=
X-Google-Smtp-Source: AGHT+IGDSlIrMpFgn/V8ura8ZIKZtXcMX3El1z5OwXZ8AzCb2FT/8bSO+SRiLiqDp5oxPLs65pOZLg==
X-Received: by 2002:a05:6512:b97:b0:52e:9fe0:bee4 with SMTP id 2adb3069b0e04-532eda59e63mr3297113e87.9.1723720808603;
        Thu, 15 Aug 2024 04:20:08 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429e7987681sm17067555e9.0.2024.08.15.04.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 04:20:08 -0700 (PDT)
Date: Thu, 15 Aug 2024 14:20:04 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	shwetar <shwetar@vayavyalabs.com>,
	Ruud Derwig <Ruud.Derwig@synopsys.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] crypto: spacc - Fix uninitialized variable in
 spacc_aead_process()
Message-ID: <74ca2a96-978d-4d22-a787-04ceaa08aff6@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c352e73-714a-476e-8e71-eef750f22902@stanley.mountain>

Smatch complains that:

    drivers/crypto/dwc-spacc/spacc_aead.c:1031 spacc_aead_process()
    error: uninitialized symbol 'ptaadsize'.

This could happen if, for example, tctx->mode was CRYPTO_MODE_NULL and
req->cryptlen was less than icvremove.

Fixes: 06af76b46c78 ("crypto: spacc - Add SPAcc aead support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/crypto/dwc-spacc/spacc_aead.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/dwc-spacc/spacc_aead.c b/drivers/crypto/dwc-spacc/spacc_aead.c
index 3468ff605957..50ef9053fc4d 100755
--- a/drivers/crypto/dwc-spacc/spacc_aead.c
+++ b/drivers/crypto/dwc-spacc/spacc_aead.c
@@ -823,7 +823,7 @@ static int spacc_aead_process(struct aead_request *req, u64 seq, int encrypt)
 	u32 dstoff;
 	int icvremove;
 	int ivaadsize;
-	int ptaadsize;
+	int ptaadsize = 0;
 	int iv_to_context;
 	int spacc_proc_len;
 	u32 spacc_icv_offset = 0;
@@ -974,8 +974,6 @@ static int spacc_aead_process(struct aead_request *req, u64 seq, int encrypt)
 	    tctx->mode == CRYPTO_MODE_NULL) {
 		if (req->cryptlen >= icvremove)
 			ptaadsize = req->cryptlen - icvremove;
-	} else {
-		ptaadsize = 0;
 	}
 
 	/* Calculate and set the below, important parameters
-- 
2.43.0

