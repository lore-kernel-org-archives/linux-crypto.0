From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: sha512: make it work, undo percpu message schedule
Date: Sun, 15 Jan 2012 12:43:39 +1100
Message-ID: <20120115014339.GB27370@gondor.apana.org.au>
References: <20120111000040.GA3801@p183.telecom.by> <20120111003611.GA12257@gondor.apana.org.au> <20120112235514.GA5065@p183.telecom.by> <20120113070813.GA20068@gondor.apana.org.au> <1326450942.2272.20.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20120113110255.GD12501@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	ken@codelabs.ch
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:45700 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2AOBnq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Jan 2012 20:43:46 -0500
Content-Disposition: inline
In-Reply-To: <20120113110255.GD12501@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2012 at 12:02:55PM +0100, Steffen Klassert wrote:
>
> If we want to do dynamic memory allocation, we could place it to the
> shash_desc context where we already store the intermediate digest value.
> This is preallocated anyway, so we don't need to do another allocation.

The problem with that is that some call paths place shash_desc on
the stack too.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
