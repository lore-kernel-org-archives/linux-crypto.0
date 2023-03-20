Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B060BC7619A
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Mar 2023 19:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjCTTgJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Mar 2023 15:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjCTTfd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Mar 2023 15:35:33 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03C40144A0;
        Mon, 20 Mar 2023 12:30:20 -0700 (PDT)
Received: from vm02.corp.microsoft.com (unknown [167.220.197.27])
        by linux.microsoft.com (Postfix) with ESMTPSA id 15EF420FB1B2;
        Mon, 20 Mar 2023 12:20:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 15EF420FB1B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1679340030;
        bh=JLW993L7KNZ43aI6v0ynXV6I6nnprRROSEVuJCp8QVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZdE92xkSlNsSdtRY8SG1L72AfSgg+/UasdFbiQcPghgRMaTIcGcQI7O/GdJjG+2g
         aWqacbBFkt1YwcRsXRt//5OyRFmExbllwk6D5Dauo/wgqJENztvMcvlC21wtD1AULa
         6T9tnRofIADsnQym6v0uN3sS6lgk2IRXtyo1dh+M=
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Kalra, Ashish" <ashish.kalra@amd.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 5/8] crypto: cpp - Bind to psp platform device on x86
Date:   Mon, 20 Mar 2023 19:19:53 +0000
Message-Id: <20230320191956.1354602-6-jpiotrowski@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230320191956.1354602-1-jpiotrowski@linux.microsoft.com>
References: <20230320191956.1354602-1-jpiotrowski@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The PSP in Hyper-V VMs is exposed through the ASP ACPI table and is
represented as a platform_device. Allow the ccp driver to bind to it by
adding an id_table and initing the platform_driver also on x86. At this
point probe is called for the psp device but init fails due to missing
driver data.

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
---
 drivers/crypto/ccp/sp-dev.c      | 7 +++++++
 drivers/crypto/ccp/sp-platform.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index 7eb3e4668286..4c9f442b8a11 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -259,6 +259,12 @@ static int __init sp_mod_init(void)
 	if (ret)
 		return ret;
 
+	ret = sp_platform_init();
+	if (ret) {
+		sp_pci_exit();
+		return ret;
+	}
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 	psp_pci_init();
 #endif
@@ -286,6 +292,7 @@ static void __exit sp_mod_exit(void)
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 	psp_pci_exit();
 #endif
+	sp_platform_exit();
 
 	sp_pci_exit();
 #endif
diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
index 7d79a8744f9a..5dcc834deb72 100644
--- a/drivers/crypto/ccp/sp-platform.c
+++ b/drivers/crypto/ccp/sp-platform.c
@@ -56,6 +56,12 @@ static const struct of_device_id sp_of_match[] = {
 MODULE_DEVICE_TABLE(of, sp_of_match);
 #endif
 
+static const struct platform_device_id sp_platform_match[] = {
+	{ "psp" },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, sp_platform_match);
+
 static struct sp_dev_vdata *sp_get_of_version(struct platform_device *pdev)
 {
 #ifdef CONFIG_OF
@@ -212,6 +218,7 @@ static int sp_platform_resume(struct platform_device *pdev)
 #endif
 
 static struct platform_driver sp_platform_driver = {
+	.id_table = sp_platform_match,
 	.driver = {
 		.name = "ccp",
 #ifdef CONFIG_ACPI
-- 
2.34.1

