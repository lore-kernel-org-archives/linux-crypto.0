From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] x86, crypto: ported aes-ni implementation to x86
Date: Fri, 29 Oct 2010 18:15:41 -0400
Message-ID: <20101029221541.GA12822@gondor.apana.org.au>
References: <1288386624-5649-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, minipli@googlemail.com
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:33741 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900Ab0J2WPo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Oct 2010 18:15:44 -0400
Content-Disposition: inline
In-Reply-To: <1288386624-5649-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mathias Krause <minipli@googlemail.com> wrote:
> The AES-NI instructions are also available in legacy mode so the x86
> architecture may profit from those, too.
> 
> To illustrate the performance gain here's a short summary of the tcrypt
> speed test on a Core i5 M 520 running at 2.40GHz comparing both
> assembler implementations:
> 
>                             aes-i586   aes-ni-i586   delta
> 256 bit, 8kB blocks, ECB:  46.81 MB/s   164.46 MB/s   +251%
> 256 bit, 8kB blocks, CBC:  43.89 MB/s    62.18 MB/s    +41%
> 384 bit, 8kB blocks, LRW:  42.24 MB/s   142.90 MB/s   +238%
> 512 bit, 8kB blocks, XTS:  43.41 MB/s   148.67 MB/s   +242%
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Nice work :)

I have to say though that I'll love this een more if we could
avoid duplicating those assembly files somehow.  Is this possible?

Oh and those CBC numbers look out of whack.  I'd expect CBC to be
way faster as it's done directly by the hardware unlike the
other modes.  What numbers do you get in 64-bit before/after
your patch?

If the hardware CBC is really so much slower then maybe we should
stop using it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
