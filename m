Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA211E8326;
	Thu, 29 May 2025 11:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748517444; cv=none; b=q1awiqbD9xPVA3Ntd9aaRmRLQn5mEp08s/Kw+3Nz1IALspAvO/wHeKo22M46OPD8g8ls5MY92ATc6ZQJtmx2iZImJW7/J8fdr4uHU8xyoBQQWFt7RrDde59luwVzOaUyKfQXFZ/ZgqFMJOy2WNsDUDYzs3EfMFVnpYw25exJjFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748517444; c=relaxed/simple;
	bh=y1WxNsUaaCQ76I6bmdF7st+6K4OmxaslZfaz5YthJcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ohGDG3fXOieUaj6HB/fttSRGIVUtu6DL9B/DxkR5WtChpAEqlvgwn8elpaWjwW8+CnIZCEmiKNh6mwYKuzTG+enm5a5wnSsy8fA+i/imMvN5I16vy2jnbkxbVIXVAH/0lNdXl4QVdRK4OfjwBTSPsg7xX15p6Pu4hoy9PCkftGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gWp0Ebs6; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gWp0Ebs6"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a36e0d22c1so471471f8f.2;
        Thu, 29 May 2025 04:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748517441; x=1749122241; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nlXDRDgb6NELSEvtZDiZWhvLmZhCjsZFnwl0WjO5hXQ=;
        b=gWp0Ebs6W9U8dpJyQRC8XeLUxqC7D84gPD74W7M0+02zf/y1aSKfz9c2c5uqy5nKTj
         QyXhjhm3nDu5BABwVhwNnI2DhwHLpLx05WkgNEeBnW1uPBr4BF8ZqKlU9D5Do/UmEk7g
         /uZqY/Ijva7zclNWSvsG0oPGfZN3owF5FsrSojN+jic3C0dLI0ExXDgYD+L3p8RD30BH
         55Azv/0yX3q6QCJ5lGDdAfwrmAvvNNhlnjj0DJToSbpaeYpws/YL4Xs1LQWq8wLhT1f2
         vy+68j2UL4PpEV/a+54LCFg/suQrOK5Vov3abUvk7BsX/64x0EeO02Fli+Nrc990xpQK
         OwDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748517441; x=1749122241;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nlXDRDgb6NELSEvtZDiZWhvLmZhCjsZFnwl0WjO5hXQ=;
        b=sldIj30fkUMlIgZqJI/95DyCCJjNabo6kR3aODLkoNS9Ow9t/MP1n2l0gLG5SelLJ/
         f4BOsJTdbHg+mUes7KRxij8wzM8mO2nxfNaWMVOn5MvjB6qpz6YdJpK8DriGxRsdNCM0
         J/6CNgEQiTsXHXYBeKNyPX8w56iA1DcSf2aXFU0UI1a/+5kQ9ero1FgcCMVlLHlhWg5Z
         EKJ3TDzDdgocrBME+EhpiYhhnVGTlqdpQ2ne/DmJQhMreYCIzWOTXxM86R+AL95kZDts
         vgJEaPJYbC7GNKU5ppMzxdBA1JUclMmUCitnXWF3i+UhwLldxagc9iW55dhoZk/P6cJr
         S+Og==
X-Forwarded-Encrypted: i=1; AJvYcCUUArnpJARj+qQ89f8ZegMSQuiMRWR5BimaozoaE0c/B3oxz8hRDEpPEfd/GaI0BoeG2ykVP+Mg6qeTssD1@vger.kernel.org, AJvYcCXyztSpzmF/cPoZHvijBqPw7bqrmQ6wS9EePk1LS6bSE14LBCegZKpmbEP5r1kyJC21AEM4T/JRZUFGLr8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxuh4Cmw59v+MGB+dHTJFtfrqFjs2nCMe2HK/TahgrxC95fMBsm
	M6rXDX7pHy7VzmfsXOoTGzX4FPmg+q+BpJOEklmB7zXPnkFZqL/AC3NZWEqYvg==
X-Gm-Gg: ASbGncu8NkANA3g+6yYI5wbXVih5d5zpsO+4zy6bnK7hxfNlRzsQrmAo7KDDHsOgoqB
	ZcAZ+xEk9q+wxJ8TdS1Ho6k3bm2SzRj3DDcDCKsSY23wyRRtZ/75rhzS+VPRM+Uq4l/mLiEzfFN
	QQyw7pZKoCtX10ag8FB7csAfnmPOOkFUQGA/aD0gPrShdXj/8WMqkTIlKsUIUU5wuNyr0lq19Zz
	OFpxr3A9GI5NIU2KK1Oj/cON3RnkR4zONGUabcpgKg9nWpmv8Tzq2B7LfND26RDeCAfjFfykOQY
	5Z5BuQT/chnV/tYphWGeSHRN+uVzDxQTi+bBcPuqrAwQrnCqHCLpj8hBmwE9Lck=
X-Google-Smtp-Source: AGHT+IHtgZ/XW+7fRrlSv/HIrfly33pmvCxjkrQUeDtROrJKxEFcueqCNb0ZrPOIgzS/ZWEMVKb0LQ==
X-Received: by 2002:a05:6000:250f:b0:3a4:eac6:e320 with SMTP id ffacd0b85a97d-3a4eac6e4cfmr5557421f8f.3.1748517440483;
        Thu, 29 May 2025 04:17:20 -0700 (PDT)
Received: from Red ([2a01:cb1d:897:7800:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-450cfc030fcsm16997705e9.15.2025.05.29.04.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 04:17:19 -0700 (PDT)
Date: Thu, 29 May 2025 13:17:17 +0200
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
Message-ID: <aDhCPZwmH515TJav@Red>
References: <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
 <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
 <aC2aAvX07Aaho08d@gondor.apana.org.au>
 <aC2uvvzlR89iVFGW@Red>
 <aC2xTI1ZuXoZjgjX@gondor.apana.org.au>
 <aC3cF0-bWb-Jiz4i@Red>
 <aC6TkPM6mOuFwvkD@gondor.apana.org.au>
 <aC7UbAIDA46olNJL@gondor.apana.org.au>
 <aC-EGr50MIVJqwVn@Red>
 <aDbeNYbwhmG6fzUh@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aDbeNYbwhmG6fzUh@gondor.apana.org.au>

Le Wed, May 28, 2025 at 05:58:13PM +0800, Herbert Xu a écrit :
> On Thu, May 22, 2025 at 10:07:54PM +0200, Corentin Labbe wrote:
> >
> > Here is the result:
> > http://kernel.montjoie.ovh/479404.log
> > 
> > I have built by adding also your "crypto: marvell/cesa - Fix engine load inaccuracy"
> 
> Please try this patch on top of the current mainline tree.
> 
> I've force-enabled the software finalisation code and switched it
> over to kmalloc + dma_map_single.
> 
> Thanks,
> -- 

Hello

I have tried on top of torvalds/master 90b83efa6701656e02c86e7df2cb1765ea602d07

https://kernel.montjoie.ovh/479785.log

Regards
