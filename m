From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: User Space API for CryptoAPI
Date: Tue, 25 Mar 2008 15:26:56 +0300
Message-ID: <20080325122656.GA15675@2ka.mipt.ru>
References: <20080220202543.3209.47410.stgit@jazz.citi.umich.edu> <20080324131204.GA7324@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6043EDC6C@SDCEXCHANGE01.ad.amcc.com> <20080325030723.GA12830@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Loc Ho <lho@amcc.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:38268 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbYCYMYi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Mar 2008 08:24:38 -0400
Content-Disposition: inline
In-Reply-To: <20080325030723.GA12830@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Tue, Mar 25, 2008 at 11:07:23AM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > Is there an user space API driver wrap around Linux CryptoAPI? I notice
> > there is OCF-Linux which has an user interface that works with OpenSSL.
> > It seems to use Linux CryptoAPI if there is no hardware offload with
> > OCF. In addition, there is a fellow which developed cryptodev patch
> > around Linux CryptoAPI but it is limited and doesn't support everything
> > and not compatible with OpenSSL. Are there anything else? 
> 
> Evgeniy might have an implementation as well.

What I had for acrypto is not very well suitable for what we have right
now, so better create it from scratch.

> I haven't had much time to look at this recently, but an fd-based
> scheme involving splice could be interesting.

Yes, I belive the simpler it is, the better result.
Like creating tfm per opened file descriptor with ability to change
cipher/mode/whatever via ioctl.

-- 
	Evgeniy Polyakov
