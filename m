Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEC81A239A;
	Thu, 22 May 2025 20:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747944483; cv=none; b=TT/LiD1XkuhTuT+NTess2e77USOHzEXwDTfKLl7mq37XmuS6ErAmEJIvDteQst3zQBaJctbVIUwYOIDXEFFUl+Flqj6iVzyRr3SA4zCAcWKCfR3+6BW6jkHklJdZYbNYqSvQf6MtpUnCLCwBOJhdIIfjlSz0/drCWHEMYAMsHUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747944483; c=relaxed/simple;
	bh=BUCLC3GDDDNi++xQJV2x9OdVC1R2H2qikmN94FNnCoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=to3w7+YjhdbkNQnxMyohsABVGGlMhu0bCA5+Q4bh8/D8M+B6Vu1chsn+0HZnumRQ7B/o+BL0W1FPtogc0JFFIiQjfxt8zJvfp7/pzUj9BI6EFMTgzR+8ADkZsCTA0VV+Rc1vu9P15hhhHNayo4BXMwxEahK/oPIbRBW1V17ENDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bYXABHYX; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bYXABHYX"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cf680d351so1604345e9.0;
        Thu, 22 May 2025 13:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747944480; x=1748549280; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=G5gpVCcMV1i9snPwFeqD1LIyAIQqJtgrDKNKGxDbPqo=;
        b=bYXABHYXnm2rYsFUuhM+RZ3kjkTt3cZq7Yr2xlPG0z9olASfUljbdoW59M6xzyORYI
         dcUN1Jz2Ol2igVy0uWlyMxJGO5bXlfS1+EE4U6lgB2RVMa2O1ZuVnJ/kZPRuKorlG2L0
         +nee3hwNi7OPUqQ50Gpj90++mpRy9AL2qiyrbQ4iJMGBMQb+Giiy8lp/983OqG4tfXHd
         sR+prGKuNqkQOtm/YzeYA7m6MRqBkKu2uhFjvWKcMYlcj+Aah+7hMZ0tNW2Fx7sqbwJJ
         xP1D1p/V0yBs4aDQHSsgNZavraun5ndk19eqto/lG+NaxtJb1UboiXXBR9V1IIINxGlu
         6Tmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747944480; x=1748549280;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G5gpVCcMV1i9snPwFeqD1LIyAIQqJtgrDKNKGxDbPqo=;
        b=OsFSu65vf3QHTJnLDmoyv55PQYDkpRfbEXo8a4vo+crf3yxqTYhJ9OdoCJXwZGKLMj
         wNFEPWe7MlEIkF3LkDUkDnFjLyWGi+wznDqVvDxSDM+KXNu5zXm/TfwufthWcXLUDS8S
         80lzWdVS3sfgkD5ZGu/SaEw1wIcZ0/zhFt5sA+NNRAMtT6tayX90e2kCIb5DMgezX6TH
         QKLTVz202AmgnO5LNCHDrcEWGDlau7YRUAcy3hUk/gVvon1CM63JbBePHG5F2I2Vb+O0
         RgYD9DWky/mNBdX9DcxP8hny0l04Uq3iqS/LlY0o3fP3gLriUhj0MDw7kVq+rzVfezNf
         wfbA==
X-Forwarded-Encrypted: i=1; AJvYcCV6abiM5ju8CSYGpw1K3q1yWud4oCvKEyzeB20N3y4z0PT3YVGJXBy3G1a9e2UphNizfMnncoFWPd3Mcoc=@vger.kernel.org, AJvYcCXS3YSS4YMUZGxbYH25lR1u3jHad3IJStDaIwPGoybEQw4XxpsYK55XU6j0qmgYNfpzQuVqZM4WgTLpTTWO@vger.kernel.org
X-Gm-Message-State: AOJu0YzjqIDqj0Ks0TzxcpfhSc0C18y4ZhBmVOUtyz/5WtjGSuCt1qiE
	Ai4B9GJXBzPN+W5gWZa9Yn01/PRLijF7f45Ls8WWjV8DOWMHUhCLsrIo
X-Gm-Gg: ASbGncuuWQVSh03CtzNp4lTqsG1LXTfvvzsOJmg0NmIgrZX0rGV4UMxYkw/CWylCAsI
	Aw9U+6DtIwQv1GwzzzrRRo3GSuUyIEa5UeL8akmPOtdlfPCUhYF3qT9cZyRYiYv0rvMSnZyEPiK
	hnyFbagLzqk3zjsDop1GhXbpD8XbUlROxqim7etq5lpe0NVaHk0iJIJRA38t/jDup1kN6nLE8gC
	IKgxHjcnXFK3zDAiHvQnjdafvoxLafHx8LF+p9rr1mOXipjpcTCFw7qKhSy2ld1yDhsIS7/WU32
	o/rzz8+TxMT7qVHi5JAAv1MIC7shkuTeOxc+56q2+HN80WTLKQ/L
X-Google-Smtp-Source: AGHT+IHiscUjYHw6hRgf6vQpphZCl8lZi4zCqb+M0K4BvM0wTOLA0OOWMHCxOMl33M+fLv2bdqFSaA==
X-Received: by 2002:a05:600c:3d92:b0:43d:b33:679c with SMTP id 5b1f17b1804b1-44b529ff7damr8348965e9.14.1747944479294;
        Thu, 22 May 2025 13:07:59 -0700 (PDT)
Received: from Red ([2a01:cb1d:897:7800:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-447f78aea59sm120824755e9.25.2025.05.22.13.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 13:07:57 -0700 (PDT)
Date: Thu, 22 May 2025 22:07:54 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Gregory Clement <gregory.clement@bootlin.com>,
	Christoph Hellwig <hch@infradead.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: crypto: marvell/cesa - dma_alloc_coherent broken but kmalloc +
 dma_map_single works
Message-ID: <aC-EGr50MIVJqwVn@Red>
References: <aCczV6MF6xk5rRA3@gondor.apana.org.au>
 <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
 <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
 <aC2aAvX07Aaho08d@gondor.apana.org.au>
 <aC2uvvzlR89iVFGW@Red>
 <aC2xTI1ZuXoZjgjX@gondor.apana.org.au>
 <aC3cF0-bWb-Jiz4i@Red>
 <aC6TkPM6mOuFwvkD@gondor.apana.org.au>
 <aC7UbAIDA46olNJL@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aC7UbAIDA46olNJL@gondor.apana.org.au>

Le Thu, May 22, 2025 at 03:38:20PM +0800, Herbert Xu a écrit :
> On Thu, May 22, 2025 at 11:01:36AM +0800, Herbert Xu wrote:
> > 
> > So here is the latest debugging patch with dma_map_single on top
> > of cryptodev.  Note that the partial hash mismatch code is buggy
> > but it doesn't matter because it still prints enough info for us
> > to interpret.
> 
> Oops, I screwed up that patch.  Here is the corrected version.
> 

Hello

Here is the result:
http://kernel.montjoie.ovh/479404.log

I have built by adding also your "crypto: marvell/cesa - Fix engine load inaccuracy"

Thanks
Regards
