From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: How to utilize crypto source in kernel?
Date: Fri, 23 Mar 2007 09:14:13 +1100
Message-ID: <E1HUVXx-0003mp-00@gondolin.me.apana.org.au>
References: <3befbf920703220248k3449d916ycd578bddc814246a@mail.gmail.com>
Cc: linux-crypto@vger.kernel.org
To: hbtsai@gmail.com (Tsai, Hong-Bin)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1675 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161149AbXCVWOS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Mar 2007 18:14:18 -0400
In-Reply-To: <3befbf920703220248k3449d916ycd578bddc814246a@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Tsai, Hong-Bin <hbtsai@gmail.com> wrote:
> 
> I'd like to modify the kernel to load a encrypted initrd. While
> loading the initial ramdisk, kernel reads secret key from somewhere
> else and decrypts initrd, and then continues the boot process.
> However, I met a problem.
> 
> Since there are crypto libraries reside in kernel, I believe that's
> the best resource for me to implement this mechanism. At first I
> followed the interfaces found in crypto/api.c, but found it is loads
> crypto-algorithms from modules. Even after I configured an algo as
> build-in module (say, aes), I always failed at its initialization
> stage. (crypto_alloc_blkcipher returns error)
> 
> Please give me suggestions. Am I on a right course?

Have a look at dm-crypt.  It's best if you just load a normal but
minimal initrd which then can use dm-crypt to load a larger and
encrypted file system (it could even be a loop back mount of a
file in the initial initrd).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
