From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: Suspect bug in the authenc module
Date: Mon, 1 Mar 2010 14:24:33 +0100
Message-ID: <20100301132433.GA20729@secunet.com>
References: <201002271214.15414.myrobmail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Roberto Sassu <myrobmail@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:42814 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab0CANYM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Mar 2010 08:24:12 -0500
Content-Disposition: inline
In-Reply-To: <201002271214.15414.myrobmail@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 27, 2010 at 12:14:15PM +0100, Roberto Sassu wrote:
> Hello
> 
> i'm trying to use the authenc module and i wrote a small kernel module that 
> simply encrypts/decrypts a fixed data using the hmac(sha1) as authentication 
> algorithm and cbc(aes) as encryption algorithm. 
> The used platform is a KVM quest with Fedora 12 i686 and the latest kernel 
> 2.6.33.
> I have taken the code from the testmgr and from net/ipv4/esp4.c.
> But, when testing the code, attached in this mail, the crypto_aead_decrypt() 
> function always replies -EBADMSG. 

I've posted two fixes for authenc to the linux-crypto list last week.
Could you please try whether these patches fix your problems?

Thanks,

Steffen

