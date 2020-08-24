Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 950DAC433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 14:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FBC2206B5
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 14:13:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gIEf+8Hs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgHXONu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 10:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgHXONu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 10:13:50 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE677C061573
        for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2020 07:13:49 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id s15so3755167qvv.7
        for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2020 07:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UgeOvMcHf23is5h6ao+Te2TcimdrCSu4y2w3pg5/Zts=;
        b=gIEf+8Hs4YiQBGIClEjEQ+WD7okcoLVdtNZAZVq+r2+Jml3ESBu03Pb2fEsVpLcL8a
         R16pzlh86j9AlJC5HE/IDxAClNzRdiwxIA7qsr0PZY3E5IuOEIpwSmilAy5B8W9vIrKv
         KyPnfWS85MGn7as1jDU1NRTfrlJPJ6i6OsEp6C4PJJDVR3p9zpfW5joY9JRNiR2jLjS8
         BA268GrW6qxEaHS5Uy/U/Wav/pzwqsYUlhyJEnu3YkGgJxTRVuTpHMaC5RaNGEGt3nQi
         AewoPad3J815QyUiLF14FAB0odMlkSMjbj3Ic0+GQ/+lT1CN1qa0JufKJwomIgAfOeYM
         AwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UgeOvMcHf23is5h6ao+Te2TcimdrCSu4y2w3pg5/Zts=;
        b=YtrPEusjuF0xmj5/EiVknEKjieTmE3QXmtCNIaxgG5riJdd9AAQZ3B9rE/Tzwz4za5
         U2oxtECXNftaK1AGnj06MUDOW08OVnOzvttX0KXyf1ionPqjd3vUL1XBmxJ/7DiGekko
         WyFI0CL2u7R/yg7KHDjfZPrUBatWcAOBwBlXE40VE8HdoKfcIJnA9j1zES7ys94I3yES
         WtFYzZP8Tr8bl5+Ai0wng5O1qnmvz01i6wtiYAB9DKSf3P4+uqdsUs/Ro5Ngomb8iXlB
         Ryt+VAHo/vpmzmxXsPExf+h1ps1RtJAPxMEOZonGe39MPXLM9q8IURt+rmX3rb8lJuRX
         kVVQ==
X-Gm-Message-State: AOAM5328TEb5zf9k501N5CB4rAODkAoBS/2lysyxKBzgTghvZRhrtiGu
        4RnwMe2sXaoGYP4zd8XYsupJltqPmug=
X-Google-Smtp-Source: ABdhPJxt7nKXZrgfgggWyukL4mNhwYOds/zzeHI0FCnPMwRfwIxR0GSP+49qtIZhDWaXNCY7MPJaHQ==
X-Received: by 2002:a05:6214:452:: with SMTP id cc18mr5101635qvb.100.1598278426982;
        Mon, 24 Aug 2020 07:13:46 -0700 (PDT)
Received: from localhost.localdomain ([177.194.72.74])
        by smtp.gmail.com with ESMTPSA id w27sm10809892qtv.68.2020.08.24.07.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 07:13:45 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     Jason@zx2c4.com, linux@armlinux.org.uk,
        linux-crypto@vger.kernel.org, ardb@kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: arm/curve25519 - include <linux/scatterlist.h>
Date:   Mon, 24 Aug 2020 11:09:53 -0300
Message-Id: <20200824140953.5964-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Building ARM allmodconfig leads to the following warnings:

arch/arm/crypto/curve25519-glue.c:73:12: error: implicit declaration of function 'sg_copy_to_buffer' [-Werror=implicit-function-declaration]
arch/arm/crypto/curve25519-glue.c:74:9: error: implicit declaration of function 'sg_nents_for_len' [-Werror=implicit-function-declaration]
arch/arm/crypto/curve25519-glue.c:88:11: error: implicit declaration of function 'sg_copy_from_buffer' [-Werror=implicit-function-declaration]

Include <linux/scatterlist.h> to fix such warnings

Reported-by: Olof's autobuilder <build@lixom.net>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 arch/arm/crypto/curve25519-glue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/crypto/curve25519-glue.c b/arch/arm/crypto/curve25519-glue.c
index 776ae07e0469..31eb75b6002f 100644
--- a/arch/arm/crypto/curve25519-glue.c
+++ b/arch/arm/crypto/curve25519-glue.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/jump_label.h>
+#include <linux/scatterlist.h>
 #include <crypto/curve25519.h>
 
 asmlinkage void curve25519_neon(u8 mypublic[CURVE25519_KEY_SIZE],
-- 
2.17.1

