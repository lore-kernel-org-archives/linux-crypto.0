Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F95510A01
	for <linux-crypto@vger.kernel.org>; Tue, 30 Apr 2024 03:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714447687; cv=none; b=NNJqKKzhqvex5UjPoFt5PmAz0FygrezLGShybNDO4uX7Ql2epagVplmJz9hJIFds5QjN3KuoP/bZ4gLx+e2SgpEVrX/ilOF36oiqEaggR6Qci1EaY64snkHaDnviXDnM2kps0xHZK0rXSs0AXurygvusKfPuBfgNe/68IIq0obk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714447687; c=relaxed/simple;
	bh=X7+tzh36SwxdnVhNwvviplK8DkcDG2Wj7K7DH1U7s+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ce7EmBIpoykUuyU8PAIHZi4YHV3miM91qedf9XK7vuXna7tp+YYBokoej/x3iPh5zq75UNeEhfBi5ZGIKbOD0VHGwZciXGMPuh6p0dIf8EG59XXBYcP2LZwCuRGRFlLUTiKDwFipWWqP41XkwllXniQUb4X6kzh3XZsJZcilqDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=dtxGhOZ9; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dtxGhOZ9"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5e4f79007ffso3384333a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 29 Apr 2024 20:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714447685; x=1715052485; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nI6GVHFEnKQIyhOQ+dRjVDZL1gDFD6/whs+wpxDGxhE=;
        b=dtxGhOZ93rEnTgzqWE3kQTUtrc18Pe+clV1pLmQDsB9i28Oh9L0ib/XAHlWIiJJD6o
         RIMWhqk2RkuCHYrjUrgJru5MaMfKS9a58BX5RCPOBtyqHwJYH20elvZPNnDIIjOzmzuq
         gH2x01sHfn1CT0bgb0SAvVYI+GkuXE1o9iLfA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714447685; x=1715052485;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nI6GVHFEnKQIyhOQ+dRjVDZL1gDFD6/whs+wpxDGxhE=;
        b=AXEXTQjY4rtVChRm4tja/153xHKopYIXkfk337LeLNhL25wRdVedWH5PE4uG+A8j8C
         OEqP5o4ogoBNes0szLCZYkBR82lURQJz+1jXEHahAGWaZr+74RIoF2GeW3CXUQtQ28/q
         B+hKuCIUYAOIX9Y1vCgExE5KVq5aTf+Mpgl2ieT7NFwVEmBmEMr6zvDRCOK1dAr5X1sQ
         /aUazdvGcICNyPTgs/zCo7xCnR7DMd3CQ1SLgurWWd0nQgIIsCix6+7ATvf8Gy0PNQa1
         w3rT3F81kPx2H0TRZrGpYcw7VD/Qr0pHUt+S4Kpyya40KdIxeMddi2hcpJ8zqUjAOl9r
         8qXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCgyUzLWDpv/3JauWeI7quWjb6r6E2/+Iq93gSB305G9D7UTBSJjPrPb7xHnAVT2cJamlheCnbxv6biUEKH9Ichj9k5ezKLDSJu0lq
X-Gm-Message-State: AOJu0YxExAQp5fHNebwAOg93B/5bpDjdgy8021vm8Ho1KwaqMfpm+kQJ
	CAcCMq0/BE68tErgEYCx1aRE35HFIyK96hH5pSxtjr5+roxyQ7iaGbeu0BPhjw==
X-Google-Smtp-Source: AGHT+IGTEFpQfg9hB4l411n77KX9sgz2Y96n//ejpLU1YmuQrQYO1xWNepZdQdzOcj9axS99PfdhGw==
X-Received: by 2002:a05:6a20:7f9e:b0:1aa:6167:b6d6 with SMTP id d30-20020a056a207f9e00b001aa6167b6d6mr1793420pzj.42.1714447685254;
        Mon, 29 Apr 2024 20:28:05 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:e55f:86cd:c9e1:6daf])
        by smtp.gmail.com with ESMTPSA id m14-20020a17090a668e00b002a6e67e197dsm19946952pjj.45.2024.04.29.20.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 20:28:04 -0700 (PDT)
Date: Tue, 30 Apr 2024 12:28:00 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] crypto: passing configuration parameters to comp algos
Message-ID: <20240430032800.GF14947@google.com>
References: <20240430030447.GE14947@google.com>
 <20240430031847.GB10165@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430031847.GB10165@sol.localdomain>

On (24/04/29 20:18), Eric Biggers wrote:
> On Tue, Apr 30, 2024 at 12:04:47PM +0900, Sergey Senozhatsky wrote:
> > Hi,
> > 
> > 	We'd like to be able to pass algorithm-specific parameters to
> > comp backends. As of this moment, crypto usees hard-coded default
> > values and does not permit any run-time algorithm configuration,
> > which in some cases simply disables the most interesting functionality.
> > E.g. zstd can be configured to use a pre-trained (in the user-space)
> > compression dictionary, which significantly changes algorithms
> > characteristics. Another, obvious and trivial example, is algorithms
> > compression level.
> > 
> > The problem is that we need to pass params to cra_init() function,
> > because for some algorithms that's the only place where configuration
> > can take place (e.g. zstd). Changing cra_init() to accept additional
> > `struct crypto_comp_params` looks to be a little intrusive so before
> > I write any patches I'd like to hear your thoughts.
> > 
> 
> Have you considered just using the zstd library (<linux/zstd.h>) directly?

Yes, sort of.

> Which kernel subsystem are you working on that uses compression?

Forgot to mention - this is for zram primarily (and potentially for zswap).
Both of which take advantage of crypto API and can be configured to use
various compression algorithms (per-device).

So, on the zram side, in theory, I can stop using crypto API and start
calling lzo/zstd/lz4/etc. compression/decompression functions directly
(in fact we used to do that many many years ago, before we switched to
cypto API).
