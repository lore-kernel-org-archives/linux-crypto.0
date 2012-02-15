From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: sha-512...
Date: Wed, 15 Feb 2012 15:01:28 +1100
Message-ID: <20120215040128.GA8738@gondor.apana.org.au>
References: <20120214.225833.303014660389989764.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35846 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2BOEBa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Feb 2012 23:01:30 -0500
Content-Disposition: inline
In-Reply-To: <20120214.225833.303014660389989764.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 14, 2012 at 10:58:33PM -0500, David Miller wrote:
> 
> FYI, I just started seeing this on sparc32 after all those
> sha512 "optimizations":
> 
> crypto/sha512_generic.c: In function 'sha512_transform':
> crypto/sha512_generic.c:135:1: warning: the frame size of 1136 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Is that with the latest patch applied?

	crypto: sha512 - Avoid stack bloat on i386

If so then this is not good.  What was the original stack usage,
i.e., if you revert to the original percpu code?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
