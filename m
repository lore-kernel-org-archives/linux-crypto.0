Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E18C433E6
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 05:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDE4D64DFF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 05:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhA2FuI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Jan 2021 00:50:08 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:56100 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231939AbhA2FuF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Jan 2021 00:50:05 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l5MeO-0002bW-GP; Fri, 29 Jan 2021 16:48:57 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Jan 2021 16:48:56 +1100
Date:   Fri, 29 Jan 2021 16:48:56 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] crypto: octeontx2 - Add dependency on NET_VENDOR_MARVELL
Message-ID: <20210129054856.GA20020@gondor.apana.org.au>
References: <b1397a30-0018-ac78-2a89-4fc0db1d1ec8@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1397a30-0018-ac78-2a89-4fc0db1d1ec8@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 25, 2021 at 09:41:12AM -0800, Randy Dunlap wrote:
> on x86_64:
> 
> ld: drivers/crypto/marvell/octeontx2/otx2_cptpf_main.o: in function `cptpf_flr_wq_handler':
> otx2_cptpf_main.c:(.text+0x2b): undefined reference to `otx2_mbox_alloc_msg_rsp'

Thanks for the report.  The issue is that the crypto driver depends
on code that sits under net so if that option is off then you'll end
up with these errors.

---8<---
The crypto octeontx2 driver depends on the mbox code in the network
tree.  It tries to select the MBOX Kconfig option but that option
itself depends on many other options which are not selected, e.g.,
CONFIG_NET_VENDOR_MARVELL.  It would be inappropriate to select them
all as randomly prompting the user for network options which would
oterhwise be disabled just because a crypto driver has been enabled
makes no sense.

This patch fixes this by adding a dependency on NET_VENDOR_MARVELL.
This makes the crypto driver invisible if the network option is off.

If the crypto driver must be visible even without the network stack
then the shared mbox code should be moved out of drivers/net.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 5e8ce8334734 ("crypto: marvell - add Marvell OcteonTX2 CPT...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index 2efbd79180ce..a188ad1fadd3 100644
--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -41,6 +41,7 @@ config CRYPTO_DEV_OCTEONTX2_CPT
 	depends on ARM64 || COMPILE_TEST
 	depends on PCI_MSI && 64BIT
 	depends on CRYPTO_LIB_AES
+	depends on NET_VENDOR_MARVELL
 	select OCTEONTX2_MBOX
 	select CRYPTO_DEV_MARVELL
 	select CRYPTO_SKCIPHER
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
