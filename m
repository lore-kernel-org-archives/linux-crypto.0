From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v11 1/2] crypto: AF_ALG: add AEAD support
Date: Mon, 26 Jan 2015 15:37:33 +1100
Message-ID: <20150126043733.GA20984@gondor.apana.org.au>
References: <1923793.K38mGRD6eo@tachyon.chronox.de>
 <6238416.vGUni1CI4i@tachyon.chronox.de>
 <20150126000631.GA18350@gondor.apana.org.au>
 <13294516.zBBDkdi9pn@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel Borkmann <dborkman@redhat.com>,
	'Quentin Gouchet' <quentin.gouchet@gmail.com>,
	'LKML' <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:58771 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbbAZEhl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Jan 2015 23:37:41 -0500
Content-Disposition: inline
In-Reply-To: <13294516.zBBDkdi9pn@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 26, 2015 at 05:35:07AM +0100, Stephan Mueller wrote:
> 
> It seems I have misunderstood you in the last discussion.

I thought you were limiting the receive SGL by ALG_MAX_PAGES rather
than a single IOV entry.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
