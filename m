Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793220997;
	b=3WSQEZh/4Ny2f8yIZgel4pHYWxJ+5+5eTosMVm0yDj3CE4OjQt3lRTB4Eb6oNDXySnFx
	 l2xuORFcA+eAW4ys5l7jTs5LjAKOs8pwu607gTmqok4ccxv4mh9shBFNyOUKpoKRWNzDF
	 oUWZzbWy1Ux8mNdsGwgOUiO+jKgcVJj0hiivRhBTrNcRIqzKPbc8H0/4xmBvOT56bXD2o
	 MFpxYSvD4D/Dbao9i9W8QLsxJXz616V7bokjYae4QumWUzYzQQxtsbo+2uXd7LYW1SBbf
	 /VAqeAJjAQSbg94hyO+RdPL1jz6/1dVefMaktZin6/gpPg3lYOhDnk8u7bR34/YRp1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793220997;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ODTX1Mq0hRb3U0WQ7WjPVnYgtfrvQWKTica7ES+VT4I=;
	b=5QHIRazxHGIykG91uPYNaNRZbUNLwgD0Jt/5XlqNQq4O89rHRJehzMU1If2hXB35wIau
	 z1wP4a80j0RrB2sy7S5Iv+11PSEBU6KtaS5diFK+7G98TA65cla0P+rZYcB3FcdUFs14Y
	 kpO5nyE2ndXLinqWMvmd2Mp5APJyoz9yfZ7Sk5eR7vgYLu2/KEQvh2lLFIfvXVd3g4iRi
	 MG0BOevCAsqO2wPF2tKIE4MdrNd9BC+g1CvNMsHUEiWPgHJKQ/R2acYE23MFY6MTCJp3h
	 971cV7DTMn4YbKlok8YnT+4M2sGtz/5JDXcB+xqmpivFoY8nAoWFXdoTnEsV4m+norg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CZjmXWXX;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D79606A320
	for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 20:56:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9D79606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CZjmXWXX
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so12457905e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 13:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793220995; x=1793825795; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ODTX1Mq0hRb3U0WQ7WjPVnYgtfrvQWKTica7ES+VT4I=;
        b=CZjmXWXXnX+ztXHAuvrQTkbPf+jP/sDF0PnXOpWzwXGpBsdJ1rhg3JnJMulsn1LZtc
         wyfSr73iuW6G6lYTK5qywTRamFK65aw4EhHZpcs3YXXCMYJ182FpfQ0EHPNAOYBiFgz+
         uV0g7eMcsfSrQBk+z2YakRjoz7OW1t+CNZ6e5KYZ7iJQkSRFeL4/v3EBLJB/nHuOxYlB
         AEsAVqT+qXm4fLz6ZXg3F2AkmI4dzFjPtCKKf+RmgYz9Zuloc/ssDOidWLd2kUgUBnto
         nE/cIOG6liqfC08Ld70skugGugDGff6oPpJHsQ+0uGhAbGBDKRIufj2JqR/AH3BoAL7U
         EaGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793220995; x=1793825795;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ODTX1Mq0hRb3U0WQ7WjPVnYgtfrvQWKTica7ES+VT4I=;
        b=pbBrdmyGpHGMuImt/0FHPV+WSiHfatiiXW6JulFe+x4M98abW+PbtbSpM0DCF5S//e
         7dNELNlqld5wNVmQYuH3HnlZ98gBO8A48ZDFs7OCHF2ddCOk5hxDpl+N/MKL9t8LWu81
         Wzhb4sqLLecaw+ZHx0rXwDTb1itNQBLqQXcrDIF9sQu1dIppfMQQuWTGA56eq3yDzOSb
         aWaVXHZDxXuqJLHr9j9mkKQcKXhSBAnKVP7bTYVOWmLw4Aqgrt+ti85ogXYww7B2Qp8c
         RGWgDRVvhcodsi1x2qQ58wXDU1KC0145np6uCPbiQCqW63VmuOZ/lhN+YZP9WPvrfZSA
         Iuqg==
X-Forwarded-Encrypted: i=1; AKwUvBxcWvHmjP6VAGPcP4R5uNwNs2SErjUWdThzmbT/9xbiYKPbv1aUgVrLoJhY3i8+qwjlf+12pl71JFSWTpI=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ+ayaCEFL+purIaLzRh9HIr9kxMNaXiC+ljpx5CZWQz/xbd/Rw
	//CNI0rKb3HMJJK8AKIHXj8fflXX+clJX22poJ3FLmUEsy9EfxWztQ7s
X-Gm-Gg: AYBFou3lSRwKTAQioMXnTzgH5IPv27wSrFaVQwPZTRGLAQWQpVTeElhXTiL7F/CprBt
	rtArRUd2ROH4VqzWwpDwDX+XGmzbNJ9+iywcGR5c179tz08aInMaiBR8VWH7wcKm4i7qfVKO8Er
	plvS8hEQt5baxgC9al0o9/632UxCVkJqT0bNxsPO93YnmhlJJs9noh/1iDjYP/F9OUiUl/OGwRi
	8uBLapNtKhCSQxYc7HQ0LFs+xUCIfdQ3m+Y2cbG2r8ou4TUzeZoQcTfd59ITVL+Xs382krTNAO9
	1tn43sugqVZ10kpYLH1ubYFTblv3z+4B6ku2MkF7IeUsznnvnVbphdJUrbUnjNbQnGrJE/SYcv7
	XmlwRcJg604NhMEjOmtVQtWeiz0SQdn6seOLnHrqewRDctRDosJP+85hOVpeNCAxgrEYkn0krw4
	Q6njg6ihbsyx3CWXGg0Z0cElj8NNqGijtsf57Nn/MOFzSG4iACFP72MolJ9Xj/dFUTBp942O0mr
	5vEk+iosElGPmpEQvxnG/2d1xSNw5tvzXzfon39EnpPGK+qlp9MoymN2wFQFrOE6zbLocBMCYZh
	FpYX3sBSnTJsBTeyAx5z2UWjwBiZuCtgt18NzA4YIKrg77gTQR97AiLIgJLslkfBtQ==
X-Received: by 2002:a05:600c:811b:b0:4a3:59c9:a743 with SMTP id 5b1f17b1804b1-4a967e8d5afmr77924555e9.27.1793220994832;
        Wed, 28 Oct 2026 13:56:34 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f3229dbsm15896115e9.1.2026.10.28.13.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 13:56:34 -0700 (PDT)
Date: Wed, 28 Oct 2026 20:56:33 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>, ardb@kernel.org,
 Jason@zx2c4.com, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: aes: use memzero_explicit() instead of
 memset()
Message-ID: <20261028205633.7625d789@pumpkin>
In-Reply-To: <20261028155134.GA4041913@google.com>
References: <20261028142636.5888-1-raizudeen.kerneldev@gmail.com>
	<20261028155134.GA4041913@google.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Oct 2026 15:51:34 +0000
Eric Biggers <ebiggers@kernel.org> wrote:

> On Wed, Oct 28, 2026 at 07:56:36PM +0530, Mohamad Raizudeen wrote:
> > aes_gcm_decrypt() and aes_ccm_decrypt() use plain memset() to wipe the
> > output buffer when authentication fails. But the compiler can optimize
> > that wipe away, so use memzero_explicit() instead of memset().
> > 
> > This matches every other sensitive wipes in this file, which already
> > uses memzero_explicit() for keystream blocks, tmp buffers, ctx
> > teardowns.
> > 
> > Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> > ---
> >  lib/crypto/aes.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
> > index e1c191551736..7814ef525239 100644
> > --- a/lib/crypto/aes.c
> > +++ b/lib/crypto/aes.c
> > @@ -1733,7 +1733,7 @@ int aes_gcm_decrypt(u8 *dst, const u8 *src, size_t data_len, const u8 *authtag,
> >  		 * Clear the inauthentic decrypted data so that callers won't
> >  		 * receive it even if they fail to correctly handle errors.
> >  		 */
> > -		memset(dst, 0, data_len);
> > +		memzero_explicit(dst, data_len);  
> 
> This isn't for "zeroization" (making the data unavailable in ramdumps),
> though.  It's just so the caller doesn't accidentally use the
> inauthentic data, as the comment right above it states.

It is also a parameter so has to be zeroed anyway.
memzero_explicit() is used to clear on-stack buffers.

David

> 
> - Eric
> 

