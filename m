Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F296263F2D;
	Tue, 20 May 2025 08:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747729497; cv=none; b=m3fMGBCx9EKyjo2RArSrOYX9l4iT/fsChfY1auXSBEpAq1uMs6UIwk8SijzNwqdQV3mkoDpht0Mjbnvr8uzONFTH7+krdj72sGaS8G0sOGmKHjjPco6DnsEqkLk4aGUj6xtIkBi/2kbNmbwcQ+mQtX3wGqU2dVxKP1oWiGgzJ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747729497; c=relaxed/simple;
	bh=T/BPs7AVr5XnkfJdKRAT/wF0DytkqWa/g+g70eIDPuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bYic9lHQKj8mOJOzcZWqxugj6UGZtBR+blp9xSBStf3Ao87tinFqJJcgyaVaejv8pQcQRk40eEnT3SHQZS3l4MeVTSEEhtxi/SKP2csTBq3Gnkw8steCgh5y0YkInG/L5qpFK/q8/Izry6WsK+tdOpPDDgiKj4oy638Boi9sEQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IVDQifqh; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IVDQifqh"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-442ec3ce724so43388335e9.0;
        Tue, 20 May 2025 01:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747729492; x=1748334292; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pBe9HFmfYkZA0vZ9epGzGQwP62XWv9bdcLFLfgUYqN4=;
        b=IVDQifqhsC2m3ztaUHMi2wYx+qN/+ldul9upZrfLhT3Kb5tMyIldLSBdxPlY8/z7o8
         T1AL9C1oP8o4DMlG76hEdBM0rKVnbAsm56wxXWVNRXy95vwDbKXcs1K4JvtnP/KpMy0s
         oqeyViPq0GpfVmQb/QCAzxImVgc3PjOPQaFmPmZIBix1sP91q+f2udA/AZklXVvCVeRT
         1Zb7yRK6KihJjKYw+qOgC9zkjA98Knb7mPct1hF3xEtCyRXMGfPrC0YoqxDLIfmQB+7l
         xq+qg/cZ0xqM2TLvaj2Y4foEuYBa581JWG+kvS19ym7tTPClIOZWoI7AeXP5kFPqpADx
         aYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747729492; x=1748334292;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pBe9HFmfYkZA0vZ9epGzGQwP62XWv9bdcLFLfgUYqN4=;
        b=XdaxHZENPPdKy1W0e2WepwdLJU/Eq97/TNi5HP2CP1qlMvfj/19etpAamQycMT1iAM
         BiuBI+hvlvp3NFDjqBNj3bXq2T64iWye8QQhN+MBKGDkuLSTeSamD+iRVM7PlpO+yWWa
         43JJab9JbuoS5uv0oxrTStslL7aIPQDCtD025j137vXlnQzWqqOJK25ZjzaQX4d/EhIb
         3rI4mv7doPXzGw2VA3XWx8VUH+mQDz03LR4mkPeVUwQ5LYEereYpr511TmLWbKZIVEDn
         V0bL7RD8N725BLzNEe2ZNIFKWg8z/JISX07aJlUqa7hd1/QQFZEOgocCLrpGB669N0JC
         a3Qw==
X-Forwarded-Encrypted: i=1; AJvYcCWGIq9GZDZFiaoQLljxdlnXE9uCP6xN3hmLlUHp9s3trP3EFFlBPcV+DqIla0yy7vhiegBFHO93wEVvW38=@vger.kernel.org, AJvYcCXCX2klOv7UbhBMdCWdM8Gd+nKW877fME9YEcFQIZGbD1taGHVpNnVgliDP0BabJSoRIMO/v2aPZfhoWW6m@vger.kernel.org
X-Gm-Message-State: AOJu0YyiuaFGQZCCnf4EsZWb/SssJCz+AtrRYIuprC/sSJE19msgT1hM
	9kUaGDXhHyR7Hd74Xvpy6PKCJmr1UmnAA59bwCV7F4bAscf1bZ3cj6v+
X-Gm-Gg: ASbGncsECZZyAfU3ap9te+d1QBPp4Pf5rODh+NawWw328lzzU9JqPgVYBGf+cmVO1H+
	GReuOjbCUzhdCA5zY3CMyjWmop2ERMSuAF8RKeulmo+7xKtui4s1FL/sLOYfhYIAsCSiYYJ4bso
	MiNaWMqM08f6niPYcL/UHKQs0DbripMM//EzG3v7Zw6k7yz2Ku+TvqMM+CNwDfWU+mrHq9jqxhT
	O3UfItrutGqjTvhYiJ4KTdfv0J+c+Ny5IO34aze9mQDLX3Dd3DwEoFuG6hjsoANJQj6YFgG6nUs
	mARLTdp7aIkWUlNDmCgy80dxtpbfJXMVjI1+sldlQuTGaBvpgC52
X-Google-Smtp-Source: AGHT+IFiq7yNzRMHYgxf8Y2AvL/vFL+N/JR75NfHsu+y2i1yEiKH/7J56FYwi2SZ/j61+N05P1IBwQ==
X-Received: by 2002:a05:600c:8597:b0:445:cd3:fa00 with SMTP id 5b1f17b1804b1-4450cd3faafmr73300515e9.4.1747729492130;
        Tue, 20 May 2025 01:24:52 -0700 (PDT)
Received: from Red ([2a01:cb1d:897:7800:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-447f74cce5bsm20578415e9.24.2025.05.20.01.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 01:24:51 -0700 (PDT)
Date: Tue, 20 May 2025 10:24:49 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] crypto: sun8i-ce - fix nents passed to dma_unmap_sg()
Message-ID: <aCw8UVORVj7GFc22@Red>
References: <20250519151350.3442981-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250519151350.3442981-1-ovidiu.panait.oss@gmail.com>

Le Mon, May 19, 2025 at 06:13:48PM +0300, Ovidiu Panait a écrit :
> In sun8i_ce_cipher_unprepare(), dma_unmap_sg() is incorrectly called with
> the number of entries returned by dma_map_sg(), rather than using the
> original number of entries passed when mapping the scatterlist.
> 
> To fix this, stash the original number of entries passed to dma_map_sg()
> in the request context.
> 
> Fixes: 0605fa0f7826 ("crypto: sun8i-ce - split into prepare/run/unprepare")
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Hello

All patches are:
Acked-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>

Thanks
Regards
