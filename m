From: Dimitrios Siganos <dimitris@siganos.org>
Subject: ESP hardware acceleration
Date: Tue, 15 Sep 2009 14:19:27 +0100
Message-ID: <4AAF945F.8060501@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lvps212-241-214-128.vps.webfusion.co.uk ([212.241.214.128]:50406
	"EHLO siganos.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbZION0K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2009 09:26:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

We are using linux-2.6.28 and we would like to hardware accelerate the 
NETKEY IPsec traffic. We are using strongswan for the upper layers.

I understand that strongswan uses the Linux/NETKEY IPsec implementation, 
which in turn, uses the Linux Scatterlist Crypto API for all its 
cryptographic work. To hardware accelerate IPsec, I need to write a 
"Linux Scatterlist Crypto API" driver for my hardware accelerator and 
register it with the linux kernel.

What I would like to know is:
1) does the xfrm/ESP implementation support asynchronous/parallel packet 
operation?
2) If yes, does it support it in both directions (tx/rx)?

Our hardware supports a queue packets for processing and we would like 
to utilise that, to keep the hardware as busy as possible i.e. we would 
like to be able to send multiple packets to the hardware engine for 
encryption/hashing and then receive multiple acknowledgements that the 
packets are ready.

Regards,
Dimitrios Siganos

