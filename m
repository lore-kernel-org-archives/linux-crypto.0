From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: PATCH: SEED cipher support
Date: Fri, 17 Aug 2007 11:23:14 +0800
Message-ID: <20070817032314.GA14451@gondor.apana.org.au>
References: <20070812151130.GA37318@FreeBSD.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Hye-Shik Chang <perky@FreeBSD.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4692 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752150AbXHQDXV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2007 23:23:21 -0400
Content-Disposition: inline
In-Reply-To: <20070812151130.GA37318@FreeBSD.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Aug 12, 2007 at 03:11:30PM +0000, Hye-Shik Chang wrote:
> Hello,
> 
> Here I propose a patch for linux crypto API to add a support SEED
> (RFC4269).  This patch was generated against git-HEAD as of today.
> This patch have been used in few VPN appliance vendors in Korea for
> several years.  And it was verified by KISA, who developed the
> algorithm itself.
> 
> As its importance in Korean banking industry, it would be great
> if linux incorporates the support.

Thanks for the patch! Could you please add a Signed-off-by
and I'll merge it in.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
