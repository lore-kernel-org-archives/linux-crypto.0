From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Update for 4.1
Date: Thu, 16 Apr 2015 10:42:52 +0800
Message-ID: <20150416024252.GA11558@gondor.apana.org.au>
References: <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <CA+55aFyynQ75NfQy7Lp6t9Tp8+bp=LKG9Xw9q8KQqNoS+gGLmA@mail.gmail.com>
 <CA+55aFz8pr-J7K-EY5gjCV7ajJZC2tkFwjNG1xLXvQk0qAm2HA@mail.gmail.com>
 <CA+55aFwG1y6KSu-ZUMHXFnw69nRttS3LZW_pScvB6LCZjS02tA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49552 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbbDPCnH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Apr 2015 22:43:07 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFwG1y6KSu-ZUMHXFnw69nRttS3LZW_pScvB6LCZjS02tA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 15, 2015 at 07:38:29PM -0700, Linus Torvalds wrote:
>
> > Ok, bisect completed:
> >
> >     [torvalds@vaio linux]$ git bisect bad
> >     9c521a200bc3c12bd724e48a75c57d5358f672be is the first bad commit
> >     commit 9c521a200bc3c12bd724e48a75c57d5358f672be
> >     Author: Stephan Mueller <smueller@chronox.de>
> >     Date:   Thu Apr 9 12:09:55 2015 +0200
> >
> >         crypto: api - remove instance when test failed

Is CONFIG_CRYPTO_MANAGER_DISABLE_TESTS set or unset in you .config?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
