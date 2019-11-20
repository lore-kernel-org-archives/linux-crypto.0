Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DA4C43215
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0C2B20895
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:54:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A7dwQMCy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732904AbfKTQyy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:54:54 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34084 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731995AbfKTQyy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 11:54:54 -0500
Received: by mail-pj1-f66.google.com with SMTP id bo14so103413pjb.1;
        Wed, 20 Nov 2019 08:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SmmkPL/s8+dLRBd7moGUYjQr50TV9dprre5biO+pWFE=;
        b=A7dwQMCypoe6p4h96B9/TxzQRMiJlE0NJWcizqdgGJzf68jKTqmp/hiT1TDSHLZXrh
         5kgOcBhMI8xn1SXXboQ9V9VYjO3AxVGb4KLqx54jO7MkmPWCMufJXhUt+X66KDVYUCP8
         cncdn/Jn9FtaTEaR/+RzABGlvyUO3zB1ZntakO/rmj6DCX/fylGLUjMImcHC4fVQY2OF
         XpagH4PoIhpP77h+oK1LEEKrfQSyEVjJ9zCupA7UANk1KQOzlfaB71z+ml/oa9zJj0RJ
         kQs6/V5pX+kroPd4aas5FHTLEoOopF62oBTFGGNMhBCNfeiralaf1hDzd4pV7mGPxJYk
         8ztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SmmkPL/s8+dLRBd7moGUYjQr50TV9dprre5biO+pWFE=;
        b=I6IG9Icz0Uwb/RMfhwftlBjyx2Frw3suwb9xyx8Vwqtzip7WWwmBhJra4fWR6w71Cx
         bTqeMkgpr/MAe8nugHInlCRj09Ei71HgipqZwyWxk7Kzk2HtjqbT+dE9rva4wGdLdBYI
         SUwGSlnZ3uO9GYojytGA3WNfsbvvVw7SlgvMkgqSn4xdpK+xUOymDBaNhkH+dAYCMq4r
         MCJmC+ka9Ved4dlTJGYnqN6UDGOipM5eMLa/Nj/rCcn4w40yLS6TUEv9trvnxYGXwryK
         T08CiVMng7mlqk9PJGRYvAEL7PvuVkqKu2NewUdNRwkKBL8PYO9rDeTsrYftU0lV1ceD
         5ZQA==
X-Gm-Message-State: APjAAAXx5YK5SIbBwZP9eAplmyOQFT8I0j/B05xRENpiVn5NcZFZAv4S
        NF6qCz9uCmpbdJ0mGkqyETOTwOPO
X-Google-Smtp-Source: APXvYqxfRw7lBAZELqyM7BpttNf4yc/FBABSygrhE2LduXO/T+ZEuxM63jk69xNqzsFIHhaqjRGejQ==
X-Received: by 2002:a17:902:6b47:: with SMTP id g7mr3949682plt.87.1574268892235;
        Wed, 20 Nov 2019 08:54:52 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id e11sm29841483pff.104.2019.11.20.08.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 08:54:49 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v3 0/6] enable CAAM's HWRNG as default
Date:   Wed, 20 Nov 2019 08:53:35 -0800
Message-Id: <20191120165341.32669-1-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Everyone:

This series is a continuation of original [discussion]. I don't know
if what's in the series is enough to use CAAMs HWRNG system wide, but
I am hoping that with enough iterations and feedback it will be.


Changes since [v1]:

    - Original hw_random replaced with the one using output of TRNG directly

    - SEC4 DRNG IP block exposed via crypto API

    - Small fix regarding use of GFP_DMA added to the series

Chagnes since [v2]:

    - msleep in polling loop to avoid wasting CPU cycles

    - caam_trng_read() bails out early if 'wait' is set to 'false'

    - fixed typo in ZII's name

Feedback is welcome!

Thanks,
Andrey Smirnov

[discussion] https://patchwork.kernel.org/patch/9850669/
[v1] lore.kernel.org/lkml/20191029162916.26579-1-andrew.smirnov@gmail.com
[v2] lore.kernel.org/lkml/20191118153843.28136-1-andrew.smirnov@gmail.com

Andrey Smirnov (6):
  crypto: caam - RNG4 TRNG errata
  crypto: caam - enable prediction resistance in HRWNG
  crypto: caam - allocate RNG instantiation descriptor with GFP_DMA
  crypto: caam - move RNG presense check into a shared function
  crypto: caam - replace DRNG with TRNG for use with hw_random
  crypto: caam - expose SEC4 DRNG via crypto RNG API

 drivers/crypto/caam/Kconfig   |  15 +-
 drivers/crypto/caam/Makefile  |   3 +-
 drivers/crypto/caam/caamrng.c | 358 ----------------------------------
 drivers/crypto/caam/ctrl.c    |  29 ++-
 drivers/crypto/caam/desc.h    |   2 +
 drivers/crypto/caam/drng.c    | 175 +++++++++++++++++
 drivers/crypto/caam/intern.h  |  32 ++-
 drivers/crypto/caam/jr.c      |   3 +-
 drivers/crypto/caam/regs.h    |  14 +-
 drivers/crypto/caam/trng.c    |  89 +++++++++
 10 files changed, 338 insertions(+), 382 deletions(-)
 delete mode 100644 drivers/crypto/caam/caamrng.c
 create mode 100644 drivers/crypto/caam/drng.c
 create mode 100644 drivers/crypto/caam/trng.c

-- 
2.21.0

