Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8DDC10F0B
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 08:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5A53214DA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 08:17:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c9bFdsqC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388245AbfDRIRu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 04:17:50 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46620 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733205AbfDRIRu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 04:17:50 -0400
Received: by mail-wr1-f65.google.com with SMTP id t17so1777422wrw.13;
        Thu, 18 Apr 2019 01:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=shwvU1y7ksmVy0QXfrQ/apRCOOdUrT/0ZWS8rq45Pu0=;
        b=c9bFdsqC3n2TWANZ9ynb5Dv6XUF4YEz2kMretIa4ZEyEqKEkPZ+H04yo5usk6SO69+
         w5QzVEnZLl6br+yXBI2XQ5ljw/k0NMgEiW72mRCOZiMH2lpkqL8gKJLZ5KNesWH7jh6w
         wNUvKIgTZZQRQhRAJ29v0RD9DCsIu71s+4YBDrkJxvjAT2tIqTrze6PvTAvZJJ+A6mUF
         9u+iolZQrRHYOSO4mjELT4CQk/KK+SvCX09G6L8c8MOB5PpCDF76qQoDMOLPk62NMjsj
         zZ4e/X62rH1HaIROf0Kyt6qXSRFnTL6JRrcTGOeoHFb4L+fF7cJJycZV83RKtqUze83q
         s+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=shwvU1y7ksmVy0QXfrQ/apRCOOdUrT/0ZWS8rq45Pu0=;
        b=onn5YMApJgCGfA3DKhXqzyvZRfH902/70InGOLqj7ZbYHm4sT6/45hPmGSoIScCAuN
         R4lRlBy8D7tvbo6PuGGWiepZhUH8VeqAGc3WmNqxBcTc1aC0uZXgHJBn3mib4FkWsW9Y
         5wpHeXiBSteJjlhZvqrcVHAN6unQ1s7q6xWAY6Cp/gigg3/sMKvLRVTitaWvZAz3YZa8
         w1gDF9oLoovEsjm52FxxwBHr9xyJ1B5izTtR8ZCNS7LPc7iY/FpVkfoGX6DgFONyoP8g
         RLzvm01QRj6DC2vC+h5dniVjFhToTzFb+lUgXGyqROZU0DLBS/M4wMN47gqxZSH10B2O
         zILQ==
X-Gm-Message-State: APjAAAWxZabf3YjMZ+v+rS/2ckuVXoPbaPGtANnqlFfiKXxvK8HfGAoe
        CLaKcP7PmX+X5r6iace592o=
X-Google-Smtp-Source: APXvYqybzxYYd+nlxzYeJwuJLoO57E5qgdPxsNzvjuevizszBpSDJpX95WfOGkgmFv+VGuhdJGYQ2w==
X-Received: by 2002:adf:8051:: with SMTP id 75mr4878861wrk.2.1555575468706;
        Thu, 18 Apr 2019 01:17:48 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id w11sm2350619wre.15.2019.04.18.01.17.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 01:17:48 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        maxime.ripard@bootlin.com, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        ebiggers@kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 0/4] crypto: sun4i-ss: Fix problem reported by CONFIG_CRYPTO_EXTRA_TESTS
Date:   Thu, 18 Apr 2019 10:17:31 +0200
Message-Id: <20190418081735.19002-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

Loading sun4i-ss with CONFIG_CRYPTO_EXTRA_TESTS, lead to hung tasks.
This patchset fix the two deadlock (one in hash, one in cipher) found.
This patchset fix also some invalid IV handling found while debugging
thoses issues.

Regards

Corentin Labbe (4):
  crypto: sun4i-ss: Handle better absence/presence of IV
  crypto: sun4i-ss: remove ivsize from ECB
  crypto: sun4i-ss: Fix invalid calculation of hash end
  crypto: sun4i-ss: fallback when length is not multiple of blocksize

 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 67 ++++++++++++++++++-----
 drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 19 ++++---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c   |  5 +-
 drivers/crypto/sunxi-ss/sun4i-ss.h        |  2 +
 4 files changed, 71 insertions(+), 22 deletions(-)

-- 
2.21.0

