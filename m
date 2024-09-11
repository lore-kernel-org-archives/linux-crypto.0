Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3C913D635
	for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2024 08:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726042089; cv=none; b=tPrkQ+rBbboXCK35XPyALOBNlxpIy127ZpRy61ywiZw2GRmvswEWKIAqVPvsCC1LwNqPOi9Bdb0Vhby/4b9jIdIgLvwOdoPiAw06udA5bMjMLA949F1v0gQtZCPhwFU/XkSn5zXovllLEwF6yMyOWB4+yXis8i71btmlw0WFbzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726042089; c=relaxed/simple;
	bh=BQPOpYYCQkhPUhrt8AUfxhvN0AAhfW4ksV1vz5hh/7s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qLDsaqt7FBHrXSehWEgUaaPCpCRM6f+RtTPSwutvy1c9sabl01O9A3lKCnpeyKHKJ9XKXQbQtykBCsHSZS//5wa4golIqyBTLY/KzjjrYr0W7eCtrxS0dEvwJtr6tqjD2CQ+vzffw8eH1e+cO7aThf21Y5p6+nSZrfnMWXERemg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=s2RIX6GT; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s2RIX6GT"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4280ca0791bso60380565e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2024 01:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726042086; x=1726646886; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+gHVaZN7dAIfNeImX+HOoDw8Q1KwcV0Z64ECRxFwdt0=;
        b=s2RIX6GTHCIyOwdFXoaB129FTu6ROnJhELNgT7/AAnrQiSfca7v95ApvJ55VHicLay
         J2UDh5hotNo4mYa/WlMeFyXo8RluyhQBdlLz1A6Kt2qWW7iLW/0uUq1lhvMVDPDZOBER
         2aSNw8RtuQ9apSScO1KkYky8Ubg1+0oLmg65wQKgRiEgsOGJukagUcAL30AfJDlNiyXf
         uOU0wADZpUtrhqqQwfVW/YefoqDjj5MeXsDGXb6Mx9ut2yCp3Dk9KM8IcgGuMoflS/Q1
         bvwdOoznYn9tcSF3cciJJe4zm6qFf1cJfc8hRDjqcmfjC8NeJhxGwTn6oUdruLP0z5wL
         kvVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726042086; x=1726646886;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+gHVaZN7dAIfNeImX+HOoDw8Q1KwcV0Z64ECRxFwdt0=;
        b=oo8r9n8+dsvhZ3rrFJgzPRaLM32qlujP0gC6t3wuqAkV/YPwEBiw/PXPCLih6q0pEc
         qaX+syR8/xaugKgZxWDx0OXbBTH0DA10Opc47ENZSqJ+dQ6wxFrwpk3qBTPYx2wMLwzd
         VBl9oJXi1zi1Qpoc26jaXQxSkDJC4DgnswwQgyMMAZYKfMFTvYmbxWCB4rbRU0GRe7ve
         gWmLexz3bqHHL9faexz1j2IsXFqHxl1grF88w0EvyvDMlSe3nUcJSvwzzkEioBQKiQL7
         LwtFmEH4DVPVI2foGviKSgv4Sl5NE5f/Z85SE0Wws7rCf43DIP9y9p6QYNE1u1QsBXc/
         /D4Q==
X-Gm-Message-State: AOJu0YyWTrGle7ZwtgqimPx9sYRZ/JEifVQhST1mpmv1WHd89vqzDbuN
	h6MeakV5CfvZik1FF67D5hfA76eTb3gZb+TAGQfM/xBv618CV41AgGo2BdU41Xs=
X-Google-Smtp-Source: AGHT+IGamNK4G2v/Eu5KK7iyvryQrssbgu9x2esoCSmnUl7pkELxj3l5jNlufi8E5on19pIFrQXZlA==
X-Received: by 2002:a5d:51c8:0:b0:374:c2cf:c017 with SMTP id ffacd0b85a97d-3788967589fmr9943299f8f.46.1726042085472;
        Wed, 11 Sep 2024 01:08:05 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeb21a68sm134547635e9.8.2024.09.11.01.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 01:08:05 -0700 (PDT)
Date: Wed, 11 Sep 2024 11:08:01 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Subject: [bug report] crypto: algboss - Pass instance creation error up
Message-ID: <7f5c4907-ac4f-4b41-90d0-e00c1e552bf6@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Herbert Xu,

Commit 795f85fca229 ("crypto: algboss - Pass instance creation error
up") from Sep 1, 2024 (linux-next), leads to the following Smatch
static checker warning:

	crypto/algboss.c:67 cryptomgr_probe()
	warn: passing zero to 'ERR_PTR'

crypto/algboss.c
    50 static int cryptomgr_probe(void *data)
    51 {
    52         struct cryptomgr_param *param = data;
    53         struct crypto_template *tmpl;
    54         int err = -ENOENT;
    55 
    56         tmpl = crypto_lookup_template(param->template);
    57         if (!tmpl)
    58                 goto out;
    59 
    60         do {
    61                 err = tmpl->create(tmpl, param->tb);
    62         } while (err == -EAGAIN && !signal_pending(current));
    63 
    64         crypto_tmpl_put(tmpl);
    65 
    66 out:
--> 67         param->larval->adult = ERR_PTR(err);

I wasn't able to find anything which was using this code...

This is assigned on both the success and failure paths so it means that
crypto_larval_destroy() never calls crypto_mod_put(larval->adult).  But I don't
really understand this code well so maybe there is nothing to free at this
point.

    68         param->larval->alg.cra_flags |= CRYPTO_ALG_DEAD;
    69         complete_all(&param->larval->completion);
    70         crypto_alg_put(&param->larval->alg);
    71         kfree(param);
    72         module_put_and_kthread_exit(0);
    73 }

regards,
dan carpenter
