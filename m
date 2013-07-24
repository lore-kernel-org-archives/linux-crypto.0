From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] modules: add support for soft module dependencies
Date: Wed, 24 Jul 2013 17:17:57 +1000
Message-ID: <20130724071757.GA30970@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Zhao Hongjiang <zhaohongjiang@huawei.com>, davem@davemloft.net,
	tim.c.chen@linux.intel.com,
	Andrew Morton <akpm@linux-foundation.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org
To: Andreas Robinson <andr345@gmail.com>,
	Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:33169 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751828Ab3GXHSI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jul 2013 03:18:08 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Rusty:

I don't know why this patch never went into the kernel, even
though the corresponding features have been added to modprobe
in most if not all distros.

This is required for dependencies on crypto modules such as
crc32c where the dependency is only visible at run-time, which
means that depmod fails to list the necessary dependencies
causing modules to go missing in the initrd.

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--0OAP2g/MAC+5xKAE
Content-Type: message/rfc822
Content-Disposition: inline

From: Andreas Robinson <andr345@gmail.com>
Date: Thu, 5 Nov 2009 14:01:44 +0100
Subject: [PATCH 1/2] modules: add support for soft module dependencies

Additional and optional dependencies not found while building the kernel and
modules, can now be declared explicitly.

Signed-off-by: Andreas Robinson <andr345@gmail.com>
---
 include/linux/module.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 482efc8..0a97fe2 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -98,6 +98,11 @@ extern struct module __this_module;
 /* For userspace: you can also call me... */
 #define MODULE_ALIAS(_alias) MODULE_INFO(alias, _alias)
 
+/* Soft module dependencies. See man modprobe.d for details.
+ * Example: MODULE_SOFTDEP("pre: module-foo post: module-bar")
+ */
+#define MODULE_SOFTDEP(_softdep) MODULE_INFO(softdep, _softdep)
+
 /*
  * The following license idents are currently accepted as indicating free
  * software modules
-- 
1.6.3.3

--0OAP2g/MAC+5xKAE--
