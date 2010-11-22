From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH 0/11] Add IPsec extended (64-bit) sequence numbers
Date: Mon, 22 Nov 2010 11:24:55 +0100
Message-ID: <20101122102455.GC1868@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Gruenbacher <agruen@suse.de>,
	Alex Badea <abadea@ixiacom.com>, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:45366 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab0KVKY6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Nov 2010 05:24:58 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset adds support for IPsec extended (64-bit) sequence numbers for
esp as defined in RFC 4303. Also it adds support for anti-replay windows
bigger than 32 packets. To make use of big anti-replay windows and extended
sequence numbers, new userspace tools are needed. An example patch for
iproute2 is provided with this patchset. It has not much testing yet, in
particular I don't have any other implementations of IPsec extended sequence
numbers to test against. So this is not yet ready for inclusion, I just want
to receive some review on the design before I spend more time on working at it.

The patchset is also available at branch net-next-esn of

git://git.kernel.org/pub/scm/linux/kernel/git/klassert/linux-2.6-stk.git

Steffen
