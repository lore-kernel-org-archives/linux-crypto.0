From: Dean Jenkins <djenkins@mvista.com>
Subject: ESP output when using NULL encryption and NON authentication
Date: Thu, 27 Nov 2008 18:13:18 +0000
Message-ID: <200811271813.18727.djenkins@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:7278 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbYK0SNU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Nov 2008 13:13:20 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I am writing a kernel driver for hardware crypto offloading for IPsec.

I have configured IPsec to use NULL encryption and NON authentication. The ESP 
packets contain just the encapsulated packet as expected.

However, ESP's call to crypto_aead_decrypt() puts the start of the 
encapsulated packet (first 16 bytes) into the IV field of the AEAD request 
instead of wholly in the src scatterlist. The dst scatterlist is in fact the 
same src scatterlist.

I guessing that the NULL encryption need to copy the start of the packet from 
the IV field and join it back up with the end of the packet in src and place 
the whole packet in the dst. Am I right ?

My question is how do I increase the size of the dst scatterlist as it is too 
small to hold the complete packet ?

If I use software encryption then the ESP packets work OK. So there must be 
special treatment for NULL encryption and NON authentication. Can someone 
please explain ?

Also, I note that tcrypt.ko does not test authenc.

Thanks,
Dean Jenkins
MontaVista Software
