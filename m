Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD024259C;
	Sat, 10 May 2025 11:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746875668; cv=none; b=Oq7xYVLWceQOLbs//re7kCeai5gQJ9tpcSlvSy6n5Igk5aWjLrYHGg+opZFgRNDLC5S4kRlkaf/OaTBaQqyHFMQWSKSmNtBsulzIuG0SZNFHxwWsZoYnqn6mPBRqkWIi0e9RbHVzHolgoaHu6LpJjpKqbx/X/Br/yCU7taXTCN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746875668; c=relaxed/simple;
	bh=JVuJZLECwi+3pAQ/GOlAuA3lFmiRAQSy82wsmLkDmag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J6+yswFnADn/x7x7FTZ3KugD8tHNKGX+wbjUMJWabLi+XsYMdY8v9tHV8IDxfgiKMGcGqN28R3R+KMA//uil1UGFhFpLUARylbGxqBZDYPgLlaYMV5qtmVFWYe/iMHg+dJ9sB+AY/P8w/avB4c3QY8J1hySQAF+wf/ua59U5AZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JJVek7HW; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JJVek7HW"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43edecbfb94so28858445e9.1;
        Sat, 10 May 2025 04:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746875665; x=1747480465; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4vTd4IdGZfOB83BlB3xpUMaXO+byPkXDIaPQinyrIOc=;
        b=JJVek7HWJTKG8/nQJRVungXbC0lmjiefzvmeUQBdaZXZPX9KrZgvQ2OL4BlcJF/pPU
         brZKmEDdavUlWgXzKXNMloEzsT8l3YKdrI8N0ihQO0YjDeJ9afVepEUn4qGl6RwEeqiY
         qJLEtH8QN2OKtdb2Unx0A2KkLDjrjuSFO1AN7js4jl8tAHvwY3/09cNN3qys3KV0smBB
         PU6+g5tXUGY7MqwmzR49ptbH6WhcU8g20MkP03cRU8wVzXNsQrY+CDFuy22jNNjh6lCK
         Jw2N8I1AM6vSzsLJWOdp791AE8jhK/ZPb7/tJgX6q6/dH1jIkMbGMe3sUOxixSuCHVBF
         8ZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746875665; x=1747480465;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4vTd4IdGZfOB83BlB3xpUMaXO+byPkXDIaPQinyrIOc=;
        b=a7KDzF1lw9ealaBYM+jbKP9yEDP/aDdp3JjKwNTkW9XH+f2ozoH3d7dsvqNYTApBWq
         WKZYD1fMvPBkC9uns8r55v0WXl45obMuiiuM6Zliguxj5xMC3eFgoEBHgWe+3moFm8G9
         ufiWcYB5jobcQ1JBgZxyZDae3l0JoGrpuXw9UEnih93XmFttRqnIgTukfxZYuaOPfSkV
         Q6Ca0OJquH5OsdEDAt2XZpew82xIsAzAdTAgvuEtFW7UItXhjWLNkpx9BHtl3vYfpjSY
         jSSKezqcxaNdmeQqCDD2BazEcOJx7rCOnrPj8iNpP33/3vBl5AQu6R9nCHVSOzl+0768
         +m1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU7NnkYsJnvb+OquIvqhmK5+wooS2RxEtQiX67JiqDgRCCkZt5LJQGiW3GSRHhucw/ehhIEUsXe5oCiKO5d@vger.kernel.org, AJvYcCUcUMvhvuuxUZSNa+IAlziNUT/4OkVIn74Welq0ST8H7uCJjNy+sdjK6GoV9X0GIPf88Kbv6EOvU0tucWM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJxZail9IjpU2e8KSlid6wcjQW6zbW8HD4OQToTYwgNDr7BF+q
	dzsNObtwFihkh+8Jjbt/QG/CQcgnnTE83fId+U1ki9WKPYwSMVfJ
X-Gm-Gg: ASbGncvepfi1L7X2/73IKuLk+Y3q3DrvaoVfms50U1WSih+vkBtdMLGlS9PUZZFz4xC
	uhdAH3ASFc0WVXoI6neX+jQq0vllG4iZBRM1dW0rT7MrHAJ/gHGReyEGd/b+nDZfmgzZSDKQs23
	NJh4lLBa96szK4dm5EILg3vo3vqW5NO0YwndGZZnILlqv7gD0XgXbyJf5hHRorsl9mo1Q431ovr
	EMFxUG9WLSTSZ3Lav2RH1NiVTTrcpkABL5SGIk7vtFUuL1dOofTheZDZ8wz9BaLqewbbTx0rxjq
	RxUOj96uTWsOuzhsYfUGdCiMOj5vTmkhDrWSGZUAjP3Ke/r9SWY=
X-Google-Smtp-Source: AGHT+IEgW6PcLowUSY6cHDwCiuTzQxA1TVJYACarfPwPu1Vm8zE5kVz6VaDYg7EAeFbWII/CCQGalw==
X-Received: by 2002:a05:600c:608c:b0:43c:e70d:450c with SMTP id 5b1f17b1804b1-442d6dbbd6cmr56265225e9.22.1746875664772;
        Sat, 10 May 2025 04:14:24 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-442cd32835dsm102727445e9.6.2025.05.10.04.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 04:14:24 -0700 (PDT)
Date: Sat, 10 May 2025 13:14:22 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aB81Dh83fZoKa2st@Red>
References: <Zw9AsgqKHJfySScx@gondor.apana.org.au>
 <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <dd55ba91a5aebce0e643cab5d57e4c87a006600f.camel@gmail.com>
 <aB8W4iuvjvAZSJoc@gondor.apana.org.au>
 <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>
 <aB8t1ZTVBexqGlcm@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aB8t1ZTVBexqGlcm@gondor.apana.org.au>

Le Sat, May 10, 2025 at 06:43:33PM +0800, Herbert Xu a écrit :
> On Sat, May 10, 2025 at 11:38:16AM +0200, Klaus Kudielka wrote:
> >
> > Patch applied on top.
> > On the first attempt all self-tests passed, but on the second and third unfortunately not.
> 
> This patch fixes the extra zero-length TDMA descriptor, which even
> if it doesn't fix the problem, is obviously the right thing to do.
> 

Hello

I have tried all your cumulated patchs and got: http://kernel.montjoie.ovh/478197.log

This is the git diff result to be sure I didnt miss a patch: http://kernel.montjoie.ovh/cesa.debug.diff

Regards
