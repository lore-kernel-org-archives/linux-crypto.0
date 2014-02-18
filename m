From: Marcel Holtmann <marcel@holtmann.org>
Subject: Support for ECDH P-192 and P-256
Date: Mon, 17 Feb 2014 23:41:07 -0800
Message-ID: <88CA6BC5-E6E7-43C3-8A2A-829D27E76CE8@holtmann.org>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55062 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbaBRHlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Feb 2014 02:41:19 -0500
Received: from [192.168.1.107] (S010620c9d099deff.vc.shawcable.net [24.84.124.211])
	by mail.holtmann.org (Postfix) with ESMTPSA id 02AF28B30E
	for <linux-crypto@vger.kernel.org>; Tue, 18 Feb 2014 08:41:11 +0100 (CET)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

we are looking at adding support for Bluetooth Secure Connections to the Security Manager of the Bluetooth subsystem. For that we would need support for ECDH P-256 and eventually also P-192.

Right now we are bit lost on how this could be achieved best. I saw that the symmetric_keys feature has support for public_keys, but as far as I can tell that requires that userspace loads the public keys into the kernel and the private keys stay in userspace.

What we need is to generate private/public key pairs using elliptic curve with P-192 and P-256. We only need the private/public key pair for the Bluetooth pairing. After successful pairing, we derive link keys or long term keys and we can throw the private/public key pair away. Any further authentication between Bluetooth devices is done via their link keys or long term keys.

Has anybody looked into extending the kernel crypto framework to support ECDH P-192 and P-256. If nobody has, what are the best starting points to do so.

Regards

Marcel
