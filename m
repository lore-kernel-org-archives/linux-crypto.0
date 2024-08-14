Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40221C9DFA
	for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 21:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723669926; cv=none; b=ot/bJAcvmmp+BqcQA/QMj+4thyYZPCEsavCg9dQEXRu8/8sFc1/ubVYkFddo3ekJneKZ1VD0E12BLQ9KpF5fOj3jPNw5rYU60cIsx6vjjVH8RJb9U5t9NGAgYeELhAlObWFuHsVSss24fK/QPT3stAhKNrsFrZMz5F8UObqi7xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723669926; c=relaxed/simple;
	bh=2GDAnPXDCO8WsPQJmInY0Nku6B4q2ax/ORM0Ijp/ysM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=RViAnzjp8PO04BxbL7Eq2UCRlgn3QYPkWSp3eHzc9M5Wd7bmCHMcOPxYbHP8meP75jiH5QwHNQkL+pSG9p2d24xZLYI/DMsW0SlahN3cqbG6Brz8dxng+SoKX+58PpHMaZSefSIsQ52UEKi6Cxd2ycjyhRGoQmcK3fuUhS04AZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XYMT06+U; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XYMT06+U"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-429e29933aaso1327015e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 14:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723669922; x=1724274722; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wnecrCBfNMIqTbazGYk50cWogArEuWoUivR0Jks7i3o=;
        b=XYMT06+UGYlGN1lEb96xSOoSQqLDnN387B8X2EYAvcTNUkzJno082TZ6PMfosQRUoL
         l2vhewnEfHIT1TcP0K7uxD1poexJRAtNwRmKRCCqdObbFXmR6CaVO3G/lkkIyN642MTH
         IgCW1OgAPZq2iOoWOq+j2Qq+rQ9sqdECnrN5P8hpZByPCD8VPdz3OOvHyFLu8L2fjj8z
         6ILlOKHm5qyym8uaFjUC+0qXiPwG7LWt66GeB94mSc3zjYm4qJsOPklpymJaHuchKQVV
         3Bkfo2D6BVpU6yMKDvr0C3p2/PtNkHLiia7BpK9UrU1Ml9NZTbkxTsamK2FcDQppObLd
         xSrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723669922; x=1724274722;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wnecrCBfNMIqTbazGYk50cWogArEuWoUivR0Jks7i3o=;
        b=GwrVTu4rC0qRjmhY/9r4mGDZVJmmGq/ah0SaIINpgptWmhPy0kUNnR3cjTcljhMkLC
         yerLEHDUcOOiVqe8cy8rxnQpZ6vEh9519SJlUK1BQS2q6ceyRTzsHjgNjXFGw3yCJXFy
         MmhPTSFJnT0KgWoWWEvXsZE15tw/asF1hHCYdjX38V7F+d80Lk9SQIhUXHvNMEEd8mWx
         rcVUyq+eIZsBZ/HEziwRFm1+B5WQ3E6PoTLXnrbmg+YcQE5+9JHXoQeUuN8FbF4oMm4n
         XFDONcwXjwAVml/GExVMH6Q4AldOR9Y7IkWmt0Db0pp0Ir86y5BnmDkyD0OHF3xY5MEz
         Fd7g==
X-Forwarded-Encrypted: i=1; AJvYcCWtOa/bf1TPwtiwKHNBw1lqVtnAyNOHmXVdCfMb8ynrETjyhcO1CoVm2K+jc5qbQ/0xA9zCOvXHiPS/p9GoBS9t4r2LCcHvZ/sUmsUl
X-Gm-Message-State: AOJu0YyLTmGihrOkFVcG9F0SHjtPAn3lUIKZEJfEMhuE+/e9Mat+FhHP
	V9Gr41bwFM6Du3QlVjCUaUp9dr4DL24meFV/8BxBVNhfuviS92ndc1iZYI+FnTE=
X-Google-Smtp-Source: AGHT+IGT4QskXd6JH+wwlH+mb1PDuD4UMLNo4ckVVpaOKI5SBci3hdH8HmXXfH/EyMzKqk/UWE9jnw==
X-Received: by 2002:adf:ec52:0:b0:368:5e34:4b4b with SMTP id ffacd0b85a97d-37177768ef1mr2577439f8f.6.1723669921933;
        Wed, 14 Aug 2024 14:12:01 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37189849a05sm40860f8f.26.2024.08.14.14.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:12:01 -0700 (PDT)
Date: Thu, 15 Aug 2024 00:11:58 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bhoomika K <bhoomikak@vayavyalabs.com>,
	Ruud Derwig <Ruud.Derwig@synopsys.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] crypto: spacc - Fix off by one in spacc_isenabled()
Message-ID: <6327d472-b4d5-4678-b54c-9808a68e3504@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c12622ca-923e-4aa5-993b-36cee7442ed2@stanley.mountain>

The spacc->config.modes[] array has CRYPTO_MODE_LAST number of elements
so this > comparison should be >= to prevent an out of bounds access.

Fixes: c8981d9230d8 ("crypto: spacc - Add SPAcc Skcipher support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
The CRYPTO_MODE_LAST variable is poorly named.  Based on the name you
would expect it to be the last valid value but it's not.  (I'm not
a huge fan of code which uses the last valid value instead of the
size personally, but the names should match).

 drivers/crypto/dwc-spacc/spacc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/dwc-spacc/spacc_core.c b/drivers/crypto/dwc-spacc/spacc_core.c
index e3380528e82b..b7630f559973 100644
--- a/drivers/crypto/dwc-spacc/spacc_core.c
+++ b/drivers/crypto/dwc-spacc/spacc_core.c
@@ -1295,7 +1295,7 @@ int spacc_isenabled(struct spacc_device *spacc, int mode, int keysize)
 {
 	int x;
 
-	if (mode < 0 || mode > CRYPTO_MODE_LAST)
+	if (mode < 0 || mode >= CRYPTO_MODE_LAST)
 		return 0;
 
 	if (mode == CRYPTO_MODE_NULL    ||
-- 
2.43.0

