Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E299EC432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 15:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABB322192D
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 15:39:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dSCD/0Uu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfKRPjE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 10:39:04 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38094 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfKRPjE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 10:39:04 -0500
Received: by mail-pf1-f196.google.com with SMTP id c13so10568725pfp.5;
        Mon, 18 Nov 2019 07:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VM7WOH+2WiJWnDk5F5oKFEBVwx6qbmQaghETu0YE1Oo=;
        b=dSCD/0UurD6XtLVdFTf12Qt2OJSpQf0r9AjAYdfFcRF9UieGPr6YceQA6uo7x2apxX
         fLRpdauP7xUk1ZZVuoQ4eknhG8Avm+7UvzwJmoriM4jAAXlKmEWN6kxLtMmBYyUqLz7R
         OXm+HPb2wiioPfWRH8HexVaue5jB2p8t1L0WySbwNNuczTsKLsF6XbpSpHcIKsZvTe63
         Mra39Nnv5Frf5GBOwVPlKKDe0j+F3JtDUWlHVt7osLvF/ia1rxVY5AxlzexM1jcCiCa+
         vaHcxaWrtLrEOYkKejmqYeV56WbJ9Mg3sYWcBs5LVP9uEoBjjRh5vShD6Hraz+Kyvnt4
         3X3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VM7WOH+2WiJWnDk5F5oKFEBVwx6qbmQaghETu0YE1Oo=;
        b=afLzL+n12XgI+vm4IFVCdVQV64OA1ZDKzqTza2s8NhSd3RGKSM7j43eB9n0z0HrkLe
         uORA83FBWRVTBOeOuYC+URMSnk+uErA5IYMHhCq9P0grHY52lxvlWG3gtF8GMpHIsRxH
         OFDwCKjigpcpHuBHNSsFYFFvKZ+2iyeUgGtSecQDP7vJPH8xGHULPSvJitGRU6F7QxmU
         NfpWsANljTP3ztgrivU3D3V1moapiNiZnvD7ocH33nrxlAwq47STrNMSk5z0Tl9gWyrj
         /jfoy9EDVsHwfb4BVY35WcLg7OPCvGroynkaHKNHi8EF5gAvGcMPIpEQ17vbkifl+xOM
         X5BQ==
X-Gm-Message-State: APjAAAW9BAo+XQHoErqhci/d053L56n8GV1Dbiy8CqYs9/b3I1c97Nai
        J2E/lX4gtAikDgbahF/7fRAl+YVt
X-Google-Smtp-Source: APXvYqz6ixm/Ial2SVgu2Wo1FWpe8VTuOm0E5fY1bulojOyWQbSn2VnuFhWnecGPhv/284FXj4PFtA==
X-Received: by 2002:a63:4553:: with SMTP id u19mr33237513pgk.436.1574091543130;
        Mon, 18 Nov 2019 07:39:03 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id z7sm23573732pfr.165.2019.11.18.07.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 07:39:01 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v2 0/6] enable CAAM's HWRNG as default
Date:   Mon, 18 Nov 2019 07:38:37 -0800
Message-Id: <20191118153843.28136-1-andrew.smirnov@gmail.com>
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

Feedback is welcome!

Thanks,
Andrey Smirnov

[discussion] https://patchwork.kernel.org/patch/9850669/
[v1] lore.kernel.org/lkml/20191029162916.26579-1-andrew.smirnov@gmail.com

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
 drivers/crypto/caam/trng.c    |  85 ++++++++
 10 files changed, 334 insertions(+), 382 deletions(-)
 delete mode 100644 drivers/crypto/caam/caamrng.c
 create mode 100644 drivers/crypto/caam/drng.c
 create mode 100644 drivers/crypto/caam/trng.c

-- 
2.21.0

