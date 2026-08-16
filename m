Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406A83B05B6
	for <linux-crypto@vger.kernel.org>; Sun, 16 Aug 2026 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786893295; cv=none; b=cUEuyq+IqFsuH6hZSRjHFZQ2mJwnxAN5RLnlOU+n+c4cBACgVDopmKrBFp1lVohRQzJrV0MhuK1ACTaaBFBZ9EDMSPp3Z9ZM5vHul1WH0LhpF6pw/FiVzN/oG8+6DpQMT7gWloSDr5SlHD0rt90LmGD33BgHNJ/01Hx7s9f135Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786893295; c=relaxed/simple;
	bh=oHad1wyox8qdDpY81HM8XfWbSH7UCwe0GLxzkyCErM4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jgZ0d2Gggnag/CUYfRvI8cxwaMQX7hRheBKhUuopFMAIuStLlM+6NqDAB/6s/L8e2GL5e5UIBSgix9NGgHVTAuJO+y5qKI8OsLSbI2n5pjDVsoWArjFZ6vp3eFb1FNynR72Ii8RTBo5DU39r55orvL6AP1imBeHz7TQP+XBuK7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bfv+1QI4; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bfv+1QI4"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47fe377a217so1663504f8f.1
        for <linux-crypto@vger.kernel.org>; Sun, 16 Aug 2026 08:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786893292; x=1787498092; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oDn1zkAJTAhRzfQXoiRfUNpmt/wvhx4bAoFeaZmIx14=;
        b=bfv+1QI4UV37TIKxa1TGhmFpcxlnBRLXA3kdutOATbmkmxGlaVPInNN7+AJ/aywRBQ
         h9zunZb2XN2eK5jSWcZMZHo+tM0A+Yw5gYyjr8hCuzt9kWLFxsz2ATY7un6PO4sJz23t
         d2wFNByaLUh9s7W+1mi3dLFSnBjbwvrElqjBnA8V06L/SrfPaujtc10tRlb/F4Fkr9F2
         de3HaQM1KhFuBk6SxL8tgAK1zbxOaRb8Apqu8xo28DVJpHVHPE7F/+d9m+wKMhhbsFYq
         05Lh0y89uoNWSLMI+tv9hquMOn6QEJp4+fqoo00S+gb5yrTY7+nx1JNnYYM3CCAoJXem
         /Nkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786893292; x=1787498092;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oDn1zkAJTAhRzfQXoiRfUNpmt/wvhx4bAoFeaZmIx14=;
        b=eeX+qx/FUg49CoTRI1jNzwdjPNj0SPmQw4ebnLiihyXbqGA0rJyp4MVPEAoAoiqStR
         TAgxhnj8Ya1aIh+XNdV4xuvwnFb91TMLKPIPj+KZnX1RNwM1+j6Rhq4LCFD70anqc40K
         n0MIaodtRhxEhjXl2SVmceLxGwgeBItIl8jIg/oojRtFRy9cBngPyAVtEfk2jqk1ynSW
         qhA6Vt25vVtXCnXde7tl112xoZCY4SzinHk6QlLYEmmj5l0FiM53A056UsjH7RMSDr4Q
         Bt3DdVUNKg/Z4j58V8P1xnLko8AWx0WABE0+7ZW6SF6wGoI+UT2ExBDXhiefC7HckBS2
         empg==
X-Forwarded-Encrypted: i=1; AHgh+RpvEyITf9UZlM/ZAj5KLXwDBF87micoz0HA5dYk2HDwIMA+i8h+yfYqsUXmDY/lrWSCMuPv1wnki1djjFY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMClSQoRNTSwXaWqaQ1MuaHIfXiWrqBkRn/jMlE2543w920/MT
	hTeX0QcxxHLK584wLBylFrRcjOgsH/BhiAvwWVlKPKnDf0ZzZw1wfzVj
X-Gm-Gg: AR+sD12D5kaXxjPv5zYHGT9XYi5XbVhMvYTqIwzYHZ7i2r3W87TFlZd+B3o2tjgkmeE
	S6+XAYj11elcTfWjGqHehpjRi/fiI/ndEIdvELkCN1ZT6YleKj0FCMCRUlBL43800xm6wSDfLv4
	WHaftQ4B7PXGcgN8q8VVogpIS+ZgH+bfucSLvD3uKbY58gWT9sBZYQuopGH22LrxZgGS1o50jcG
	nD2XUr2u8MbFGsqVxPmFYtWS+ig/31QzMEG7ZOuFgsfmYk4NttETYTmOlqHtzNB1Pha18DB4V11
	verq/pJEibUHWCzRixLZQqO08h1imHTlK8YfQRCMr5AiAm7EUMtUZZuWhMh86kg5OHYHUH86who
	h/M8alFjwxM6GH2HuUHeXNunf9OlPy7ZnUCBjqhodaWvGFAzRNAogdb2B35y6gy7yOIv2cpFQ1g
	RmJ4e7y46MQLHLq6+vK8pUW+LkCrS6jV6TdF6OglNFoJY9iE5/sjsWZ3GxzXIMkEUip7ISbYpMG
	pmSFrQW7+1YvGX2Srt78+2l8g==
X-Received: by 2002:a05:600c:6a10:b0:499:79ba:a754 with SMTP id 5b1f17b1804b1-49987973094mr241171505e9.11.1786893292329;
        Sun, 16 Aug 2026 08:14:52 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49987b2a176sm223938615e9.4.2026.08.16.08.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 08:14:52 -0700 (PDT)
Date: Sun, 16 Aug 2026 16:14:50 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Taehee Yoo <ap420073@gmail.com>, netfilter-devel@vger.kernel.org, Pablo
 Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil
 Sutter <phil@nwl.cc>
Subject: Re: [PATCH 0/6] x86: add missing vzeroupper instructions
Message-ID: <20260816161450.05fd24f2@pumpkin>
In-Reply-To: <20260815205750.169336-1-ebiggers@kernel.org>
References: <20260815205750.169336-1-ebiggers@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 15 Aug 2026 13:57:44 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> Assembly code using YMM or ZMM registers is supposed to end with the
> vzeroupper instruction in order to avoid degrading the performance of
> any later SSE code.  Since this only affects performance and not
> correctness, it is sometimes overlooked.  Most kernel code does it
> correctly, but a few cases were missed.  This series fixes them.
> 
> It should be easiest to take the full series through the x86 tree.

Would it be better to an an unconditional vzeroupper in kernel_fpu_end()?
It could go in kernel_fpu_start() but that might have a bigger effect
on latency.
(I assume there is one in kernel_fpu_start() if it actually saves
the user registers?)

Looking the latency/uops seems reasonably on everything 'recent' except
zen-1 and knights-landing.
Although the microcode patch for zen-2 might make that a lot worse.

	David  


> 
> Eric Biggers (6):
>   xor: add missing vzeroupper to AVX code
>   raid6: add missing vzeroupper to AVX2 code
>   raid6: add missing vzeroupper to AVX-512 code
>   crypto: x86/aria - add missing vzeroupper in AVX2 code
>   crypto: x86/aria - add missing vzeroupper in AVX-512 code
>   netfilter: nft_set_pipapo_avx2: add missing vzeroupper
> 
>  arch/x86/crypto/aria-aesni-avx2-asm_64.S  |  6 ++++++
>  arch/x86/crypto/aria-gfni-avx512-asm_64.S |  3 +++
>  lib/raid/raid6/x86/avx2.c                 |  6 ++++++
>  lib/raid/raid6/x86/avx512.c               |  6 ++++++
>  lib/raid/raid6/x86/recov_avx2.c           |  2 ++
>  lib/raid/raid6/x86/recov_avx512.c         |  2 ++
>  lib/raid/xor/x86/xor-avx.c                |  1 +
>  net/netfilter/nft_set_pipapo_avx2.c       | 17 ++++++++---------
>  8 files changed, 34 insertions(+), 9 deletions(-)
> 
> 
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58

