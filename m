From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC v2 PATCH 1/9] crypto: authencesn - Add algorithm to
	handle IPsec extended sequence numbers
Date: Sun, 13 Mar 2011 14:30:17 +0800
Message-ID: <20110313063017.GA10849@gondor.apana.org.au>
References: <20110308100407.GB31402@secunet.com> <20110308100458.GC31402@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>,
	Alex Badea <abadea@ixiacom.com>,
	Andreas Gruenbacher <agruen@suse.de>, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:43045 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1CMGah (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 13 Mar 2011 01:30:37 -0500
Content-Disposition: inline
In-Reply-To: <20110308100458.GC31402@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 08, 2011 at 11:04:58AM +0100, Steffen Klassert wrote:
>
> +	return crypto_authenc_esn_genicv(req, iv, CRYPTO_TFM_REQ_MAY_SLEEP);

BTW, we should get rid of these MAY_SLEEP flags.  Originally I
included them for the IPsec encryption path because that happens
to be sleepable.  We should instead be getting it from the request
itself.

Also, as soon as we enter the async path it becomes unsleepable.

Of course this affects the existing authenc file as well.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
