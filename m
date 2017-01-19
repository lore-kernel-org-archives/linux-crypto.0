From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH] x86/crypto: fix %progbits -> @progbits
Date: Thu, 19 Jan 2017 22:28:05 +0100
Message-ID: <20170119212805.18049-1-dvlasenk@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Xiaodong Liu <xiaodong.liu@intel.com>,
        Megha Dey <megha.dey@intel.com>,
        George Spelvin <linux@horizon.com>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751894AbdASV2L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Jan 2017 16:28:11 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

%progbits form is used on ARM (where @ is a comment char).

x86 consistently uses @progbits everywhere else.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: Josh Poimboeuf <jpoimboe@redhat.com>
CC: Xiaodong Liu <xiaodong.liu@intel.com>
CC: Megha Dey <megha.dey@intel.com>
CC: George Spelvin <linux@horizon.com>
CC: linux-crypto@vger.kernel.org
CC: x86@kernel.org
CC: linux-kernel@vger.kernel.org
---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index dc05f01..7a7de27 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -312,7 +312,7 @@ do_return:
         ret
 ENDPROC(crc_pcl)
 
-.section	.rodata, "a", %progbits
+.section	.rodata, "a", @progbits
         ################################################################
         ## jump table        Table is 129 entries x 2 bytes each
         ################################################################
-- 
2.9.2
