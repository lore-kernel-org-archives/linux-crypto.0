Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445D2286D4D
	for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 04:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789534564; cv=none; b=fF7bXtlqVmZdc88NYB5TkhN4NKx8Wq5/1yGZlc3Y5/1fNIHve2PJhrDuTxi+pvzhkh8iiAsATWf7le8E4phLTCoaCN8gSzJOursLUFu/S6elZ8QZ37PmKWEM4VEGYMEr95nv7UbfWoNNwah44i/AHvVTnH3sp8JANWNrF2OOWyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789534564; c=relaxed/simple;
	bh=/y3E593iRUA37jO7B38pBXA7r37+dX3kgWb6Dllnr30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c1jlel8HWpEOMQqW8BXar/TLgO30zrIN9m3d5NIECExISluMaE3JnULTtuSOEdeghb70xwwnN6eYPzUpbp5bJy6ma8+iEBDp/gWUYG4L5yZlVrqm1nthSPVaIptuIPFxatUfG/qLGToZZxm7gcgYqkNbYqSuHm8bvN2DkxhkdXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dw7jm/qO; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dw7jm/qO"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747ee1f38so4913355ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 21:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789534562; x=1790139362; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NH5SR9jg7eNT12/RBDArov96uanRr4HR7KrIlDgUX+4=;
        b=dw7jm/qOs+Zdasl6A5QzGg89Jluc1GsMiN3uCNh4DUsqJhagQh6gabpmqlyS4vTMyF
         kXQXxPlM6IU66Pctwrxbwanvrv2pRXI4uSU/kINNH6zFKUGcQiAr+hfXojoif/xRTpZB
         XwTHrG5+XbxSWmF4CkRZj2gKV/MD3tXHinD4lgLLjX2eujiLC+1CGFVXvq2JqN640M6H
         0LAV4DJneQFVCJEuaCAk3UlF/WqA+zEpEBP9zQtoNZWRE0mFQTt9dMhwcxr4WuF+voKt
         nGALsx8JvOl3cTmpBD0Jf3Zq2mLoHZSIOjnGKygG2ghcgYsS57mSiYQ0EhEwmSWp+46s
         YhSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789534562; x=1790139362;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NH5SR9jg7eNT12/RBDArov96uanRr4HR7KrIlDgUX+4=;
        b=jwMpB8290uSLwJco0snmVDzHRYAeWQh8WUanoASdULLVKhfMowmaedKSJQPUCOtjwg
         9BNOPksu0JrSKv36aKvP+nx7BegOMFbMIDk2Xc2+Z/Runz46jQTuqH9F7ktlb+GXDFGZ
         a7dh2+LPv4XRS2kNlTkS/kM+w8IxN9Zy3LGyytbqUr2RAT2yhh9q1MIIvAUcVEYyU680
         gcSa+UyiteSoAhE5ZLMYYtXH/eiHXzoYQ+wEPO0IcK4cvsZcEyXsocjKwRm+zSEbE5nV
         vWaOFClgyHbSwokzYyld13UNlRzxNQf+f3/42eXOVku5pjcjczrGZ+OPEAndQDcS/VQL
         kyzQ==
X-Gm-Message-State: AFuF++kM4Qt/s43BcvDLKZlIscI510egFtlY0TCkNbkLKFwwoCqjBIWm
	2Hg8xpKOOo1RMqs8ZnmgHU2lCeh52iSmpkofpTw8p6mdMKhg0198/kW3
X-Gm-Gg: AYBFou03yhwBRHGz4Rrrmi8F+mMqfRUxa9FTmGgqaNrospJ7A5T4XImtjNTJuBr3qCM
	13TwDc6npFb+ZyvQufeyNPvJqumnBydumUypH94x4rq9/AbAZ9U7ZZl4tmbqfx7rh7NJwGeyYwM
	dAhADoFrucZDSX8uCavkWp7+wJnoA9lE89GAvvWY3wMtDGMbxWyg9ehWtt0qdJgr9kby3hDR4r1
	a5CPFltWO8ZlZDuw4NQ8H4FIkU4u44T+AHHpw69pVA8mJcfN1cJuZVWyKQkBXcp0kZHx2tVcQLC
	TbIWbFuWV0wr4bRqPgJn++SdDg6LJ9aHtu1TLhjXA4xnf5fuoAahkw4l4sbLMelAbEZ0pB/oH+G
	r3nb/HmAs/jXKlT5tDCYOY/iZsfftIeBhX7WiGcpVseHdP7vvbxf7d61sphq7WPtgBRRcnaVhVi
	G8eUrAJzgye46qTbtvI4IaWKpelx0iftbsdVs+n2TgBllPohtSX9FCafwQFDqDEx4htzMvgWwPn
	R9ZyxWDoYMc8vjn9g==
X-Received: by 2002:a17:903:2f91:b0:2dd:9112:c4c9 with SMTP id d9443c01a7336-2dd9112ca94mr10220955ad.7.1789534562517;
        Tue, 15 Sep 2026 21:56:02 -0700 (PDT)
Received: from kernel ([45.251.35.123])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5aee8b0sm9261930eec.23.2026.09.15.21.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 21:56:01 -0700 (PDT)
Date: Wed, 16 Sep 2026 10:25:54 +0530
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: clabbe@baylibre.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	jkoolstra@xs4all.nl, lkp@intel.com
Subject: Re: [PATCH v2] crypto/amlogic: Use devm APIs for clock management
Message-ID: <aqohWhV8HLW_J9AY@kernel>
References: <20260901024302.5407-1-raizudeen.kerneldev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901024302.5407-1-raizudeen.kerneldev@gmail.com>

On Tue, Sep 01, 2026 at 08:12:52AM +0530, Mohamad Raizudeen wrote:
> The driver currently gets the core clock and manually enables it using
> clk_prepare_enable(). This requires matching calls to
> clk_disable_unprepare() in the error paths and remove function.
> 
> Switch to devm_clk_get_enabled() instead. This lets the kernel handle
> enabling and disabling the clock automatically, which allow us to drop
> the manual cleanup code and keeps the probe function simple.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202608310329.QgxCCMs1-lkp@intel.com/
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---
> Changes in v2:
> - Dropped the devm_crypto_engine_alloc_init() change due to build
>   failure reported by the kernel test robot.
> - Kept the devm_clk_get_enabled() clock cleanup as the sole focus of
>   this patch.
> - Link to v1: https://lore.kernel.org/linux-crypto/20260821151303.8150-1-raizudeen.kerneldev@gmail.com/T/#u
> 
>  drivers/crypto/amlogic/amlogic-gxl-core.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
> index 169c6eeb51e5..6f4c62ddaf89 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-core.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
> @@ -243,10 +243,10 @@ static int meson_crypto_probe(struct platform_device *pdev)
>  	if (IS_ERR(mc->base))
>  		return PTR_ERR(mc->base);
>  
> -	mc->busclk = devm_clk_get(&pdev->dev, "blkmv");
> +	mc->busclk = devm_clk_get_enabled(&pdev->dev, "blkmv");
>  	if (IS_ERR(mc->busclk)) {
>  		err = PTR_ERR(mc->busclk);
> -		dev_err(&pdev->dev, "Cannot get core clock err=%d\n", err);
> +		dev_err(&pdev->dev, "Cannot get/enable core clock err=%d\n", err);
>  		return err;
>  	}
>  
> @@ -261,15 +261,9 @@ static int meson_crypto_probe(struct platform_device *pdev)
>  			return err;
>  	}
>  
> -	err = clk_prepare_enable(mc->busclk);
> -	if (err != 0) {
> -		dev_err(&pdev->dev, "Cannot prepare_enable busclk\n");
> -		return err;
> -	}
> -
>  	err = meson_allocate_chanlist(mc);
>  	if (err)
> -		goto error_flow;
> +		return err;
>  
>  	err = meson_register_algs(mc);
>  	if (err)
> @@ -290,8 +284,6 @@ static int meson_crypto_probe(struct platform_device *pdev)
>  error_alg:
>  	meson_unregister_algs(mc);
>  	meson_free_chanlist(mc, MAXFLOW - 1);
> -error_flow:
> -	clk_disable_unprepare(mc->busclk);
>  	return err;
>  }
>  
> @@ -306,8 +298,6 @@ static void meson_crypto_remove(struct platform_device *pdev)
>  	meson_unregister_algs(mc);
>  
>  	meson_free_chanlist(mc, MAXFLOW - 1);
> -
> -	clk_disable_unprepare(mc->busclk);
>  }
>  
>  static const struct of_device_id meson_crypto_of_match_table[] = {
> -- 
> 2.53.0
>
Hi, 

Just following up on this patch. Please let me know if you have any
feedback or if further changes are needed.

Thanks,
Mohamad Raizudeen
