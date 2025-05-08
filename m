Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3F620E000
	for <linux-crypto@vger.kernel.org>; Thu,  8 May 2025 05:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746680468; cv=none; b=dvyxQl4gPjSZpxbAyg/tNZ8Q/MYbONG8PS2I8sEURkwx1OEuHDmfQ8Drw3j7aIj0WibxrN3Ah3fNWOylZS8/ES8SMrILLkcp0p4kzv62e8ia8h7a3bKlhMyXpr1LhNEAcI0o6b4QBlVUMeh9rmlwuNi3CCur0244uQFuoF7WEv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746680468; c=relaxed/simple;
	bh=c02DpI/EiM16HLoJ7AaWlv92/PHI40vEjuplf9fAJdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bxqB8ri75BS7s/K9TkDMtspS32YV35gKpxAu0f6X3yMnyGhmqwk+2AnttAwMkDaICH15+uBhOP7DrmTXxO4u4epOsxUrxAsi8oEMyjmBQDgrSoQQUq5MYkcqGT/67No6eA7GJb2yHyIzlONvr9nSPRQibj9ecAUZw3fZsFbXI+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=A99Spezd; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="A99Spezd"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7398d65476eso546960b3a.1
        for <linux-crypto@vger.kernel.org>; Wed, 07 May 2025 22:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1746680466; x=1747285266; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UijIsxU5c55Xg3RuGViwB2KkAp8ogs0m6/j3R9pqGsM=;
        b=A99SpezdPT38H9cl7Q96Zo6zjmDTUEvp6kRQRu/OShNm3umszKgH4W8QA8Q1fBX8Py
         Zj0Mx0yeg+04+b1YMkm3rCYe+PjF+clUUDDSza33q0lNe4PXb9F/0kExgSKQlo3A4HAy
         ToFj1/ys0ueXcNhCuWdM4/fC0llDimt5sW1G4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746680466; x=1747285266;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UijIsxU5c55Xg3RuGViwB2KkAp8ogs0m6/j3R9pqGsM=;
        b=Jyzb5hoa62JTK40a2b5uCaVlEKaSH3dzbQ+yw5NwGopUBeyQJloQQe2pKCVnvJd63W
         nPl8uOiTgNVazZ1yC4vLNjlA7l0kk0eyAk19XyLhCZ5g13j77ruuPSjv91a1aoAUEHZp
         khvSX/M8NZc093ZWkyR/oKBf7h4BkykAZE4hfudOr4e+KgRKSVnrYidYxt/Wgq/Q8jcR
         I2JzBFD9SdbncU1ItfsX/loVX03PMvNqjACv5I87geb3GFrecyXftuiCcY5lf5Uuvzgb
         rd4T4oXSlRsUeU4yeSW+gdYewp2e7B1iySa3/DQcudi5JZ+DZQ8Ugki9BkX5DbAPFk1h
         nRjg==
X-Forwarded-Encrypted: i=1; AJvYcCUg+2An/XkaZT3RZNxGD0PO3zs7GQj+3iJ6M/6Nd1RjSYySqDivXAbk22NnyNAPTMFgKp109YxsWKn1OzI=@vger.kernel.org
X-Gm-Message-State: AOJu0YymVMllQQdThw7ebQ+ZGqK4ptfrIQcFmyQARVy8/tgjiBEUBDaK
	3Qy08SM8sY8JjMLL9nB22YuNQh7MZb4JdkMcZBaNaxSpjNE61r6Hd9wcNDEajA==
X-Gm-Gg: ASbGnctFybzAps/ArnuQJsjuCqzBw3OFNrtaQheyN00eq+iojASnKcrJJtzEiCvebMq
	OFcW0T2yY7e3sUbfvoGGSyIo3rStbZWpEOQ3joNYkyRU4KhvanQiMPpy3j0mPFf57ksjSHrm9wd
	8NERTy9SchJ50CKHfcxGA7ym2H98smEMMqTQtw8hqfdUxjEZCOypHUi/JZXQU3Gvli/nibLwBeY
	j3IiYRIiXwNvy5NWxGheQU+HqopyTtqKvdSdgQmQeL3EWToqXrUw8I6BRS54Z/d4m5mY32pzVzB
	9grBqlbCobY/D+yKKLASVpQsk4vB5FS8F/T6J9Z48ueo
X-Google-Smtp-Source: AGHT+IFO8HYKnL3mkTJI/c6QM9EDb+tM5GD4IbPlwVlHZkR7Jvns/fZ/K5rqQBfMvCxHEfvJQUcXXA==
X-Received: by 2002:a05:6a00:e84:b0:736:9f2e:1357 with SMTP id d2e1a72fcca58-740a947d58dmr3373524b3a.12.1746680466165;
        Wed, 07 May 2025 22:01:06 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:c794:38be:3be8:4c26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058b7e30esm12285110b3a.0.2025.05.07.22.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 22:01:05 -0700 (PDT)
Date: Thu, 8 May 2025 14:01:02 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/3] crypto: acomp - Add setparam interface
Message-ID: <345mxnhwzthfvvukzmi7hzahcolrxtlwpgabyoncekhaa24ptk@e7wsatfvrfsc>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <74c13ddb46cb0a779f93542f96b7cdb1a20db3d4.1716202860.git.herbert@gondor.apana.org.au>
 <aBoyV37Biar4zHkW@gcabiddu-mobl.ger.corp.intel.com>
 <aBrDihaynGkKIFj8@gondor.apana.org.au>
 <aBtdOevCMsIDwSmv@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBtdOevCMsIDwSmv@gcabiddu-mobl.ger.corp.intel.com>

On (25/05/07 14:16), Cabiddu, Giovanni wrote:
[..]
> > param is just an arbitrary buffer with a length.  It's up to each
> > algorithm to put an interpretation on param.
> > 
> > But I would recommend going with the existing Crypto API norm of
> > using rtnl serialisation.
> > 
> > For example the existing struct zcomp_params (for zstd) would then
> > look like this under rtnl (copied from authenc):
> > 
> > 	struct rtattr *rta = (struct rtattr *)param;
> > 	struct crypto_zstd_param {
> > 		__le32 dictlen;
> > 		__le32 level;
> > 	};
> > 
> > 	struct crypto_zstd_param *zstd_param;
> > 
> > 	if (!RTA_OK(rta, keylen))
> > 		return -EINVAL;
> > 	if (rta->rta_type != CRYPTO_AUTHENC_ZSTD_PARAM)
> > 		return -EINVAL;
> > 
> > 	if (RTA_PAYLOAD(rta) != sizeof(*param))
> > 		return -EINVAL;
> > 
> > 	zstd_param = RTA_DATA(rta);
> > 	dictlen = le32_to_cpu(zstd_param->dictlen);
> > 	level = le32_to_cpu(zstd_param->level);
> > 
> > 	param += rta->rta_len;
> > 	len -= rta->rta_len;
> > 
> > 	if (len < dictlen)
> > 		return -EINVAL;
> > 
> > 	dict = param;
> Thanks Herbert.
> 
> > BTW Sergey said that he was going to work on this.  So you should
> > check in with him to see if he has any progress on this front.
> Sergey, do you have an updated patchset?

Hi,

I do have some in the making (a bit of a low priority recently),
not ready to show them yet.

> If not, I can take over on this work. I have already rebased this version
> against the latest head of cryptodev-2.6.

So these patches is step 0, there are a lot more steps after it.
I suppose you focus on IAA?

I'm in particular interested in lz4 and zstd (less so in deflate),
parameters support for those is currently implemented in "custom"
zram compression backends.
