From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: [PATCH] powerpc: crypto/vmx: various build fixes
Date: Wed, 16 Nov 2016 20:41:46 +0530
Message-ID: <20161116151146.15720-1-naveen.n.rao@linux.vnet.ibm.com>
Cc: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59247 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752977AbcKPPMG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2016 10:12:06 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAGF8lwt114253
        for <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2016 10:12:05 -0500
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26rgygf06x-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2016 10:12:05 -0500
Received: from localhost
        by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <naveen.n.rao@linux.vnet.ibm.com>;
        Thu, 17 Nov 2016 01:12:02 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
        by d23dlp03.au.ibm.com (Postfix) with ESMTP id 0606E3578052
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2016 02:12:00 +1100 (EST)
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
        by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uAGFBxOR32833702
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2016 02:11:59 +1100
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
        by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uAGFBxPN006260
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2016 02:11:59 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

First up, clean up the generated .S files properly on a 'make clean'.
Secondly, force re-generation of these files when building for different
endian-ness than what was built previously. Finally, generate the new
files in the build tree, rather than the source tree.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
Michael,
I've added your SOB here though you didn't explicitly include it in your
previous mail. I hope that's fine from your end.

- Naveen

 drivers/crypto/vmx/Makefile | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/vmx/Makefile b/drivers/crypto/vmx/Makefile
index de6e241..55f7c39 100644
--- a/drivers/crypto/vmx/Makefile
+++ b/drivers/crypto/vmx/Makefile
@@ -10,10 +10,12 @@ endif
 quiet_cmd_perl = PERL $@
       cmd_perl = $(PERL) $(<) $(TARGET) > $(@)
 
-$(src)/aesp8-ppc.S: $(src)/aesp8-ppc.pl
-	$(call cmd,perl)
+targets += aesp8-ppc.S ghashp8-ppc.S
+
+$(obj)/aesp8-ppc.S: $(src)/aesp8-ppc.pl FORCE
+	$(call if_changed,perl)
   
-$(src)/ghashp8-ppc.S: $(src)/ghashp8-ppc.pl
-	$(call cmd,perl)
+$(obj)/ghashp8-ppc.S: $(src)/ghashp8-ppc.pl FORCE
+	$(call if_changed,perl)
 
-.PRECIOUS: $(obj)/aesp8-ppc.S $(obj)/ghashp8-ppc.S
+clean-files := aesp8-ppc.S ghashp8-ppc.S
-- 
2.10.2
