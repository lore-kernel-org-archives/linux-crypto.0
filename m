Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A279FC31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 16:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 722AF2082C
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 16:20:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BA7paCSA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbfFLQUH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 12:20:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35027 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729732AbfFLQUH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 12:20:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id m3so17622682wrv.2
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 09:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mZ2sshoBdgjTADqyqImsuvrAqHjRWCvMbRsB/RYLrtM=;
        b=BA7paCSA1mzyqzC38Zlr3tYarqND6Jcqz+jzFSsrKIn4il9ahcoyl5JRHo/m+gj4/z
         clrBO1N1AKIYFfZ0DMWgJu+qODW158Ukk6syfCHZqljajHuP65atttBIIPcSL0t1TM3M
         +2IDZxj3NHfiaKlQrQFj5KxC149VSI6e4y9Wd6oOYV4MJqFAAszok/Wg1HLsbDr7Hkeh
         yCjzWJSr4h/+809ep25U0MWClNzkFA5VpZ/3hAjWASVju0R+srthyW6x0zQJeOA6MSas
         XWaUzHUAAMX75Vose/8JOh0sRpfjYd4V5Y+9/Nz3JzrdOfa/w2T1xxsohkBqiOOck8jj
         ENCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mZ2sshoBdgjTADqyqImsuvrAqHjRWCvMbRsB/RYLrtM=;
        b=t2jaj8AeT+jXmpcEy1SNjd5N1j8xS2tW8bV1qKEbcms857vX59V8eXc6PEdsFQc9x0
         vhcPFVJk71XMFWCvxvxqSJgWyHfTDpHOepZ2lHscZ51Ng5Z5d9iGbomgDmEjoXx6OJE8
         eASvqEKE0A9gB2b0J8iVSYCHihhXaf8V10W3z2Vrxo2F8fc+ulEQBbiKGsPLlPIsfUb5
         9JXnpVzUSoTj/o5hnc4eSivlt2Y6wg1Ogp1RYgEqqqbfLKCJd2WJeiajVmuQAz7navg1
         e4eMrTuBPySUqLJpLk9bUg3HVr3JM9zpwuEayQ4vxn9Vxma2Q2smL4ASrwVOcEUaI9DZ
         pmiA==
X-Gm-Message-State: APjAAAWSO+o+t40PkvgshBfj7ATYI4+4hFaxCUErJZzq4KuN3KzEo0zt
        m0hr3pN3d7Cvxe/cXBIj9GrFGMztW+o2KA==
X-Google-Smtp-Source: APXvYqyOpCxY8NJwg20r8/mJ4sEzrk90cpyQDQHrq9QOtCAtMMbGUtBrAXnusVM725EYhiP5RAi9pA==
X-Received: by 2002:a5d:694a:: with SMTP id r10mr33440646wrw.345.1560356404599;
        Wed, 12 Jun 2019 09:20:04 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id c16sm70172wrr.53.2019.06.12.09.20.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 09:20:03 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v5 0/7] crypto: rc4 cleanup
Date:   Wed, 12 Jun 2019 18:19:52 +0200
Message-Id: <20190612161959.30478-1-ard.biesheuvel@linaro.org>
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

Changes since v4:
- add a missing MODULE_LICENSE() for the new libarc4 module
- add a missing 'select CRYPTO_LIB_ARC4' to the lib80211-tkip patch
- some cosmetic changes for the skcipher driver after removing the cipher code
- a testmgr fix to ensure that the test framework understands that this skcipher
  driver is the reference for testing ecb(arc4)

Changes since v3:
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
 crypto/arc4.c                      | 124 +++-----------------
 crypto/testmgr.c                   |   1 +
 drivers/net/ppp/Kconfig            |   3 +-
 drivers/net/ppp/ppp_mppe.c         |  97 +++------------
 fs/cifs/Kconfig                    |   2 +-
 fs/cifs/cifsencrypt.c              |  62 +++-------
 fs/cifs/cifsfs.c                   |   1 -
 include/crypto/arc4.h              |  10 ++
 lib/Makefile                       |   2 +-
 lib/crypto/Makefile                |   4 +
 lib/crypto/arc4.c                  |  74 ++++++++++++
 net/mac80211/Kconfig               |   2 +-
 net/mac80211/cfg.c                 |   4 +-
 net/mac80211/ieee80211_i.h         |   4 +-
 net/mac80211/key.h                 |   1 +
 net/mac80211/main.c                |   6 +-
 net/mac80211/mlme.c                |   3 +-
 net/mac80211/tkip.c                |   8 +-
 net/mac80211/tkip.h                |   4 +-
 net/mac80211/wep.c                 |  49 ++------
 net/mac80211/wep.h                 |   5 +-
 net/mac80211/wpa.c                 |   4 +-
 net/wireless/Kconfig               |   2 +
 net/wireless/lib80211_crypt_tkip.c |  48 +++-----
 net/wireless/lib80211_crypt_wep.c  |  51 ++------
 27 files changed, 205 insertions(+), 371 deletions(-)
 create mode 100644 lib/crypto/Makefile
 create mode 100644 lib/crypto/arc4.c

-- 
2.20.1

