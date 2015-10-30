From: Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH] nx-842: Endian swap ->count before handing over to the
 nx-842 compressor
Date: Fri, 30 Oct 2015 15:45:36 -0700
Message-ID: <20151030224536.GB22549@ram.oc3035372033.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ddstreet@ieee.org, hbabu@us.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:53036 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031670AbbJ3Wpo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Oct 2015 18:45:44 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <linuxram@us.ibm.com>;
	Fri, 30 Oct 2015 16:45:43 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 34E373E4003E
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2015 16:45:42 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9UMjgPi2949598
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2015 15:45:42 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9UMjfxW028574
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2015 16:45:41 -0600
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The nx-842 compressor overshoots the output buffer corrupting memory. Verified
that the following patch fixes the issue on a little-endian system.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/crypto/nx/nx-842-powernv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 3750e13..3b80ea7 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -66,7 +66,7 @@ static void setup_indirect_dde(struct data_descriptor_entry *dde,
 			       unsigned int dde_count, unsigned int byte_count)
 {
 	dde->flags = 0;
-	dde->count = dde_count;
+	dde->count = cpu_to_be32(dde_count);
 	dde->index = 0;
 	dde->length = cpu_to_be32(byte_count);
 	dde->address = cpu_to_be64(nx842_get_pa(ddl));
