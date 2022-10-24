Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB5CC3A59D
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Oct 2022 06:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiJXGb0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Oct 2022 02:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiJXGbS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Oct 2022 02:31:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028BD5B7AC
        for <linux-crypto@vger.kernel.org>; Sun, 23 Oct 2022 23:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C026B80ED7
        for <linux-crypto@vger.kernel.org>; Mon, 24 Oct 2022 06:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBB2C433D6;
        Mon, 24 Oct 2022 06:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666593074;
        bh=tzliwd919YHPSnBymIAw8/q1/Fe8hN6NNMU9NT0KVHw=;
        h=From:To:Cc:Subject:Date:From;
        b=iLv5l/jrr3NirxqrLE6YZQ4OQIiFJQwWfrVKiQdA32lvy0BqAkTTaMd0j1mWEEeEm
         gY9TDdoeQmNFMv7TWbEiHjWaBwUuEi2SvCvKfQbfxnPucJFBwFn5kXocYFfxZdvdnu
         Hd/p3fsbjqITM6R9jkrixc+XztqDz9qk+KbW715yR1rqg5nqLkRPfJr1XmCwsbXVTw
         G7DmykVnfjO4GEYt+sSGWFuJNVuZH/Rpc05CPRSq3tLoEv4WYowqVlB+fO+VYpzTeF
         0CGD/sTq9YLWjrbLHXYIckYQYF4IMiUDqhJztrcZfTXHB+UlI2t5V21uEJqqKbUO86
         jzINT95yUyG1g==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        keescook@chromium.org, jason@zx2c4.com, nikunj@amd.com,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v4 0/3] crypto: Add AES-GCM implementation to lib/crypto
Date:   Mon, 24 Oct 2022 08:30:49 +0200
Message-Id: <20221024063052.109148-1-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2081; i=ardb@kernel.org; h=from:subject; bh=tzliwd919YHPSnBymIAw8/q1/Fe8hN6NNMU9NT0KVHw=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjVjEWM0G1Wh0RijfOgvjltPKAPfwxoXL2rhkQ2h75 JFJh5siJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY1YxFgAKCRDDTyI5ktmPJE1DDA CwH2c2EENwhW0wiDBx/BpplPNimxVsAjW3AoO/fwPB0J5CDq/KH8wFQZoGz2o5kF1zIqL8ZaaCkVMW 7qUNJle/jEdpL8NAqyN6uRHMKHIEIT73XIltRnXUB6vAoHfcd6Mdpcz3ENPBOXz++5GaEiCHZGZg4j C4ucTTROzrFkjzWiXIy3VaucaUdLW044mvlbAMtrtG3TBTIneTWR4U+1K7BmSJ82WSZcgGMZHSgMtd Z0d/O9rHmO1KXNZwieWO0+RpM2RXNuITfkj3QBP2x1ZCs+pn0sKiCBzXFRSwQAR1sVSYUpVKmyzPuK 3S6AcGgbaRc66dh3zp+/EDn/vhXItiIILaFLTeNRt5IMl9W9RV3jqtlWYLdUJfKOwcZTKnfm3qeBPQ 7X0xNOwj0Z6+/QtsQfRkUehMrOcpSdoc8BU4yj4BmlyjBq8F4V+hoqtzmVfuC7h+yOildjRI24YlVx wao2e69HFXBE4kQ5uNBwvNz9XaRzlgbfiD0DEf/+Nf0DY=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Provide a generic library implementation of AES-GCM which can be used
really early during boot, e.g., to communicate with the security
coprocessor on SEV-SNP virtual machines to bring up secondary cores.
This is needed because the crypto API is not available yet this early.

We cannot rely on special instructions for AES or polynomial
multiplication, which are arch specific and rely on in-kernel SIMD
infrastructure. Instead, add a generic C implementation that combines
the existing C implementations of AES and multiplication in GF(2^128).

To reduce the risk of forgery attacks, replace data dependent table
lookups and conditional branches in the used gf128mul routine with
constant-time equivalents. The AES library has already been robustified
to some extent to prevent known-plaintext timing attacks on the key, but
we call it with interrupts disabled to make it a bit more robust. (Note
that in SEV-SNP context, the VMM is untrusted, and is able to inject
interrupts arbitrarily, and potentially maliciously.)

Changes since v3:
- rename GCM-AES to AES-GCM

Changes since v2:
- move gf128mul to lib/crypto
- add patch #2 to make gf128mul_lle constant time
- fix kerneldoc headers and drop them from the .h file

Changes since v1:
- rename gcm to gcmaes to reflect that GCM is also used in
  combination with other symmetric ciphers (Jason)
- add Nikunj's Tested-by

Ard Biesheuvel (3):
  crypto: move gf128mul library into lib/crypto
  crypto: gf128mul - make gf128mul_lle time invariant
  crypto: aesgcm - Provide minimal library implementation

 crypto/Kconfig                    |   3 -
 crypto/Makefile                   |   1 -
 include/crypto/gcm.h              |  22 +
 lib/crypto/Kconfig                |   9 +
 lib/crypto/Makefile               |   5 +
 lib/crypto/aesgcm.c               | 720 ++++++++++++++++++++
 {crypto => lib/crypto}/gf128mul.c |  58 +-
 7 files changed, 795 insertions(+), 23 deletions(-)
 create mode 100644 lib/crypto/aesgcm.c
 rename {crypto => lib/crypto}/gf128mul.c (87%)

-- 
2.35.1

