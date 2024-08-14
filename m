Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8A01C8233
	for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 21:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670873; cv=none; b=WKEyoVSex/amqT1w9u0fE2xgwJl2sX3+k143C0VfJ+goCUMbmQLWszRimELtLw8l2s2Tyq2petQ+7pK7bXQaSVw02JUR0HP+5LOlKOxn50qqFcOvf/D8LZfy7dTE4e43vxEIuz5jUR+y558LFJqEiGU3WZPmrNvjykMQpZl/ktI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670873; c=relaxed/simple;
	bh=0uZWJ4CNyNhyFH6KDcEuMgVO7ru5HkFi+NtpedYAtsk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XyYczYoetu+FPAtfXLnFjdHC1CXfvCQizYGgklQzdfKEG348UX7RtDORREvayHgKKPFIv9NViI0MzgWaJ9vs0JFpC2sEmw4PaAAS3ehHQhsmb0c1L1cX63k9qusOsEiUTbuMkRt3revL1JZ/I1BTvxM84CQ1qR2P3cMBAKMd4jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S7H8PdCz; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S7H8PdCz"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2f189a2a841so2729331fa.3
        for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 14:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723670870; x=1724275670; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cAd1X6ahQeMFzahQzlwMdcXtfPH0nhzB2yJEIaQpr4s=;
        b=S7H8PdCzF4wh3Vx6orNeNUmmDKnMK0R8iqpcXjUuqoSoVH8cJPQGqhJbihtv/TAWW0
         VEUFTGkY16gaHmO5ch4NMwxoQawp8GrGS6a8f+2ip+j+aRxaDCI2ZS4lKngrJpRABggE
         COS1FTssi3HPvggGwBAOrRt98rxa7kC5V+26g/dAkQ3HyVIfDXdf7jSLaG99yIoxOQzO
         IW9s7dgqwWnQngUx6dwoq3/cAA7Go+OpzdmJbtO3PlA6xGor6EZeIjXWZsdc+lv8mcJs
         iyFQ47fYojfma/xxMLakGZJ/g6pKG5eQ3Rb2ZYio1V+g1qbDdkqRCDs2LbTc3Ivv6ONn
         gYbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670870; x=1724275670;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cAd1X6ahQeMFzahQzlwMdcXtfPH0nhzB2yJEIaQpr4s=;
        b=H9cbenDCqkqN8GS3VNn7Qllqwt5TCEbBzUBJwSZgm3O4S+jWgdRuXCTA7LNCC5mkK6
         nufo9/90OKucWildTlxHBVTUlC13tX3rf9zhPzjTLO8mOkl0W2Yx3v6kF8ekSwM12AyT
         Gp6LaE3rhAI9FY+fXhlF1f8YBfAUx8/Z8pCs6JS3/BmUwnTw7UpolsjHg8cgpiq6DXNS
         49BpKakKxkO7a9KkbNw5eMmsPlC1RTe5rz/oMidccKh8Eay/t+Ot5oTPb3peqMOghpo2
         tFaMAFqiQKbR8EzKSP7h2rKsCk4QsdNYs0kPexoZHvVmNHvi4zUMSAE+7Or+ybWvU3l7
         il4A==
X-Gm-Message-State: AOJu0YyPwqE7vXN5/b0r7BOSififwU7d5DN4y/qwT9Lpn7ecSNUIBBuu
	AHxV02VDC94SGtIOHb6SXopwCNvOL7J8iIMbtgWIYK5NNFCt/pIq5NInQgKQCNy47M6mhLsymAT
	G
X-Google-Smtp-Source: AGHT+IFT6dDigFk+T9UlKhi3sRVyNbI/NrN2ZSTlDWn/UFbHvTGLR5Dq1RocKCOJwQjO04fvlKgZUA==
X-Received: by 2002:a2e:e0a:0:b0:2ec:56b9:259b with SMTP id 38308e7fff4ca-2f3aa303e3dmr22566161fa.49.1723670869782;
        Wed, 14 Aug 2024 14:27:49 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429e7c03979sm1834265e9.11.2024.08.14.14.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:27:49 -0700 (PDT)
Date: Thu, 15 Aug 2024 00:27:45 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org
Subject: [bug report] crypto: spacc - Add SPAcc Skcipher support
Message-ID: <f61e2eb5-2493-4d7d-a2fa-4b3659c50880@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Pavitrakumar M,

Commit c8981d9230d8 ("crypto: spacc - Add SPAcc Skcipher support")
from Jul 29, 2024 (linux-next), leads to the following Smatch static
checker warning:

	drivers/crypto/dwc-spacc/spacc_skcipher.c:458 spacc_cipher_process()
	warn: bitwise AND condition is false here

drivers/crypto/dwc-spacc/spacc_skcipher.c
    441                 } else if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3)
    442                            & (0x1)) { /* 16-bit counter width */
    443 
    444                         for (i = 14; i < 16; i++) {
    445                                 num_iv <<= 8;
    446                                 num_iv |= ivc1[i];
    447                         }
    448 
    449                         diff = SPACC_CTR_IV_MAX16 - num_iv;
    450 
    451                         if (len > diff) {
    452                                 name = salg->calg->cra_name;
    453                                 ret = spacc_skcipher_fallback(name,
    454                                                               req, enc_dec);
    455                                 return ret;
    456                         }
    457                 } else if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3)
--> 458                            & (0x0)) { /* 8-bit counter width */
                                   ^^^^^^^
What the deal here?  Generally in the kernel we don't allow dead code.  If it's
necessary then we can add it later.

    459 
    460                         for (i = 15; i < 16; i++) {
    461                                 num_iv <<= 8;
    462                                 num_iv |= ivc1[i];
    463                         }
    464 
    465                         diff = SPACC_CTR_IV_MAX8 - num_iv;
    466 
    467                         if (len > diff) {
    468                                 name = salg->calg->cra_name;
    469                                 ret = spacc_skcipher_fallback(name,
    470                                                               req, enc_dec);
    471                                 return ret;
    472                         }
    473                 }
    474         }

regards,
dan carpenter
