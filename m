From: Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: Getting vom synch to asynch algorithms
Date: Sun, 15 Jan 2012 14:25:34 +0100
Message-ID: <CB38925E.3194%markus.stockhausen@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:53901 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750759Ab2AONYt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Jan 2012 08:24:49 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

in the last weeks I programmed a small assembler optimized MIPS kernel
module that provides basic IPsec algorithms CBC(AES), SHA1 and MD5. The
OpenWrt driven router can now achieve higher throughputs than with
standard modules.

During my LAN direct-connect tests I noticed that the device will
lockup because of being exclusively busy in encryption and decryption
routines. It does not matter if I use the generic modules or the new
one. Everything works like a charm if the device can handle IPsec
traffic with a CPU load of less than 100%.

Maybe I'm wrong but as far as I understand providing async algorithms
should enable the device to be not exclusively blocked by IPsec
handling (although it is processed totally in software). From what
I can see this requires registering the module in a different way.
I checked several existing modules but I only understand the cornerstones
of all of this.

- provide async_funct(struct ablkcipher_request *req)
- Do what inside?
- ...
- finally call the encrpytion/decryption algorithm already implemented

Some modules make work of queues others seem to call the encryption
directly. I'm somehow confused of what the async_funct should do
when working with a software algorithm.

Maybe someone can enlighten me. These days a pcrypt module was mentioned
that could help, but my router has only on CPU so there is no load to
distribute. What will be the best way to make the kernel stable with
high encryption CPU load?

Thanks in advance.

Markus
