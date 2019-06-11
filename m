Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF835C4321A
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 13:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82BFC20896
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 13:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MuAM88dN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389251AbfFKNr5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 09:47:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53828 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388299AbfFKNr5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 09:47:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so3041805wmj.3
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2019 06:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SPvq1TSklyvGf3Mu8PrbXdN3TXq8wdRsziixaPTYMwE=;
        b=MuAM88dNq8yvZonActjV5w2mTXFiruMmu7kwM8C7MXTERQS6rHBcEeyCzHQN8RUi6g
         i/Wo1/xkL2bK7mB6Vhlcbqt3KrGWx1FtG8oZoNH7gv1VuL4JMqiBmtCvEAgStByzfpXx
         G465wKK2wFE8G4HYYkEq37GPfiyEV+KxvQwuO4f1HG/n+gQWTODyEY1osQ5lsr7KvxWd
         fB3qOf5fkWtr5t0tDU2OFXOGPnJPfphTwDtjNSdxelfYIZHmNrIGZinxJWs/Btx0uoe5
         ltP7tvtTZsqSycT8sVqxfoMjpmcI3ZGj+3ofE1qTxSMOTY00O7K1Z5LIWdNuc9324Q5J
         2fGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SPvq1TSklyvGf3Mu8PrbXdN3TXq8wdRsziixaPTYMwE=;
        b=Ors3eWOPw3z8rc/IylTr2eQjWqedM4f1nbYZc4Oxkue67jn5OLJMcfP/u4juLMBxiL
         BylFg5efdbNZWxXqVJUdj6nK79aqZ2bnkl9DX+SWTzuvMRIHNql3xZYloLub4z8BeGW/
         aoUwlMh6dzW6R74fcPWoCDPDt9vvAehmuNJtI/lnFi9jq+1AMiOpG8tEe0fDVMZ8WhfW
         gNww4YWsxdnZ0h5MxTWVEfcvMvNdkOsB+hR4uWA9L+6SwJ3qXqPAlsE8IzkN4QM4t/XZ
         GVkOnuyf9M6H6V6WSu9CurnffJM8n8wzcRRjku0plBunMM7QAR0juBzoVnIbE9eLGZvC
         zU6g==
X-Gm-Message-State: APjAAAXWPtROnBQHsz+9A++a4IXzP9JJP6Aa/OdF9I6gNscuLfWAdtGq
        OIy5rNAcPN1KOlK+uepd+CDpnqxPX/lsN8l4
X-Google-Smtp-Source: APXvYqzqgPpsZ/W/MpKZxB9bRBcTKcs/rpa0vtiQwxDFhGbodjhueVHdwFx3iEPzZuKOGy6aGTrz0g==
X-Received: by 2002:a1c:3b02:: with SMTP id i2mr16758612wma.23.1560260874369;
        Tue, 11 Jun 2019 06:47:54 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:24bb:7f31:25fe:43a7])
        by smtp.gmail.com with ESMTPSA id o126sm3964305wmo.31.2019.06.11.06.47.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 06:47:53 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v3 0/7] crypto: rc4 cleanup
Date:   Tue, 11 Jun 2019 15:47:43 +0200
Message-Id: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
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

Changes since v2:
- drop the crypto_ prefix from the arc4 library functions and types
- rename the source file to arc4.c but keep the lib prefix for the actual
  module to prevent a clash with the crypto API driver
- preserve the existing behavior wrt the fips_enabled flag, which prevents
  any use of ARC4 (note that the fips_enabled flag evaluates to 'false' at
  compile time for kernels that lack the feature, so with these patches, we
  get rid of most of the runtime logic regarding FIPS for builds that don't
  have it enabled)

[0] https://lore.kernel.org/linux-crypto/20190607144944.13485-1-ard.biesheuvel@linaro.org/

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>

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
 crypto/arc4.c                      | 104 +-------------------
 drivers/net/ppp/Kconfig            |   3 +-
 drivers/net/ppp/ppp_mppe.c         |  95 +++---------------
 fs/cifs/Kconfig                    |   2 +-
 fs/cifs/cifsencrypt.c              |  53 +++-------
 include/crypto/arc4.h              |  10 ++
 lib/Makefile                       |   2 +-
 lib/crypto/Makefile                |   4 +
 lib/crypto/arc4.c                  |  72 ++++++++++++++
 net/mac80211/Kconfig               |   2 +-
 net/mac80211/cfg.c                 |   3 -
 net/mac80211/ieee80211_i.h         |   4 +-
 net/mac80211/key.h                 |   1 +
 net/mac80211/main.c                |   6 +-
 net/mac80211/mlme.c                |   2 -
 net/mac80211/tkip.c                |   8 +-
 net/mac80211/tkip.h                |   4 +-
 net/mac80211/wep.c                 |  47 ++-------
 net/mac80211/wep.h                 |   4 +-
 net/mac80211/wpa.c                 |   4 +-
 net/wireless/Kconfig               |   1 +
 net/wireless/lib80211_crypt_tkip.c |  46 +++------
 net/wireless/lib80211_crypt_wep.c  |  49 +++------
 25 files changed, 179 insertions(+), 352 deletions(-)
 create mode 100644 lib/crypto/Makefile
 create mode 100644 lib/crypto/arc4.c

-- 
2.20.1

