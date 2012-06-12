From: Phil Sutter <phil.sutter@viprinet.com>
Subject: RFC: support for MV_CESA with IDMA or TDMA
Date: Tue, 12 Jun 2012 19:17:14 +0200
Message-ID: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
References: <20120612113941.GA14757@gondor.apana.org.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:58649 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab2FLRR5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jun 2012 13:17:57 -0400
In-Reply-To: <20120612113941.GA14757@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

The following patch series adds support for the TDMA engine built into
Marvell's Kirkwood-based SoCs as well as the IDMA engine built into
Marvell's Orion-based SoCs and enhances mv_cesa.c in order to use it for
speeding up crypto operations. The hardware contains a security
accelerator, which can control DMA as well as crypto engines. It allows
for operation with minimal software intervention, which the following
patches implement: using a chain of DMA descriptors, data input,
configuration, engine startup and data output repeat fully automatically
until the whole input data has been handled.

The point for this being RFC is lack of hardware on my side for testing
the IDMA support. I'd highly appreciate if someone with Orion hardware
could test this, preferably using the hmac_comp tool shipped with
cryptodev-linux as it does a more extensive testing (with bigger buffer
sizes at least) than tcrypt or the standard kernel-internal use cases.

Greetings, Phil
