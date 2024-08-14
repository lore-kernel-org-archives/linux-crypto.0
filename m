Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E591C9EB0
	for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 21:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723669933; cv=none; b=ohxxqCxPdmSY9gQup+XfwWkPe4tucDIRSeCj/+2cMQ5vDvsAhMPpLdE+OuY35ApkBQQfJyN2blNDkk5M1EjL2NjzFzL25b+SnV5fhPuF/3OXKqSC/7cLnX5S9dfAF1hhNyx5o/lY9E8BVaDeCpvYMtGZXXePANbEwnLA32JTNew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723669933; c=relaxed/simple;
	bh=NrYy3KCJ93XBrlv0fDajDdUpZNCCuP92065pd5XQ7L0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=hieV3wezdMLAVZnfdRN32ELfVndReVDvABPd1LRlZkgs71Q4QlQdKx/6Qdt4TU1ceU2RTSwzYViB5S85DFChOemsXHAHC126ZlNZFuXEJEKZwbZYKhgUPqCjEVvrduTBbfqZKnRXfqTvXBSPp0lXVC4Y8K95hiyzGiwXb8Ln+K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TGiOsIRo; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TGiOsIRo"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-368440b073bso160755f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 14:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723669928; x=1724274728; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DvinTXy1Pu55Z1s2JUlMWc8o/CYhTf2Gu4R5avb3VKA=;
        b=TGiOsIRooyHcS0msmiFeN891Da1wTkpXIWki0edp2EJhLLJ5MfAF2+UaqSC7QZqsjq
         P4pG3F4eXgjKsYFGFNc8arEneEmNwa2Sk9X+2G9pkyhO84FPDWYW3MI0ykjj/ZzReNqx
         Porr53d+ZJxTxO6HUganSeTyl0D5o0hutV1elxJW5L0KjR7JZQOrAS/7x0bp7WuCID4r
         I+XxvjEgk+0K8kqORFkKnCfB7H85kEglUhfwVAH8zA9b88YTdK7JCd18LbfJoYpnF5o0
         Rz7QnFMOX7h4UlWrQ0LjfDy3GZPaGINO3ymfbvcoO4eI/YHsPdKQ8trmkfCJUiMauFiF
         leWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723669928; x=1724274728;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DvinTXy1Pu55Z1s2JUlMWc8o/CYhTf2Gu4R5avb3VKA=;
        b=YhoWmiwJsmsBAAfoORc3pPNBFPYDHq3b91gFrlwj5uQPJ1jiGEVLmrubqwW1ixjasg
         UL8D6AqwXn4fm5Xjtm9GScOW2PVtzLdny+QQigFbgJAvBr2S6XyAih2alHY9LYdoyLAM
         k7tXYJL7zGzk0mpslGTkp7Nf8goD68XM6LEv/HGHr3UWrcg1h31YcJpe6sg8Mc3nvdzd
         yzm9syyQdHuk/vvh9DEA2EFmhUFnC4VjLCRi8EFD0G3Kir/N1hVGpqcVJZQDAM9fuTrh
         V+JBGQQeaXMKXoYbkUCNo4+eRAMtqfQEF2jco+ae/cjsTE83igQHhShfsOb8Yx3o2Lvo
         wzKA==
X-Forwarded-Encrypted: i=1; AJvYcCW1xbvMPo2rtEuw8HQ7o9lXHUQXkCWvUxN7KtUzTmc7iQF3JWX7GsnjzX+LLcm0hH7Z3fWhJVmiCVAsjLLSSYkvjpcBP63ADKi0VwRC
X-Gm-Message-State: AOJu0Yzu5pvTO6AA8jn2fURkpQaO28UQQMDxmZR1QT2b9do+cRDU3105
	phfGznzQgYhyV157MWqS2fio+zV6Lpc35ZN74N0AtOpF7KjCY0E5MAVNCD2AFa8=
X-Google-Smtp-Source: AGHT+IH6g79uU3REsY1aYPRVUa3GzDJE31zY/2sWg+HmnohPnve8H/2pByk8jsfDM46XuWz95tP5uQ==
X-Received: by 2002:adf:e609:0:b0:36b:ea3c:5c00 with SMTP id ffacd0b85a97d-37186bea9a7mr629717f8f.9.1723669928337;
        Wed, 14 Aug 2024 14:12:08 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429e7e1c5f2sm1477435e9.40.2024.08.14.14.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:12:08 -0700 (PDT)
Date: Thu, 15 Aug 2024 00:12:03 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
	Ruud Derwig <Ruud.Derwig@synopsys.com>,
	Bhoomika K <bhoomikak@vayavyalabs.com>,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] crypto: spacc - Add a new line in spacc_open()
Message-ID: <6e603578-2250-4ace-aa43-818b8f23e2e9@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c12622ca-923e-4aa5-993b-36cee7442ed2@stanley.mountain>

Put the break statement should be on its own line.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/crypto/dwc-spacc/spacc_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/dwc-spacc/spacc_core.c b/drivers/crypto/dwc-spacc/spacc_core.c
index b7630f559973..b9e0d3227f81 100644
--- a/drivers/crypto/dwc-spacc/spacc_core.c
+++ b/drivers/crypto/dwc-spacc/spacc_core.c
@@ -1904,7 +1904,8 @@ int spacc_open(struct spacc_device *spacc, int enc, int hash, int ctxid,
 		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
 				H_SHAKE256);
 		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE,
-				HM_SHAKE_KMAC); break;
+				HM_SHAKE_KMAC);
+		break;
 	case CRYPTO_MODE_MAC_KMACXOF128:
 		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
 				H_SHAKE128);
-- 
2.43.0

