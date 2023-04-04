Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC88BC6FD1D
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Apr 2023 18:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbjDDSZu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236087AbjDDSZO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Apr 2023 14:25:14 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C8A5FC3
        for <linux-crypto@vger.kernel.org>; Tue,  4 Apr 2023 11:23:08 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id le6so32125233plb.12
        for <linux-crypto@vger.kernel.org>; Tue, 04 Apr 2023 11:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680632588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8jniZVFM5VdIC7zEQqZON+ttcH4hGM09Ty8jho7PtM=;
        b=l4Jw1Rq2ntfHAMU4Y/Hm9cQCfDsI39b8psQRCZLgg7ZBeveqOfGhPNw3A44NfjsPNt
         CDKqtSOQE0ZvLjdx7COmE7Mmmrg95qIj8JP5YmXaGEVFBmrJrdMDDFWnVXKN/Hi3Wdzv
         m7j9aJzVpOi+j8aj17Zs85oruoTEu/NnXDzWeoMKKL+qQSnp6dtAlbbUr8MJhZ7snY/m
         UAdB4JApQKXF0moipSxBKcnvaKFXZhpP/jzffrNHKJ3HaMLoqBJk2NDoulhVo6A56Xt4
         64gplAMVGV20KfPamu5185j/DJgIptQzQinjGOAraB+/y3g6Hlz9Pwdurbr5SvSLD1Kn
         nvLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O8jniZVFM5VdIC7zEQqZON+ttcH4hGM09Ty8jho7PtM=;
        b=dB09rB/rKBHQCzdjHQUlbm/E+lJnWl8NppgjkznreNaH1aCClPVvul49cv9/YatZ7K
         4zDigxHMFWRzFc6d0iRb51Kc2q+Wlp4K2Cqk4okX1io7EZX1It/6XXVks7u9GIz/T6H1
         SXA5Hnfc7W/WAyKHax+gKeQU30EJA0JuWr71h2h/+gDPG5xOeSbGAE69OncX7RcrI1KA
         FgoJdhfHoRjSkTmRePUS4d0pLU+H/CTdmaZI87CO621Ug7ENiTyZPIeD92HkzJyrYiju
         JIY/AtlTJajG5XGbe6YtqnAwqooDsR3rZ/75HSxLNMn3wKjLxUTbBA//eAZApEjWucs+
         UFww==
X-Gm-Message-State: AAQBX9eCNaJiVL8nYQ1IG7Ggy2PuJli7G42MHUJl10XwwvUHGemVRo4S
        JN83YEL6uDBMoi4I/z1jsisZQA==
X-Google-Smtp-Source: AKy350YWtiByLvuA5MHF6bNdPYqUjMVVmlzTK+bqmZihos/8knO44e4LwsVq3Bx9usreNyRcUWXZ0w==
X-Received: by 2002:a05:6a20:7b2a:b0:db:1d43:18fe with SMTP id s42-20020a056a207b2a00b000db1d4318femr3016723pzh.8.1680632588299;
        Tue, 04 Apr 2023 11:23:08 -0700 (PDT)
Received: from localhost.localdomain ([106.51.184.50])
        by smtp.gmail.com with ESMTPSA id o12-20020a056a001bcc00b0062dcf5c01f9sm9018524pfw.36.2023.04.04.11.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:23:08 -0700 (PDT)
From:   Sunil V L <sunilvl@ventanamicro.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux-crypto@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        llvm@lists.linux.dev
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Len Brown <lenb@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Marc Zyngier <maz@kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sunil V L <sunilvl@ventanamicro.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH V4 20/23] RISC-V: Enable ACPI in defconfig
Date:   Tue,  4 Apr 2023 23:50:34 +0530
Message-Id: <20230404182037.863533-21-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404182037.863533-1-sunilvl@ventanamicro.com>
References: <20230404182037.863533-1-sunilvl@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support to build ACPI subsystem in defconfig.

Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index d98d6e90b2b8..8822b49ddb59 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -238,3 +238,4 @@ CONFIG_RCU_EQS_DEBUG=y
 # CONFIG_FTRACE is not set
 # CONFIG_RUNTIME_TESTING_MENU is not set
 CONFIG_MEMTEST=y
+CONFIG_ACPI=y
-- 
2.34.1

