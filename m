From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [RFC PATCH] powerpc: crypto/vmx: clean up generated files
Date: Wed, 16 Nov 2016 21:02:15 +1100
Message-ID: <87oa1fyc7s.fsf@concordia.ellerman.id.au>
References: <20161115170549.10538-1-naveen.n.rao@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:56123 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753590AbcKPKCW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2016 05:02:22 -0500
In-Reply-To: <20161115170549.10538-1-naveen.n.rao@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> writes:

> ..as stray .S files result in build errors, especially when using
> cross-compilers.

They should be cleaned on make clean, so adding them to clean-files
seems correct.

> More specifically, the generated .S files are endian-specific and will break
> subsequent builds targeting the other endian architecture.

But that indicates we're missing an if_changed somewhere, ie. switching
endian should cause them to be regenerated.

Also they should be generated into $(obj) not $(src) I think.

How about this?

diff --git a/drivers/crypto/vmx/Makefile b/drivers/crypto/vmx/Makefile
index de6e241..52f6ae9 100644
--- a/drivers/crypto/vmx/Makefile
+++ b/drivers/crypto/vmx/Makefile
@@ -10,10 +10,10 @@ endif
 quiet_cmd_perl = PERL $@
       cmd_perl = $(PERL) $(<) $(TARGET) > $(@)
 
-$(src)/aesp8-ppc.S: $(src)/aesp8-ppc.pl
-       $(call cmd,perl)
+$(obj)/aesp8-ppc.S: $(src)/aesp8-ppc.pl FORCE
+       $(call if_changed,perl)
   
-$(src)/ghashp8-ppc.S: $(src)/ghashp8-ppc.pl
-       $(call cmd,perl)
+$(obj)/ghashp8-ppc.S: $(src)/ghashp8-ppc.pl FORCE
+       $(call if_changed,perl)
 
 .PRECIOUS: $(obj)/aesp8-ppc.S $(obj)/ghashp8-ppc.S


cheers
