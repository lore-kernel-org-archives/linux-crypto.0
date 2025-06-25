Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941A41C5D55
	for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 15:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750864911; cv=none; b=vAGwV8Cdlg56SrtHm2jFXY/a92kWP6dfu3jGYHGtANT5DF1ozUo7z0H/i3f53DGfKZFxEzd6jtoMbFRtAemhiMA28Mo1xBni03J7ISfrgFYjzYiymisJ+o69cwpbg5yhk5Hqlb4fEfCa5mz/7YsrZCrlYouyW4Hx6abTvl6fAbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750864911; c=relaxed/simple;
	bh=FwaubJuigsZg8k8QqXeH6ngkMzsk/W7h25YDngdHAZw=;
	h=Message-ID:Date:From:To:Cc:Subject:MIME-Version:Content-Type:
	 Content-Disposition; b=pGF/yhr9wTRdU8Wj3zU/jG7yR7MNET/kTUiIQja1ujoMx4DtH5o/6zhd1EAKH/QxkMU+dexuTIQJoqwzUHgAqfdZxFyoa1tgBm1IhuXk+jPs9T8pZ/zxbWtxy1FT5Ufl0J6u517qvzGytjxv7VzVzMYPsKRd6BIdo4h6bWsLuwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JDGVd0kb; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JDGVd0kb"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-73a8d0e3822so965169a34.2
        for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 08:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750864908; x=1751469708; darn=vger.kernel.org;
        h=content-disposition:mime-version:subject:cc:to:from:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H65QKwaFiR2y48UiapcKDR0YMlcWeER7HaTLLMJ7tpo=;
        b=JDGVd0kbvmGuSM65/m5TnkCWnHrFTGhV00UwzyRJV/dGGUKTisjPiNxfhxuJxmmPIk
         MuXiRJ0SpnzozxXsFrCBXoNV8aUyRnbQa+2AdXGgsfZOXyRCFQs5CeG73LIpjrLjF3Nm
         w+C8o+vHUbXYsQmBe+TfkodRY6Lh51VAbtE6TGWcqDFMvQLAzA0i2f8/WGGBx3vuAXBV
         +Lta5PKM12JT9L0qqS2WjxwK+w96QKNBXvbHwLvj2SuUUA5YT8dXhm1EoRVReH0SxlHs
         eX53kBwRGWG13YdCmhsf2YP2PSteGKNMKxTSl6eJiqMPEY3nOicPJuwpe7xxcD1OeFxv
         zRPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750864908; x=1751469708;
        h=content-disposition:mime-version:subject:cc:to:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H65QKwaFiR2y48UiapcKDR0YMlcWeER7HaTLLMJ7tpo=;
        b=gXxNeSfVvWmmkkfTMHYg5H6uXyByubY0+JiAfvr6TtG5snXhU9Mi+FGBWxAn12S2FI
         bvW0UFFcNUnn6oIQtp/ngk/AsjEnA+sugKsUw0Uzi/fjXizxyRhQ2AhycwlO9SW2yDeA
         CmbLXREXy8p8PzJOzHv2fczmZun78IKp5rmY1fTaNA8PewpQB/tydTmt9wpscK7XJlEd
         VYhWBg2Y4fXxVBy5j7sco/9o92GOiA5P/YQEqjqqi8Oyc6ArEV1kFZSW9ZVZ3IQ9DMXO
         r6bQjCxGswGg2fWJXv8EIFAgYZFtoPQkHxmczJs7x7lG7pjlrEmBJ4eLZvmxKlS3yC2K
         6yiw==
X-Gm-Message-State: AOJu0YylK/fEwhwjUEApQc2eKydKi8Nhrz07yZurYDiw01a9GwP1FMtB
	AVCwa1Lmnw635pHxqnfnEM7vdNVq2c6XTn7XjEf0HZkhR1rl8s4+gRmIk2q214PTtzU=
X-Gm-Gg: ASbGncu6ZKFxD/05loxCNQSPIAqdm2/WuoqA8OEL2jq0AOz/c5/rHYNnv5vcEM97H41
	ZWdKUJM+0tfuhtTwcJRa/rQolbhPOHRx0Fu/3BVFe18oy1xbMQcDV9XOTTIu8JgcncJdhObfkF9
	XHSrIDNY4V8TIZUm071Hr2JMYPQ9fCDiPq/SbjC/HIAjjpz7M9cYh0VXoLxmUegEB9wcgmLBoao
	9BpirYlkgcSFBEMZL83ZtaRkOO3YBHvLhpgBa4pqzXfLoDvM4bmG6RKfNgb5TUSs8noB2FvdP6Q
	KLlPfpW98Mh0jBA08BpyaVjzhrMp7jYEMfqD1qHFsVFUCXIJHZJavXLcNOApd1NYR4iX7A==
X-Google-Smtp-Source: AGHT+IHTpRmOtzQ2zNZRgia8DQxzidgtYee/zpuEiKBhrWpX4A3ipNTBxvQ0xzCaXKw1/NWZxal0vg==
X-Received: by 2002:a05:6830:280e:b0:735:aca2:9bf6 with SMTP id 46e09a7af769-73adc815f81mr2502530a34.22.1750864908634;
        Wed, 25 Jun 2025 08:21:48 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:1fca:a60b:12ab:43a3])
        by smtp.gmail.com with UTF8SMTPSA id 46e09a7af769-73a90cc31d4sm2288915a34.65.2025.06.25.08.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 08:21:48 -0700 (PDT)
Message-ID: <685c140c.050a0220.552db.dab5@mx.google.com>
X-Google-Original-Message-ID: <@sabinyo.mountain>
Date: Wed, 25 Jun 2025 10:21:47 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org
Subject: [bug report] crypto: aspeed/hash - Add fallback
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Herbert Xu,

The patch 508712228696: "crypto: aspeed/hash - Add fallback" from May
13, 2025, leads to the following static checker warning:

	drivers/crypto/aspeed/aspeed-hace-hash.c:453 aspeed_ahash_fallback()
	warn: inconsistent indenting

drivers/crypto/aspeed/aspeed-hace-hash.c
    433 static noinline int aspeed_ahash_fallback(struct ahash_request *req)
    434 {
    435 	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
    436 	HASH_FBREQ_ON_STACK(fbreq, req);
    437 	u8 *state = rctx->buffer;
    438 	struct scatterlist sg[2];
    439 	struct scatterlist *ssg;
    440 	int ret;
    441 
    442 	ssg = scatterwalk_ffwd(sg, req->src, rctx->offset);
    443 	ahash_request_set_crypt(fbreq, ssg, req->result,
    444 				rctx->total - rctx->offset);
    445 
    446 	ret = aspeed_sham_export(req, state) ?:
    447 	      crypto_ahash_import_core(fbreq, state);
    448 
    449 	if (rctx->flags & SHA_FLAGS_FINUP)
    450 		ret = ret ?: crypto_ahash_finup(fbreq);
    451 	else
    452 		ret = ret ?: crypto_ahash_update(fbreq);
--> 453 			     crypto_ahash_export_core(fbreq, state) ?:
    454 			     aspeed_sham_import(req, state);

I guess this should be something like?

	ret = ret ?: crypto_ahash_export_core(fbreq, state);
	ret = ret ?: aspeed_sham_import(req, state);

    455 	HASH_REQUEST_ZERO(fbreq);
    456 	return ret;
    457 }

regards,
dan carpenter
