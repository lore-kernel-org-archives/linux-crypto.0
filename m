From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Testing the geode-aes driver with the tcrypt module completely freezes the machine
Date: Thu, 3 May 2007 18:47:22 +0400
Message-ID: <20070503144722.GA5551@2ka.mipt.ru>
References: <000601c78d84$bc24b430$1a04010a@V505CP> <20070503132310.GA21082@2ka.mipt.ru> <000701c78d8c$86935990$1a04010a@V505CP>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org
To: Martin Schiller <mschiller@tdt.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:41536 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162057AbXECOr3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 10:47:29 -0400
Content-Disposition: inline
In-Reply-To: <000701c78d8c$86935990$1a04010a@V505CP>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 03, 2007 at 04:08:29PM +0200, Martin Schiller (mschiller@tdt.de) wrote:
> > Hm, driver does not perform encryption in-place at all.
> > Since we did not hear from AMD quite for a while, could you please
> > remove src==dst check in geode_aes_crypt() and run tests again. If it
> > is software protection against hardware bug, I doubt such hardware
> > should be used at all...  
> > 
> 
> Removing the src==dst check solves the freeze problem, but the
> encryption/decryption results are wrong:
> 
> Encryption:
> Should be: 	69c4e0d86a7b0430d8cdb78070b4c55a
> But is:	c8a331ff8edd3db175e1545dbefb760b
> 
> Decryption:
> Should be:	00112233445566778899aabbccddeeff
> But is:	69c4e0d86a7b0430d8cdb78070b4c55a (same as input)

That means that hardware does not work when source and destination
addresses are the same, roughly saying it will not work with majority
cases of ipsec and dm-crypt.

As a workaround one needs to allocate a buffer and copy there data and
then encrypt/decrypt from buffer into destination.
 
> Regards,
> Martin
> 

-- 
	Evgeniy Polyakov
