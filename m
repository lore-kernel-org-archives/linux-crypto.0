From: Stephan Mueller <smueller@chronox.de>
Subject: Re: communicating from the user space
Date: Sun, 22 Feb 2015 16:04:36 +0100
Message-ID: <1989293.ccvZM8v2KA@tachyon.chronox.de>
References: <CAHTT9VLmj8A7V5t+P9Zc02r5nyv37VMfa=QwPOuiMS9WFdXUxg@mail.gmail.com> <1543956.4M98jElNTF@tachyon.chronox.de> <CAHTT9VKQ2nB92SgRsGYemgTO6tTDucKyOs-9uCQn9+vAweQwuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: sri sowj <srisowj4linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60285 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbbBVPFN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 22 Feb 2015 10:05:13 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S1691A> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sun, 22 Feb 2015 16:04:36 +0100
In-Reply-To: <CAHTT9VKQ2nB92SgRsGYemgTO6tTDucKyOs-9uCQn9+vAweQwuQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 22. Februar 2015, 18:32:34 schrieb sri sowj:

Hi sri,

> Hi Stephen,
> 
> It was a great information with respective PF_ALG , I have explored a
> bit on openssl and algorithms prospect , Please let me know if
> anything to add to it.
> 
> openssl crypto engine:
> 
> below are the steps to enable openssl to communicate using pf/af_alg.
> 
> #1:git clone http://src.carnivore.it/users/common/af_alg/

Yes, that is it. But it is not fully efficient as it does not use vmsplice 
where appropriate. So, libkcapi should be faster in several use cases.

> #2:cd af_alg/
> #3:make
> #4:sudo cp libaf_alg.so /usr/lib/arm-linux-gnueabi/openssl-1.0.0/engines/
> #5:sudo chmod 644
> /usr/lib/arm-linux-gnueabi/openssl-1.0.0/engines/libaf_alg.so
> 
> 
> Algorithms supported by pf/af_alg from user space to test:
> 
> CIPHERS=aes-128-cbc aes-192-cbc aes-256-cbc des-cbc des-ede3-cbc
> DIGESTS=md4 md5 sha1 sha224 sha256 sha512
> 
> 
> Next step is ,I would like to see the support available to write and
> test more and more samples/test utilities between PF/AF_ALG and
> cryptodev .
> 
> BR,
> SriSowj
> 
> On Sat, Feb 21, 2015 at 12:31 PM, Stephan Mueller <smueller@chronox.de> 
wrote:
> > Am Samstag, 21. Februar 2015, 08:39:05 schrieb sri sowj:
> > 
> > Hi sri,
> > 
> >> Hi Stephen,
> >> 
> >> Thank you very much for the information provided.
> >> 
> >> I will try to explore more on AF_ALG , in between please can you also
> >> provide information regarding below ?
> >> #1: how openssl communicates to crypto h/w using PF_ALG
> > 
> > Search the net, there is an engine available
> > 
> >> #2: How man algorithms are supported?
> > 
> > All that the kernel crypto API supports
> > 
> >> #3: are there any samples to get start with.
> > 
> > Maybe you look into libkcapi -- there are plenty of examples.
> > 
> >> but if you can provide some info regarding cryptodev-linux from the
> >> openssl prospect it will be more helpful.
> > 
> > cryptodev-linux is not merged into the kernel and it looks that it never
> > will considering the presence of AF_ALG
> > 
> >> BR,
> >> Srisowj
> >> 
> >> On Sat, Feb 21, 2015 at 2:28 AM, Stephan Mueller <smueller@chronox.de>
> > 
> > wrote:
> >> > Am Samstag, 21. Februar 2015, 01:27:04 schrieb sri sowj:
> >> > 
> >> > Hi sri,
> >> > 
> >> >> Hi ,
> >> >> 
> >> >> I want to interact with Crypto Hardware from user space using openssl
> >> >> like libraries based applications through cryptodev-linux interface.
> >> >> 
> >> >> it looks like openssl comes with cryptodev-linux support(through
> >> >> eng_cryptodev.c) .
> >> >> When I downloaded openssl,eng_cryptodev.c file is available by
> >> >> default.
> >> >> 
> >> >> below link refers about eng_cryptodev.c for openssl support :
> >> >> 
> >> >> http://repo.or.cz/w/cryptodev-linux.git/commitdiff/56cc4e3b8b761cb34f9
> >> >> 28f
> >> >> 4ee e59755d1f0afc53
> >> >> 
> >> >> Note:looks like there are some additional changes done on
> >> >> eng_cryptodev.c file available in updated openssl source code.
> >> >> 
> >> >> There seems to be some changes/patches  also available recently for
> >> >> cryptodev-linux,below contains reference information.
> >> >> 
> >> >> http://rt.openssl.org/Ticket/Display.html?id=2770&user=guest&pass=gues
> >> >> t
> >> >> 
> >> >> 
> >> >> Please let me know if my understanding is incorrect .
> >> > 
> >> > See AF_ALG and a generic user space library around it:
> >> > 
> >> > http://www.chronox.de/libkcapi.html
> >> > 
> >> >> BR,
> >> >> Srisowj
> >> >> --
> >> >> To unsubscribe from this list: send the line "unsubscribe
> >> >> linux-crypto"
> >> >> in
> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> > 
> >> > --
> >> > Ciao
> >> > Stephan
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-crypto"
> >> in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > --
> > Ciao
> > Stephan


-- 
Ciao
Stephan
