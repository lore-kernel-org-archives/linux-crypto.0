From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [ACRYPTO] New asynchronous crypto layer (acrypto) release.
Date: Sat, 21 Oct 2006 10:59:37 +0400
Message-ID: <20061021065937.GA12921@2ka.mipt.ru>
References: <20060928120826.GA18063@2ka.mipt.ru> <451BCCDF.5000201@ciphirelabs.com> <20060929094809.GA31117@2ka.mipt.ru> <453793F3.1080207@ciphirelabs.com> <20061020063111.GA26283@2ka.mipt.ru> <4538D070.80203@ciphirelabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56981 "EHLO 2ka.mipt.ru")
	by vger.kernel.org with ESMTP id S2992789AbWJUG7i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 21 Oct 2006 02:59:38 -0400
To: Andreas Jellinghaus <aj@ciphirelabs.com>
Content-Disposition: inline
In-Reply-To: <4538D070.80203@ciphirelabs.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 20, 2006 at 03:34:40PM +0200, Andreas Jellinghaus (aj@ciphirelabs.com) wrote:
> >Btw, async provider only supports AES-128 in CBC mode, so if you try
> >different ciphers, there can be some problems.
> 
> my code does
> 
> SECTORS=`blockdev --getsize /dev/hda3`
> 
> echo 0 $SECTORS crypt aes-cbc-essiv:sha256 $ROOTKEY 0 /dev/hda3 0 \
>         |dmsetup create root
> 
> so this is not compatible with acrypto I guess :(
> any special reason why acrypto is limited this way?

I'm lazy and I did not implemented async provider so it would request
other ciphers. It is not limitation of acrypto, but instead of software
async_provider, which should be extended to support any kind of ciphers,
instead of precompiled one.

> guess that limitation needs to go away before it can be added to
> the linux kernel, or some workaround so dm-crypt will fall back on
> not using acrypto or something like that in order to not brake existing
> and working installations.

Well, I guess async_provider itself should go away, instead I will
change synchronous cryptoapi code to register itself as acrypto device
when new tfm is created.

> Thanks, Andreas

-- 
	Evgeniy Polyakov
