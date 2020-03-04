Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6105FC3F2D1
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 18:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 373EC21775
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 18:25:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DglB+WYH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgCDSZE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 13:25:04 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40110 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgCDSZE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 13:25:04 -0500
Received: by mail-qt1-f195.google.com with SMTP id o10so2109329qtr.7
        for <linux-crypto@vger.kernel.org>; Wed, 04 Mar 2020 10:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NgzS/8FtCj01Tx+QLybY5HTl1Vfnoqx9UghL3+n0BE0=;
        b=DglB+WYHn0Y2Iu0aLbT8rQahnqupR/ePqMyoEymkjP6bCdNFILi609HTybc1C1xH6r
         Y8EdK4ICZytTBapkmPqkRMkEyReBDQsqvoiAFkgXBE7o1x2+ZyKjdjIyGt1h1YqUrITV
         x/W59SJH1dlcp4RtQkpW8xRs9aGTiNCVFQSpon6p8CaXIy2EiObYZ3pvpXKSPnOLYMXi
         t+CJJiV0htTOSulRkbpWDGXStsehUu8B5dcAqN/xiycwWwnpEOkGPUNB6DZGHhULunt4
         BOspg98S850Rb2WoJgyHExW+k/kQtoxXRUun7M5v6KNE29WnlJEiHHWVSfdPpzl2x09T
         wnZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NgzS/8FtCj01Tx+QLybY5HTl1Vfnoqx9UghL3+n0BE0=;
        b=Kr8RrXdgShhfhrydGnPtsLgvxAi6Z2X4AGAXwpvfdawMBWPbDuK9TG1VeQ3Fw+TxFv
         IXwE6S24xu1s1JjeJq++RwKARl0wVPtojkb9d+tRPeod2d5zHqU7GyYTphGoxDh3pVGp
         sFIw4jyP2YNoLu5kIVVSoqmp2FUgRTwQdVg/X5KedIeNQxgaGQYCpT+T1Jn9p/cNzKWo
         jbH898oTwrtQcuBh41FtbhWpge8IiAkFOSVpx+CqWUkvjRM200Ok1SI0nGLXO7vwh02J
         zBZF9Mba3DT91uLWJ4NdTwJNjRBqIN7vMDwZ0LHA4rxeJ0AytH03+O5cJczEQyO+BSa4
         4YPQ==
X-Gm-Message-State: ANhLgQ1slwRtpcSCzJJH8fb9fEVRZr8M4vH/gQOuftcbzUBPIhwLPmpF
        BrAxRu5fKiqURNiqLy4M+v4=
X-Google-Smtp-Source: ADFU+vvjrPLHtfCMSBIKLOOAstrnO2nTy7+0/6CfDFYSRKqJDITbZaavlM0xZVozGJPCk2g3pXqGvQ==
X-Received: by 2002:ac8:514e:: with SMTP id h14mr3455757qtn.97.1583346303321;
        Wed, 04 Mar 2020 10:25:03 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id a1sm14016363qkd.126.2020.03.04.10.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 10:25:02 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH] crypto: qce - fix wrong config symbol reference
Date:   Wed,  4 Mar 2020 15:24:55 -0300
Message-Id: <20200304182455.29066-1-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CONFIG_CRYPTO_DEV_QCE_SOFT_THRESHOLD symbol was renamed during
development, but the stringify reference in the parameter description
sneaked by unnoticed.

Signed-off-by: Eneas U de Queiroz <cotequeiroz@gmail.com>

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index a4f6ec1b64c7..9412433f3b21 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -18,7 +18,7 @@ module_param(aes_sw_max_len, uint, 0644);
 MODULE_PARM_DESC(aes_sw_max_len,
 		 "Only use hardware for AES requests larger than this "
 		 "[0=always use hardware; anything <16 breaks AES-GCM; default="
-		 __stringify(CONFIG_CRYPTO_DEV_QCE_SOFT_THRESHOLD)"]");
+		 __stringify(CONFIG_CRYPTO_DEV_QCE_SW_MAX_LEN)"]");
 
 static LIST_HEAD(skcipher_algs);
 
