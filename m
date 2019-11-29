Return-Path: <SRS0=xIDj=ZV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054BDC432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9E7B21721
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575051394;
	bh=qH8chtq21VTUC09zCa9EbHhgJqTk8Du5bgarliTIMh8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Gk+eeRua7ukZYjM+c4q5b87vR+QEOfKsYY8iHKUsBFLvHXG9cHB0QbtCL9WVA3TJD
	 eSWp5UHadVRio/0S7EhOA23BIP0nbgZ7ueNW2My+Em2BeWbhVIDVwrKrYhCYGaDD1o
	 wgutttcr0ZOrBCC5J2koVUa2oiyUsv9SdeAVV4uE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfK2SQe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Nov 2019 13:16:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbfK2SQe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Nov 2019 13:16:34 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D52C2158A;
        Fri, 29 Nov 2019 18:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575051393;
        bh=qH8chtq21VTUC09zCa9EbHhgJqTk8Du5bgarliTIMh8=;
        h=From:To:Cc:Subject:Date:From;
        b=FpfvZ7z8fwSrhDjEYaWNp5ETrtbSAldZFrTv8Vji7we/fKHoz0o9iVmOAtm/WyW3l
         7jNqWQok6l2D19vRq9H2fvBLaaahisERWSdCTg0uaclb+De6Qw3qGlgCPI6ty5C+GR
         /Df/pWWuvdgqiTFzOB4KULiEH1HsdMrUOYSvskbY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Zaibo Xu <xuzaibo@huawei.com>,
        Longfang Liu <liulongfang@huawei.com>
Subject: [PATCH] crypto: hisilicon - select CRYPTO_SKCIPHER, not CRYPTO_BLKCIPHER
Date:   Fri, 29 Nov 2019 10:15:56 -0800
Message-Id: <20191129181556.45422-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Another instance of CRYPTO_BLKCIPHER made it in just after it was
renamed to CRYPTO_SKCIPHER.  Fix it.

Fixes: 416d82204df4 ("crypto: hisilicon - add HiSilicon SEC V2 driver")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/hisilicon/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index c0e7a85fe129..da749f6ecbea 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -16,7 +16,7 @@ config CRYPTO_DEV_HISI_SEC
 
 config CRYPTO_DEV_HISI_SEC2
 	tristate "Support for HiSilicon SEC2 crypto block cipher accelerator"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_ALGAPI
 	select CRYPTO_LIB_DES
 	select CRYPTO_DEV_HISI_QM
-- 
2.24.0

