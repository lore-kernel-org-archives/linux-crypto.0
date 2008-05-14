From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Userspace API proposal was: Re: [PATCH 1/1] RFC: Add CryptoAPI User Space Interface Support
Date: Wed, 14 May 2008 16:18:56 +0400
Message-ID: <20080514121855.GA14949@2ka.mipt.ru>
References: <DB599F406D04E34389140B7D99C71B1B055EE51E@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60301C29D@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B055EE6B2@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60472088A@SDCEXCHANGE01.ad.amcc.com> <20080514103224.GA10416@Chamillionaire.breakpoint.cc> <20080514110311.GA22116@gondor.apana.org.au> <20080514115730.GA10664@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Loc Ho <lho@amcc.com>,
	Shasi Pulijala <spulijala@amcc.com>,
	linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33311 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYENMTN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2008 08:19:13 -0400
Content-Disposition: inline
In-Reply-To: <20080514115730.GA10664@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 14, 2008 at 01:57:30PM +0200, Sebastian Siewior (linux-crypto@ml.breakpoint.cc) wrote:
> Great. Here a few ideas for a new interface:
> - /dev/crypto:
>   - open file, creates a new ctx which may be one of crypto/hash/...
>   - set type via ioctl / netlink
>   - set key / other attributes via ioctl
>   - put a block for encryption via write()
>   - wait until it is done. poll() could be used to determine this state
>   - read the result via read(). 
>   - ->final() (hash) could be executed on read()

Above but without special device, but syscall instead, which will have
all needed parameters like mode string, key, iv and sizes.

> - cryptofs attempt (somehow inspired by spufs):
>   - 1 syscall to create a special crypto device (that is aes(cbc),
>     hmac(sha1) or what ever the crypto api offers).
>   - returns a handle and creates a unique folder in cryptfs
>   - the folder is RW to the owner 
>   - and contains properties of the algorithm. So we write in the file
>     keysize to specify the size of the key and write to the file key to
>     set the key. This properties are based on the class of the algorithm
>     (should be almost equal I guess).
>   - Every crypto request will be created once a file in the request
>     folder is created. Request is fed with data via the write(). 
>   - I'm not sure how we signalize that a request is done. Maybe another
>     file pops up and we can track this via inotify.
> 
> So I put this two for discussion :)
> I came up with those two a while ago but never wrote code because I had
> no use case.

Well, it might be time to start :)

I'm not sure virtual filesystem is needed though, but as well can be a
good idea. At least not ioctl hell with /dev/crypto

-- 
	Evgeniy Polyakov
