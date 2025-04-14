Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E587627466C;
	Mon, 14 Apr 2025 14:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744641077; cv=none; b=daFVkET2hudXV9Lk+XjlSR6dbuu8fX3rEQKjdmpT/Iht0uV4I3tZdLatVqxOkKut083X4adCFRnvJ9WsHWNWzE1UXa4hZguRf4i8mjoEMEEVfFHCIskXFt81qNvvWP1cXnyUfebBN9XI6pKOvIIvmL37Rnbfb3A7b3rbGAw0JOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744641077; c=relaxed/simple;
	bh=2gXSInJKusrPdd4J5X6NbBlVa5dxF7j9qgzK0PQiHaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Re3tdNJFVhIF9aDGw8qSgokaJ2iFBIWgbmyvhW7l+bvKMa0BPJswflcpEIG82dI2dYi1JzJWEolSv2n5kJ1ck7ITVTCXSjvCVt/fWxytEyITG/691jGiL2VOfyGC0th33x2f1y0Bpf1MVeoW3nFlEzei2w76NB1XPBiL+p0oUAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PfXOV3Qv; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PfXOV3Qv"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-399749152b4so2332285f8f.3;
        Mon, 14 Apr 2025 07:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744641074; x=1745245874; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HCrgWYM3Hgypgkdhg98cFtG7nn+j6jrPiIXWi6bPyp0=;
        b=PfXOV3QvJjLS3B6OEdGeVZ8Y+UKQhdU5kfWkGWKUrfNkTy42HLVzYxmZrMfXLMy5zL
         Aw8DUxc/Zuoqiw/cm8UdeOI0TiIwiBmU1L0lyVHbsh9XN+/V1I3geYePp9zLCSNuDJQD
         LF5kvFBUMNkaDH/GSheQY8I8Y6/HimFEXyZgn1dnQwdJH12n05j+NwLIfXCijExidcj8
         3/iMkoMVlwplTwipPNw8kBO2qKfF9n3vyr6QZEkDwubA1T8G5QQv7DyeAbTRxbwFnXIO
         0JSTo1100waAbEO1yMOxKpGyLy6qH4at8Ln5GaNeHEPGua3ZjTTMM19aVgjTXdxbGKLG
         3Zmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744641074; x=1745245874;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HCrgWYM3Hgypgkdhg98cFtG7nn+j6jrPiIXWi6bPyp0=;
        b=edGfSowPbPczzgFy+spu+ZYzBwnR4KJAaYxyaOI2HmFukXzNtvjLL4sQDG++pthdsG
         PRlS3UUrIg4nIj2xH7t7eiR+9uzk+BqXIA71zmsMIekmRWVUArGyHfWuaQRx6OYMNeuI
         N6JywS/gUiZwM3K3qTNSa66Pu91YEYtDzO3h9m9r69bjsYKTgxv/h1eNPdVlJtQVNhRN
         qSTEyNhIeiI+C5KZffRwewprf7ivnw5SEWNadaO7NrKDxSisVSNotll2MrhgqeI4+SGZ
         s86m0NS5vkOG3DmRQTYABwjsNKW8fuQ5DsrQJobO6Ixas6SKckHk6VSa9gCsZ5OFfeqv
         2gLw==
X-Forwarded-Encrypted: i=1; AJvYcCUJVt2ysIgyLfCRbK2aBDXBaV/Ccm6/sw4f7WqevTbi7uGxxuuo2ukx6Id/KkZ2XL2vou4s5tw//2wt8FI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlrI1U8CnJNPHHMfKHFgnEPnzOBNjfbSfeZSgxNkwrFWabIqDX
	rOOnEXspluxF2aLWup7oUm9xzRDpJc8ruH8tyyzigAxP01lDunQqGXIS4Q==
X-Gm-Gg: ASbGncu9GIxi6sfwcApBEh5sJ3zFFdR+xlVTsNDA9LtaYMtPeW3oLgWPJcKLNRmn7Nf
	aWmeXCn0oReVC+27OR5BX1fHxefcLFQdTbsPHLWoQn1caST3gu819H3KurZS4XCUM5ReKTC4GKk
	T++U2o1wlBwqsvQZUxLGmYZLQ/guVzjnZ+wzy/nONNBKUzE82bdRoj+0KZAhlNB4Xv9iXpymfKp
	yj+vWEiCRBOOwuBXDErR32vczP6mI8fWZ6mM2zx16HTlF06cDay91B9Cb/kHONaa1Oe+7Yt5BSj
	/0eGHEpx222RhcRTluHaAD7VVukQGdmwwm0COpgzzb9Vfn4Hwxg=
X-Google-Smtp-Source: AGHT+IF4cFQXcUsJCUJ4rTn9rXcC4sO3n9nbDC1x24huqFx1CW67qBr8ulhefX4lOvKb92oRjDJHCw==
X-Received: by 2002:a05:6000:144d:b0:391:4999:776c with SMTP id ffacd0b85a97d-39eaaecdb44mr10571104f8f.40.1744641073750;
        Mon, 14 Apr 2025 07:31:13 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-39eaf43cd17sm11246340f8f.78.2025.04.14.07.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 07:31:13 -0700 (PDT)
Date: Mon, 14 Apr 2025 16:31:11 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 3/4] crypto: sun8i-ss - use API helpers to setup fallback
 request
Message-ID: <Z_0cLywDNhlYIQBd@Red>
References: <20250407123604.2109561-1-ovidiu.panait.oss@gmail.com>
 <20250407123604.2109561-3-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250407123604.2109561-3-ovidiu.panait.oss@gmail.com>

Le Mon, Apr 07, 2025 at 03:36:03PM +0300, Ovidiu Panait a écrit :
> Rather than setting up the fallback request by hand, use
> ahash_request_set_callback() and ahash_request_set_crypt() API helpers
> to properly setup the new request.
> 
> This also ensures that the completion callback is properly passed down
> to the fallback algorithm, which avoids a crash with async fallbacks.
> 
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
> Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
> Cc: Samuel Holland <samuel@sholland.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-sunxi@lists.linux.dev
> 

Herbert I acked but just saw some crash I didnt saw in first look.
Please wait a bit before merging, I verify what is the cause.

Regards
