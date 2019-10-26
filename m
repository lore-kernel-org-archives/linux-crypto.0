Return-Path: <SRS0=2cET=YT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D782BCA9EBC
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 14:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A553D21871
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572101635;
	bh=SmDraQe5IZLOG+WLxMhmI/EhoYeINysU8csTg6xa8F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WuCPFjToUDtOMxYiZ6/hDfw08QMM+ASwaYBuFv06tCkLQg0wXg5M8U9Ku97Q9f+xi
	 1GtwGFNgAhachnd6JhYBgkp9uw5qBGdJ9t1JQwFxnQeBieFUYdTlGdp909Za1e0d/9
	 j5pVPK/apg8zRutoFW+96kvYmGj1u/T7UxZ7gogQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfJZOxy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Oct 2019 10:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfJZOxy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Oct 2019 10:53:54 -0400
Received: from e123331-lin.home (lfbn-mar-1-643-104.w90-118.abo.wanadoo.fr [90.118.215.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABDB92070B;
        Sat, 26 Oct 2019 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572101634;
        bh=SmDraQe5IZLOG+WLxMhmI/EhoYeINysU8csTg6xa8F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xcZ3QJDuPTu5jFBkBWRXTkOUoHLsDsflyjB+t4Tf2Pvx+x3kKyMX1HDiNdUudjAYx
         r1+vibniNvBkRxcUiHQYaNTOVhd2PnOI+UbF0IQ5WP10C/2xivvAOyzypFvf1qVggE
         fkjZyrqwzn7oenlDWxG+8onGKC5Aiyw/UMoB0ckU=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        linux-omap@vger.kernel.org, Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 3/6] crypto: omap-aes-gcm - deal with memory allocation failure
Date:   Sat, 26 Oct 2019 16:52:56 +0200
Message-Id: <20191026145259.16040-4-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191026145259.16040-1-ardb@kernel.org>
References: <20191026145259.16040-1-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The OMAP gcm(aes) driver invokes omap_crypto_align_sg() without
dealing with the errors it may return, resulting in a crash if
the routine fails in a __get_free_pages(GFP_ATOMIC) call. So
bail and return the error rather than limping on if one occurs.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/omap-aes-gcm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
index dfd4d1cac421..05d2fe78b105 100644
--- a/drivers/crypto/omap-aes-gcm.c
+++ b/drivers/crypto/omap-aes-gcm.c
@@ -120,6 +120,8 @@ static int omap_aes_gcm_copy_buffers(struct omap_aes_dev *dd,
 					   OMAP_CRYPTO_FORCE_SINGLE_ENTRY,
 					   FLAGS_ASSOC_DATA_ST_SHIFT,
 					   &dd->flags);
+		if (ret)
+			return ret;
 	}
 
 	if (cryptlen) {
@@ -132,6 +134,8 @@ static int omap_aes_gcm_copy_buffers(struct omap_aes_dev *dd,
 					   OMAP_CRYPTO_FORCE_SINGLE_ENTRY,
 					   FLAGS_IN_DATA_ST_SHIFT,
 					   &dd->flags);
+		if (ret)
+			return ret;
 	}
 
 	dd->in_sg = dd->in_sgl;
-- 
2.17.1

