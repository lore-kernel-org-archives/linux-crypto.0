From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Proposal for adding setpubkey callback to akcipher_alg
Date: Tue, 4 Aug 2015 21:33:27 -0700
Message-ID: <5591E036-386D-40D4-B906-4D014B20667A@holtmann.org>
References: <905E1812-AD9B-4188-A668-3CD8985EA1BF@holtmann.org> <1704807.Rn4DsddD6R@tauon.atsec.com> <70C201C0-233D-4912-9856-C8C0E7A6A0FA@holtmann.org> <14682477.78a1L9JDin@myon.chronox.de> <3743CED6-E3E0-416E-9B82-F1677628E35E@holtmann.org> <20150805024600.GA3878@gondor.apana.org.au> <DDF4B0CD-92AE-4EB4-97BE-9218CF7FA784@holtmann.org> <20150805040641.GA4398@gondor.apana.org.au>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Stephan Mueller <smueller@chronox.de>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	David Howells <dhowells@redhat.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:52414 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbbHEEdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 00:33:33 -0400
In-Reply-To: <20150805040641.GA4398@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

>> We already have an interface that can handle asymmetric keys and it is easy to extend with new key formats and key types. So lets use that. I can clearly see that after RSA, we get DSA, ECDH etc. So having a simple way to handle these key formats is a good idea. That infrastructure is already in place and easy to extend if needed. Especially with the background that some keys might be actually in hardware or compiled into the kernel, the current asymmetric key interface has the right abstraction. It is also the right abstraction to deal with crypto hardware like TPM or even UEFI.
> 
> The crypto API akcipher interface is never going to be used for TPM
> or UEFI.  This is a purely algorithmic interface intended for
> hardware acceleration devices.  If your key is embedded into the
> hardware or otherwise hidden then this is not the interface for you.

I think it actually is the correct interface. And it will still stay a purely algorithmic interface. It is just that the algorithm is bound to specific hardware with a specific key. I really do not understand your distinction here.

Seriously where is the difference. Lets say you have AES-CCM offload in one PCI card and AES-ECB offload in another PCI card. The main job of skcipher here is to pick the right engine. So RSA-key1 in one PCI card compared to RSA-key2 in another PCI card is pretty much the same concept. So really explain to me where you are deriving your difference from.

If the hardware can offload the operation for you, then that is what it is doing. Not everything is about speed. Some things are actually about security. And treating akcipher the same as skcipher is not going to work. They are two different concepts and they are used differently.

Why would you advocate that we duplicate akcipher abstraction once for hardware acceleration and once for security key storage operation. At the end of the day it is the same abstraction. As I mentioned before, for skcipher the acceleration aspects are clear first and foremost. However just extending that reasoning blindly to akcipher is short sighted. I think we have a great opportunity to create a really powerful and simple API for asymmetric cryptography and hardware assisted asymmetric cryptography.

And if you think about how RSA for example is used these days, you spent more time loading the certificate and the keys, then you actually spent in the cipher operation. It is just the stepping stone for creating the session key that you are using with skcipher like AES.

So I do not want to waste time setting up my keys over and over again for a single RSA operation. I want to set them up quickly and then run my RSA cipher operation. I also want to set them up securely where my private key is protect and not copied for every single instance.

Regards

Marcel
