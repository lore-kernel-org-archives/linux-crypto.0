From: Phil Sutter <phil.sutter@viprinet.com>
Subject: RFC: support for MV_CESA with TDMA
Date: Fri, 25 May 2012 18:08:26 +0200
Message-ID: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:47939 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285Ab2EYQJF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 12:09:05 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

The following patch series adds support for the TDMA engine built into
Marvell's Kirkwood-based SoCs, and enhances mv_cesa.c in order to use it
for speeding up crypto operations. Kirkwood hardware contains a security
accelerator, which can control DMA as well as crypto engines. It allows
for operation with minimal software intervenience, which the following
patches implement: using a chain of DMA descriptors, data input,
configuration, engine startup and data output repeat fully automatically
until the whole input data has been handled.

The point for this being RFC is backwards-compatibility: earlier
hardware (Orion) ships a (slightly) different DMA engine (IDMA) along
with the same crypto engine, so in fact mv_cesa.c is in use on these
platforms, too. But since I don't possess hardware of this kind, I am
not able to make this code IDMA-compatible. Also, due to the quite
massive reorganisation of code flow, I don't really see how to make TDMA
support optional in mv_cesa.c.

Greetings, Phil
