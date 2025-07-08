Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B9F2DCF46;
	Tue,  8 Jul 2025 12:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751979519; cv=none; b=VNNoKfWADhCTQJAVM8cyf519QecMv0A3Ce22E05HWTvM8IslKLvFkeCo1Bgkeke5vCWOLmpHWlnd8OmDkhFORzAoG/ZXLW/JOs3ZYdvO/bJr0kXOYDbzobRQw4V4C5VkBr4dSfcUTPhMWDBFEHyAC+uIPNAfhMTIB5UY3FZrhgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751979519; c=relaxed/simple;
	bh=U+KD2SfDixKcBf4nlRtTUsKZNe6YPFFReciXtdVOck0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tHR0N8RcQTypidm6n8KzMEWpaa6RIZdO6tYSYjXBq3d4nNiplY4AGF7OSEsH6TcEbQkiNJ+glsbMwqy0DRoZjZkeg2PCwmrrFCo1HG7CttXwAf1Mm46kIHKmB/UmzFu3QIVWhMwV+7bn3m5Q3Y6B/3Z1fPa69Q+f4SiUPUtXAVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=je+z9hs2; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="je+z9hs2"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a4e742dc97so3363986f8f.0;
        Tue, 08 Jul 2025 05:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751979516; x=1752584316; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=S3jJ8BMukDKm1ntMLDCU6/IXiTPsV5zOI4ZOEY7XVrU=;
        b=je+z9hs2Tx/OaOZgGwP17geEVlgd1gjlAcNgYwFQI3ufexLLz0A06WBAz0AbySEu9w
         04iMbjxMVLQkoU+zG0vYrW9aMH15FI61YisBSXxeBFuO77GzNgNyLkFzj2BKrAjSM7mp
         W0XOeBZ5MWT4aI9LoQyPu7mG2Veey/Gt6ae09O6ETba7PMKtyun1MEA24q8ru9yIiDpP
         tH9cFmCqNyolv/+LRvfYIC8MpVqB1TStYMhd6s01DmN+Q8HAPn7WEmRYFz5wjq1rhubq
         3CcI6Xjdo14JDrGVHzTR15eTXy2yYw9OXrcOUK3YeXYHulatO4YGMJKY9xkPbVOdRSzS
         +ZlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751979516; x=1752584316;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S3jJ8BMukDKm1ntMLDCU6/IXiTPsV5zOI4ZOEY7XVrU=;
        b=gnBEeqEiTFHZALUgq9nwg8MNuD1PKQZEzlxhlv5cthYb+NCsAtpOVPji3+ZmGuET5U
         hpX/gXMazrwFmXYz1+5lhHqyx/KJ2PmGDKSvvL9iClV3n1v0qCQW/1Z+Eys2AgkeieV0
         VZ4nrnOztVP7O72Ck3L0Bap7+8PrYYFfcxIpSTEPGCVkoNcINq8YgUqfKe6kBeVw0EkT
         4Z6ehU84Jw4jKbyjG8V8yLLO+H/nJqVno+tiiNEnz5WXqdDmB/iOOaa8T96ctQXUUkZT
         nWE4TmnoWSFSMqdsR708y9HoM4YA2VqcxvJUf1haI+5IRhu1GQnuGEzeGh5uZ61cscQZ
         R7fg==
X-Forwarded-Encrypted: i=1; AJvYcCUgnHQkeiBmNz/td5hjl9vt7VuVzHWffjHRSNK6Rky7A7TNdGB1oMP7kgwCGob1uizRS5jRh9xC3aZRwFM8@vger.kernel.org, AJvYcCVnLWap5Ih5JnRIqubgA3wtJTyEcR6Dy/pBgK0l1jkZmeqmC5l7xmfQqDrYrFB7jqZemsNb1XawLDiz/uE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcFtQh01CeNY5Uh83V2M7WzJ1ujI+U/coRtgzG2piotdg6yJXc
	/pMveJkbI5h7mNgKuenyiXoDru+ZBDi919S1aJqQWmw7Q67LUms5AINl
X-Gm-Gg: ASbGncsl5T4TCGV7Zk/+oFC9ACgZZDmJRPG74Dv/j8jt6AmXZw8Nqmn6XrTfbleDYX+
	pjH3zbYFS1+23saS20ZwqBWNfve6mTs0kejBqJZKwrglR6o8xVhA9IdcGHBlO1w8RtCJT+e8Nta
	Ecc/EH/3rxwRnXYJuygXqPiQR8iorAqcC0bzba7au7XgZAjaRawoOyemQa8GtLxMPHSwp3CFQSU
	xfyRVUwEK+kbliOHTcUr6CRMkm+olZh1nnJxWY4caF57QuvmDESiEnSMX9CwjQJOIrXGQ+QGEAn
	367K+io3hSir+M1Lz8P3OKLaKA6PTRbt0D4b3a4fgR6OYApuUQLTwvDD/w5QxXjyove9zyhxuA=
	=
X-Google-Smtp-Source: AGHT+IHN7LDQiiQu3mRLFgDwPBd6uS5/8IY+itp6iFFjd+pue4GlyC58MYxMurBFSzPsD4KJPUtVaQ==
X-Received: by 2002:a5d:64e1:0:b0:3a3:70ab:b274 with SMTP id ffacd0b85a97d-3b5ddfcea37mr2397438f8f.12.1751979515491;
        Tue, 08 Jul 2025 05:58:35 -0700 (PDT)
Received: from Red ([2a01:cb1d:897:7800:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-454cd43f0dbsm21985665e9.5.2025.07.08.05.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 05:58:34 -0700 (PDT)
Date: Tue, 8 Jul 2025 14:58:32 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/10] crypto: sun8i-ce - remove channel timeout field
Message-ID: <aG0V-P_Zvlzhi2i7@Red>
References: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>
 <20250626095813.83963-2-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250626095813.83963-2-ovidiu.panait.oss@gmail.com>

Le Thu, Jun 26, 2025 at 12:58:04PM +0300, Ovidiu Panait a écrit :
> Using the number of bytes in the request as DMA timeout is really
> inconsistent, as large requests could possibly set a timeout of
> hundreds of seconds.
> 
> Remove the per-channel timeout field and use a single, static DMA
> timeout of 3 seconds for all requests.
> 
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

Yes, timeout was strangely handled, thanks for fixing this

This patch is:
Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Reviewed-by: Corentin LABBE <clabbe.montjoie@gmail.com>

Thanks
Regards

PS: I started to review all patch one by one, sorry for being slow
