From: Leonidas S Barbosa <leosilva@linux.vnet.ibm.com>
Subject: [PATCH 2/2] Fixing vmx-crypto GHASH Key issue on little endian
Date: Fri, 14 Aug 2015 10:14:16 -0300
Message-ID: <20150814131413.GA12564@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Paulo Smorigo <pfsmorigo@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:55353 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbbHNNOX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2015 09:14:23 -0400
Received: from /spool/local
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Fri, 14 Aug 2015 10:14:21 -0300
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

GHASH table algorithm is using a big endian key.
In little endian machines key will be LE ordered.
After a lxvd2x instruction key is loaded as it is,
LE/BE order, in first case it'll generate a wrong
table resulting in wrong hashes from the algorithm.

Bug affects only LE machines.
In order to fix it we do a swap for loaded key.

Signed-off-by: Leonidas S Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/ghashp8-ppc.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/vmx/ghashp8-ppc.pl b/drivers/crypto/vmx/ghashp8-ppc.pl
index 0a6f899..d8429cb 100644
--- a/drivers/crypto/vmx/ghashp8-ppc.pl
+++ b/drivers/crypto/vmx/ghashp8-ppc.pl
@@ -61,6 +61,12 @@ $code=<<___;
 	mtspr		256,r0
 	li		r10,0x30
 	lvx_u		$H,0,r4			# load H
+	le?xor		r7,r7,r7
+	le?addi		r7,r7,0x8		# need a vperm start with 08
+	le?lvsr		5,0,r7
+	le?vspltisb	6,0x0f
+	le?vxor		5,5,6			# set a b-endian mask
+	le?vperm	$H,$H,$H,5
 
 	vspltisb	$xC2,-16		# 0xf0
 	vspltisb	$t0,1			# one
-- 
2.1.0
