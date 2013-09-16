From: dominik.d.paulus@studium.uni-erlangen.de
Subject: crypto: GCM API usage
Date: Mon, 16 Sep 2013 12:58:40 +0200
Message-ID: <65abe254e199230984fd6a15dec39a76.squirrel@faumail.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-kernel@i4.cs.fau.de, tobias.polzer@fau.de
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:46406 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757497Ab3IPLFH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Sep 2013 07:05:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

We are currently trying to add encryption support to the usbip kernel
driver. Unfortunately, there is almost no documentation for the kernel
crypto API. So far, we couldn't figure out how to use the GCM encryption
mode in the kernel. There seems to be infrastructure for IV generation
in place (e.g. seqiv.c, the geniv stuff and the RFC 4106 implementation),
but no code directly using it.

What's the recommended way to use the IV generators with a "high-level"
API?

Regards,
        Tobias Polzer and Dominik Paulus
