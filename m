From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: gcm - fix assumption that assoc has one segment
Date: Tue, 2 Apr 2013 17:56:58 +0800
Message-ID: <20130402095658.GA15246@gondor.apana.org.au>
References: <20130328195403.13775.20772.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:46544 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757681Ab3DBJ5H (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Apr 2013 05:57:07 -0400
Content-Disposition: inline
In-Reply-To: <20130328195403.13775.20772.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 28, 2013 at 09:54:03PM +0200, Jussi Kivilinna wrote:
> rfc4543(gcm(*)) code for GMAC assumes that assoc scatterlist always contains
> only one segment and only makes use of this first segment. However ipsec passes
> assoc with three segments when using 'extended sequence number' thus in this
> case rfc4543(gcm(*)) fails to function correctly. Patch fixes this issue.
> 
> Reported-by: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
> Tested-by: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
