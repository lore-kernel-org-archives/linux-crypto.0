Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D67B3BD642
	for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 11:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783769023; cv=none; b=gL7wllT7+qK3bPvK/obWXK3dBpvpSy+H0rL/nBJwwMeqL4Pkhp8WECMy+IcDkxu40y74dmVvjIjg5jp0QPVFhI5xyhue7khUyDVdLWpXIR7v3FPjpJq2qvGWyOlFneb2qfYiwwJEfLzyANF2n6qBQ7AnOYTcVV31YIG/5bml/J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783769023; c=relaxed/simple;
	bh=OEYqxVTCTI9USysQOmqLS37+FcyNxiCmGACoc0w05Xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ErriNflXSXTfkpZAegZtmmRCozIx73rvvj4dJYWBRF3r957dYvfw/bTQbhmcyhO56gm1/QDZdT+Ep0i14e1WczQ2veA97LVzWfSQNIholV2D2IQ61P5SY0x1jWTOgmNJyRGyyIbL2+S2YKRVkhleWfKnTw+13ISZsMSi9bh9ff0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=GfItbQ2X; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="GfItbQ2X"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c15f020a223so247475766b.1
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 04:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1783769019; x=1784373819; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=234jl/SdWrM5VnGn/5as0DaA7W5mFTvl5zh/6Ezco9A=;
        b=GfItbQ2X7J0gFAiMF8+EgkPDwLa2Oo95gBipecodccqhlxE2TCrWKudrY4hSg0VPNT
         dW7y/DiKYpCIk+RDvcYdFUYDf9JvQ+BnYnRsmcWhGZiV9Z1oZJSqYh9n/tSSB2lhtwPL
         b5VSj12KvtE68anfzQg+68uRZXHugeLxYNBqtdS4Pl7VACCpw9/iZ/kUCfHXrpcYv6uf
         Yi8vNgyEkbi7pXsbbuJkNjYnh3IxFqel1LYoMvMEDgPAPCLDEKArCh7h4D6cXGrPaJ5y
         +ALN6j0V2mzpZyFYp1C9xtw9ds2jwVkLANwxw/kvslOL+5HHjLC+/eEUCqadoU+Gct0f
         bKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783769020; x=1784373820;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=234jl/SdWrM5VnGn/5as0DaA7W5mFTvl5zh/6Ezco9A=;
        b=UTj4B0FjUjsun1ShV8FUqVn3sCAseEfTVfYMUrIocnPzitaZZ8zEk/J4zSsLCCQEcX
         UccN4/U2YN/jUzz9X3qOAyCO/nT+WkshYkVwyxQCLn9jaffoQs8HNR1NlPxJPdfRohmR
         ftAEIWL1g6E8k07pAr58GsgXGXE/FfZYRx4wibNLJ/CEX+Cxl1rPhTBHJ3ZHhOFBxO4Z
         SMZ83qXiwZMr1kbUTGoj9p2huavIMVwQ6nJh6irMpGfP/byMakpbXwhG7jwLMCDV4iB5
         Z4tKjtfK90JGBsf/tgJbOYtyemuFjYdoUrvoJ9wO9mDFA5/TP3cbSIcqF29NLQI1Qa/f
         +CFw==
X-Forwarded-Encrypted: i=1; AHgh+RoAD1DLPlT3O+iDaJ4NnXImPYA2dZNBtwcN0v1ZWI9xA5iQ9iyZTtNvdug+CKXb5oQ5vQthXeWGf70HGt8=@vger.kernel.org
X-Gm-Message-State: AOJu0YziLUENb+0A/fn5B0SBp07PM2n07CR3VvXAVVpP6KbpLnmba8qe
	jdXHsVBzbp4W/05AOONXsFwGTNGGn9PrpVfD583oI+7Igbdk8Ty97NPQyjfLTZQUjMuBaQ==
X-Gm-Gg: AfdE7cmBIVjWCRK4V3tBWqygUhkgXzS7aAzqNAfS8/wiP2pp15YOQQW9sn+5kAmeqiD
	BqheNUkKaDiaw9zJzP6VO+LR2g/q3dl/zsKYPWh8AsdMtzzYlV2hD3eCp7VpClUG8lNgUTHD8ru
	Ld09OP8E+aiEI3XmNhuKoePdbmUq6jOWnTxFkAfX7zQ7tLnHoe5xr20QiFpoc2NALJS0+Cvsb5E
	3dMslmsogo+ErDGmzCQR0P1UMgDduNrukl5qFm5MLmgclXavLPsWSkkF9rBf5mVe4uiBlXKSLcT
	ycAAAaRSwQrBWr9ygNK2OEJ2a7BePrDvtylAr+f1av2J9lJD0f5r2e2mxbHP/QqV1Y2hIzMoENP
	/aRKwXV26OjCoGHPtE8Id9Uxmq0T0vQveRJY2M7IEiRQf/tnVEi0N/5jul4FNoAy3lYQxhI/OF3
	C1Z6jstl2HtR2k7sATg2geO66a5trbs11qi9cinYft
X-Received: by 2002:a17:907:25ce:b0:c15:ce72:9350 with SMTP id a640c23a62f3a-c161ed88b0emr98383966b.41.1783769019411;
        Sat, 11 Jul 2026 04:23:39 -0700 (PDT)
Received: from fudgebox (k10193.upc-k.chello.nl. [62.108.10.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15ad694736sm728524666b.0.2026.07.11.04.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 04:23:38 -0700 (PDT)
Date: Sat, 11 Jul 2026 13:23:36 +0200
From: David Gall <david.ccm.gall@googlemail.com>
To: Ignat Korchagin <ignat@linux.win>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Eric Biggers <ebiggers@kernel.org>, Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: rsassa-pkcs1: use constant-time comparison for
 digest and signature verification
Message-ID: <alInuM5TquLTv5QE@fudgebox>
References: <alEr_e-G0L2nxxv-@fudgebox>
 <20260710213718.GD1911@quark>
 <2026071156-masculine-unsold-3567@gregkh>
 <CAOs+rJUPQq88D7YwHyrbTFF-G9Lw7cJ9pcaZBpACP89ES9z00w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOs+rJUPQq88D7YwHyrbTFF-G9Lw7cJ9pcaZBpACP89ES9z00w@mail.gmail.com>

On Sat, Jul 11, 2026 at 09:00:23AM +0100, Ignat Korchagin wrote:
> On Sat, Jul 11, 2026 at 6:19 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Jul 10, 2026 at 05:37:18PM -0400, Eric Biggers wrote:
> > > On Fri, Jul 10, 2026 at 07:29:33PM +0200, David C.C.M. Gall wrote:
> > > > Replace memcmp() with crypto_memneq() for cryptographic digest and
> > > > signature comparisons to prevent timing side-channel attacks.
> > > >
> > > > crypto/rsassa-pkcs1.c: RSA signature digest verification used memcmp
> > > > which can leak valid prefix length via timing analysis, user data
> > > > could reach the leaky comparison via the digest argument to verify.
> > > >
> > > > Assisted-by: gregkh_clanker_t1000
> > > > Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
> > >
> > > While we should use crypto_memneq() on MACs, auth tags, and other secret
> > > data, I don't think we should let it creep into domains where it is
> > > clearly not needed, like public key signature verification.
> >
> > But isn't this user-controlled data and so a user could use it to figure
> > out the key?
> 
> This is signature verification with a public key. So the user knows
> the key already.
> 
> > thanks,
> >
> > greg k-h
> >
> 
> Ignat
Nevermind, my reasoning on how this method is used was faulty. The
crypto_memneq call does not protect against digest forgery, the
public key is already available to anyone attempting verification,
so an attacker can compute the padding/digest offline without needing
the kernel's comparison at all, timing or otherwise.

That said, this function already uses crypto_memneq for the hash-prefix
check a few lines above. I'd argue for consistency it's worth using it
for the digest comparison too.

David
