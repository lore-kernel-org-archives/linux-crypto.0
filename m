Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94BC2D47F1
	for <linux-crypto@vger.kernel.org>; Sun, 11 Oct 2026 09:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791710059; cv=none; b=mCaixJwYdyF13830J/7NJNlqD2zSxrFTpF8dPwX/28t4ZpDtziQhaIY1ciLJgUV9OGtf+VTjASRmO46C4/3LxJjSlJHB2AST0MlA+GHU3IXogY80zSaQjEt0fn+uVXuufAq+b6bLlVx+o/cTKr6XjYzSrL774Fnk4graEIfUZr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791710059; c=relaxed/simple;
	bh=fnspbfCcGV6mSBf+inHXyL2EwSxqPFcnpLeH6pQJXGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pKFIRDU5UYyrAXKYwVfgl5cK7zOYEUTx/R9E4WVnxQ2DODsxIMPx/dQyOyPbWE1tERLgV5VLjaT50B8u/RUe8m3gUexj368g0+Sf8I7dWuSiCIQKrh7OO3/8RzmQSnHIl5R0/ZFaC4jMsy4TibaGDk7MvrsC/jK7EPeCD0O+kKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GEPZmFdv; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GEPZmFdv"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3535a54bed9so1359623eec.1
        for <linux-crypto@vger.kernel.org>; Sun, 11 Oct 2026 02:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791710058; x=1792314858; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h7FJI5dN/FyGY4mAC7187znWc+Enmok4bG9Rd/tePv0=;
        b=GEPZmFdvFJDaHfQhxwEi3zgBPWDkrqia5bP5tZ+UMSRuXmtZhGiye6dKXT6z4m3j9K
         ykjj7wb4noRZJOCUQawCujxwzKk9n52SziVlqB7w64fHK52zmB5x+sxYiR2D6oaiVuj7
         Xkv5wb27PJA/PEwKiq7Cd1Qcll+L8mt1EWbcUwvX5dwsAjqqs2jSLDmzHvLh8ykIr+iO
         ev/QJAHnsBK4WLzWlew+3RQJIKEpvwXzOeQ5rEXuF58s3ECNjHburhHrFDeetRcY7HDM
         nAuWFGEXNChxHlY7WPnAEZBpNOrVpnV1vfWAsWdY6IoJlaBCDCULrkyeSKl8CUV5+PVK
         CVnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791710058; x=1792314858;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h7FJI5dN/FyGY4mAC7187znWc+Enmok4bG9Rd/tePv0=;
        b=wTHX7VaP/J7w4CNzKUTEulPdBt9paO8cR7gF8NyvF8T1YsTxBU4y5WTJtdmh3jVflf
         BR2EcwcHHBOghYlmfbOu+Qb88LzBr4vyyLl7CeoIbZ1qvXsqexVctAEC+EAYfs2iPzY7
         nw7zsI2vnApnwAw8fLbWZFkcb8YImcG0M+37Pxj2Y6/yII/StRV0XU0QystKsDGbbt33
         12neHB3Y+pjYvexE6cbkJYio8vsCwd+orK95pCQXHoFMQ4ONS54d/eI7DNHU8xdoZSyA
         xHZeBB8wBzP7+YINiVWk1zkMX7WMprk85Y/qjIdFjepRflwsxA41KktgsCiXsDW8wCPn
         ChIA==
X-Forwarded-Encrypted: i=1; AKwUvByE1L7j9Vl/1P5Ad86a2fPBet5YwRDDa5R7Fx8Pnpm/yfiYrlnfmK2LA9GhdM8+aJ5BGtJaTgc8VJNr/aE=@vger.kernel.org
X-Gm-Message-State: AFq9FYJJcJ0wwFW31YunfNl4HE6fXoLHVFmA6LR+x+B5xo/MfnXZaRA+
	8P1A4ugINJ95Q+dXDaNanVykohyfMHd/L6OTzTS/SCIW77hqJKToOiOb
X-Gm-Gg: AYBFou3/MP74dySAsYSIO6PSSDLygNcidQZ2o9UPBWHJif2ezwCnkMxX1KW35LS7E8h
	LJ/FNeKTy+u7BOEd2yUJqCgi4AJ8mtiNvU3cJw1kJAfAdkDYtTrnGCZ5gpINH2TaamQ3PBHWBPM
	ny7qnS9OFR68OJvj+Gg+ykqFgjUSPKu8GK0Ng4KKBZx0OwBbW0A+Ncy4fA95eO8RiUlZQl+mlJL
	7ZRmV+c2gsIvwNM+cgKyEPmbxjcvOhPaEYT3kt0SUE5frkAYoORLqYZ27zJxwcjl5VfZagNzHOJ
	Fe5/jZk4dvQ3RxbkVK8GVDnEDPvnLHBguWCaoWjZ2apXYt9HjwoTkvel2dc/GDD1bzj2J8mTqGo
	kTYOxS5kA9o6L+8lzgBWDb5+6eZcRJPopbAEhrI5Mf6UbF26JljngSyGpzdilkPcSFNVvN4T0/l
	oxEFk69uyFEypDby+L8AkZizoCdDYNNT5yKtKtsi1Srrz0fH3In1c8Ga1DoWqyykKvMWFjyliFJ
	gL2DDitlaSi+aY=
X-Received: by 2002:a05:7300:ce94:b0:328:7033:9b8c with SMTP id 5a478bee46e88-3537e03331bmr9513887eec.6.1791710057560;
        Sun, 11 Oct 2026 02:14:17 -0700 (PDT)
Received: from kernel ([45.251.35.97])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-358de54fe47sm9822262eec.31.2026.10.11.02.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 02:14:17 -0700 (PDT)
Date: Sun, 11 Oct 2026 14:44:09 +0530
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: Simon Richter <Simon.Richter@hogyros.de>
Cc: ebiggers@kernel.org, ardb@kernel.org, Jason@zx2c4.com,
	skhan@linuxfoundation.org, me@brighamcampbell.com,
	jkoolstra@xs4all.nl, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: sha1: use put_unaligned_be64() for length
 encoding
Message-ID: <astTYX3RBV44n2gX@kernel>
References: <20261011051524.6703-1-raizudeen.kerneldev@gmail.com>
 <454f2204-2c4b-43c0-8fd0-1eaa83186e69@hogyros.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <454f2204-2c4b-43c0-8fd0-1eaa83186e69@hogyros.de>

On Sun, Oct 11, 2026 at 03:10:44PM +0900, Simon Richter wrote:
> Hi,
> 
> On 10/11/26 14:15, Mohamad Raizudeen wrote:
> 
> > The rest of this file already uses the unaligned access helpers like
> > get_unaligned_be32() for reading input and put_unaligned_be32() for writing
> > the digest, for all structured buffer accesses. Replace both casts with
> > put_unaligned_be64() for consistency.
> 
> These aren't unaligned accesses, though.
> 
> > In hmac_sha1_final(), this also writes the full 64-bit length field
> > explicitly rather than writing only 32 bits and relying on a preceding
> > memset() to zero the upper 32 bits. The resulting bytes are identical,
> > nothing changes functionally.
> 
> These aren't unaligned either, and the size here is fixed (which is also why
> we don't need to handle the case where the size does not fit into the
> current block).
> 
> The get_unaligned and put_unaligned functions aren't used as convenience
> functions, but because the data might actually be unaligned, so we need to
> eat the cost of doing an unaligned access.
> 
>    Simon

Hi,

Well, you are right. My patch would have added unnecessary overhead on
strict alignment architectures.

Withdrawing this patch.

Thanks,
Mohamad Raizudeen
