Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4A2C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Mar 2022 11:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240657AbiC1LU4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Mar 2022 07:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240609AbiC1LU2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Mar 2022 07:20:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CD6554B8;
        Mon, 28 Mar 2022 04:18:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2415B81056;
        Mon, 28 Mar 2022 11:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF59C340EC;
        Mon, 28 Mar 2022 11:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466319;
        bh=gLx6LyEARQOPG7EoCVpdTIUT4WgJnC0gWdY0sjo1HKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3m/AcBaYZT8vXd/tfsQ6hp+SJzzv9q60E5pyuD24g05KD3s/rt8NEwyHJhEnqxn3
         7wu19iNyPDopuPCLS7YtXpIhcB1ILIgQYmoCVx7WGbKMT0iMIIOOfsfKdq4G1Ln9j4
         S4UzbhsZ7Otgoz1IYMN41XhnRDZYrikS/Vb0kvz9HFjreqZla/NY2mJwR8+pLpJZmU
         CQdlicy558+wfr9Inh3EPM5n9eRohvhAGh96/5Lx+T0KKFjEmgiHiS5lgpCLV0yNW5
         91SkPhUg4juxI1wWlZAbj7JIQleV2IwDViAfvsPQ7FdVPhePQmUbqttH3oHjMCLbtq
         n1d2xkAd33AXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srujana Challa <schalla@marvell.com>,
        Shijith Thotton <sthotton@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, bbrezillon@kernel.org,
        arno@natisbad.org, davem@davemloft.net, dan.carpenter@oracle.com,
        ardb@kernel.org, keescook@chromium.org,
        jiapeng.chong@linux.alibaba.com, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 04/43] crypto: octeontx2 - CN10K CPT to RNM workaround
Date:   Mon, 28 Mar 2022 07:17:48 -0400
Message-Id: <20220328111828.1554086-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328111828.1554086-1-sashal@kernel.org>
References: <20220328111828.1554086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Srujana Challa <schalla@marvell.com>

[ Upstream commit bd9305b0cb69bfe98885a63a9e6231ae92e822e2 ]

When software sets CPT_AF_CTL[RNM_REQ_EN]=1 and RNM in not producing
entropy(i.e., RNM_ENTROPY_STATUS[NORMAL_CNT] < 0x40), the first cycle of
the response may be lost due to a conditional clocking issue. Due to
this, the subsequent random number stream will be corrupted. So, this
patch adds support to ensure RNM_ENTROPY_STATUS[NORMAL_CNT] = 0x40
before writing CPT_AF_CTL[RNM_REQ_EN] = 1, as a workaround.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: Shijith Thotton <sthotton@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 43 ++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 1b4d425bbf0e..7fd4503d9cfc 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1076,6 +1076,39 @@ static void delete_engine_grps(struct pci_dev *pdev,
 		delete_engine_group(&pdev->dev, &eng_grps->grp[i]);
 }
 
+#define PCI_DEVID_CN10K_RNM 0xA098
+#define RNM_ENTROPY_STATUS  0x8
+
+static void rnm_to_cpt_errata_fixup(struct device *dev)
+{
+	struct pci_dev *pdev;
+	void __iomem *base;
+	int timeout = 5000;
+
+	pdev = pci_get_device(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CN10K_RNM, NULL);
+	if (!pdev)
+		return;
+
+	base = pci_ioremap_bar(pdev, 0);
+	if (!base)
+		goto put_pdev;
+
+	while ((readq(base + RNM_ENTROPY_STATUS) & 0x7F) != 0x40) {
+		cpu_relax();
+		udelay(1);
+		timeout--;
+		if (!timeout) {
+			dev_warn(dev, "RNM is not producing entropy\n");
+			break;
+		}
+	}
+
+	iounmap(base);
+
+put_pdev:
+	pci_dev_put(pdev);
+}
+
 int otx2_cpt_get_eng_grp(struct otx2_cpt_eng_grps *eng_grps, int eng_type)
 {
 
@@ -1189,9 +1222,17 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 
 	if (is_dev_otx2(pdev))
 		goto unlock;
+
+	/*
+	 * Ensure RNM_ENTROPY_STATUS[NORMAL_CNT] = 0x40 before writing
+	 * CPT_AF_CTL[RNM_REQ_EN] = 1 as a workaround for HW errata.
+	 */
+	rnm_to_cpt_errata_fixup(&pdev->dev);
+
 	/*
 	 * Configure engine group mask to allow context prefetching
-	 * for the groups.
+	 * for the groups and enable random number request, to enable
+	 * CPT to request random numbers from RNM.
 	 */
 	otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL,
 			      OTX2_CPT_ALL_ENG_GRPS_MASK << 3 | BIT_ULL(16),
-- 
2.34.1

