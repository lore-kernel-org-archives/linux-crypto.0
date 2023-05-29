Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91D8C7EE23
	for <linux-crypto@archiver.kernel.org>; Mon, 29 May 2023 23:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjE2XNN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 May 2023 19:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjE2XNM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2023 19:13:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29429AD;
        Mon, 29 May 2023 16:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=2GSBnGGF/cWciTe090S7qBqvsPOJa4MBkLkJEyta5hk=; b=JVJvd0HZPkeM1i/qHdw8SNFkZm
        ofwPGKDaFbdxyWAqsXjT+IeCdSOdrhMr2amWD/SVGRRarIqMPqRi7JMhfIalNaMoCsU8XFY/Pim1W
        ac5KSoDelKbQHKXAE2fA9lUiVPc1Y6A5heX9TVpXbL/m2tfCS3lm9FowHJmiFAzYo3UXIVdBgmpWa
        SXftjTYfcMw4HRESb0VQuu3bXE9fKTplOvNff2WibOqrOtMwKH8wWwveigf/Q4MVfZ4xlDWaYtfbF
        TTF8kK2Y2CeUesvsPM6ICOCu4AqUPgCPd5Y0LXdNA3vCS4sfiZmcggoaX5u0ow3ONWO21BqBEXftQ
        S+Lrsa3Q==;
Received: from [2601:1c2:980:9ec0::2764] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q3m31-00BtbH-1I;
        Mon, 29 May 2023 23:13:07 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paul Gazzillo <paul@pgazz.com>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] virt: sev-guest: fix kconfig warnings
Date:   Mon, 29 May 2023 16:13:05 -0700
Message-Id: <20230529231305.16995-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

kconfig complains about unmet dependencies for SEV_GUEST
whenever CRYPTO is not set/enabled, so also select CRYPTO
when selecting other crypto kconfig options to silence the
warnings.

Quietens these warnings:

WARNING: unmet direct dependencies detected for CRYPTO_GCM
  Depends on [n]: CRYPTO [=n]
  Selected by [y]:
  - SEV_GUEST [=y] && VIRT_DRIVERS [=y] && AMD_MEM_ENCRYPT [=y]

WARNING: unmet direct dependencies detected for CRYPTO_AEAD2
  Depends on [n]: CRYPTO [=n]
  Selected by [y]:
  - SEV_GUEST [=y] && VIRT_DRIVERS [=y] && AMD_MEM_ENCRYPT [=y]

Fixes: fce96cf04430 ("virt: Add SEV-SNP guest driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Link: lore.kernel.org/r/202305300557.PJ5ao694-lkp@intel.com
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Paul Gazzillo <paul@pgazz.com>
Cc: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/virt/coco/sev-guest/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -- a/drivers/virt/coco/sev-guest/Kconfig b/drivers/virt/coco/sev-guest/Kconfig
--- a/drivers/virt/coco/sev-guest/Kconfig
+++ b/drivers/virt/coco/sev-guest/Kconfig
@@ -2,6 +2,7 @@ config SEV_GUEST
 	tristate "AMD SEV Guest driver"
 	default m
 	depends on AMD_MEM_ENCRYPT
+	select CRYPTO
 	select CRYPTO_AEAD2
 	select CRYPTO_GCM
 	help
