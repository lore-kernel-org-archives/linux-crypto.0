From: Stephan Mueller <smueller@chronox.de>
Subject: Re: communicating from the user space
Date: Mon, 23 Feb 2015 09:17 +0100
Message-ID: <4767408.E4yQUuQjlM@tachyon.chronox.de>
References: <CAHTT9VLmj8A7V5t+P9Zc02r5nyv37VMfa=QwPOuiMS9WFdXUxg@mail.gmail.com> <1989293.ccvZM8v2KA@tachyon.chronox.de> <1424640392.22199.3.camel@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60289 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbbBWIRG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Feb 2015 03:17:06 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S169C7> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 23 Feb 2015 09:17:00 +0100
In-Reply-To: <1424640392.22199.3.camel@gnutls.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 22. Februar 2015, 22:26:32 schrieb Nikos Mavrogiannopoulos:

Hi Nikos,

> On Sun, 2015-02-22 at 16:04 +0100, Stephan Mueller wrote:
> > Am Sonntag, 22. Februar 2015, 18:32:34 schrieb sri sowj:
> > 
> > Hi sri,
> > 
> > > Hi Stephen,
> > > 
> > > It was a great information with respective PF_ALG , I have explored a
> > > bit on openssl and algorithms prospect , Please let me know if
> > > anything to add to it.
> > > 
> > > openssl crypto engine:
> > > 
> > > below are the steps to enable openssl to communicate using pf/af_alg.
> > > 
> > > #1:git clone http://src.carnivore.it/users/common/af_alg/
> > 
> > Yes, that is it. But it is not fully efficient as it does not use vmsplice
> > where appropriate. So, libkcapi should be faster in several use cases.
> 
> When would vmsplice be appropriate? As far as I understand vmsplice adds
> a cost on operations for small data, which is the majority of use cases
> in crypto. In the measurements I did for cryptodev-linux [0] vmsplice
> did improve performance only for more than 64k packets which is never
> the case with real world crypto (TLS has a maximum of 14k for example).

According to my measurements, I have the following heuristic for symmetric 
ciphers: if the ciphertext is less than 1<<13, then use one sendmsg call. 
Otherwise use vmsplice.

For AEAD, my library uses 3 IOVecs which means that sendmsg is faster in any 
case (the overhead for setting up 3 IOVecs in kernel space for vmsplice is 
higher than sendmsg copy).

For hashes, I yet have to make the measurements.
> 
> regards,
> Nikos
> 
> [0]. http://cryptodev-linux.org/comparison.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ciao
Stephan
