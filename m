Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EBCC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 03:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 954D02147C
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 03:23:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rppNowcT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbfBSDXB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Feb 2019 22:23:01 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35647 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfBSDXA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Feb 2019 22:23:00 -0500
Received: by mail-ed1-f65.google.com with SMTP id g19so6515283edp.2;
        Mon, 18 Feb 2019 19:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jl8mehWyrUBP556vhgCSLwlVFDpTSFATt786X/rXFy0=;
        b=rppNowcTh7frIdWuG7SfdEhRYXnN6B9/ZLJWfNtcz1LccaZsL5AdjSi4ZvIwPULFqA
         cKBOymYVgebWq1i7mItu5bW/+nA/WNfQDLm4TgfJn2GDeenpXUp9GNJeMdBIAtzxr883
         hIR/onWd9CNv9U/G+15GFYhUCius83IDD2YaKpDJB3/zkfnK3oc63gT8cI/EaFWoE1Ey
         vGB/SGTPeZAc7RlSUtXTLJolVJKvatap6LlSm5lSdQUe0hfz/EdRiVcChwmggdbzO8ew
         sKOJyontu5csWIzylrVJdfGq8GGbo//m334+qHuwtrl2tXGtZdJSUL2tGOYoNJ7kcyCv
         /cog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jl8mehWyrUBP556vhgCSLwlVFDpTSFATt786X/rXFy0=;
        b=PHAiSrPD8//NBhLo0l1Lt0sg+qK/49gMFeH568R1/LHnehmBJ6pVE45AS30i6n1jLa
         WagrljRxaOqPK5goRpCHKtDF9Kx+eW2RiGYKpV2Judb6PmUnrJfksEFGnB6nntqfZruV
         QCJflPyTjNTS1c9qZReimLeutFYE2NioMvHNdqaJN+YMdTZlp+n3IqvLhoPw7WW+P2FZ
         pHWNH408a1MddJT+oBB+faZd+Vgh31BWS1QxQHxNS9/L23XSb34a5Fole4cQXCfF6her
         JAA5V5FlG8NvCP02nTDwbZepQjrfhrIk18VNuSLMnmQJvHtOTN52nqNrM6T2BeCG5nQJ
         VqWQ==
X-Gm-Message-State: AHQUAuZChVzJRTUnmikmy4imDvJpaxxZXNl21kRzniJROyMmPBpV7+dX
        aQWH4XaX7ApsXBsvXWNhoGI=
X-Google-Smtp-Source: AHgI3Ib8DAK2epvilWIwyDk/cQcbtCyMyjAo8X7djRfiF/LivxlJuQv04wI3dLeDDobLcFrK7YHPOA==
X-Received: by 2002:a17:906:1d0d:: with SMTP id n13mr11051396ejh.23.1550546578588;
        Mon, 18 Feb 2019 19:22:58 -0800 (PST)
Received: from localhost.localdomain ([2a01:4f9:2a:1fae::2])
        by smtp.gmail.com with ESMTPSA id b9sm4649069ede.12.2019.02.18.19.22.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Feb 2019 19:22:57 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] hwrng: optee: Initialize some structs using memset instead of braces
Date:   Mon, 18 Feb 2019 20:22:40 -0700
Message-Id: <20190219032240.22935-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.21.0.rc1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Clang warns:

drivers/char/hw_random/optee-rng.c:80:31: warning: suggest braces around
initialization of subobject [-Wmissing-braces]
        struct tee_param param[4] = {0};
                                     ^
                                     {}
drivers/char/hw_random/optee-rng.c:177:31: warning: suggest braces
around initialization of subobject [-Wmissing-braces]
        struct tee_param param[4] = {0};
                                     ^
                                     {}
drivers/char/hw_random/optee-rng.c:212:48: warning: suggest braces
around initialization of subobject [-Wmissing-braces]
        struct tee_ioctl_open_session_arg sess_arg = {0};
                                                      ^
                                                      {}
3 warnings generated.

One way to fix these warnings is to add additional braces like Clang
suggests; however, there has been a bit of push back from some
maintainers, who just prefer memset as it is unambiguous, doesn't
depend on a particular compiler version, and properly initializes all
subobjects [1][2]. Do that here so there are no more warnings.

[1]: https://lore.kernel.org/lkml/022e41c0-8465-dc7a-a45c-64187ecd9684@amd.com/
[2]: https://lore.kernel.org/lkml/20181128.215241.702406654469517539.davem@davemloft.net/

Fixes: 5fe8b1cc6a03 ("hwrng: add OP-TEE based rng driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/369
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/char/hw_random/optee-rng.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
index 2b9fc8ac5500..46f4bcd28c41 100644
--- a/drivers/char/hw_random/optee-rng.c
+++ b/drivers/char/hw_random/optee-rng.c
@@ -76,8 +76,11 @@ static size_t get_optee_rng_data(struct optee_rng_private *pvt_data,
 	u32 ret = 0;
 	u8 *rng_data = NULL;
 	size_t rng_size = 0;
-	struct tee_ioctl_invoke_arg inv_arg = {0};
-	struct tee_param param[4] = {0};
+	struct tee_ioctl_invoke_arg inv_arg;
+	struct tee_param param[4];
+
+	memset(&inv_arg, 0, sizeof(inv_arg));
+	memset(&param, 0, sizeof(param));
 
 	/* Invoke TA_CMD_GET_ENTROPY function of Trusted App */
 	inv_arg.func = TA_CMD_GET_ENTROPY;
@@ -173,8 +176,11 @@ static struct optee_rng_private pvt_data = {
 static int get_optee_rng_info(struct device *dev)
 {
 	u32 ret = 0;
-	struct tee_ioctl_invoke_arg inv_arg = {0};
-	struct tee_param param[4] = {0};
+	struct tee_ioctl_invoke_arg inv_arg;
+	struct tee_param param[4];
+
+	memset(&inv_arg, 0, sizeof(inv_arg));
+	memset(&param, 0, sizeof(param));
 
 	/* Invoke TA_CMD_GET_RNG_INFO function of Trusted App */
 	inv_arg.func = TA_CMD_GET_RNG_INFO;
@@ -209,7 +215,9 @@ static int optee_rng_probe(struct device *dev)
 {
 	struct tee_client_device *rng_device = to_tee_client_device(dev);
 	int ret = 0, err = -ENODEV;
-	struct tee_ioctl_open_session_arg sess_arg = {0};
+	struct tee_ioctl_open_session_arg sess_arg;
+
+	memset(&sess_arg, 0, sizeof(sess_arg));
 
 	/* Open context with TEE driver */
 	pvt_data.ctx = tee_client_open_context(NULL, optee_ctx_match, NULL,
-- 
2.21.0.rc1

