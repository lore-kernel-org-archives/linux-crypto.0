Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B62DC282DD
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 15:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB6C92067D
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 15:41:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="evrCk2kp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgAHPl4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jan 2020 10:41:56 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43651 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgAHPl4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jan 2020 10:41:56 -0500
Received: by mail-pg1-f195.google.com with SMTP id k197so1755904pga.10;
        Wed, 08 Jan 2020 07:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wr7wZF5IW9e7GOkAKuIeFml4/EnTneclSGORFEfwN8k=;
        b=evrCk2kpznLVfN9YWmJ2NJPgqzK5uvwE88pWlqwez0yi/fRxTp52YiB945YmXvQ0Wl
         tNR3Te/7gzCHKZeGh/d1OecZXnz3Wp8ZPch8AjKM3VCQKewbxXwWlcgBHduqkAF0/ZVr
         2JjAGfwV3ddvP+vxRyOYxfb5j/bgq7rGruM82n2kmGbBVOiVSU/UuPV5EbHHVPlcay7x
         JT4MT32qwdT9oUJ2HKY8PhSJMmWEmSlmyXhq8IAPk/GADey+ifzRaRU98V4FPRyuWqml
         fVqo4MxfWzj9aAfmaxHhqBKrMim2Q3QLBL3MKFnBj+MxogXQKN+l0yD7/nkai+h0iJfa
         lMRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wr7wZF5IW9e7GOkAKuIeFml4/EnTneclSGORFEfwN8k=;
        b=QgNBPWy6rFayUBw8OyRtIVZ4vAVsjAUKGUh0qDpLDsJhMWbm2YGFnSxFO91M9urz9s
         bhxwc6yKpvgkNrTtnubqrTumDi14vYYfzL/cVaVh7VHWSu5shm0kP3OiRV8yKnj5zaJS
         W8W46B8GIAKiUcJST0gn3MSeBGIpeLR4q371jPA0VOSoNrDDfqpJumiVKGxjQN23LAA0
         RzOfPNRtIINjaMCZa/dfCF5FYfqu1/6dWZzfa6LIKNq0BtoyDp1bSPiBKkpBkVKEdZ0g
         mnwLM5+ynbH+2RAPrMeygr6045sQj9Rx1HiqBpOJPFKftsdyUg3qTi3oLah8JYfo85Hi
         ZJyQ==
X-Gm-Message-State: APjAAAUYzyb8xmHLljZELES0ExkrwaYhgeDiheA7G98kWsB7akqvjwnn
        EBveVNOOfHqqlmZtOT9ILFySOza+
X-Google-Smtp-Source: APXvYqxcQ5MHQ0geh3gHKxWeqtkNSL35HKJj7RT73LwtAqr7P13uZxql9j/ghxOaXPN0r5CjpEsvbg==
X-Received: by 2002:a65:4344:: with SMTP id k4mr5795638pgq.193.1578498114684;
        Wed, 08 Jan 2020 07:41:54 -0800 (PST)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id e1sm4286640pfl.98.2020.01.08.07.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 07:41:53 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v6 0/7] enable CAAM's HWRNG as default
Date:   Wed,  8 Jan 2020 07:40:40 -0800
Message-Id: <20200108154047.12526-1-andrew.smirnov@gmail.com>
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

Feedback is welcome!

Thanks,
Andrey Smirnov

[discussion] https://patchwork.kernel.org/patch/9850669/
[v1] https://lore.kernel.org/lkml/20191029162916.26579-1-andrew.smirnov@gmail.com
[v2] https://lore.kernel.org/lkml/20191118153843.28136-1-andrew.smirnov@gmail.com
[v3] https://lore.kernel.org/lkml/20191120165341.32669-1-andrew.smirnov@gmail.com
[v4] https://lore.kernel.org/lkml/20191121155554.1227-1-andrew.smirnov@gmail.com
[v5] https://lore.kernel.org/lkml/20191203162357.21942-1-andrew.smirnov@gmail.com

Andrey Smirnov (7):
  crypto: caam - use struct hwrng's .init for initialization
  crypto: caam - drop global context pointer and init_done
  crypto: caam - simplify RNG implementation
  crypto: caam - check if RNG job failed
  crypto: caam - invalidate entropy register during RNG initialization
  crypto: caam - enable prediction resistance in HRWNG
  crypto: caam - limit single JD RNG output to maximum of 16 bytes

 drivers/crypto/caam/caamrng.c | 391 ++++++++++++----------------------
 drivers/crypto/caam/ctrl.c    |  33 ++-
 drivers/crypto/caam/desc.h    |   2 +
 drivers/crypto/caam/intern.h  |   5 -
 drivers/crypto/caam/jr.c      |   1 -
 drivers/crypto/caam/regs.h    |   7 +-
 6 files changed, 174 insertions(+), 265 deletions(-)

--
2.21.0
