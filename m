From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: User Space API for CryptoAPI
Date: Tue, 25 Mar 2008 11:07:23 +0800
Message-ID: <20080325030723.GA12830@gondor.apana.org.au>
References: <20080220202543.3209.47410.stgit@jazz.citi.umich.edu> <20080324131204.GA7324@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6043EDC6C@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38993 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756165AbYCYDH2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Mar 2008 23:07:28 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D6043EDC6C@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 24, 2008 at 04:54:16PM -0700, Loc Ho wrote:
> Hi Herbert,
> 
> Is there an user space API driver wrap around Linux CryptoAPI? I notice
> there is OCF-Linux which has an user interface that works with OpenSSL.
> It seems to use Linux CryptoAPI if there is no hardware offload with
> OCF. In addition, there is a fellow which developed cryptodev patch
> around Linux CryptoAPI but it is limited and doesn't support everything
> and not compatible with OpenSSL. Are there anything else? 

Evgeniy might have an implementation as well.

I haven't had much time to look at this recently, but an fd-based
scheme involving splice could be interesting.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
