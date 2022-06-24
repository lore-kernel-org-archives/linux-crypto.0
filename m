Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22D2C43334
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jun 2022 11:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiFXLOK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jun 2022 07:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiFXLOI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jun 2022 07:14:08 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E73F590;
        Fri, 24 Jun 2022 04:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1656069248; x=1687605248;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=C+2JZuxDaO1dSIA4AcGGYwxdg94USAJGnnLvJk44KPE=;
  b=ZyJehayBCS4F5HAfRhDna7hAMppHgQW85arUHXE+t/ZduitmvoG3XdFN
   oxIvKFPyYYgHAQNKlnop68h8aJqpjXFYsNrhweRTWN+s3FRa4nv1E69wB
   xsndBLgxl35eUiNiu7dZIcJIGbMGUtxbQndvLZxKHx36d09LTQNQGaRBR
   Y=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 24 Jun 2022 04:14:07 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 04:14:07 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 24 Jun 2022 04:14:07 -0700
Received: from ubuntu.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 24 Jun
 2022 04:14:05 -0700
From:   Qian Cai <quic_qiancai@quicinc.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Qian Cai <quic_qiancai@quicinc.com>
Subject: [PATCH] arm64/crypto: Select AEAD for GHASH_ARM64_CE
Date:   Fri, 24 Jun 2022 07:13:38 -0400
Message-ID: <20220624111338.209380-1-quic_qiancai@quicinc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Otherwise, we could fail to compile.

ld: arch/arm64/crypto/ghash-ce-glue.o: in function 'ghash_ce_mod_exit':
ghash-ce-glue.c:(.exit.text+0x24): undefined reference to 'crypto_unregister_aead'
ld: arch/arm64/crypto/ghash-ce-glue.o: in function 'ghash_ce_mod_init':
ghash-ce-glue.c:(.init.text+0x34): undefined reference to 'crypto_register_aead'

Fixes: 537c1445ab0b ("crypto: arm64/gcm - implement native driver using v8 Crypto Extensions")
Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
---
 arch/arm64/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 4391a463abd7..60db5bb2ddda 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -71,6 +71,7 @@ config CRYPTO_GHASH_ARM64_CE
 	select CRYPTO_HASH
 	select CRYPTO_GF128MUL
 	select CRYPTO_LIB_AES
+	select CRYPTO_AEAD
 
 config CRYPTO_POLYVAL_ARM64_CE
 	tristate "POLYVAL using ARMv8 Crypto Extensions (for HCTR2)"
-- 
2.34.1

