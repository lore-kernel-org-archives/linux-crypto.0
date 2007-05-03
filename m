From: "Martin Schiller" <mschiller@tdt.de>
Subject: RE: Testing the geode-aes driver with the tcrypt module completely freezes the machine
Date: Thu, 3 May 2007 16:08:29 +0200
Message-ID: <000701c78d8c$86935990$1a04010a@V505CP>
References: <000601c78d84$bc24b430$1a04010a@V505CP> <20070503132310.GA21082@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: "'Evgeniy Polyakov'" <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.tdt.de ([195.243.126.82]:42359 "EHLO ns.tdt.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161956AbXECOIX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 10:08:23 -0400
Received: from ns (root@localhost)
	by ns.tdt.de (8.11.6/8.11.6/SuSE Linux 0.5) with SMTP id l43E8LZ30801
	for <linux-crypto@vger.kernel.org>; Thu, 3 May 2007 16:08:21 +0200
In-Reply-To: <20070503132310.GA21082@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday, May 03, 2007 3:23 PM, Evgeniy Polyakov wrote:

> On Thu, May 03, 2007 at 03:12:43PM +0200, Martin Schiller
> (mschiller@tdt.de) wrote: 
>> The freeze is the result of an invinite while-loop in the function
>> geode_ecb_encrypt() (and maybe also in the geode_ecb_decrypt()).
>> 
>> The cause for this seems to be, that the op->src == op->dst whereby
>> the geode_aes_crypt() function does nothing at all, and so the value
>> of nbytes will never be changed.
> 
> Hm, driver does not perform encryption in-place at all.
> Since we did not hear from AMD quite for a while, could you please
> remove src==dst check in geode_aes_crypt() and run tests again. If it
> is software protection against hardware bug, I doubt such hardware
> should be used at all...  
> 

Removing the src==dst check solves the freeze problem, but the
encryption/decryption results are wrong:

Encryption:
Should be: 	69c4e0d86a7b0430d8cdb78070b4c55a
But is:	c8a331ff8edd3db175e1545dbefb760b

Decryption:
Should be:	00112233445566778899aabbccddeeff
But is:	69c4e0d86a7b0430d8cdb78070b4c55a (same as input)


Regards,
Martin
