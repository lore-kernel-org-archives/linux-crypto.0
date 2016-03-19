From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: gcm - Fix rfc4543 decryption crash
Date: Sat, 19 Mar 2016 10:23:07 +0800
Message-ID: <20160319022307.GA25338@gondor.apana.org.au>
References: <20160318144240.GA20816@gondor.apana.org.au>
 <20160318173423.GB19137@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	patrick.meyer@vasgard.com
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37117 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbcCSCXQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 22:23:16 -0400
Content-Disposition: inline
In-Reply-To: <20160318173423.GB19137@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 18, 2016 at 10:34:23AM -0700, Greg KH wrote:
> On Fri, Mar 18, 2016 at 10:42:40PM +0800, Herbert Xu wrote:
> > This bug has already bee fixed upstream since 4.2.  However, it
> > was fixed during the AEAD conversion so no fix was backported to
> > the older kernels.
> 
> What was the commit id of that fix?

commit adcbc688fe2f8107b7f564187593293aa9ea3932
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Jun 16 13:54:18 2015 +0800

    crypto: gcm - Convert to new AEAD interface
 
> What stable kernel(s) do you want this in?

Since the fix was merged in 4.2 this is needed on all kernels
prior to that, i.e., 4.1 and any prior version.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
