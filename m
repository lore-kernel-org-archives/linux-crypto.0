From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: [RFC PATCH] powerpc: crypto/vmx: clean up generated files
Date: Tue, 15 Nov 2016 22:35:49 +0530
Message-ID: <20161115170549.10538-1-naveen.n.rao@linux.vnet.ibm.com>
Cc: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>
To: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35703 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932956AbcKORGM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Nov 2016 12:06:12 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAFH4oAW004856
        for <linux-crypto@vger.kernel.org>; Tue, 15 Nov 2016 12:06:12 -0500
Received: from e23smtp01.au.ibm.com (e23smtp01.au.ibm.com [202.81.31.143])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26r4c4pmf1-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 15 Nov 2016 12:06:11 -0500
Received: from localhost
        by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <naveen.n.rao@linux.vnet.ibm.com>;
        Wed, 16 Nov 2016 03:06:09 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
        by d23dlp03.au.ibm.com (Postfix) with ESMTP id E8EBB3578052
        for <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2016 04:06:06 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
        by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uAFH661L44433456
        for <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2016 04:06:06 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
        by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uAFH66Nt004671
        for <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2016 04:06:06 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

..as stray .S files result in build errors, especially when using
cross-compilers.

More specifically, the generated .S files are endian-specific and will break
subsequent builds targeting the other endian architecture.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/vmx/Makefile b/drivers/crypto/vmx/Makefile
index de6e241..31b25cb 100644
--- a/drivers/crypto/vmx/Makefile
+++ b/drivers/crypto/vmx/Makefile
@@ -16,4 +16,4 @@ $(src)/aesp8-ppc.S: $(src)/aesp8-ppc.pl
 $(src)/ghashp8-ppc.S: $(src)/ghashp8-ppc.pl
 	$(call cmd,perl)
 
-.PRECIOUS: $(obj)/aesp8-ppc.S $(obj)/ghashp8-ppc.S
+clean-files := aesp8-ppc.S ghashp8-ppc.S
-- 
2.10.2
