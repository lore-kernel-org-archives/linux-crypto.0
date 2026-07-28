Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D6441F369
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 09:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785231024; cv=none; b=mq/VBU1h6ZGeNWq5KtFcP6HEGZaovzdOe63TbFPy3qLymbEaPfTNzvqETcBhLtW9DaGsEm9rzRhpliUIFlkMiXA6gXlgkNqqlvNAARHRUBTReAw6PYFIvSFmvzqA70Zd1cJS3iOaboXxpEK5LRwXp0h7Q9EDDiayjzczuux5xGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785231024; c=relaxed/simple;
	bh=5birTs3jZadiSM71ETEkOn2VcKNyOlS3GF0BwSWxb4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sYn5vvVpJmGIFP0dRscR00NAjCc6Xpx2Y5EgIGin4e8oooLQ1FaGYbwgpAGJnn29UfBY8jbewB6nWNhOfdM0i6yuxwGEThQaQ5eqTtz8iqfNjKIZdFZLv/x1SEsAB6VmEvPEZpl3Ozx0M3AofvloJtWlA77T6k4+eViZApnz04o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qdfn5M+9; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qdfn5M+9"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4953de5be0aso23708695e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 02:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785231020; x=1785835820; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fd4u7HbSw7LmAIg2c748Ol/BOezHkKcbVf+2ouQF5V0=;
        b=qdfn5M+990Eb/ueBBcYv4rI4czjhL32WeHkZFSAwMUANwR8LSeNpH9aJ042VXMwygF
         ilJzjV2kFlmv8zcvodkKL6qEEq9OLAEUc8cG1tReGvP/w6VrGzYTJCN/2IXLqS4FiuPW
         CAlnz2cyfJg9e1dct16QM0RR31YC1zXwXuantdTNbo23qLau2NL3cvQvFw5RrUVZ9tR2
         69ejLOml3G0SKy9/U9MZCK/Ic5d3i13kxbul28Uk7Dg1rc9gPkWMRbb2oBQCBtXOrgB/
         jR0/3u88g+ms7a6sUW2hWd4AH2mMI8mm8zfa6m9kFgp1MQnCnexOdM3Gy7QrMDcMXCl2
         obHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785231020; x=1785835820;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fd4u7HbSw7LmAIg2c748Ol/BOezHkKcbVf+2ouQF5V0=;
        b=MTPTBaRv3moNpTXXdmf7y0J/SrrzdJUR3JsTCZ1QJXnUDlG4qIPGG9lJ2ZHYIdsIne
         C3KaYr3XJbyQX/yzyuheInCIm/Wxpjh7KWmsqIH2hYLdjTdDslho0MaQ0RcO4IMeYXPy
         zw3a0wNbIYyPfoE6nPk4DquCj85my9tNosMdnehKEJWuKyYkbm4gLAcdzNWJqxt/qAMz
         MzfATeN08nogd0ZjoZ8a4fK2M2KUPXgWSP8kRut+wRh1dZs1MDWze9p1M5xpmz0GMSeW
         MA342Jjv0BtW/Dl3TPHZl+a8UZUVGTuP/q1v/7tclDI3IqhnJXtOhcj3sZDU4CX5/gZW
         fsOA==
X-Forwarded-Encrypted: i=1; AHgh+RoVTcOxw+VbupWGljd450Qd4pmpmiHWoMtlVmdPFHs+hW5+4m78uN6N3QIr2gFDbYoPg6nmAU/kQa1RNCI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhBm6/y+zwzwLoZm/Mgkt2twkE0rHCqRKJ5uEXntnCBnxGAWE0
	YkMtSMxE5tWtHup5y9jo2kn7ZyjVxvXRuWI5rLX9BvyokQqLN3ASeSaE
X-Gm-Gg: AR+sD12eUdXpSdMj52HhOmQn+pK5JWTL9tLgrJOlvauNt0fJIT87FBUEewr1jRy+UJr
	qHpRuWavK7iyFIdhJ1OhuWEFJZqC46bzAF6jkrfwE4ergVALReRmbm/yrrfu7lN/aXroH1EkhKN
	NZP8tKxudDgkdUsg1zyTc6IzboNiua4FZK9NKoqkw4vRqgvO09+yDScJlBJFySqrBfB5/sI3VIF
	rgVpOoH14rfC8azieF9f0Gk9BzYGTlqbZVce1KTP1OcayEepewuAadgyg1aszar+nSn+Dkm5hKk
	p3q3SjB2h4409xg/E6mguedpOqzPLYABRdiVot0ApfxwL5zGMDfQRYwbVThvOUriB4/JwgByT+6
	P/+94dPdVA92qzY6fCAD+5Gh6X7Dp3uaOSrd90BxtKDB20ZdAtuQb7tCrFtJJ0Nx6YOlHT2AYFa
	lcjhEt6QzDkmpJVtiN4MdQe3L9SytYWsco3KkZNLM=
X-Received: by 2002:a05:600c:310b:b0:495:779c:fbef with SMTP id 5b1f17b1804b1-496c65aaf28mr16540495e9.37.1785231020039;
        Tue, 28 Jul 2026 02:30:20 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c44b84edsm99732275e9.5.2026.07.28.02.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 02:30:19 -0700 (PDT)
Date: Tue, 28 Jul 2026 10:30:18 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
 linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/8] crypto: x86 - Stop using cpu_has_xfeatures()
Message-ID: <20260728103018.00938ac6@pumpkin>
In-Reply-To: <20260728021603.79870-4-ebiggers@kernel.org>
References: <20260728021603.79870-1-ebiggers@kernel.org>
	<20260728021603.79870-4-ebiggers@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 27 Jul 2026 19:15:58 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> Checking both boot_cpu_has(X86_FEATURE_AVX*) and cpu_has_xfeatures() has
> never really been needed in practice, and it's never been universally
> done (e.g., lib/raid/ omits cpu_has_xfeatures()).  Nevertheless, both
> x86 and UML now explicitly clear the AVX and AVX-512 flags if their
> xfeatures are missing, which should remove any remaining doubts.
> 
> Thus, remove all the calls to cpu_has_xfeatures(), as well as the
> related checks of boot_cpu_has(X86_FEATURE_OSXSAVE).
> 
> In a few cases there was no corresponding boot_cpu_has(X86_FEATURE_AVX*)
> check, so add the missing ones.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
...
> --- a/arch/x86/crypto/aria_gfni_avx512_glue.c
> +++ b/arch/x86/crypto/aria_gfni_avx512_glue.c
> @@ -196,24 +196,15 @@ static struct skcipher_alg aria_algs[] = {
>  
>  static int __init aria_avx512_init(void)
>  {
> -	const char *feature_name;
> -
>  	if (!boot_cpu_has(X86_FEATURE_AVX) ||
>  	    !boot_cpu_has(X86_FEATURE_AVX2) ||

Doesn't AVX2 require AVX support?

>  	    !boot_cpu_has(X86_FEATURE_AVX512F) ||
>  	    !boot_cpu_has(X86_FEATURE_AVX512VL) ||

And (less sure) AVX512xxx require AVX2?

So the extra checks could be reduced.

	David

> -	    !boot_cpu_has(X86_FEATURE_GFNI) ||
> -	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
> +	    !boot_cpu_has(X86_FEATURE_GFNI)) {
