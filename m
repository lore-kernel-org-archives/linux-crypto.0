Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A773D7D87
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jun 2026 15:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780326498; cv=none; b=tFffRtLZGSOfdlVxWiuxqqIQSn8S8rc4W9rTuluGrr/WPPf1B3ZD+8to8YFb/+k+0sptRLhngC/fhnrRfIQ3tLfWL24SMKokvgX8kw16pK8TTacovVr3RHopQxg2hJoMpXTTJl2Ccgde1zDxtEIn+p6IMecsMS6GJzVbvmdMN1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780326498; c=relaxed/simple;
	bh=8cYW1eZoP6NBNGgjXZ5EeGzBWJiUFyOZDDX8DreahPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dgt+Bj9f0h07TZxDYPdrqDMu8rHHRakRI/jtt2FR74WZ7fUyMcDjX9h5ABGELwDrKBaHdL0/lCeGt806Ge+sdEdHRAg9eIUdz7Xw6aB8MNJoRrxDVOf42pvvm8aSRINPUFVWUcNaiRuxsGv2THUc0L7ACNCkqV1D7MrbUOX1Ues=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W/eIcnx9; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W/eIcnx9"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45ef82204c6so1214453f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jun 2026 08:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780326496; x=1780931296; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/iDvFkdNstCMV6U6YBcdPpzEdn9fHll2vJW0mE3op7o=;
        b=W/eIcnx9x2qiMXYqTwnjxzj1De0XzRjRutk7v952pCfNih879aCH4qPFA2mxNTkAjr
         GSydIoNShWsyybsfT5UICvLEL0hi9blzHqyQYGBNTB9hk7ry+AOC08WDC/EGmzh6imlu
         JmGYBo1q2p97R51k183KrMDMENdKPpl4dAwpx2QKwHIEirtYWh94vItZJBz+yAIHQIJF
         aJqwf0BcpSYmUh+PBadmQ72dXvsUgwHbt69EYp92qmQg1e0WUoWJJQ4LuNM7gp60xn71
         c1Er8uy9xjGpHoPn87nw8kp4USv63CjP/OG8fVhtiyow+rcLkBofpyO7ZrIRTftBi+AM
         6wTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780326496; x=1780931296;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/iDvFkdNstCMV6U6YBcdPpzEdn9fHll2vJW0mE3op7o=;
        b=rroclLWO9xCkKRewg/sm57pUE0G9bhTPZSE/8/tdw9I+jyb9tbvVq9KTD0zdS2YaVC
         1N2De+bzE4NufxikXUo55a9CTUENp8rQKghdHlFeJdYrPFBSA1bG7GiKYtW79QguRQcV
         0nytKi7/yy4xAivijXeYv0KB/PbYRkdWobTJmsFObR7acAzbeDkvTS63Kvv7YFXPUfuG
         orLgxyDraPzlzWCTaItAJD0a1uV8/SdDdGrV7j6Yv1LJHHZKFP+wLigr3+ITOo1G5hrA
         jB65N5oqwFQ+SZxXLXTIh5wXb7ou1EHPj3RXas+RovlO9I1+x7kcegaKCAPH7le0fAle
         b3Tg==
X-Gm-Message-State: AOJu0Yz12jEfcbik8c0hjORseKbYHD9iE7aVdQV9FljEI0Q2GJVR3yi3
	ixUfHUXA7NqfKlpwoNFJ/pilWSe+6V8GBxH30vs8Svy4lcslN6UPXktu
X-Gm-Gg: Acq92OEoOA26f28BWpp3DVSYLkpvtHlHYOQtg9VBgCRKK42u5dVyy3sVaZ8SL0xslpM
	+8DlsdOEVMrJnAmhQy4MQXZjdrNWuro20juM9eC7zBp7E6bFfhuC6AGEJuMsLIX4OyblL3jK+p8
	0RAbTGEOUHpZxGUpZ4ysBuMG2fk+zMkjNcnOeMgPe/7DO3yAK7l8FQsa6AhGpT07ZzVQtSCf8IF
	ZHK+ku5x+ycBYNSafvgirQqq3Dp04b95bJ2+0e+k5jlq3CPN/D7YOjtw9b+oDike2erXrfXnPyY
	1pi3kpGPScWCcp0eCf8+NZ98OiPKD3ev62NsgtQUb3AUjspRvDykDtPUjDMj+Q7HLg4JJRLOhu5
	Q2h1GPVxQxg4fgPOLa9uSwQHF/2aYwQ37grDlL1Fa2+VkYXHlCZFuyMfJ5NvyC4qW1b9rqOsHhR
	9ME5uoe95o2LI4r5bDaVwfIQadQgelZITZ9Q==
X-Received: by 2002:a05:600d:4453:10b0:490:6869:ef13 with SMTP id 5b1f17b1804b1-490a2918e9fmr148899075e9.14.1780326495794;
        Mon, 01 Jun 2026 08:08:15 -0700 (PDT)
Received: from Red ([2a01:cb1d:897:7800:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4909c6319ddsm245702965e9.0.2026.06.01.08.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 08:08:15 -0700 (PDT)
Date: Mon, 1 Jun 2026 17:08:13 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-sunxi@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: sun4i-ss - Remove insecure and unused rng_alg
Message-ID: <ah2gXTMxfH-ux_J2@Red>
References: <20260529193648.18172-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260529193648.18172-1-ebiggers@kernel.org>

Le Fri, May 29, 2026 at 12:36:48PM -0700, Eric Biggers a écrit :
> Remove sun4i_ss_rng, as it is insecure and unused:
> 
> - It has multiple vulnerabilities.  sun4i_ss_prng_seed() is missing
>   locking and has a buffer overflow.  sun4i_ss_prng_generate() fails to
>   fill the entire buffer with cryptographic random bytes, because it
>   rounds the destination length down and also doesn't actually wait for
>   the hardware to be ready before pulling bytes from it.
> 
> - No user of this code is known.  It's usable only theoretically via the
>   "rng" algorithm type of AF_ALG.  But userspace actually just uses the
>   actual Linux RNG (/dev/random etc) instead.  And rng_algs don't
>   contribute entropy to the actual Linux RNG either.  (This may have
>   been confused with hwrng, which does contribute entropy.)
> 
> Fixes: b8ae5c7387ad ("crypto: sun4i-ss - support the Security System PRNG")
> Cc: stable@vger.kernel.org
> Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---

Acked-by: Corentin LABBE <clabbe.montjoie@gmail.com>
