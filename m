From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Userspace API proposal was: Re: [PATCH 1/1] RFC: Add CryptoAPI User Space Interface Support
Date: Wed, 14 May 2008 20:09:41 +0400
Message-ID: <20080514160941.GA7419@2ka.mipt.ru>
References: <DB599F406D04E34389140B7D99C71B1B055EE51E@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60301C29D@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B055EE6B2@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60472088A@SDCEXCHANGE01.ad.amcc.com> <20080514103224.GA10416@Chamillionaire.breakpoint.cc> <20080514110311.GA22116@gondor.apana.org.au> <20080514115730.GA10664@Chamillionaire.breakpoint.cc> <20080514121855.GA14949@2ka.mipt.ru> <0CA0A16855646F4FA96D25A158E299D604720974@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shasi Pulijala <spulijala@amcc.com>,
	linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56515 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbYENQJx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2008 12:09:53 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D604720974@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Wed, May 14, 2008 at 08:40:43AM -0700, Loc Ho (lho@amcc.com) wrote:
> Option #2:
> 1. Use syscall with algorithm name and its associated parameters
> 2. Operation such as encrypt, decrypt, hash, and etc are operated via
> another two system call - crypto_read and crypto_write
> 3. For this option, how should one handle asynchronous operation???

No need to read/write syscall, initialization one returns a file
descriptor, which can be read/written via usual read/write calls.
It is also pollable.

> Option #3:
> 
> 1. Use syscall to create a special crypto device folder per an algorithm
> 2. A handle is returned and a crypto filesystem entry is create for that
> handle
> 3. Crypto parameter can be set based on read/write on that folder
> 4. Crypto operation will be based on file created under that folder. It
> will inherit all crypto attributes of that folder.
> 5. And etc... (See previous email)
> 6. This approach is overkill and totally unnecessary.
> 
> Does this email summary all suggested solution? If not please add to
> this list. Which one will like be accepted into the crypto tree???

Essentially it is the same as second one, but with aditional eye-candies
like simplified key management (some file in some dir written and key is
being changed).


Belive me, there will be always people, who do not like your interface,
whatever one you will create, with second or third approach such number
will be smaller, so just create what you like and prove your point is
strong. New interfaces is such a tasty ground for empty talks :)

-- 
	Evgeniy Polyakov
