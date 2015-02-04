From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt: do not allocate iv on stack for aead
 speed tests
Date: Wed, 4 Feb 2015 21:01:05 +1100
Message-ID: <20150204100104.GA3053@gondor.apana.org.au>
References: <1422443252-6396-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35908 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605AbbBDKBM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Feb 2015 05:01:12 -0500
Content-Disposition: inline
In-Reply-To: <1422443252-6396-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 28, 2015 at 01:07:32PM +0200, Cristian Stoica wrote:
> See also: 9bac019dad8098a77cce555d929f678e22111783
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>

All three patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
