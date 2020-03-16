Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D097AC2BB1D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 15:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8C4920679
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 15:01:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lLkRFYsk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbgCPPBE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 11:01:04 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38633 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731629AbgCPPBD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 11:01:03 -0400
Received: by mail-pj1-f66.google.com with SMTP id m15so8151800pje.3;
        Mon, 16 Mar 2020 08:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YmKRCv/D9RMADh2OrMpzXDg0WtSJ2/WTNutUXLsM7sc=;
        b=lLkRFYskCWOoR/OHcVEFlIECbKeWjzqxW11DFESSK1DPOqo4txD1V05hUIX8bzO5cB
         O/WnGj7yiaMur4OoAMxKHdszmhEbnN/yHktEehFmtYv31xXHlFhm8bDwGd+Ou0LfdP/w
         xEb/roqYMPqrq2YinERi7RD+Q3hS697T6FUtIXgW5ri5pN+ByZd7M+GfGeV259CQ/pwI
         UBGMVj6BkuYGynat6V7Qwrl2x7RfGsECXKulAdxYO4xjcaqf7NoOJXgtUubExOOmwT6/
         Sm+zG6FGmaI4igMk78yGGAtS/12+cR5/fG0Fu1g7FRsvH9nHz8aC/p9tq9eyAXVa28Ih
         ftnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YmKRCv/D9RMADh2OrMpzXDg0WtSJ2/WTNutUXLsM7sc=;
        b=FHgaP/Zq5sElbX22KfouBbVygraFuO2EfUJ5hqym6XAE1CRQPNK+6NUfokO36OF/27
         HfQFT8peu6/kgZnHZiakfX1xo7viuUbyqGSP5tg1LDZRWNZ4EWrtHKZrKKsxAqv9P7br
         FieUE+O80CYmps79VXHow5UYg7K2ROqw2vDO15lhpHt+cw79HPq3AVdGwtt/UjHfX3eO
         B01U4/Mkd2Ze0djzZ54HtwJuF0wjczNJ+x/O8GEGwrt7jsamjL4KDsBYpmOtXLwQOD8r
         ZZciRaTx4rtc7lQDEX9WFBfD2NH+FDPs8JjxPVnt40zsBBiadlZI9c8JxMWrO43THFiB
         dWAw==
X-Gm-Message-State: ANhLgQ3CnTgmPBhhgBzsGFST/dnyXKQHHpfBqVtjCf3tywyeet9fRaTM
        ZCkthx7SUAvmXfCTKjumoYJKgKQs
X-Google-Smtp-Source: ADFU+vt2NywATHTn29ojvKEu8wm49lxwkJJ3BhTHNaxNw70o1gVtl8aHebjl9NMWZVplnXNEQ58SLA==
X-Received: by 2002:a17:90a:a60c:: with SMTP id c12mr26661171pjq.28.1584370860033;
        Mon, 16 Mar 2020 08:01:00 -0700 (PDT)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id o128sm256354pfg.5.2020.03.16.08.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 08:00:58 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v8 0/8] enable CAAM's HWRNG as default
Date:   Mon, 16 Mar 2020 08:00:39 -0700
Message-Id: <20200316150047.30828-1-andrew.smirnov@gmail.com>
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

Changes since [v3]:

    - DRNG's .cra_name is now "stdrng"

    - collected Reviewd-by tag from Lucas

    - typo fixes in commit messages of the series

Changes since [v4]:

    - Dropped "crypto: caam - RNG4 TRNG errata" and "crypto: caam -
      enable prediction resistance in HRWNG" to limit the scope of the
      series. Those two patches are not yet ready and can be submitted
      separately later.

    - Collected Tested-by from Chris

Changes since [v5]:

    - Series is converted back to implementing HWRNG using a job ring
      as per feedback from Horia.

Changes since [v6]:

    - "crypto: caam - drop global context pointer and init_done"
      changed to use devres group to allow freeing HWRNG resource
      independently of the parent device lifecycle. Code to deal with
      circular deallocation dependency is added as well

    - Removed worker self-scheduling in "crypto: caam - simplify RNG
      implementation". It didn't bring much value, but meant that
      simple cleanup with just a call to flush_work() wasn't good
      enough.

    - Added a simple function with a FIXME item for MC firmware check in
      "crypto: caam - enable prediction resistance in HRWNG"

    - "crypto: caam - limit single JD RNG output to maximum of 16
      bytes" now shrinks async FIFO size from 32K to 64 bytes, since
      having a buffer that big doesn't seem to do any good given that
      througput of TRNG

Changes since [v7]:

    - Collected Reviewd-bys from Horia

    - updated "crypto: caam - simplify RNG implementation" to drop
      custom type and fix comments

    - updated "crypto: caam - enable prediction resistance in HRWNG"
      to integrate code from Andrei Botila

    - updated "crypto: caam - drop global context pointer and
      init_done" to use .priv instead of container_of for private data
      pointer

Feedback is welcome!

Thanks,
Andrey Smirnov

[discussion] https://patchwork.kernel.org/patch/9850669/
[v1] https://lore.kernel.org/lkml/20191029162916.26579-1-andrew.smirnov@gmail.com
[v2] https://lore.kernel.org/lkml/20191118153843.28136-1-andrew.smirnov@gmail.com
[v3] https://lore.kernel.org/lkml/20191120165341.32669-1-andrew.smirnov@gmail.com
[v4] https://lore.kernel.org/lkml/20191121155554.1227-1-andrew.smirnov@gmail.com
[v5] https://lore.kernel.org/lkml/20191203162357.21942-1-andrew.smirnov@gmail.com
[v6] https://lore.kernel.org/lkml/20200108154047.12526-1-andrew.smirnov@gmail.com
[v7] https://lore.kernel.org/lkml/20200127165646.19806-1-andrew.smirnov@gmail.com

Andrey Smirnov (8):
  crypto: caam - allocate RNG instantiation descriptor with GFP_DMA
  crypto: caam - use struct hwrng's .init for initialization
  crypto: caam - drop global context pointer and init_done
  crypto: caam - simplify RNG implementation
  crypto: caam - check if RNG job failed
  crypto: caam - invalidate entropy register during RNG initialization
  crypto: caam - enable prediction resistance in HRWNG
  crypto: caam - limit single JD RNG output to maximum of 16 bytes

 drivers/crypto/caam/Kconfig   |   1 +
 drivers/crypto/caam/caamrng.c | 405 +++++++++++++---------------------
 drivers/crypto/caam/ctrl.c    |  88 ++++++--
 drivers/crypto/caam/desc.h    |   2 +
 drivers/crypto/caam/intern.h  |   7 +-
 drivers/crypto/caam/jr.c      |  13 +-
 drivers/crypto/caam/regs.h    |   7 +-
 7 files changed, 243 insertions(+), 280 deletions(-)

--
2.21.0
