Return-Path: <SRS0=juXm=2K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6A6C43603
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 19:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7EFB206D8
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 19:02:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMzmETQy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfLTTC7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Dec 2019 14:02:59 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:52768 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfLTTC7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Dec 2019 14:02:59 -0500
Received: by mail-pj1-f68.google.com with SMTP id w23so4503048pjd.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2019 11:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sZ8GJcI5gw0BSj7DivaJsECpSKPvi+CxzdHaD1P8e7o=;
        b=eMzmETQyac1PI4SBZcmVlOEjNfEi8LRQ9zVT2V9tWfH8PGEnXvCeEk564YN5ip0ScX
         Tpnp2YyKcUgMfsljZxUjwuuILwNSzq4Th7x/EJUorZWfcgxNVWb/5OsjeYAspAXKh3i0
         VpAZ4QyrP8e+7wtz/9YFkJFStvstgdS647AucQQkLvatCfeT75orYLQQ0E5sI0SUfL+L
         ZE/uLk6kfPTbU5uMM5rFv+x4xx6ol5IWMF7Pxlkgy+I1iiRzXg1HByKnhoPA0NCYCg2C
         ei66zIZzfF+YGXvn0nNblD5SmU+DwqTyoSHSFoJDXW89IcOx9dU0RwhHN0GrsdcRhtdb
         7BgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sZ8GJcI5gw0BSj7DivaJsECpSKPvi+CxzdHaD1P8e7o=;
        b=dVP5nm5ms//LqYoiPrseeAwdxynPwQg8JJxSnx+nR2U3dh4KiAcEoVWxZXYw1IkU70
         ZU985wr0dQBPX/1soFlhJgSoe8pCf/WtEzwtWXQYBQrrnD+Yf4y2fUGb3J50w/hISg/n
         qCGWLY0L8R8P63hyFPoypLGbRt5DlebHGbrv6erIKxJMitOVafv+EifIF3RurlyoIpJG
         PU0NxHV2WCapX1FdFJ/gAqtk1RYWtwx8x4DwM4Fv6v+0jjCkMf4LByBZUokoIMPMdyvw
         oB39ErHb/6pKytNJfcHp3bx22lojamauEx3/Gomsbe6l6bzbmR6gTX06tR6rO9+DMbbb
         drXw==
X-Gm-Message-State: APjAAAU38tclHjZOM4l9bXwjelnte6dTuyyRA9KP9uzyBL+Q9hBKUypT
        r6tC7fyq8Ec98C0vIGeAtXM=
X-Google-Smtp-Source: APXvYqwcBdeSYg3ZGeiyG9Y7aS8aeo2MqdFfM33llWZ7LzgCBC49wW/LhCMZ1RWjkbIp0jyc0wIR1w==
X-Received: by 2002:a17:90a:d34c:: with SMTP id i12mr3800529pjx.18.1576868578029;
        Fri, 20 Dec 2019 11:02:58 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id i4sm10833612pjw.28.2019.12.20.11.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 11:02:57 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: Subject: [PATCH 0/6] crypto: QCE hw-crypto fixes
Date:   Fri, 20 Dec 2019 16:02:12 -0300
Message-Id: <20191220190218.28884-1-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I've been trying to make the Qualcomm Crypto Engine work with GCM-mode
AES.  I fixed some bugs, and added an option to build only hashes or
skciphers, as the VPN performance increases if you leave some of that to
the CPU.

A discussion about this can be found here:
https://github.com/openwrt/openwrt/pull/2518

I'm using openwrt to test this, and there's no support for kernel 5.x
yet.  So I have backported the recent skcipher updates, and tested this
with 4.19. I don't have the hardware with me, but I have run-tested
everything, working remotely.

All of the skciphers directly implemented by the driver work.  They pass
the tcrypt tests, and also some tests from userspace using AF_ALG:
https://github.com/cotequeiroz/afalg_tests

However, I can't get gcm(aes) to work.  When setting the gcm-mode key,
it sets the ctr(aes) key, then encrypt a block of zeroes, and uses that
as the ghash key.  The driver fails to perform that encryption.  I've
dumped the input and output data, and they apparently are not touched by
the QCE.  The IV, which written to a buffer appended to the results sg
list gets updated, but the results themselves are not.  I'm not sure
what goes wrong, if it is a DMA/cache problem, memory alignment, or
whatever.

If I take 'be128 hash' out of the 'data' struct, and kzalloc them
separately in crypto_gcm_setkey (crypto/gcm.c), it encrypts the data
just fine--perhaps the payload and the request struct can't be in the
same page?

However, it still fails during decryption of the very first tcrypt test
vector (I'm testing with the AF_ALG program, using the same vectors as
the kernel), in the final encryption to compute the authentication tag,
in the same fashion as it did in 'crypto_gcm_setkey'.  What this case
has in common with the ghash key above is the input data, a single block
of zeroes, so this may be a hardware bug.  However, if I perform the
same encryption using the AF_ALG test, it completes OK.

I am not experienced enough with the Linux Kernel, or with the ARM
architecture to wrap this up on my own, so I need some pointers to what
to try next.

To come up a working setup, I am passing any AES requests whose length
is less than or equal to one AES block to the fallback skcipher.  This
hack is not a part of this series, but I can send it if there's any
interest in it.

Anyway, the patches in this series are complete enough on their own.
With the exception of the last patch, they're all bugfixes.

Cheers,

Eneas

Eneas U de Queiroz (6):
  crypto: qce - fix ctr-aes-qce block, chunk sizes
  crypto: qce - fix xts-aes-qce key sizes
  crypto: qce - save a sg table slot for result buf
  crypto: qce - update the skcipher IV
  crypto: qce - initialize fallback only for AES
  crypto: qce - allow building only hashes/ciphers

 drivers/crypto/Kconfig        |  63 ++++++++-
 drivers/crypto/qce/Makefile   |   7 +-
 drivers/crypto/qce/common.c   | 244 ++++++++++++++++++----------------
 drivers/crypto/qce/core.c     |   4 +
 drivers/crypto/qce/dma.c      |   6 +-
 drivers/crypto/qce/dma.h      |   3 +-
 drivers/crypto/qce/skcipher.c |  41 ++++--
 7 files changed, 229 insertions(+), 139 deletions(-)

