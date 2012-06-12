From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sha1 - use Kbuild supplied flags for AVX test
Date: Tue, 12 Jun 2012 18:02:50 +0800
Message-ID: <20120612100250.GA14078@gondor.apana.org.au>
References: <1337850822-1855-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:54809 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995Ab2FLKCy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jun 2012 06:02:54 -0400
Content-Disposition: inline
In-Reply-To: <1337850822-1855-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 24, 2012 at 11:13:42AM +0200, Mathias Krause wrote:
> Commit ea4d26ae ("raid5: add AVX optimized RAID5 checksumming")
> introduced x86/ arch wide defines for AFLAGS and CFLAGS indicating AVX
> support in binutils based on the same test we have in x86/crypto/ right
> now. To minimize duplication drop our implementation in favour to the
> one in x86/.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
