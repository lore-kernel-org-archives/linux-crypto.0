Return-Path: <SRS0=XAm+=ZT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77085C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 12:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C9632073F
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 12:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574856105;
	bh=TziSEip9ZikWXUb6vddqqT1XCVIbwlGlZtN3ZQciJFQ=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=2GWA4pis9L13ptFRgFlPoq8JjsebVyT3q8B26o4ERTX4QI9Eobh7vqH5CLlXOunRe
	 hkq5xcTOd3Bt6pGl0U0GBwb4nliTZxdJZWWxeeNzGuYkSpvztIQHBShGwa8OziCWMl
	 NuYCEvnhs4VK8q1No1GZlF6WxWvnhw335gBYPhV0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfK0MBo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 07:01:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbfK0MBo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 07:01:44 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5097E206F0;
        Wed, 27 Nov 2019 12:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574856104;
        bh=TziSEip9ZikWXUb6vddqqT1XCVIbwlGlZtN3ZQciJFQ=;
        h=From:To:Cc:Subject:Date:From;
        b=adGbilzhpKiK4sfwGDqft1IqGvpY+Lm1ThaHm1tI2LsI032dTR38upyYl2yCA70sd
         QWa1dTxHjkjM690IY2v1OnA1QSFdTFwFzp2FN805hDT8hsRm7Jnlsud26abhcwy6Xq
         Z0nYd25ROG8G7/YdUiZcmRunCSuLnolKOheXl4Hc=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp: set max RSA modulus size for v3 platform devices as well
Date:   Wed, 27 Nov 2019 13:01:36 +0100
Message-Id: <20191127120136.105325-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

AMD Seattle incorporates a non-PCI version of the v3 CCP crypto
accelerator, and this version was left behind when the maximum
RSA modulus size was parameterized in order to support v5 hardware
which supports larger moduli than v3 hardware does. Due to this
oversight, RSA acceleration no longer works at all on these systems.

Fix this by setting the .rsamax property to the appropriate value
for v3 platform hardware.

Fixes: e28c190db66830c0 ("csrypto: ccp - Expand RSA support for a v5 ccp")
Cc: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/ccp/ccp-dev-v3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index 0186b3df4c87..0d5576f6ad21 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -586,6 +586,7 @@ const struct ccp_vdata ccpv3_platform = {
 	.setup = NULL,
 	.perform = &ccp3_actions,
 	.offset = 0,
+	.rsamax = CCP_RSA_MAX_WIDTH,
 };
 
 const struct ccp_vdata ccpv3 = {
-- 
2.20.1

