Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEACC43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3E8A20838
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388396AbfIFPXg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 11:23:36 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:57609 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfIFPXf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 11:23:35 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MC3L9-1i0zgF3HKf-00CQ6I; Fri, 06 Sep 2019 17:23:14 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Hao Fang <fanghao11@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: hisilicon - avoid unused function warning
Date:   Fri,  6 Sep 2019 17:22:30 +0200
Message-Id: <20190906152250.1450649-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190906152250.1450649-1-arnd@arndb.de>
References: <20190906152250.1450649-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ltG7Dz//KZqox/ulRWhNwr6SfqbMWug5c/0Q+nuvztJL6BD1vJA
 EmHRbJP1qdS6LHV68X6MZAAlJG0X0zCKPWwfoQuPwwOy5llTfWPGPYi7Zj45BMLWklrozkT
 xKHwcH9T6mMO5c4xJ4zh27kGw9XbnlTJfrQ+d9MTzb37QOjUaolFjo9vQHybDkA9bQR7viF
 ipY6Iu17Pt9qIK8PGMl+Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:1uFE00/QaKM=:RpHBHFJ7z5dUtAY8BG6QR+
 PXPkJAqDK11VOHtVg5HxdhFLKQ+dv/ca8OlweOakzJCAkjIs3YgBwZ7CfxItKbFwc1fZX0mEc
 OcDTEGGCOhC36+aAYf71NFoxz3SpDzq3nQhpeF+mjfdvcAvoxbDsDtpBl2XlHPYh6xoxuRILZ
 G5dVVc1XZC2R2AVqeiHpdOEcoiRLQdFM9s8+MOp843H5/kt0F1znnd1UVz0EBGu5g+qVguH4I
 7Wl2S+TCgbGTrCKAmRd6ZBFRsgPeP1kYWxvtZRcy5TcD4CDaikGoShMSiFA2sNDW2S3U2yaLA
 CJd4Ref3oLxIQvj0l4ozsBEshGINdKP7RjxX8qhsBsi6MF1qS/j0ITT2t1u2ag9uKj4hoDXvC
 VRcNAaGawP1JaexgXFrCkBOLoO+/2qtx47EQBQGkblceVV0AxOrd2xggwfNlCdsHmdUOYPp3C
 eofed5/n/MO5X5bZd/LqgZ7LeykztBwws0w6hrCb4dFA4fi5CITEvnIXdAMjtVcafJpWjYBgk
 wbPZciDvGyvwz5zaaJ9BxVVjZUiv6P2IdEojIhhgKwP1EQFmpeu0jrqICOYr2qOGWiv0JZVdG
 L/n8IW91EQA0dbjoE5Rq/bZbbFSCD1gPwHiQYQqftj7YLquEvs3eQrs6CPtbdwfqeaYRAY0ty
 TmH/FXTsdxtA4FDaFdGAu5FNiYLiDUAZJw9Ja/MBhc8op4w685vGfeNZTyv7OlMpnGZH3wvJp
 A0cVeScbtsRqEh4ZfhgrrGxOLzdsdCCbgPrXQAL6MJRKZR99wONcWBxJHDkCojWZDJXxHXFzY
 C0fpJCXDkBSmo9cVpJLE9/hEBmaFrKdTfVOanF7laQKELtPrsM=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The only caller of hisi_zip_vf_q_assign() is hidden in an #ifdef,
so the function causes a warning when CONFIG_PCI_IOV is disabled:

drivers/crypto/hisilicon/zip/zip_main.c:740:12: error: unused function 'hisi_zip_vf_q_assign' [-Werror,-Wunused-function]

Move it into the same #ifdef.

Fixes: 79e09f30eeba ("crypto: hisilicon - add SRIOV support for ZIP")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 6e0ca75585d4..bd0283c2fa87 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -736,6 +736,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
+#ifdef CONFIG_PCI_IOV
 /* Currently we only support equal assignment */
 static int hisi_zip_vf_q_assign(struct hisi_zip *hisi_zip, int num_vfs)
 {
@@ -764,6 +765,7 @@ static int hisi_zip_vf_q_assign(struct hisi_zip *hisi_zip, int num_vfs)
 
 	return 0;
 }
+#endif
 
 static int hisi_zip_clear_vft_config(struct hisi_zip *hisi_zip)
 {
-- 
2.20.0

