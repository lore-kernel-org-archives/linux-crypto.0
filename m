From: Martin Willi <martin@strongswan.org>
Subject: Re: HMAC regression
Date: Fri, 29 May 2009 12:04:32 +0200
Message-ID: <1243591472.7473.169.camel@martin.hsr.ch>
References: <1243523348.30487.89.camel@martin.hsr.ch>
	 <20090529061931.GA10003@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zaes.ch ([213.133.111.41]:45376 "EHLO zaes.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300AbZE2KEi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2009 06:04:38 -0400
In-Reply-To: <20090529061931.GA10003@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> > Switching the hash implementations to the new shash API introduced a
> > regression. HMACs are created incorrectly if the data is scattered over
> > multiple pages, resulting in very unreliable IPsec tunnels.
> 
> What are the symptoms?

After doing further tests, it seems that this is additionally related to
User-Mode-Linux and/or it's TUN/TAP network driver. I couldn't reproduce
the issue on a x64 with e1000. 
I think the bug is actually in the UML network code, but changing the
scatterwalk logic by using the hash_walk functions triggered the issue.

I'll try to find out more...


More details to the issue I'm seeing on UML hosts:

Packets (non fragmented) laying on multiple pages are hashed incorrectly
for HMAC calculation. This results in packet drops on HMAC secured
tunnels (XfrmInStateProtoError's on the receiving end). Affected are at
least 2.6.29, net-2.6, crypto-2.6 and cryptodev-2.6.

To reproduce this, try to send large packets (e.g. ping with -s 1400, or
iperf with TCP) over a HMAC secured ESP tunnel.
Only packets with data on page boundaries are affected. You'll have to
try until the kernel allocates the packet on multiple pages, which is
more likely with larger packets near MTU.

Thanks
Martin

