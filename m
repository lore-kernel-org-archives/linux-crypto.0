Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B94C33CB6
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 17:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93E2724685
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 17:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579195468;
	bh=iXlGhkD+iPp8vh7EEoCYUfHQYjiFUHCq17Z2sMpPylM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PdxS/l5OasKG32EvpmnKHiwjvgQqAl4mwA3vKOA9kLA3nFazpQmdbppMltPWYjPRg
	 yGJL87AZr6hk1wZNtsRhJ27aRSapY/lwiEXIDqiQ1jumitv4T7fcTkdlskfAEFqBIE
	 ViIJAEKhzQS0gGOrEIOpaicRPYBqzE8PHwRXvMm8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391748AbgAPRY1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:24:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391759AbgAPRY0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 12:24:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 193D424684;
        Thu, 16 Jan 2020 17:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195465;
        bh=iXlGhkD+iPp8vh7EEoCYUfHQYjiFUHCq17Z2sMpPylM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4xchUpj0jN7osIfBeIHoYwyw8gP7ZnEwpTZOCQLqPpfzuozsh0WUQYZGQjmFjy4M
         ED/are9yfSBOYe0TyaAIZQoVPDfAMBM91H0sOjMFJUfOeVzXI1gStgB71cb67tSRLr
         TmdOjpuYwLA6Uh+boDLkGE+s4AGuihpM0I0fqcQo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 073/371] crypto: crypto4xx - Fix wrong ppc4xx_trng_probe()/ppc4xx_trng_remove() arguments
Date:   Thu, 16 Jan 2020 12:19:05 -0500
Message-Id: <20200116172403.18149-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 6e88098ca43a3d80ae86908f7badba683c8a0d84 ]

When building without CONFIG_HW_RANDOM_PPC4XX, I hit the following build failure:
drivers/crypto/amcc/crypto4xx_core.c: In function 'crypto4xx_probe':
drivers/crypto/amcc/crypto4xx_core.c:1407:20: error: passing argument 1 of 'ppc4xx_trng_probe' from incompatible pointer type [-Werror=incompatible-pointer-types]
In file included from drivers/crypto/amcc/crypto4xx_core.c:50:0:
drivers/crypto/amcc/crypto4xx_trng.h:28:20: note: expected 'struct crypto4xx_device *' but argument is of type 'struct crypto4xx_core_device *'
drivers/crypto/amcc/crypto4xx_core.c: In function 'crypto4xx_remove':
drivers/crypto/amcc/crypto4xx_core.c:1434:21: error: passing argument 1 of 'ppc4xx_trng_remove' from incompatible pointer type [-Werror=incompatible-pointer-types]
In file included from drivers/crypto/amcc/crypto4xx_core.c:50:0:
drivers/crypto/amcc/crypto4xx_trng.h:30:20: note: expected 'struct crypto4xx_device *' but argument is of type 'struct crypto4xx_core_device *'

This patch fix the needed argument of ppc4xx_trng_probe()/ppc4xx_trng_remove() in that case.

Fixes: 5343e674f32f ("crypto4xx: integrate ppc4xx-rng into crypto4xx")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/amcc/crypto4xx_trng.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_trng.h b/drivers/crypto/amcc/crypto4xx_trng.h
index 931d22531f51..7bbda51b7337 100644
--- a/drivers/crypto/amcc/crypto4xx_trng.h
+++ b/drivers/crypto/amcc/crypto4xx_trng.h
@@ -26,9 +26,9 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev);
 void ppc4xx_trng_remove(struct crypto4xx_core_device *core_dev);
 #else
 static inline void ppc4xx_trng_probe(
-	struct crypto4xx_device *dev __maybe_unused) { }
+	struct crypto4xx_core_device *dev __maybe_unused) { }
 static inline void ppc4xx_trng_remove(
-	struct crypto4xx_device *dev __maybe_unused) { }
+	struct crypto4xx_core_device *dev __maybe_unused) { }
 #endif
 
 #endif
-- 
2.20.1

