Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B98288A5;
	Fri, 25 Apr 2025 13:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745589225; cv=none; b=fHxz2TlvsySmi/aQBPlpVAum6bSzoMo7EJUFrK5AUxJer3fHm+J6ufzNtlDsQcHskJyxYIk32hJzmbcJzt8ME+JkAg+3qfCntP7SuxeVqZU6O/CFXI63cPnWh1oiQ4ws+zL0W2zpX4ZS49/FGGjuEdgysIXdUWsAuiJAMYgYv/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745589225; c=relaxed/simple;
	bh=Tgdzoq0uRKVDCSs++A8sHBpH8+Vxgrwn5HHj2Ya/53I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G2zrJSKRgRiw9Cs35Auifa/b0O/AR7LAFGCGD7bMyCILyRFZ0KFlpltNgq1pGF/ccpa8maBBIQSdz16AifuaqdkfjgL5E9UpsnLZKhEfL4rRC2uzXhi+tkSwgjScmoo3iEbHzBzoTXay+FCnYyoxT047Hvz6erKlHJezL57JXFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KzJznMju; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KzJznMju"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39c31e4c3e5so1477713f8f.0;
        Fri, 25 Apr 2025 06:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745589222; x=1746194022; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zC5qCt8mPMFjOd0IN3TufN+hresnNEqhnO+6fQbRG2I=;
        b=KzJznMjuiDpy8JDbqzlzYUC6p1sNwMTtE++JTReH4YTZH6DFOe93+pBaxa6tMJFU74
         6RcWw+PPeUfXLcG85hoGxdGXZY4YoHuITX6AGIpHi08n8dX9W0C9u2CytZtTR9kHLbTI
         VrSFmoNtohjE8cV6uAH8iwyEZX/xeDBGaLJub+qRzVR8JIhEDHqNWWdMhYOUONTsZkxV
         lun2pwrGjA7DBBB2KYq8/8V6Hh1L5HhmB3nDf7p+IJ/vlHmymHzM6RPQCk1c4q7c8hVZ
         nfygAOX17rdS8TKD2STZ4LSsQg+HUiunESeUzlhuC+n5BIOFSYRun3Z7y2E6SU9Rlrt0
         0+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745589222; x=1746194022;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zC5qCt8mPMFjOd0IN3TufN+hresnNEqhnO+6fQbRG2I=;
        b=VCeLnzshq/CKprPxuSulTzZ9vDoJg3NHlK5GPzr1Bp6kRIUOIHlht/UZpWIa0TbQZY
         sgmqEueh5XiCh16/udfqK1N1mG0A08fHIfcpJljz1tKaAJuFdh6tnkb8KiTMXqczBMhF
         1v/cj2YomMeiw5wSyiZi8oEazh6lRwuNsv9EgFY+rbz1SniOh7e0tZWNyKXLZPX87lcA
         ls16F3th0A/EmpFjqSmMnHmZ1xFFHa3u/psa3OaANRczSn7rvj4GS1EH2w2BEGwA749W
         VvHfyHMk9nXH1yaqROCnNmhfXkBSq5eOOMAQHCPSjjFs/89ObLxmA6Emvo52a5nne3U3
         hm7Q==
X-Forwarded-Encrypted: i=1; AJvYcCW3OThrRXUfa9rk88OX4vbCQwTQchek0NilLZ/0P0u+0/1PDNeHp2xbKdH96NenAikrO9Rwqn9QNtH67kjy@vger.kernel.org, AJvYcCWl9MZ2c70aEZEvQ+1snpT5BUG8KuQLnXoza4dUlp4iSiAscpeKT79Vk68TvmqPBnsnR6hhcuc+w7EGONg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaHaDbSBkWW6WqUjPraMSpAQRXeXfP7KkpawCaF6zlntO/r2lZ
	RwcMniN4m1kKVVEKnfi/ffz1nyj5NKg4+KGFGHf8tDeGsGR/guCk
X-Gm-Gg: ASbGnctaq4P1b6BbY9urDbWyX+6ukbWjp4tqQCIPrQ+AMPWb8JKKeXWLEMFbwaY/Dbf
	N3TJ7FxdJwaXNNQ+lLMv0c11iRfur+Tkzwh+N0DIH/Q4olBdoE9UhS3mlH/h1KhKqE45JliUxOK
	O0HjmF90gcY3OmiPngotxsASzmGnnAF673Gtz1FttY2ZoRA4S7KhTVqrRZ1VBNYco08INErC/ax
	HsIY4v8ecruPPVWTWh+2s9pBTJmqtIsNrK1sxxcaQ3IuEv9FkgYHSUhrYd1HFBbRTE3z/QixHin
	DsNninCHvaPYycpSdRdc+WrjToJ5LSl5B6UmvmxB
X-Google-Smtp-Source: AGHT+IGIeg9vP39s+96LGPXe7HvCLrwPRTVeAxK0tbQco/f365rtXoIkERRGnWA87K7ViQhH9sGePw==
X-Received: by 2002:a05:6000:1849:b0:39a:cd84:a77a with SMTP id ffacd0b85a97d-3a074f398f1mr1823393f8f.37.1745589221600;
        Fri, 25 Apr 2025 06:53:41 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a073e46a54sm2462098f8f.67.2025.04.25.06.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 06:53:41 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:53:39 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] crypto: sun8i-ce-cipher - use IS_ENABLED() checks
 for debugfs stats
Message-ID: <aAuT4z3XC2mayIf4@Red>
References: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>
 <20250425124517.2225963-3-ovidiu.panait.oss@gmail.com>
 <aAuOdDhpnLE5bM_y@Red>
 <7653bf7c-03ac-4f94-a80c-2bfa3004d287@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7653bf7c-03ac-4f94-a80c-2bfa3004d287@gmail.com>

Le Fri, Apr 25, 2025 at 04:47:35PM +0300, Ovidiu Panait a écrit :
> Hi,
> 
> On 4/25/25 4:30 PM, Corentin Labbe wrote:
> > Le Fri, Apr 25, 2025 at 03:45:16PM +0300, Ovidiu Panait a écrit :
> >> Add IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG) checks before the
> >> fallback counter updates to make sure the code is not included when
> >> debugfs statistics support is not enabled.
> >>
> >> Also, drop the existing ifdef guards, since 'struct sun8i_ce_alg_template'
> >> is always defined, even with CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG disabled.
> >>
> >> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> >> ---
> >>  .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 46 ++++++++++++-------
> >>  1 file changed, 30 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> >> index f03a8fa7bfa2..433cd18f0b5b 100644
> >> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> >> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> >> @@ -34,22 +34,30 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
> >>  
> ...
> >> @@ -101,9 +117,7 @@ static int sun8i_ce_cipher_fallback(struct skcipher_request *areq)
> >>  		algt = container_of(alg, struct sun8i_ce_alg_template,
> >>  				    alg.skcipher.base);
> >>  
> >> -#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
> >>  		algt->stat_fb++;
> >> -#endif
> > 
> > Hello
> > 
> > You put IS_ENABLED everywhere, but here you remove it, why ?
> > I think you forgot it.
> > 
> 
> This is already part of an IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)
> block, so no need to add an extra IS_ENABLED() check here. Just the
> ifdef was dropped, as it was not really necessary.
> 
> Original code:
> 
> 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
> 		struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
> 		struct sun8i_ce_alg_template *algt __maybe_unused;
> 
> 		algt = container_of(alg, struct sun8i_ce_alg_template,
> 				    alg.skcipher.base);
> 
> #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
> 		algt->stat_fb++;
> #endif
> 	}
> 

Oups sorry didnt check with enough diff context.

So:
Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Acked-by: Corentin LABBE <clabbe.montjoie@gmail.com>

Thanks
Regards
