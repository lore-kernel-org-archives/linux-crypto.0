Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ED1426438
	for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 09:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789724913; cv=none; b=ObojaqgqHwzEmycWAbHx2i41d1+Z6Me2ADy8HqTNQlcYG9PP7QrZBPYcqQlkr1lkQAndF5NWEMAzO3nxzLOx7+4fN7GgD0uOBuQadI8qgfa+YYa5EXVc/rTDljoTO6Ay4q7Md7bkBHqwxkFfSveAnINLRFEWp5DFUQChl8+lCCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789724913; c=relaxed/simple;
	bh=MZPt/njQ/yiCw9kAPcMxqNM/6hT4kb9aHpexV2YdbAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SozSFMSaBUqiYIl2GMXdvVQ87jWvz12ayLfDurfSl7MSJjKUKP9CXG85UPI7dOa80vifGLndX8vmqQemMJmn+tQbF8ytYlqTGf83/SuSAvAzFr3SOLjGFiUhEyvLjrWCxm2ilimtApxhwB5X3Cjt2l/EPMGEDfdBZ5bEoqJ688g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lO5IHe2h; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lO5IHe2h"
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-39b5b07ec78so384101a91.3
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 02:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789724911; x=1790329711; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dkQa2qIspUk8yEWkIO1+OC37h14n8QshhY0emIiOSZw=;
        b=lO5IHe2horIQRjPV6fQOlYgPhAsfCfgmDyFxuYlJ4pqJgA34BRmWpPb1uHlCNmUTpg
         sbPBgsk/y9Dw5tKPpxThnoz7IdX7EpNhya4IVvAJ+MwvlsM16C/NKU1N5sgqXlIVBLJM
         53qDFEIx0uA3lQCb3owABRbwQLRpD4IqfXhita6fvku9EX7YVDwh4Qr3YFLi9A1E2SsG
         uH+sZesLSx17hVMZYLKq9OZizDGMhDLw/Al8oohTZKaO3PS0mKAkBK8XztDckT/tUQbn
         vRCHhvNU4ZiCwto/TEnYOJKBUmqKcGTrtSlyqNlA686seQvaSXNVf43OkI3WjzSV35+m
         EalQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789724911; x=1790329711;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dkQa2qIspUk8yEWkIO1+OC37h14n8QshhY0emIiOSZw=;
        b=tAAV4ikfc94jV8tONL4g5epPofOEuo/Edp9sOUSma0C2A+TyK9ci0UOVpGWcPt1hKe
         4ji12Wl6Rb8ib/IFMmkxBxxSgZC6u7g2uGb+ZY7s8cmvT5+KgUMK/VJ+txD03YR0nqnm
         oN1f/XztjCGmI+Ibk+cBA6iVeN3eyQY050xFaLdT7Lp6kPsO4skp4G+Vsdk6nNMS24R7
         xAbHuXUCFQil9t29kOUqOC6QchDeOWTz/0uRyV/iVtGdm2NR+TczkhPyng3x9dTpMGWu
         WKxsS6kpft/NnZkTOgPg3ZPH4N04NvEcGvYzB5i1d4rzObnRAvBJI2/OfAg8pExOzCnX
         JNsg==
X-Forwarded-Encrypted: i=1; AKwUvBymPoUMSfDfYNawi+c5LNl7+AIrUAt3w8+Pt7geITc7BrYGHyj6/616Rj/0cWWNC6S7rXxaiPK/vBQgdeU=@vger.kernel.org
X-Gm-Message-State: AFuF++k+tnU3cKg0JDQKLJloV1sO10kaJfZZmXEXtziPG422p61y7KQH
	ltb1/kWTRDjlRba3NpteJIrDk30+rDYiHfoUk6suiuRDsTy7M3ZaWpwD
X-Gm-Gg: AYBFou22ZkrKy1DXYlenre7mSJVZAgov1q9AyokFvtNyQmer2ydYNGLjQ2a3tEJsZOp
	t6l9Z222O/MCaFwlgF35vCiZZpILjT8v6Dtu7y2BP4Sls5ug8Ef6KuDRWgBxhm3MyTvOyaT/OBp
	9eVtu0YdYEFMS8MP7KEdXOVC+cdLRTsn+RLPkSExleHvG7uNVtRTnX/illy6CNd2y5zTObjZy2y
	xXVZ0SeHdOepPP5CxHCeJWupCjwVe5Mv7MJiF984S39XvMCnOiLrArty02ceqWgxiapRx/WLQoi
	EEOLEANQdbItog8W9MAKSDIRHLboytf22id3JohwMFZ6gDa2ggaFf6S8dWzPsIrDprHddw7rBXs
	5Am1/zN9MnZXW3E1K8jsMnsJnbNeVs8v64aJ/tkoGFS6Dzj2ut0vpjnZTQ7MZDTQNeCQYzl83cV
	+NszQQzb3cjdTwcADU6yTaxK/fQjwZyetAEE3PLe2iBmThCW8oGdpwneEswMZ7ZFGYzcYth355D
	pKSBXzaOUSO/wlZjtY=
X-Received: by 2002:a17:90b:548d:b0:398:c3ca:1ebc with SMTP id 98e67ed59e1d1-39e54d11d8dmr4503633a91.18.1789724911233;
        Fri, 18 Sep 2026 02:48:31 -0700 (PDT)
Received: from kernel ([103.219.206.97])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144ce065314sm3547378c88.14.2026.09.18.02.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:48:30 -0700 (PDT)
Date: Fri, 18 Sep 2026 15:18:23 +0530
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: clabbe@baylibre.com, davem@davemloft.net, skhan@linuxfoundation.org,
	me@brighamcampbell.com, jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: amlogic: Fix IRQ handler return value and
 fallthrough logic
Message-ID: <aq0I57b04bh8HAyO@kernel>
References: <20260908160120.4805-1-raizudeen.kerneldev@gmail.com>
 <aqz7tT10SEMCrwV4@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqz7tT10SEMCrwV4@gondor.apana.org.au>

On Fri, Sep 18, 2026 at 06:52:05PM +1000, Herbert Xu wrote:
> On Tue, Sep 08, 2026 at 09:31:20PM +0530, Mohamad Raizudeen wrote:
> > In irqreturn_t_meson_irq_handler(), when an interrupt matches a flow
> > but the status register is empty, the driver prints an error but
> > doesn't return. It falls through the loop and incorrectly prints an
> > `unknown irq` message.
> > 
> > Fix this by returning IRQ_HANDLED immediately after the error print.
> > 
> > Additionally, the handler returns IRQ_HANDLED for genuinely unknown
> > interrupts. This masks false interrupts and prevents the kernel from
> > detecting interrupts. Return IRQ_NONE instead for unhandled
> > interrupts.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 48fe583fe5417 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
> > Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> > ---
> >  drivers/crypto/amlogic/amlogic-gxl-core.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Please check
> 
> https://sashiko.dev/#/patchset/20260908160120.4805-1-raizudeen.kerneldev%40gmail.com
> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Hi Herbert,

Thank you for pointing out. I will send the v2 soon.

Thanks,
Mohamad Raizudeen
