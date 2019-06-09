Return-Path: <SRS0=Xb3v=UI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6505C28EBD
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Jun 2019 11:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8587220673
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Jun 2019 11:55:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h/+f01WD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbfFILzP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 9 Jun 2019 07:55:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37649 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbfFILzO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Jun 2019 07:55:14 -0400
Received: by mail-wr1-f66.google.com with SMTP id v14so6370218wrr.4
        for <linux-crypto@vger.kernel.org>; Sun, 09 Jun 2019 04:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NS/OeESvjcIylX3MvpojSYicfP5yOiELOMT1mYMpd6I=;
        b=h/+f01WDroefXzctBz18qiDh0l00iHYgnQtFRfD0l8W5BB7AGPsrYwNFgEI43f8NoH
         VnYCwHmLC11dw3y6KXSkFTI80BrGUEZTwUkkk+Xqv4x9zYl2//1mrL2oO4rQ3l8AwnEB
         Qc0TZkkUAapWOjGM0e3o3EU3JddurPrqHyx33hxrPsOXkRSIdINvcZ8KDO50IMQw6QbF
         rh4nUhgSxkruwCGwjglljaHC/LGGXJsCg0ViA7x3aldoL3BrdARJq0TuIVHyrEC/CDJt
         Duj6PKoV8PDmqD+uMpE7hFaRGLbv7IkuOlDvt+14Bt8T9NU2twvNG2HzgyAPoyVPEMw9
         gp2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NS/OeESvjcIylX3MvpojSYicfP5yOiELOMT1mYMpd6I=;
        b=HD0fuHpHlWGc8/Kw4/Kn5c4aIOLpQYUhd0TCwlFeRKoy8q/v+FkQeaKolQSPNzmXk5
         z3G/9Jn4wMOXa9k4OvO/EuQFUQ0gdA4QOywG11eQllCSIh+zvFEvR7vtz1KhUjlvNSEM
         EHz+UvnTRzMpRNRMOPprmHBRHDa9sr73Yzgm+qXluOAEuUqWNqHsEvpqvXUMJvbBo4SH
         YxJSuXTQp57sf4MJms+fH//znNKRpUghFTow2vvMy2U46qC8OMwiYNPkdB6W1hqpoTof
         U63V7ka0Gryd8N1DdvLw/Gt2vwg7nElRgq0UIkeYZYoPENrB6/lioSELa3gcOaA0qDJm
         rDTg==
X-Gm-Message-State: APjAAAUUK119rsYubrOB1Uu4x651NYxI/+Vu1MdCvKvlqulthJfg8w1+
        OVeyrv30y/7//whGnyXGvjjT2IUXmET4lw==
X-Google-Smtp-Source: APXvYqzHHBeMKpI9yFtOtgGib21DiVTL3FH81JhfbgfIEaMSBnaIBHju5JZU9rWFDd0+d1n/er0DVQ==
X-Received: by 2002:adf:8028:: with SMTP id 37mr40389410wrk.106.1560081312948;
        Sun, 09 Jun 2019 04:55:12 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:5129:23cd:5870:89d4])
        by smtp.gmail.com with ESMTPSA id r5sm14954317wrg.10.2019.06.09.04.55.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 04:55:11 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v2 0/7] crypto: rc4 cleanup
Date:   Sun,  9 Jun 2019 13:55:02 +0200
Message-Id: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a follow-up to, and supersedes [0], which moved some WEP code from
the cipher to the skcipher interface, in order to reduce the use of the bare
cipher interface in non-crypto subsystem code.

Since using the skcipher interface to invoke the generic C implementation of
an algorithm that is known at compile time is rather pointless, this series
moves those users to a new arc4 library interface instead, which is based on
the existing code.

Along the way, the arc4 cipher implementation is removed entirely, and only
the ecb(arc4) code is preserved, which is used in a number of places in the
kernel, and is known to be used by at least 'iwd' from user space via the
algif_skcipher API.

[0] https://lore.kernel.org/linux-crypto/20190607144944.13485-1-ard.biesheuvel@linaro.org/

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Biggers <ebiggers@google.com>

Ard Biesheuvel (7):
  crypto: arc4 - refactor arc4 core code into separate library
  net/mac80211: move WEP handling to ARC4 library interface
  net/lib80211: move WEP handling to ARC4 library code
  net/lib80211: move TKIP handling to ARC4 library code
  crypto: arc4 - remove cipher implementation
  ppp: mppe: switch to RC4 library interface
  fs: cifs: switch to RC4 library interface

 MAINTAINERS                        |   1 +
 crypto/Kconfig                     |   4 +
 crypto/arc4.c                      | 106 ++------------------
 drivers/net/ppp/Kconfig            |   3 +-
 drivers/net/ppp/ppp_mppe.c         |  92 ++---------------
 fs/cifs/Kconfig                    |   2 +-
 fs/cifs/cifsencrypt.c              |  50 +++------
 include/crypto/arc4.h              |  13 +++
 lib/Makefile                       |   2 +-
 lib/crypto/Makefile                |   3 +
 lib/crypto/libarc4.c               |  74 ++++++++++++++
 net/mac80211/Kconfig               |   2 +-
 net/mac80211/cfg.c                 |   3 -
 net/mac80211/ieee80211_i.h         |   4 +-
 net/mac80211/key.h                 |   1 +
 net/mac80211/main.c                |  48 +--------
 net/mac80211/mlme.c                |   2 -
 net/mac80211/tkip.c                |   8 +-
 net/mac80211/tkip.h                |   4 +-
 net/mac80211/wep.c                 |  47 ++-------
 net/mac80211/wep.h                 |   4 +-
 net/mac80211/wpa.c                 |   4 +-
 net/wireless/Kconfig               |   1 +
 net/wireless/lib80211_crypt_tkip.c |  42 +++-----
 net/wireless/lib80211_crypt_wep.c  |  43 ++------
 25 files changed, 176 insertions(+), 387 deletions(-)
 create mode 100644 lib/crypto/Makefile
 create mode 100644 lib/crypto/libarc4.c

-- 
2.20.1

