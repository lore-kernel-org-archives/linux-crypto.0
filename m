Return-Path: <SRS0=yTfj=C2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A69C35263
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 18:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DADA221E7
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 18:38:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="JriYO/BK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgIQSgN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Sep 2020 14:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgIQSgJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Sep 2020 14:36:09 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0081AC06174A
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2020 11:36:08 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w2so2914712wmi.1
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2020 11:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=80WQwBM9RNFOS8VBDzJIrM518QYIY+w3sh3jO4LWS+I=;
        b=JriYO/BKOtG/wSNu/J1GWXpv1DmYEETwaU6Q7mH+B7UsbP9CxCKI0HS2JAeZoFIWRu
         7RrWElcuTKneup0MksLrE5k/ofNmMNJvNrM5ZwriM9VN6c75qzwpeAimnruRNguM+10M
         5KjDRPcIblpjnb/SA/RSEDTvqQTuT9OCFRzBn1KVLUJmOpEtSlJwdW4uTKd9LLVmf8DU
         7gc1TYTeI8pH7ifnjFdJVyxdxpXkqcMWJXc9KLdhiQstc9ZcU8+s4Cy+eGo9oX2IrLeG
         28zYUkeFwoQ8oA3iU4XlIyhJBdF2RKxJKNrCfTXYsn7NILoiFSthi6x7yxL5D/trldqk
         0hCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=80WQwBM9RNFOS8VBDzJIrM518QYIY+w3sh3jO4LWS+I=;
        b=MmAudJelhV8tJv2bv6wA7ivx8NCEG7/YBnsyDPUT2jgvsnNX0pyUSVuwdYfxnkcfot
         9pOG8KkvXLIJM1BYcW8PWKHMmqkuPEWY0k3OwfAuAus4tS7g7YmDo3+Bc9Ru3MAA8vuf
         Ij/Iq00rgqcyjGhzHU8KkNU3FseYmDERsAveZzAMkNDgKkUd9/02YQVKn0Oa3YKQ0svz
         XUno3qKM3iy2KE3ARv3OLQNMdIdLmjezHGITmwQxvK13P9imr6l20Xy+SylY0pUB/HM6
         l7LH7S6bZLKbmv3HqZ3EuZrD9v2MYWX1ela0UOpuu69gBb8QxoLUxmWBsUjAsMRXpmLR
         ptYQ==
X-Gm-Message-State: AOAM530aXnAwiha2QHajr3MO+1dkZ3CQgJJIHH4ySX4qW6IOjDhUeKcb
        UrM3kg64Q+nxYYZICYCBZbfrqYmShE7sjg==
X-Google-Smtp-Source: ABdhPJzxrotugbf7NPHeEx+arqAgMueZlejapNGIXOt6cJFceK/hx7FR+qLmXzyNx1WE+NPWv0xONg==
X-Received: by 2002:a1c:7716:: with SMTP id t22mr10914640wmi.64.1600367767618;
        Thu, 17 Sep 2020 11:36:07 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id x16sm571901wrq.62.2020.09.17.11.36.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 11:36:06 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 0/7] crypto: sun4i-ss: prevent always fallback for ciphers
Date:   Thu, 17 Sep 2020 18:35:51 +0000
Message-Id: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

For help testing on "crypto: sun4i-ss - Fix sparse endianness markers",
I have added "stats" support like other allwinner's crypto drivers.
Seeing stats showed a clear problem, the ciphers function were not used
at all.
This is due to the not-inialized need_fallback which is "init" as true
everytime.
So basicly, since the patch introduced it, this probem hidden some bugs.

This serie fixes all hidden problems, then fix the initialization of
"need_fallback" and then add the stats like other allwinner drivers.

Corentin Labbe (7):
  crypto: sun4i-ss: linearize buffers content must be kept
  crypto: sun4i-ss: checking sg length is not sufficient
  crypto: sun4i-ss: IV register does not work on A10 and A13
  crypto: sun4i-ss: handle BigEndian for cipher
  crypto: sun4i-ss: initialize need_fallback
  crypto: sun4i-ss: enabled stats via debugfs
  crypto: sun4i-ss: add SPDX header and remove blank lines

 drivers/crypto/allwinner/Kconfig              |  9 ++
 .../allwinner/sun4i-ss/sun4i-ss-cipher.c      | 87 ++++++++++++++-----
 .../crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 54 ++++++++++++
 .../crypto/allwinner/sun4i-ss/sun4i-ss-hash.c |  8 ++
 .../crypto/allwinner/sun4i-ss/sun4i-ss-prng.c |  6 ++
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  | 11 +++
 6 files changed, 153 insertions(+), 22 deletions(-)

-- 
2.26.2

