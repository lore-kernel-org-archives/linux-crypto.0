From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] crypto: gcm - Fix rfc4543 decryption crash
Date: Fri, 18 Mar 2016 10:34:23 -0700
Message-ID: <20160318173423.GB19137@kroah.com>
References: <20160318144240.GA20816@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	patrick.meyer@vasgard.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbcCRReY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 13:34:24 -0400
Content-Disposition: inline
In-Reply-To: <20160318144240.GA20816@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 18, 2016 at 10:42:40PM +0800, Herbert Xu wrote:
> This bug has already bee fixed upstream since 4.2.  However, it
> was fixed during the AEAD conversion so no fix was backported to
> the older kernels.

What was the commit id of that fix?

> 
> When we do an RFC 4543 decryption, we will end up writing the
> ICV beyond the end of the dst buffer.  This should lead to a
> crash but for some reason it was never noticed.
> 
> This patch fixes it by only writing back the ICV for encryption.
> 
> Fixes: d733ac90f9fe ("crypto: gcm - fix rfc4543 to handle async...")
> Reported-by: Patrick Meyer <patrick.meyer@vasgard.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

What stable kernel(s) do you want this in?

thanks,

greg k-h
