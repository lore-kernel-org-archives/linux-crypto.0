From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: communicating from the user space
Date: Sun, 22 Feb 2015 22:26:32 +0100
Message-ID: <1424640392.22199.3.camel@gnutls.org>
References: <CAHTT9VLmj8A7V5t+P9Zc02r5nyv37VMfa=QwPOuiMS9WFdXUxg@mail.gmail.com>
	 <1543956.4M98jElNTF@tachyon.chronox.de>
	 <CAHTT9VKQ2nB92SgRsGYemgTO6tTDucKyOs-9uCQn9+vAweQwuQ@mail.gmail.com>
	 <1989293.ccvZM8v2KA@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:33716 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbbBVV0f (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 22 Feb 2015 16:26:35 -0500
Received: by mail-wg0-f53.google.com with SMTP id a1so22219344wgh.12
        for <linux-crypto@vger.kernel.org>; Sun, 22 Feb 2015 13:26:34 -0800 (PST)
In-Reply-To: <1989293.ccvZM8v2KA@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 2015-02-22 at 16:04 +0100, Stephan Mueller wrote:
> Am Sonntag, 22. Februar 2015, 18:32:34 schrieb sri sowj:
> 
> Hi sri,
> 
> > Hi Stephen,
> > 
> > It was a great information with respective PF_ALG , I have explored a
> > bit on openssl and algorithms prospect , Please let me know if
> > anything to add to it.
> > 
> > openssl crypto engine:
> > 
> > below are the steps to enable openssl to communicate using pf/af_alg.
> > 
> > #1:git clone http://src.carnivore.it/users/common/af_alg/
> Yes, that is it. But it is not fully efficient as it does not use vmsplice 
> where appropriate. So, libkcapi should be faster in several use cases.

When would vmsplice be appropriate? As far as I understand vmsplice adds
a cost on operations for small data, which is the majority of use cases
in crypto. In the measurements I did for cryptodev-linux [0] vmsplice
did improve performance only for more than 64k packets which is never
the case with real world crypto (TLS has a maximum of 14k for example).

regards,
Nikos

[0]. http://cryptodev-linux.org/comparison.html
