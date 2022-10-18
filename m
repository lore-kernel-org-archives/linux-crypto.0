Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F2AC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Oct 2022 20:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJRUEs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiJRUEq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2022 16:04:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F6D233A4
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 13:04:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E104360907
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 20:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3521C433D7;
        Tue, 18 Oct 2022 20:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666123476;
        bh=IU8uOJBpcajplBXvuhJ5zjigswgXq88RP+KIQCgSKmY=;
        h=From:To:Cc:Subject:Date:From;
        b=s0Wcs0WUkUlLywConFTQa0wChAviMQ5SYUFEEiMLlCafuhIEcSxutugR/jwnE0VeA
         IoZ4kiD5Dn19dE6Cb17p9vdWir9RTB/ke0+mU93EGPzuL2klT/Ur+gtwNDOiw1iiO8
         Xgh5hFyKCqBSvLjeBaF7yKgx0hwnXwQ+LVWWwk6u9szld1WOoHYyM48u6DL2MGHyWs
         9Wx/u45s3myMFFV/ZtdC7/iI1B3uLy+KjsviNv6YeoS3bEtY2+bbCSZspsbheRN/Rb
         u2/8oURSJ0LAxM5BIkaREmYseQ/Y5qEO6hK2+Zheak8BYErFVpKL5WKpvcUGj2yVAx
         pNKLwdUW1VIVQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     keescook@chromium.org, ebiggers@kernel.org, jason@zx2c4.com,
        herbert@gondor.apana.org.au, nikunj@amd.com,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v3 0/3] crypto: Add GCM-AES implementation to lib/crypto
Date:   Tue, 18 Oct 2022 22:04:19 +0200
Message-Id: <20221018200422.179372-1-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2084; i=ardb@kernel.org; h=from:subject; bh=IU8uOJBpcajplBXvuhJ5zjigswgXq88RP+KIQCgSKmY=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjTwbAcCkEAvmd15SYKK9MLXWxfBTMzDtEI/YcLat8 xFqi+8eJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY08GwAAKCRDDTyI5ktmPJIUFC/ wMmzvFnpB9sEHgjk0rqGkAmvQFTooCdl+qOO7TBzQ27zcGqoL902pMswJYkm22NH2iW4pOxqBKB90F 5Ufj/1/Q09pudnBgz58HKkzKvaMeSc44M1C+neCBX/lnuPy50gXvVMSGLZDooMeUvE78W23I7fQHHF QzuaOzPRs8uKQ57tz0/LKNjqjZzREFQ/Qo8FTT4tu/ArfV8R1T4r1nf72Y+XRVj+iI29KTFZ+fmMQI V1rx3yBKzkFfLPZRbRb2N6IjCr0NUejF7cwdi5eRAARLsZjrHwee0D2bTy4wF/Sm/YOJ5oZN6sXhDO on66LtZGcmX8yAnkjjHUTuQJrKK8BIhctaDZztXzJGH4aybh5RmOeuxQqQ9ZqQuBnFuolWQFXzz1Df qN6URB0Le15sUCi9kxyI2bSlDVdzZHKZbwnT/8Hz9I+5AUFfSPuYcRS/iu3EE1rgmEQV5rKH76I9GY p52dVyl85g9eSqLsGtAUdR1AIFhwnKChyRKoIrMHEygB4=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Provide a generic library implementation of GCM-AES which can be used
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
  crypto: gcmaes - Provide minimal library implementation

 arch/x86/crypto/aesni-intel_glue.c |  24 +-
 crypto/Kconfig                     |   3 -
 crypto/Makefile                    |   1 -
 include/crypto/gcm.h               |  22 +
 lib/crypto/Kconfig                 |   9 +
 lib/crypto/Makefile                |   5 +
 lib/crypto/gcmaes.c                | 720 ++++++++++++++++++++
 {crypto => lib/crypto}/gf128mul.c  |  58 +-
 8 files changed, 807 insertions(+), 35 deletions(-)
 create mode 100644 lib/crypto/gcmaes.c
 rename {crypto => lib/crypto}/gf128mul.c (87%)

-- 
2.35.1

