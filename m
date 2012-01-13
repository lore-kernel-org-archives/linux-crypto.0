From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: sha512: make it work, undo percpu message schedule
Date: Fri, 13 Jan 2012 11:19:42 +1100
Message-ID: <20120113001942.GA12274@gondor.apana.org.au>
References: <20120111000040.GA3801@p183.telecom.by> <20120111003611.GA12257@gondor.apana.org.au> <20120112235514.GA5065@p183.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	ken@codelabs.ch
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:41163 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab2AMATq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jan 2012 19:19:46 -0500
Content-Disposition: inline
In-Reply-To: <20120112235514.GA5065@p183.telecom.by>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2012 at 02:55:14AM +0300, Alexey Dobriyan wrote:
>
> Herbert, I couldn't come up with a single scenario. :-(
> But the bug is easy to reproduce.

OK, I'll try to reproduce it here.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
