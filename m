Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E238FC433B4
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9FD4613D8
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbhEEU1X (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 16:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbhEEU1X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 16:27:23 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51175C061574
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 13:26:26 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id l13so3202932wru.11
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 13:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1GWhhI0iSMmmiuEZ5hKTPTRltVs1yqT5L0KMdXtcVHo=;
        b=RrH29E/xtX6Nqr3atmcD7x0ouuE24Sx1nGS0MCqKymullmhi/P+fe/ymO1n4FQvNjH
         W0om+HX99ly8h5Zf+mMXOiBepZjshqSNA1BCkyfCRnv+9HEHmEeASrkq1FBLW//Mzs0X
         t1vff6HBPbIR8S/wuDJbonLq3k463f1+I8gNUsRhcVCpl2Is0GPy1kK6odS95NNzwt/V
         1URhXA6kdhioyxys+TFXFsGF6fAWwmGhnSfoHZFRwA7GT4ki2AyoyUEEeyj3Rv7ZQlUZ
         3jbvlXATyuON1X829sdsRV9A18HaDN3QQAy2XnU6dg0TfsrY120EtCKEszOAKnJOdp/c
         qtbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1GWhhI0iSMmmiuEZ5hKTPTRltVs1yqT5L0KMdXtcVHo=;
        b=JckfTxCJeUGAi7rH1NJj3UVGpOqGFdSllKCiHyyYYiz5NoarfmvKYDnWrBWH059jzq
         2b49Z9oVx3dLdVALnWeSRXu4t3rPOQHO864DozBtsLdj1t7hOTy2ZV3z1Um7wSXrQXV7
         47gtZEzwN/qwrXgpTV++57NY0eJx6Nd2z3JDVfa1bcWz0uCEPed8KVc/g4ZXFAafoM5l
         srhyB0hC+TfigATkCltdi8Yk+mPB2os1s4ECfvd9hEnBoYTxj5wN+HuPTJJpUELXGhVg
         ZvsvewaW1ZhUd76aLMA5YFFCYLiFNcvDMFmr+TYi4u5A6+ut9+fYnomLlAHLJglOL4hF
         KH4A==
X-Gm-Message-State: AOAM533IZhtlMWb/FaDuCkc5ywk0Q6B500WUySt4IODXVJa87JUyAnFZ
        qi3IfboJs8B/TRMHj7gxVKyunA==
X-Google-Smtp-Source: ABdhPJyzDQo9IN4BHvaWNRhY7cq1F8rfYdFnnq5prH8HvMU4JBI2fV8FyqoRYW7YqVCXo+bnRMTlow==
X-Received: by 2002:a5d:47a8:: with SMTP id 8mr948064wrb.124.1620246385100;
        Wed, 05 May 2021 13:26:25 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id a15sm497245wrr.53.2021.05.05.13.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 13:26:24 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     chohnstaedt@innominate.com, davem@davemloft.net,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 00/11] crypto: start to fix ixp4xx
Date:   Wed,  5 May 2021 20:26:07 +0000
Message-Id: <20210505202618.2663889-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

Loading the ixp4xx crypto driver exhibits lots of error.
All algorithm fail selftests with different reasons.
This series start to fixes some of thoses problem.

Corentin Labbe (11):
  crypto: ixp4xx: dma_unmap the correct address
  crypto: ixp4xx: update IV after requests
  crypto: ixp4xx: fallback when having more than one SG
  crypto: ixp4xx: convert unsigned to unsigned int
  crypto: ixp4xx: convert all printk to dev_xxx
  crypto: ixp4xx: whitespace fixes
  crypto: ixp4xx: Do not initialize static to NULL
  crypto: ixp4xx: remove brackets from single statement
  crypto: ixp4xx: Correct functions alignment
  MAINTAINERS: add ixp4xx_crypto to the right arch list
  MAINTAINERS: add myself as maintainer of ixp4xx_crypto

 MAINTAINERS                    |   7 +
 drivers/crypto/Kconfig         |   5 +
 drivers/crypto/ixp4xx_crypto.c | 277 +++++++++++++++++++++------------
 3 files changed, 188 insertions(+), 101 deletions(-)

-- 
2.26.3

