From: Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH] nx-842: Ignore bit 3 of condition register returned by icswx
Date: Fri, 30 Oct 2015 15:43:01 -0700
Message-ID: <20151030224301.GA22549@ram.oc3035372033.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ddstreet@ieee.org, hbabu@us.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:52922 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbbJ3WnL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Oct 2015 18:43:11 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <linuxram@us.ibm.com>;
	Fri, 30 Oct 2015 16:43:10 -0600
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id C4F4F38C805F
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2015 18:43:08 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9UMh8VU60031228
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2015 22:43:08 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9UMg1mK020312
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2015 18:42:03 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

icswx occasionally under heavy load sets bit 3 of condition register 0.
It has no software implication.

Currently that bit is interpreted by the driver as a failure, when
it should have calmly ignored it.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 arch/powerpc/include/asm/icswx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/icswx.h b/arch/powerpc/include/asm/icswx.h
index 9f8402b..bce20c7 100644
--- a/arch/powerpc/include/asm/icswx.h
+++ b/arch/powerpc/include/asm/icswx.h
@@ -177,7 +177,7 @@ static inline int icswx(__be32 ccw, struct coprocessor_request_block *crb)
 	: "r" (ccw_reg), "r" (crb)
 	: "cr0", "memory");
 
-	return (int)((cr >> 28) & 0xf);
+	return (int)((cr >> 28) & 0xe);
 }
