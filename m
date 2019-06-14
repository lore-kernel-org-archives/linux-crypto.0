Return-Path: <SRS0=me0G=UN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D02C31E44
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 08:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88C0F20851
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 08:34:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VDlIoKjD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfFNIeQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jun 2019 04:34:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33010 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfFNIeQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jun 2019 04:34:16 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so1600541wru.0
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jun 2019 01:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KGNNNzf8+V4gcSsgJqG+Sqt0bdCaLfKR6RNoaXC4yng=;
        b=VDlIoKjDWplzV0xMtfAEbTs/7yFuWHGvpOXh4T7FYLn8gsA6OjpLiP++sgjRpijrE0
         ITQJU9q3MKXMh2P0IfgQnTh406jzcorT2SdhjhvPwBczuleqSdnbUQqtH583dvD7cPJ6
         XJcjWsNk/7D/I9jV24eXvfxPOYzkiKxnQCXfghxsTimGZ6zAYYH8HpQ6aq3iGHdK1VjA
         aWL3WmXNtWbpfviUKpyDEzoQEoK4ioYWXEqoYUUcqEi1p7o/13p+AB3WjtONaPndWodr
         LV3objicYhCy2716CytwLGFSQplIWuL05NeW3wx1qN7Y/qSspi0/pdz2QdFHTm+nGKxZ
         10Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KGNNNzf8+V4gcSsgJqG+Sqt0bdCaLfKR6RNoaXC4yng=;
        b=oSFkTqiYQcF2fiI2ai+36IAW/x+VCAs8sZGtGDLbwgGjgxOOqdz2NpnqEvHwndMk7r
         EK05M/0v7mkrRGKY1BBfrf1DoRy7i9Pk8lKOO3IEA6RLHX+8szwxsEPDXVr4bm22ZqFa
         7lQfkkZI8MWTMy7adzJ2fXKIjJF8239xvDq+XVEDLUMnKr4wf+9wwX9kGpbHnqtkiaKA
         McLNtCza7LgAUi9+q2q5i7guOrqLNJmquXDK8PiBpcG/jKBcIqyKY0u5wsMV49+egzOZ
         odLON/lHq09sBRI0WW9ffor8J89gRhBkDJISJ9Sz2OPZbtRe2csjA0HZkUuBNmfrDsHZ
         Q9Vg==
X-Gm-Message-State: APjAAAUdz1oyZupKGUMTEYa0XxqL4FYqGNxeHj/My5/z75LMrjFZDpdp
        sGHk1JJQ0BwYy5Z3DU9xd50tMNT8swmHWw==
X-Google-Smtp-Source: APXvYqxWUvow4Lwp9068/G4kSu+gmAyOba4MAe3/EkseljS3T36Jm80gs2Rj8WZpsHG4UEE706Yzkw==
X-Received: by 2002:adf:dc0c:: with SMTP id t12mr63159958wri.101.1560501253588;
        Fri, 14 Jun 2019 01:34:13 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:8d0e:a5b1:c005:e3b5])
        by smtp.gmail.com with ESMTPSA id f3sm1710802wre.93.2019.06.14.01.34.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 01:34:12 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>
Subject: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
Date:   Fri, 14 Jun 2019 10:34:01 +0200
Message-Id: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series is presented as an RFC for a couple of reasons:
- it is only build tested
- it is unclear whether this is the right way to move away from the use of
  bare ciphers in non-crypto code
- we haven't really discussed whether moving away from the use of bare ciphers
  in non-crypto code is a goal we agree on

This series creates an ESSIV shash template that takes a (cipher,hash) tuple,
where the digest size of the hash must be a valid key length for the cipher.
The setkey() operation takes the hash of the input key, and sets into the
cipher as the encryption key. Digest operations accept input up to the
block size of the cipher, and perform a single block encryption operation to
produce the ESSIV output.

This matches what both users of ESSIV in the kernel do, and so it is proposed
as a replacement for those, in patches #2 and #3.

As for the discussion: the code is untested, so it is presented for discussion
only. I'd like to understand whether we agree that phasing out the bare cipher
interface from non-crypto code is a good idea, and whether this approach is
suitable for fscrypt and dm-crypt.

Remaining work:
- wiring up some essiv(x,y) combinations into the testing framework. I wonder
  if anything other than essiv(aes,sha256) makes sense.
- testing - suggestions welcome on existing testing frameworks for dm-crypt
  and/or fscrypt

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@google.com>

Ard Biesheuvel (3):
  crypto: essiv - create a new shash template for IV generation
  dm crypt: switch to essiv shash
  fscrypt: switch to ESSIV shash

 crypto/Kconfig              |   3 +
 crypto/Makefile             |   1 +
 crypto/essiv.c              | 275 ++++++++++++++++++++
 drivers/md/Kconfig          |   1 +
 drivers/md/dm-crypt.c       | 137 ++--------
 fs/crypto/Kconfig           |   1 +
 fs/crypto/crypto.c          |  11 +-
 fs/crypto/fscrypt_private.h |   4 +-
 fs/crypto/keyinfo.c         |  64 +----
 9 files changed, 321 insertions(+), 176 deletions(-)
 create mode 100644 crypto/essiv.c

-- 
2.20.1

