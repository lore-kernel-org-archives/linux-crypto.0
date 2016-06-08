From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC] DRBG: which shall be default?
Date: Wed, 08 Jun 2016 11:32:03 +0200
Message-ID: <2061639.Fd5tNFoguQ@positron.chronox.de>
References: <1664837.3VbqQRUZed@positron.chronox.de> <2066130.uIxle5Vnoa@tauon.atsec.com> <20160608091500.GA14329@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36064 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423822AbcFHJcH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2016 05:32:07 -0400
In-Reply-To: <20160608091500.GA14329@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 8. Juni 2016, 17:15:00 schrieb Herbert Xu:

Hi Herbert, Tadeusz,

> On Wed, Jun 08, 2016 at 11:07:42AM +0200, Stephan Mueller wrote:
> > No, it does not:
> > 
> > #ifdef CONFIG_X86_64
> 
> Well there is no fundamental reason why we can't do it on 32-bit.
> Even if we just did the counter increment in C this would still
> beat ctr(aes-aesni) by many orders of magnitude.

I would think that the performance boost on 64 bit should warrant an official 
patch set.
> 
> So if you really care about the performance on x86-32 then perhaps
> you should send a patch to implement ctr-aes-aesni for it.

Maybe Intel can shed some light on this:

Tadeusz, can you please help me understand why the ctr-aes-aesni is only 
defined for 64 bit?

Thanks
Stephan
