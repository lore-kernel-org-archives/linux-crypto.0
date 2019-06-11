Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54622C31E44
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 23:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25B9920872
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 23:09:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UQekfdeV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407906AbfFKXJq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 19:09:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39232 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404669AbfFKXJq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 19:09:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so12151600wrt.6
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2019 16:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CIifZCUue8/4Y/P1zH6Zg7Xsj8MwZXtqrWfo61KVM2k=;
        b=UQekfdeVS8lseMx9lOmMJne0plJNxlseJ6ZVLIBdjP+RGSEdPLrAJUYbk6MqcaT87t
         PsLyY4xtthRgo7BySrzvB8eNnqQSXaFqTt7qnO+LM310gAkELr/i79OyDDe7LT5Uu/zP
         0ZU9tPpnrLMYPu1ilAB4OKsj06O0KlHEsEe23k0Q3tU0V3zvtRv53v1PJbu4vW5n5aQt
         /qgvF1RdOyKdAbgpHzaqRyvEDPdCnqgGPf68lI7VWsnFfQ9Uva2uEtOY11bK116BYYbh
         Q4g/rKbi+XDy5yS20kiNcuSfhBU2Wxy0UUJysbffsW8brONF4qcR1ktD+nHvgZh7j71x
         Ge0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CIifZCUue8/4Y/P1zH6Zg7Xsj8MwZXtqrWfo61KVM2k=;
        b=bzb+UoIkAxNqfj3ruPCBONvceBqG0mtNYFHZzLxbUXYRB8bQIkWwytMIV/kJGMEOdS
         7eSCcGEu/bLLZEYA16WczwsNATaDNInY2oRNBbf07zr6N+o3bHaMfkROAnU/z+tCKS/C
         J5iAWpEG8l7eCJdehBCGki72ca/ZHcEHyCMHc76a+cn7CMRaEKmdoPEhNz3LU47KO1Kd
         nCWbUFGDv5J6kUBngW0yvNah8dANjMWwYi2aduUue8qa+f5SLVTAIuGmY634lOh4GBFV
         P9tGN1AFICtlyLYnqNq1R7RhBRAm87BKU9ZpdhQwR3egAQoX8fAvq9CLypMlviBSweTk
         wr/A==
X-Gm-Message-State: APjAAAV2aFNT9isJb0XZ/J6Yw1IVwZGW4JX1ajCJhsZQdPzpfXaFLIRB
        Y9L41lmgOms04B0W69P0v2zKkDfv3oKNNnXC
X-Google-Smtp-Source: APXvYqy2ZICWegZRq/M7vwxI0vGPqt8wZXAWAZRhiwspIBhnZ1W5JXcllgDG00Ywq4Ny1puUNOZtPQ==
X-Received: by 2002:adf:f508:: with SMTP id q8mr23904187wro.299.1560294583919;
        Tue, 11 Jun 2019 16:09:43 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:24bb:7f31:25fe:43a7])
        by smtp.gmail.com with ESMTPSA id g11sm10827813wrq.89.2019.06.11.16.09.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 16:09:42 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 0/7] crypto: rc4 cleanup
Date:   Wed, 12 Jun 2019 01:09:31 +0200
Message-Id: <20190611230938.19265-1-ard.biesheuvel@linaro.org>
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

Changes sinve v3:
- fix some remaining occurrences where a tfm non-NULL test should be replaced
  with a fips_enabled test
- use kzfree() or memzero_explicit() to clear the arc4 ctx where appropriate
- clean up the function naming of the crypto arc4 driver when removing the
  cipher part
- remove .h declaration of a function that is being removed
- revert a prior CIFS change that moved a variable from the stack to the heap,
  which is no longer necessary
- remove arc4 softdep from the cifs code

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
 crypto/arc4.c                      | 116 ++------------------
 drivers/net/ppp/Kconfig            |   3 +-
 drivers/net/ppp/ppp_mppe.c         |  97 +++-------------
 fs/cifs/Kconfig                    |   2 +-
 fs/cifs/cifsencrypt.c              |  62 +++--------
 fs/cifs/cifsfs.c                   |   1 -
 include/crypto/arc4.h              |  10 ++
 lib/Makefile                       |   2 +-
 lib/crypto/Makefile                |   4 +
 lib/crypto/arc4.c                  |  72 ++++++++++++
 net/mac80211/Kconfig               |   2 +-
 net/mac80211/cfg.c                 |   4 +-
 net/mac80211/ieee80211_i.h         |   4 +-
 net/mac80211/key.h                 |   1 +
 net/mac80211/main.c                |   6 +-
 net/mac80211/mlme.c                |   3 +-
 net/mac80211/tkip.c                |   8 +-
 net/mac80211/tkip.h                |   4 +-
 net/mac80211/wep.c                 |  49 ++-------
 net/mac80211/wep.h                 |   5 +-
 net/mac80211/wpa.c                 |   4 +-
 net/wireless/Kconfig               |   1 +
 net/wireless/lib80211_crypt_tkip.c |  48 +++-----
 net/wireless/lib80211_crypt_wep.c  |  51 +++------
 26 files changed, 195 insertions(+), 369 deletions(-)
 create mode 100644 lib/crypto/Makefile
 create mode 100644 lib/crypto/arc4.c

-- 
2.20.1

