Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C9AC433E1
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 12:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3AE1207DA
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 12:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgHUMma (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 08:42:30 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50310 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbgHUMma (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 08:42:30 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k96N0-0000bo-Ow; Fri, 21 Aug 2020 22:42:11 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Aug 2020 22:42:10 +1000
Date:   Fri, 21 Aug 2020 22:42:10 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: stm32 - Add missing header inclusions
Message-ID: <20200821124210.GA31649@gondor.apana.org.au>
References: <202008212033.z5PbDJuy%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202008212033.z5PbDJuy%lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 21, 2020 at 08:22:37PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   3d29e98d1d7550fc959a7ad4258bd804b533b493
> commit: 0c3dc787a62aef3ca7aedf3797ec42fff9b0a913 [2/35] crypto: algapi - Remove skbuff.h inclusion
> config: arm-randconfig-r016-20200820 (attached as .config)
> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project b587ca93be114d07ec3bf654add97d7872325281)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install arm cross compiling tool for clang build
>         # apt-get install binutils-arm-linux-gnueabi
>         git checkout 0c3dc787a62aef3ca7aedf3797ec42fff9b0a913
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=arm 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>

Thanks for the report.  This patch should fix it:

---8<---
The stm32 driver was missing a number of includes that we being
pulled in by unrelated header files.  As the indirect inclusion
went away, it now fails to build.

This patch adds the missing inclusions.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 0c3dc787a62a ("crypto: algapi - Remove skbuff.h inclusion")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index 3ba41148c2a4..5fb706b68309 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -7,6 +7,8 @@
 #include <linux/bitrev.h>
 #include <linux/clk.h>
 #include <linux/crc32poly.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 03c5e6683805..092eaabda238 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -9,6 +9,7 @@
 #include <linux/clk.h>
 #include <linux/crypto.h>
 #include <linux/delay.h>
+#include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
