Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC7CC433E1
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 21:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE64320772
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 21:48:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MBnzw7FG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgGAVs0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 17:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbgGAVsI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 17:48:08 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22135C08C5DB;
        Wed,  1 Jul 2020 14:48:08 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h19so29016780ljg.13;
        Wed, 01 Jul 2020 14:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TY+6CIVT2ufMdPHMOZOLuWUG9NLtqpkM1rBQDTAP3Eo=;
        b=MBnzw7FG212j0CXIeBmGpDYx0R8rPY75iEQDUcb4grm2hK1zDKU/2UUdFmHtA4Qxc5
         JOnVLYPJzA4Ie9tKbpngiF2UjfLs+AkBDS5xQkEQ5NbkD5Rq8R94yVQbr3zghYqi3hPY
         pLVN/TaroUJFDJNoffmA5qzzwuWTGhD9IpP7r2MWl6X2J2Gi7MLnVzMOxsXEs2x2t9d8
         jpP8wbyh9OXFF/IDhs1r/ufUxLdxf8l3RxMOY0O0T3LuUfgUSqAFO+2mVDSeSiGn9OEG
         mZbM1Makv6Pn8e1rq+GjRnFaDxouxMKK89B0T1YUb20M6/3rNJ+SqTz6PSNXkJnTYZY3
         qWJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TY+6CIVT2ufMdPHMOZOLuWUG9NLtqpkM1rBQDTAP3Eo=;
        b=EjK+zcGc/7YgSNBOKFDcUCOMD0abBK5rCHs4Y82NHoxfr/ViZ7DcilW0381H+r+2kj
         ASWTUc701m3hvQ4u5PWHVZk0ZrMr3zIfYj8xUS2dvg3PJ0BEQZow2nnGE8GmmG8EGWdX
         twEpgYAuwbtWryOkwL2iduAjgVVF7HpltOVzAG8IsL0TZkl87pt3FjfRjO64YekhODtr
         S3JMFrPBSiwSV+0JRYRlkRmIar9wgnr8TglNb9WmUO+iL2jUenGPxM8PGXiSGOb7kOpn
         FyZkwzmRdUh8I+zsc1emz68yjPJ8ubsAnuDzTp1+k3taHzyGdCm6+HDKYdVXW8E5qeE2
         zIYg==
X-Gm-Message-State: AOAM533URkDcsFhL6TGtuFvS1QtFQ91LeVascIzkysftgGqZozHMbRcp
        ORvLsdhoh0kVknnRz3rRY7A=
X-Google-Smtp-Source: ABdhPJwXr6Ub+mQMEQVVK/OBb2oG7XuLFWcsDZ+LBcuc1eb4ZFZBorIHRz4IMK1MXyp/31a3DZaFqg==
X-Received: by 2002:a2e:8882:: with SMTP id k2mr5434653lji.352.1593640086594;
        Wed, 01 Jul 2020 14:48:06 -0700 (PDT)
Received: from localhost.localdomain (h-98-128-181-241.NA.cust.bahnhof.se. [98.128.181.241])
        by smtp.gmail.com with ESMTPSA id d3sm2476812lfe.93.2020.07.01.14.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 14:48:06 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] hwrng: nomadik - Constify nmk_rng_ids[]
Date:   Wed,  1 Jul 2020 22:09:47 +0200
Message-Id: <20200701200950.30314-3-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701200950.30314-1-rikard.falkeborn@gmail.com>
References: <20200701200950.30314-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

nmk_rng_ids[] is not modified and can be made const to allow the
compiler to put it in read-only memory.

Before:
   text    data     bss     dec     hex filename
    652     216       4     872     368 drivers/char/hw_random/nomadik-rng.o

After:
   text    data     bss     dec     hex filename
    676     192       4     872     368 drivers/char/hw_random/nomadik-rng.o

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/char/hw_random/nomadik-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/nomadik-rng.c b/drivers/char/hw_random/nomadik-rng.c
index 74ed29f42e4f..b0ded41eb865 100644
--- a/drivers/char/hw_random/nomadik-rng.c
+++ b/drivers/char/hw_random/nomadik-rng.c
@@ -76,7 +76,7 @@ static int nmk_rng_remove(struct amba_device *dev)
 	return 0;
 }
 
-static struct amba_id nmk_rng_ids[] = {
+static const struct amba_id nmk_rng_ids[] = {
 	{
 		.id	= 0x000805e1,
 		.mask	= 0x000fffff, /* top bits are rev and cfg: accept all */
-- 
2.27.0

