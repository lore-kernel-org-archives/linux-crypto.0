Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0A9C31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 14:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB34320679
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 14:53:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nFZeAGDh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfHLOxl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 10:53:41 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39995 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfHLOxl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 10:53:41 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so12039221wmj.5
        for <linux-crypto@vger.kernel.org>; Mon, 12 Aug 2019 07:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=E/iJgOe1+kHrTZkg6t1LtxFkxOFOrmmNA7lNv6Yq4sY=;
        b=nFZeAGDhDtTlyI9xCJJy0yK7E9fYUG4hVcFkeA+obzFvwRHdfb6glnILFHoujsUdgv
         gHp3QMjIt7CyXy998ZHCwoT1q8l9cUB7w5RSkpDrPii4PV8EJ7xxDeQFQJQos0eqN4Lb
         VW5UvRe6wYWux6KG0gjvi9b3bYh3XOwgIh66/g7NXvO6YSNnccCRL0CyRuqy8xta5Bko
         CDDVajsO7gG3hK1r2DhRjaBo5Y307VuumorZGb7vdFAS70dPWqsTIbq46qx/z/meYYXL
         fdKxpERdeZo9xIt2sbsR0RexlO8YXmC2/3PtjBnjJOnvO8cEMzdPEpfMoOzD/rx3IX2U
         68Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=E/iJgOe1+kHrTZkg6t1LtxFkxOFOrmmNA7lNv6Yq4sY=;
        b=D+VkKY2DGFWCp8ayiiuvkkmQbqHwKXQTvWLfua7+mC5chsvLraDyIk7KkngFeGNEs3
         BfmiMWX4HeanoS1SUg2NIq7nivraRYQNtLgvf1fuH+mnzJxn3v+DvN5INQqIRjOQSw7m
         Ok4DeAgHk1h3ReXoWZp9E8uyhK4BzusSwf8d4W+a25MMuswiq/kqK7gtlcPwsiz9LEgQ
         r02bFGGhIsyXqXxzlUOg2Ky3l8fy7QKCUdTUKVaDvkDMGUtap2OD/5RHvQo6RZXKjV/e
         EaHRODUF80FFXI225e4XbCWhZj3eyGEuUG7/j7Qffvu6Or6aQushPBs0O+pPPbVrdH5o
         v/bQ==
X-Gm-Message-State: APjAAAXAo6+YVEAjuCPJkmFshrRqr/5bAysimh/kNgNQ0RwGMq8matpp
        h9v6HYtE/EyigGLi4bS6XRmuccy9GRLiYg==
X-Google-Smtp-Source: APXvYqwzxccOULCOzsbtYaOb/0tj929yv3DAml5xznqhiyfL16z+Ux8YtFvmxXpCsIsVnkiLC5aKFg==
X-Received: by 2002:a1c:2015:: with SMTP id g21mr27621200wmg.33.1565621618996;
        Mon, 12 Aug 2019 07:53:38 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:1c0e:f938:89a1:8e17])
        by smtp.gmail.com with ESMTPSA id k13sm23369190wro.97.2019.08.12.07.53.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 07:53:37 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v10 0/7] crypto: switch to crypto API for ESSIV generation
Date:   Mon, 12 Aug 2019 17:53:17 +0300
Message-Id: <20190812145324.27090-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series creates an ESSIV template that produces a skcipher or AEAD
transform based on a tuple of the form '<skcipher>,<shash>' (or '<aead>,<shash>'
for the AEAD case). It exposes the encapsulated sync or async skcipher/aead by
passing through all operations, while using the cipher/shash pair to transform
the input IV into an ESSIV output IV.

This matches what both users of ESSIV in the kernel do, and so it is proposed
as a replacement for those, in patches #2 and #3.

Changes since v9:
- Fix cipher_api parsing bug that was introduced by dropping the cipher name
  parsing patch in v9 (#3). Thanks to Milan for finding it.
- Fix a couple of instances where the old essiv(x,y,z) format was used in
  comments instead of the essiv(x,z) format we adopted in v9

Changes since v8:
- Remove 'cipher' argument from essiv() template, and instead, parse the
  cra_name of the skcipher to obtain the cipher. This is slightly cleaner
  than what dm-crypt currently does, since we can get the cra_name from the
  spawn, and we don't have to actually allocate the TFM. Since this implies
  that dm-crypt does not need to provide the cipher, we can drop the parsing
  code from it entirely (assuming the eboiv patch I sent out recently is
  applied first) (patch #7)
- Restrict the essiv() AEAD instantiation to AEADs whose cra_name starts with
  'authenc('
- Rebase onto cryptodev/master
- Drop dm-crypt to reorder/refactor cipher name parsing, since it was wrong
  and it is no longer needed.
- Drop Milan's R-b since the code has changed
- Fix bug in accelerated arm64 implementation.

Changes since v7:
- rebase onto cryptodev/master
- drop change to ivsize in #2
- add Milan's R-b's

Changes since v6:
- make CRYPTO_ESSIV user selectable so we can opt out of selecting it even
  if FS_ENCRYPTION (which cannot be built as a module) is enabled
- move a comment along with the code it referred to (#3), not that this change
  and removing some redundant braces makes the diff look totally different
- add Milan's R-b to #3 and #4

Changes since v5:
- drop redundant #includes and drop some unneeded braces (#2)
- add test case for essiv(authenc(hmac(sha256),cbc(aes)),aes,sha256)
- make ESSIV driver deal with assoc data that is described by more than two
  scatterlist entries - this only happens when the extended tests are being
  performed, so don't optimize for it
- clarify that both fscrypt and dm-crypt only use ESSIV in special cases (#7)

Changes since v4:
- make the ESSIV template IV size equal the IV size of the encapsulated
  cipher - defining it as 8 bytes was needlessly restrictive, and also
  complicated the code for no reason
- add a missing kfree() spotted by Smatch
- add additional algo length name checks when constructing the essiv()
  cipher name
- reinstate the 'essiv' IV generation implementation in dm-crypt, but
  make its generation function identical to plain64le (and drop the other
  methods)
- fix a bug in the arm64 CE/NEON code
- simplify the arm64 code by reusing more of the existing CBC implementation
  (patch #6 is new to this series and was added for this reason)

Changes since v3:
- address various review comments from Eric on patch #1
- use Kconfig's 'imply' instead of 'select' to permit CRYPTO_ESSIV to be
  enabled as a module or disabled entirely even if fscrypt is compiled in (#2)
- fix an issue in the AEAD encrypt path caused by the IV being clobbered by
  the inner skcipher before the hmac was being calculated

Changes since v2:
- fixed a couple of bugs that snuck in after I'd done the bulk of my
  testing
- some cosmetic tweaks to the ESSIV template skcipher setkey function
  to align it with the aead one
- add a test case for essiv(cbc(aes),aes,sha256)
- add an accelerated implementation for arm64 that combines the IV
  derivation and the actual en/decryption in a single asm routine

Code can be found here
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=essiv-v10

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@google.com>
Cc: dm-devel@redhat.com
Cc: linux-fscrypt@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Milan Broz <gmazyland@gmail.com>

Ard Biesheuvel (7):
  crypto: essiv - create wrapper template for ESSIV generation
  fs: crypto: invoke crypto API for ESSIV handling
  md: dm-crypt: switch to ESSIV crypto API template
  crypto: essiv - add tests for essiv in cbc(aes)+sha256 mode
  crypto: arm64/aes-cts-cbc - factor out CBC en/decryption of a walk
  crypto: arm64/aes - implement accelerated ESSIV/CBC mode
  md: dm-crypt: omit parsing of the encapsulated cipher

 arch/arm64/crypto/aes-glue.c  | 205 ++++--
 arch/arm64/crypto/aes-modes.S |  28 +
 crypto/Kconfig                |  28 +
 crypto/Makefile               |   1 +
 crypto/essiv.c                | 665 ++++++++++++++++++++
 crypto/tcrypt.c               |   9 +
 crypto/testmgr.c              |  14 +
 crypto/testmgr.h              | 497 +++++++++++++++
 drivers/md/Kconfig            |   1 +
 drivers/md/dm-crypt.c         | 271 ++------
 fs/crypto/Kconfig             |   1 +
 fs/crypto/crypto.c            |   5 -
 fs/crypto/fscrypt_private.h   |   9 -
 fs/crypto/keyinfo.c           |  92 +--
 14 files changed, 1453 insertions(+), 373 deletions(-)
 create mode 100644 crypto/essiv.c

-- 
2.17.1

