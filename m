From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: hash finup() issue
Date: Thu, 27 Jan 2011 09:32:17 +1000
Message-ID: <20110126233217.GA26664@gondor.apana.org.au>
References: <4D3ED3CF.4080205@nokia.com> <20110125232917.GA14972@gondor.apana.org.au> <4D3FD18F.2020905@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:55081 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab1AZXcW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Jan 2011 18:32:22 -0500
Content-Disposition: inline
In-Reply-To: <4D3FD18F.2020905@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 26, 2011 at 09:47:27AM +0200, Dmitry Kasatkin wrote:
> I am not talking about user space API at all.
> 
> I talk about kernel crypto API and kernel clients.
> 
> Please understand the following: when update() is called driver does not
> know if it is last update or not...
> That is essential.
> If client code would always use update/finup then it is fine..
> But original API and clients uses update/final...
> That is why some way (flag) needed to tell if finup() will be used or not...
> 
> It gave up 20% performance improvement in some case because no extra
> memcpy has been done...
> 
> If you think about other solution, please share...

If the crypto user can set the FINUP flag then it can just call
finup, simple.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
