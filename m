Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E81227EAC;
	Thu,  8 May 2025 12:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708572; cv=none; b=tdGUOkJJr6Z175NJyhCXxQGC/h1oqmrtYXlOSTadp4pUc3SBEWhTSEncwr+mJu5OmXW4goAoSgJlnGxT2uiW/DsTewsfJihRD7tjlDHSc8Jc+W11KETjfGBzIi5vfokbW58vtR7vlbrBaTv979YloGFs2vbi64hiqi7w/d3yXFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708572; c=relaxed/simple;
	bh=58sdXjoEMjFVCflGE7ncCGuTV1pF4ageHSg4rQYhGrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSNyITYz7CGCpJFS7KTu2r5YBJCca7f+ZRimiaYe6JCKIj1bxWUXJKUazxnHyAQ7Neo5pT6IH8haOYeW72h9r32PjITXPnhngGcJLAbdyhjL83EF4XZu9XvZYtnhpQS4Jn7TXayU7Nk/5cyngI4puWJj54aur+IhyRF+tLnJ51s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d5M0omu2; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d5M0omu2"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a108684f90so293807f8f.1;
        Thu, 08 May 2025 05:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746708569; x=1747313369; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g/Zo3idQAmdiJtBVtWzs8q7ppnKXkar6x4EUIEKDs8I=;
        b=d5M0omu2vkB3KvgD++IKFDTQZ35W4vGmPS+dqvFOamNs4hJs096kVq+DgVeh8+o8u/
         eRzsAT4jD++hQP6eBPxXcGdXFNJklvs2vvY8a3m9cTy4vV6aPzfSrHLpE/qwOqAkeH7y
         rFc1GESkwpeuLbSjbUNBTft6iwU5vqBOqMYCCg8w673OR13Hlqgi/FyRUCfUJezLjpF+
         8Q8TGSk6QSFx17ZoqOhpHIacG9sj+skaqcaYHA5ENy267TiV6oXeL8ekVazxXcpWDkj3
         gAwsNABAUe870H09/hd1MoxiPaQPA9NhBYjTKjsAW7o5m6yU1KKnQ9BM28v02D0z9QtJ
         hAeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746708569; x=1747313369;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g/Zo3idQAmdiJtBVtWzs8q7ppnKXkar6x4EUIEKDs8I=;
        b=cJU52rJTRCscDycfBSOPIzNZ5H/6or9Yo3oEo682OtzdiXHn3iCjFmhmJCK14rb0OQ
         TNc0gLBO+D/LZM5qvvAHYbMzie5H+gXJgQ7hCqdJ8S+e87O6SbmlGcR3LpOgw71shq3V
         jyocIQgVU8z09Lxxdxj2x8CqTk/C6yk19Wdsd5g/r2smv0Uy5kxDiD+yEwOCaQHiR7jo
         NLhXM0I16fsqTi4nbY6nXF0RXJXdJSwOhi6mUK85r1jP9GwtQnOPBN77cr349bLsaLTZ
         LAS3jrCntQnzg1RrHv9/DrSu5EgIV4KpY1kH04m0UABOQgIBwqObOomUtEp4AESLkFz3
         O2PQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdXxzBV8QVo/icTeZWvvxi1bXzAHcKdS5vvw0PjOiA4Z/oDEmet67Fv7QT7BHz+hEXCUhJ29MFOoTM2uqO@vger.kernel.org, AJvYcCXAk3ByXSOM+2szYpubj2ii4sBPnrHyTWVM0Y/J7d2Zvr8ZTauEpnh0/C3RQdnu96fU18uCn6hN6IxW3lw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2h3lbCIs09aMBk85njbEuGf1dUXSUDTl1wcNfWIzVCvOw874S
	LtEOGIEQpe4XlxhS5Y2DMPgwJbzXW+w5c8qAExMKyKCcfFURxHRw
X-Gm-Gg: ASbGncti9HsNksL7hIqAUGj9p8NPBLwM+l2ExEwZkc4YqhS6OYeSUeBq16UnrkJqpVi
	caNDYoQkgTe7NtuiUyuO7dhv7KM19HG4NFgje6QlpCdWNidE4AXzcapVuJpizOA7AYK6P0RBsNu
	fla+dnhPCQcX6MVY64i9vkiLYKBNt6zgDa579IR0Sy5y4SLHmB4cwUxh4DSxo8+j2yf5QVYREZo
	oyhEaZAaZy76wrovrCjkrWqtNuA4t1e2nk5cvlnQFV+Y+G15b4VML2+VmW0wHI0m1aKwBZ36Fx3
	m8JlgQTpdYIeZz+RySRKU8ILd8B94inyUjYyk1B3KA==
X-Google-Smtp-Source: AGHT+IE4V0eQOUc88VL5le6hnYa/WX1pFmGHFpO8rruXlZMME8banCaS9znDvFn5HounZoV3whgt2w==
X-Received: by 2002:a05:6000:2207:b0:3a0:90c3:eb0f with SMTP id ffacd0b85a97d-3a0ba098e52mr1870423f8f.12.1746708568626;
        Thu, 08 May 2025 05:49:28 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a0b9af4ba1sm2879628f8f.59.2025.05.08.05.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 05:49:27 -0700 (PDT)
Date: Thu, 8 May 2025 14:49:26 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [v2 PATCH] crypto: marvell/cesa - Do not chain submitted requests
Message-ID: <aByoVvwNq2DMw1oi@Red>
References: <ZwduxHxQtHdzz-kl@gondor.apana.org.au>
 <ZwePSPG8aWm6mwKK@gondor.apana.org.au>
 <15fadc356b73a1e8e24183f284b5c0a44a53e679.camel@gmail.com>
 <Zw31JIEyh28vK9q7@gondor.apana.org.au>
 <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
 <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aBw-C_krkNsIoPlT@gondor.apana.org.au>

Le Thu, May 08, 2025 at 01:15:55PM +0800, Herbert Xu a écrit :
> On Wed, May 07, 2025 at 05:16:03PM +0200, Corentin Labbe wrote:
> >
> > I tested this patch and my armada-388-clearfog-pro panic with:
> 
> Thanks for testing! I didn't realise that you had one of these.

I have started a bot which try to build/boot automaticly all patches touching hardware I own.
And for the moment it handles only linux-sunxi and crypto patches.
Happy it found something.

> So just out of curiosity, does this driver actually pass the
> self-tests before this patch with CRYPTO_MANAGER_EXTRA_TESTS?
> 
> Is your system SMP? How many CPUs?
> 

It fails to pass selftest on 6.14.4.
It has 2 CPU

