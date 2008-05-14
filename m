From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Userspace API proposal was: Re: [PATCH 1/1] RFC: Add CryptoAPI
	User Space Interface Support
Date: Wed, 14 May 2008 13:57:30 +0200
Message-ID: <20080514115730.GA10664@Chamillionaire.breakpoint.cc>
References: <DB599F406D04E34389140B7D99C71B1B055EE51E@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60301C29D@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B055EE6B2@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60472088A@SDCEXCHANGE01.ad.amcc.com> <20080514103224.GA10416@Chamillionaire.breakpoint.cc> <20080514110311.GA22116@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Loc Ho <lho@amcc.com>, Shasi Pulijala <spulijala@amcc.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60258 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178AbYENL5f (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2008 07:57:35 -0400
Content-Disposition: inline
In-Reply-To: <20080514110311.GA22116@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-05-14 19:03:11 [+0800]:

>On Wed, May 14, 2008 at 12:32:24PM +0200, Sebastian Siewior wrote:
>>
>> >This should add support for OpenSSL. Please note that user of this patch
>> >musts patch OpenSSL. The OpenSSL patch can be found in OCF-Linux as this
>> >interface uses the same I/O control interface.
>> So this interface must stay as it in order not to patch openssl twice?
>
>I don't think compatibility with OCF is necessary at all.  We
>should create an interface that is suitable for Linux first of
>all rather than concentrating on OCF.
Great. Here a few ideas for a new interface:
- /dev/crypto:
  - open file, creates a new ctx which may be one of crypto/hash/...
  - set type via ioctl / netlink
  - set key / other attributes via ioctl
  - put a block for encryption via write()
  - wait until it is done. poll() could be used to determine this state
  - read the result via read(). 
  - ->final() (hash) could be executed on read()
- cryptofs attempt (somehow inspired by spufs):
  - 1 syscall to create a special crypto device (that is aes(cbc),
    hmac(sha1) or what ever the crypto api offers).
  - returns a handle and creates a unique folder in cryptfs
  - the folder is RW to the owner 
  - and contains properties of the algorithm. So we write in the file
    keysize to specify the size of the key and write to the file key to
    set the key. This properties are based on the class of the algorithm
    (should be almost equal I guess).
  - Every crypto request will be created once a file in the request
    folder is created. Request is fed with data via the write(). 
  - I'm not sure how we signalize that a request is done. Maybe another
    file pops up and we can track this via inotify.

So I put this two for discussion :)
I came up with those two a while ago but never wrote code because I had
no use case.

>
>Cheers,

Sebastian
