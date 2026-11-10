Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794288727;
	b=0B6O0AK4TMUm6VtltXSq7fz5PaWtN7E1hFlP7FSwKgqYLogPhtZFBw9D0TdbImr0Kz/0
	 kIinuyWZlGZJcNqLotFecl9E+jQ0qdLG/cbfJUUPt5omWperw6FY18DtJSwMJ2gM5OG/Z
	 fZUdSBOxeiNyB2OVXXLurai6Qsuj2LyyqEgk1j4wG+G8uR9DOlD2amnO6S5vcB8I44yy1
	 OgMdvXpoaEXFGqk3DDAavTLsPeOiRD89V4jLgqkO7DOql506KYAig2MyISARmu9R7xsZj
	 pDGSdiXoiHjvNvfNg1wtIkTHtrYR/d1jOt4MAphwqJ0Pc8EX22DP5TPzpeQbJupAGtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794288727;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=xnocq1WZWdoAPVGSUgOgkKPWt/rTa6IdAGYk7ooAxeo=;
	b=eLcuZZtGNw9dEgQyPG6661x/m1s3+BCeq2XN8qNvRqnRmYxK5eyYaNTJq3iOj1Kr7+v7
	 kqT6ADribYy27bbWCYh3nkzMpWjUQg87uFE2dGmT8ugnRd92TqqlSyxqbffj+rNjiu8wS
	 Yjz9YuBJlzfIzjAvSrZIe9iiMl4cDVxdvUwJnSnI6nkeRE+aH7HzqJX9a4RvrI+sx6PyM
	 pR22NFf0yTmiifXT+zlcjwDn0tYQ8yPwIMNYFRTWjuD9IWJbdOQS431XKjR5sH7xsg6BP
	 2ekHg6cixj+W5Pd7qIXJlIoLWXdZSKCSIIobh/5VuaWYdl0x+ZhJ934QgLEXlJyglug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=NKD7nBqu;
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A188606A326
	for <linux-crypto@vger.kernel.org>; Tue, 10 Nov 2026 05:32:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A188606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=NKD7nBqu
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a05b210703so806359b3a.0
        for <linux-crypto@vger.kernel.org>; Mon, 09 Nov 2026 21:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794288726; x=1794893526; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xnocq1WZWdoAPVGSUgOgkKPWt/rTa6IdAGYk7ooAxeo=;
        b=NKD7nBquVIBNB4qaaYR2zKW+bAMipyhfH6k5oIss7pvhTr5H9DNDivmA6LyFBlYTaI
         4uw1kRx4aPbJe3bz/4M6KlZJDaZ3OEIvYm9wlTKWLh2MiMoqB2GfrySxaqYj3Idv/ftJ
         aGTK7fjoiU34fH/KaVYzyLEfPizBt75JslG4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794288726; x=1794893526;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xnocq1WZWdoAPVGSUgOgkKPWt/rTa6IdAGYk7ooAxeo=;
        b=wMvNEkPZvYt1ipmS+S2zO9BOXtXISvWrDI3okbCBRcNhrUzlP/eNQ17Ol9qPijYk68
         baq+acTSswOaepbZbpl7bAu8/KY3KbhofgbQtkEXjKQfVxYn0sC0X6ziL2fcs4HPccJ1
         R1Chs8UOqEhwrQWHSiTKiJ8+xSnzY4UykYwuDXc0eIOLcZlClzZWaZ7KbXkMKciV0/ce
         tpavwaXo5JPhNI7qw/pEbpqVOXk7XSqruqra/+9ei7f3kHopszUEXRzMZkSL7RrNCOsr
         kIjcdxVCjY0IT3l9QPvweQMxvNf2bLg1UObkCc7I/Sxns3WqW4wqzi8s1uPLI4w5qjid
         g+8g==
X-Forwarded-Encrypted: i=1; AL+hErELGay4zjk0J+qJs3NPt+HoDL/k0HgJD5UH2IZ73oNBHvQY0JacFqmn6GR8Xlpef5yBCNdQOwVJSaGrsB8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8ovI6mivx65lukJMI6wdZnLAlPuL4kLzxL3pVH/DUB/A/1oB3c
	jy2IVwi3EOos002Ado+f5oC+DrmDNHh8s/qWjhTFHnk2SHrB2BcQ0fosAS03BXb/k5jw0PATQEz
	sSm0=
X-Gm-Gg: AYBFou1qwF9vJBp2LAnkMPdLsbx4OUNTHHW2J1rh4S5ejnXp+lpeyKHfgvYu6lwNUM+
	IVMcPriHMqoeJoQp0klJbKJY74CxTDk8dbyb+zmNPVUVkiFvLTDAy8to/vlq5W0Rabt563DJyAv
	+QkJwvKxk0jERa2DjuSB/IdWdH43cKotBWwBRFOlEfDDPAFzmmdCDOz+p3469pq5S9Mi/vLTTcg
	5cWv3cH5Xkqg6VYdHa6124Zi0PNx0qc1H4nJobq4TkGMophDu6kpRUxBKLdAWFp34MnvsO0Ylot
	NY/8b0NqOUkjQG4d6BscoSQ1j0Ue+rJ5WLVjcn2eORzVhTvvwVlxnw4GP6hxK2lVOxMvYvjbQH2
	zTbUKmo3X5MuEl0zfdB+10IxfbQs43HaA9C673AayqpshXpFgyyy211SKfgHQuv8hK7UkbNjEmG
	pHRRPxgjWex+dl2Peq+5OvNZeIdBOjXKvCYmL700X88aLOWZ9z5O6J94hPp1EnDjvthvpzll2cU
	fHij9t0zRAfB9A1u1SLHKfCF1ZjB1fOUs8j/QPOSw1ZHSA/Nn6tXqzvoOtgr9Y5WXM5x2l05PHD
	ydGNCuz2aLXMbcfej8e1DnSvJXCK4CpjVo0PYtA3UlPcCTtCngfS9jFEOLocOufVxn78sg==
X-Received: by 2002:a05:6a00:408b:b0:8b5:f9b1:a8cf with SMTP id d2e1a72fcca58-8ba87550f4fmr1854484b3a.51.1794288726218;
        Mon, 09 Nov 2026 21:32:06 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab8dccc7sm400979b3a.52.2026.11.09.21.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:32:00 -0800 (PST)
Date: Tue, 10 Nov 2026 14:31:51 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: sashiko-reviews@lists.linux.dev
Cc: Michal Wilczynski <m.wilczynski@samsung.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Russell King <linux@armlinux.org.uk>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-s390@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>, 
	Nick Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, David Laight <david.laight.linux@gmail.com>, 
	Sungguk <sungguk.na@samsung.com>, Jaehoon Chung <jh80.chung@samsung.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 03/15] zram: lz4hc: reset the dictionary stream once,
 not per page
Message-ID: <avKrj0h8fBNSrfCi@google.com>
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
 <CGME20261106144252eucas1p272c9e37d66ad385db070f941879aecb1@eucas1p2.samsung.com>
 <20261106-lz4-vendor-upstream-v2-3-ee04c3f0d7dc@samsung.com>
 <sashiko-outbox-201613@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-201613@kernel.org>

On (26/11/06 14:49), sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [Medium] zram: high-order memory allocation using kzalloc in
>   lz4hc_create() [1]
> --
> 
> commit 2f51683dc7418bdcd0730283cb7003d8754fcd5f
> Author: Michal Wilczynski <m.wilczynski@samsung.com>
> 
> zram: lz4hc: reset the dictionary stream once, not per page
> 
> This commit moves the LZ4_resetStreamHC() call for dictionary-backed
> streams from lz4hc_compress() to lz4hc_create() so that the stream state is
> only reset once at creation time rather than on every compressed page.
> 
> > diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
> > index d8aa01bb258fe..06286c805cf7c 100644
> > --- a/drivers/block/zram/backend_lz4hc.c
> > +++ b/drivers/block/zram/backend_lz4hc.c
> > @@ -72,6 +72,7 @@ static int lz4hc_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
> >  		zctx->cstrm = kzalloc_obj(*zctx->cstrm);
> >  		if (!zctx->cstrm)
> >  			goto error;
> > +		LZ4_resetStreamHC(zctx->cstrm, params->level);
> >  	}
> 
> [Severity: Medium]
> This problem wasn't introduced by this patch, but should zctx->cstrm be
> allocated with vmalloc() or kvzalloc() instead of kzalloc_obj() [1]?

That's how I have it in my local tree - vmalloc(LZ4HC_MEM_COMPRESS).
Michal, I suppose you don't base the series on top of linux-next or
Andrew's tree?

We reset the stream when we setup params, so I don't think we need
to do anything in lz4hc_create().
