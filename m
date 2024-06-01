Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346E017FF
	for <linux-crypto@vger.kernel.org>; Sat,  1 Jun 2024 00:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717201462; cv=none; b=J6wj3Sqp7FaLhtARSl1Ia5QEH6yNF6cRI9xs6NcGNZBo4IX8S1CpaN050feeWqqz3IorQQfpr8i5Wx4UEW/sIRlf0BxESi7Z+29oPCRevDOrOi21sdY1uEeZKyQQyUU6ZzKybCuxy2b0VfzSJYcFxtlzJlM941DHEh1CyNC2o60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717201462; c=relaxed/simple;
	bh=nTJRmyINX1K5OVYROITyZVtB3DeRWIRjl3ImpXlYabE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LGStbSMf4uQZG8YSP33wAzJEFn26f2RKIb8xP0cJP/K2pFNqkBPFlaDcw2R3Mh+u8KUbVgIp2e/ouc7mKCRCvlbqqnE8XyJ4/K7BifApX2KqPyNKychiIm/46K8fhh65JDRmX48weVjV18GLRpyjnp6nXhvUptfRDEfK0V+4I58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=DHQ90+CG; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DHQ90+CG"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6ff6fe215c6so2292615b3a.3
        for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 17:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1717201460; x=1717806260; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vVI0Ewx+/uHRtfPvebLbcoAEnaYNZsWW/E4igELq0H4=;
        b=DHQ90+CG8MmSIcq0tUSDYj9ob9ZdkB2vHRwKd7wX4lyMGEnlweGN7nk7DSrGbKHeHh
         9x4iK6BjkqsyRIy7RsPxXyDr1feCICRGLp6HeimO6bVxPC/6SL5HZUyYXkCYQCDDpfsJ
         r3LEXwIl3R8gBH78iYPZ4nCtaGjBYemrRz008=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717201460; x=1717806260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vVI0Ewx+/uHRtfPvebLbcoAEnaYNZsWW/E4igELq0H4=;
        b=TblWIqMhp+umEpihPQwEaFEwLvDTIC4debUaAxs6WewNW45zAexAzpVwDD5/zNZEWT
         mBswGc6WV6fhseFrEvDxjQg8gbNIUiaF3nMmFKwUSA1S7QzB0Q+/onwzDaZkBk+LF7JX
         4gvOYtQjFQL/N1OfbzkgEPizrgN0sHy7TcVP5N2f+mbmgIo2WiH+vYruxcn/IZRpYFDi
         Qk4h/4mPxKZoYvFLcZguXclcxjjRp+p7Y1r2NpISWBBzXKXgweoeO8e0S4pQN1PUeuIy
         PGocWXJRsGE2O6J57QbYZbi5qnHoArtaWMI5QtjXCMY46HnZk+Vvcy72cT/dc/Vp0zL+
         cQfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMCXtQEQrNry2i5KBAvPfb3MJ0Z+DV0GoN+qpmw7INuH705eXGMiZ24j/ompD/4AeXUUc3qs43GqHrD63NDgL+gvN+fSXkgjahTZSY
X-Gm-Message-State: AOJu0YztWZDjEWHMekzGm92qIYR3m63fupzRbzc+gg4174l+5IYXz6k8
	n0Ot6/5CDabzG9/4XnjeDrSVKzSIGUvXzyzNPs3vU/MNslzSpYHyIAY8OgSrT4lsKqkJTHC7vXE
	=
X-Google-Smtp-Source: AGHT+IE58OV03P5z5QEO5aFuMuiQa6C1GahCOi8zmfOKm3VBFtN3U3gZlyGLXew50g4UxKLuJxG/tw==
X-Received: by 2002:a05:6a20:2588:b0:1af:acb1:84bb with SMTP id adf61e73a8af0-1b26f16e881mr4242876637.4.1717201460336;
        Fri, 31 May 2024 17:24:20 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:b7f3:e557:e6df:620b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6323e3d18sm22206425ad.179.2024.05.31.17.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 May 2024 17:24:19 -0700 (PDT)
Date: Sat, 1 Jun 2024 09:24:15 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/3] crypto: scomp - Add setparam interface
Message-ID: <20240601002415.GH8400@google.com>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <84523e14722d0629b2ee9c8e7e3c04aa223c5fb5.1716202860.git.herbert@gondor.apana.org.au>
 <20240531054759.GE8400@google.com>
 <20240531063444.GG8400@google.com>
 <ZlmKX4dD1EcstVmN@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZlmKX4dD1EcstVmN@gondor.apana.org.au>

On (24/05/31 16:29), Herbert Xu wrote:
> On Fri, May 31, 2024 at 03:34:44PM +0900, Sergey Senozhatsky wrote:
> >
> > So passing "raw" algorithm parameters to crypto_scomp_setparam(tfm) can be
> > suboptimal, depending on the compression driver. For instance, for zstd
> > (what is currently done in zram [1]) we pre-process "raw" parameters:
> > parse dictionary in order to get zstd_cdict and zstd_ddict which are then
> > shared by all tfm-s (as they access C/D dictionaries in read-only mode).
> > For zram/zswap doing this per-tfm would result in extra per-CPU
> > zstd_cdict/zstd_ddict allocations, which is a significant overhead.
> 
> If they share the dictionary, why can't they just share the
> tfm directly? Or do you actually need to vary the other parameters
> while keeping the dictionary the same?

Is it possible to share a tfm? I thought that tfm-s carry some state
(compression workmem/scratch buffer) so one cannot do parallel compressions
on different CPUs using the same tfm.
