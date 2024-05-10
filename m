Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B058A15FCF5
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 08:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715329737; cv=none; b=WD3X8JgI++lCEP4jCScj98pxRjr7gzXVki70TcebHPdbWPG7d9iPQRIF0Xhvy7yPnUTNAXJ1sSRwPbBZ/KCNMWsgbawrcFrfc8P1GeRRkmVCVQR4yoM9Xs3PDuXR/RvcXO6D8fMGzyoyU83cu1kCnD6GsFWJtRx8ovk9dUfT1yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715329737; c=relaxed/simple;
	bh=Z6vhoN+tJspxH8YJD1gxWYbMt8ljwE4s4VONtOpcAbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aYxXZTtIrWj0n7Fmgi6tGBX0Wms/tLskRjqpuOnc+hlG5XpIhCFi1uQyAY9/xpB8hpsOcYCzlSjEllYvY87URRMySRdVTqIvmDUQdigyiidRcek6pCFiWLeZoOWax96mjfwS7xOuOxnq+NraJ7R+txP+Pu9IDnzsQEAvUEV66Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=DN6ouloA; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DN6ouloA"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6f45020ac2cso1478770b3a.0
        for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 01:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1715329735; x=1715934535; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=doNo3paHA1BbeFdrLe1rWXejPP2AsjlFyEeEAdjWIks=;
        b=DN6ouloArvXITCc3BsGrQctIVvHkAI2AaiWcwqxd+E9EPTJtNisOjztACjtrA+akiG
         w6IposmFKZKZAmEYMo61RHWbnrjQVkC6pq9Qme/ZrqSuQaOrM5npG6RzIsLneXzv9f67
         Rq7EI0oAu//0TgmjT5Ilc4qBJaqWkmF1FNJ0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715329735; x=1715934535;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=doNo3paHA1BbeFdrLe1rWXejPP2AsjlFyEeEAdjWIks=;
        b=D8FOQ898lQonsKBMyB/qtNBVVqxXRm0THQuU6P6YYdKgZ70abdU1idOjLg1bRMlAsF
         uON8sT5ZD3C+0LCIzP+xIp/w3bLnjlTrxARTnMH4F/EusIjbjPF3aHnKljDg3FL1Ew5B
         cZb4rBIEj1RB4PvHTtAYlwFwaTDQI3bl83eYkPNpKZ1kkTqQNVfIr9k4R5Q12YBKjAwX
         u/6QIR9ZC+W4sSdtQEoDMw7IhxkzOOJ6gZsygmjHN08AP3DHzd4YbORJ1T4HkqGqVz5n
         2EHSipiKELfSQDUKqbicNAoS9X1KwWA9wgKPIctGDkzpVuIPCBokpwEfF9ACmer/YePD
         X63A==
X-Forwarded-Encrypted: i=1; AJvYcCXarKBWDOaEJXDKU+YkkD6EQmVcBfVHgc5IXqtyHdWBibYsf9YuGfgD4GZyHtlpKQ5JQgYB1amxUd20tFukjBrvsSXdPmyiPqY0VpUL
X-Gm-Message-State: AOJu0Yxm9VU64SCgvFl7JRzwNhc2jySTjaKuLvEyDy6796O02G36PY2D
	Zb5w+Wg2ZwcqoIe+sK+2IF+++3mij4q8nS7Maj8Yor/YpYPTjxBwj2GgBc5RtA==
X-Google-Smtp-Source: AGHT+IH64iN8OUks6VlJC0zq7fC1ud3tyaN5WYPieBYiGydCH/XE4nQGKjSlY3rotXNIXuWTAEtq3Q==
X-Received: by 2002:a05:6a00:3d54:b0:6f4:4850:428b with SMTP id d2e1a72fcca58-6f4e0355dacmr2053875b3a.22.1715329735089;
        Fri, 10 May 2024 01:28:55 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:de58:3aa6:b644:b8e9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2b2f9c5sm2448283b3a.193.2024.05.10.01.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 01:28:54 -0700 (PDT)
Date: Fri, 10 May 2024 17:28:50 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCHv3 00/19] zram: convert to custom compression API and
 allow algorithms tuning
Message-ID: <20240510082850.GC950946@google.com>
References: <20240508074223.652784-1-senozhatsky@chromium.org>
 <ZjzFB2CzCh1NKlfw@infradead.org>
 <20240510051509.GI8623@google.com>
 <Zj3PXKcpqUPuFJRu@gondor.apana.org.au>
 <20240510080827.GB950946@google.com>
 <Zj3W7OK9kDpneKXR@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zj3W7OK9kDpneKXR@gondor.apana.org.au>

On (24/05/10 16:12), Herbert Xu wrote:
> On Fri, May 10, 2024 at 05:08:27PM +0900, Sergey Senozhatsky wrote:
> >
> > For some algorithms params needs to be set before ctx is created.
> > For example zstd, crypto/zstd calls zstd_get_params(ZSTD_DEF_LEVEL, 0)
> > to estimate workspace size, which misses the opportunity to configure
> > it an way zram/zswap can benefit from, because those work with PAGE_SIZE
> > source buffer.  So for zram zstd_get_params(ZSTD_DEF_LEVEL, PAGE_SIZE)
> > is much better (it saves 1.2MB per ctx, which is per-CPU in zram).  Not
> > to mention that zstd_get_params(param->level, 0) is what we need at the
> > end.
> 
> For these algorithms where the overhead of allocating a default
> set of parameters and then changing them on a setparam call is
> too high, we could stipulate that the tfm can only be used after
> a setparam call (just as we require a setkey before cipher ops).

OK.  I guess for drivers' params support (dictionaries handling etc.)
we take take some code from this series.  You mentioned acomp, does this
mean setparam is for async compression only?
