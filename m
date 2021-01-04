Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6FCC43332
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 21:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 347062225E
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 21:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbhADV6y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 16:58:54 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:24532 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbhADV6x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 16:58:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1609797360;
        s=strato-dkim-0002; d=chronox.de;
        h=Message-ID:Date:Subject:Cc:To:From:From:Subject:Sender;
        bh=/l4AZil43hDxz8/ZZ/lKuvRDLAdZAYmH4XExlIK8Y+E=;
        b=JZ3fGD1KYRkIveLj67BfNCAmed5B7Dt/BwS5p8rfr2W7yWwTi/w6oFzjwl1IB3Ip8r
        lvjIc7M1sXNKDye7qI7zArKiSsRYg1DMGHG12JLXeH69pKBZy/fj1qWQhe8YtaZVADpC
        dWcYEubyLYPElPGIszhmc1PyIORwOV/wC3Jidvlo/C+OXsNJXErH8wtscoKts/K5kLaZ
        rp4J3Bov4SA8Wvhxib1FigMU1XhBb4x9W9qyl0VftsXq97X0a6dRk5dgWa9LDQIt8QEO
        EeOVPvj6r8GfdUdQslt7NHKRdg4tKcSofe6yw5usWVuBBk4mDVOO+vKxsCr8ncWkmG7z
        hz0g==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSZFqc="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.10.7 DYNA|AUTH)
        with ESMTPSA id h02bd9x04LqmxfO
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 4 Jan 2021 22:52:48 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        mathew.j.martineau@linux.intel.com, dhowells@redhat.com
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org
Subject: [PATCH 0/5] Add KDF implementations to crypto API
Date:   Mon, 04 Jan 2021 22:45:57 +0100
Message-ID: <4616980.31r3eYUQgx@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

The key derviation functions are considered to be a cryptographic
operation. As cryptographic operations are provided via the kernel
crypto API, this patch set consolidates the KDF implementations into the
crypto API.

The KDF implementations are provided as service functions. Yet, the
interface to the two provided KDFs are identical with the goal to allow
them to be transformed into a crypto API template eventually.

The KDFs execute a power-on self test with test vectors from commonly
known sources.

Tbe SP800-108 KDF implementation is used to replace the implementation
in the keys subsystem. The implementation was verified using the
keyutils command line test code provided in
tests/keyctl/dh_compute/valid. All tests show that the expected values
are calculated with the new code.

The HKDF addition is used to replace the implementation in the filesystem
crypto extension. This code was tested by using an EXT4 encrypted file
system that was created and contains files written to by the current
implementation. Using the new implementation a successful read of the
existing files was possible and new files / directories were created
and read successfully. These newly added file system objects could be
successfully read using the current code. Yet if there is a test suite
to validate whether the invokcation of the HKDF calculates the same
result as the existing implementation, I would be happy to validate
the implementation accordingly.

Stephan Mueller (5):
  crypto: Add key derivation self-test support code
  crypto: add SP800-108 counter key derivation function
  crypto: add RFC5869 HKDF
  security: DH - use KDF implementation from crypto API
  fs: use HKDF implementation from kernel crypto API

 crypto/Kconfig                         |  14 ++
 crypto/Makefile                        |   6 +
 crypto/hkdf.c                          | 226 +++++++++++++++++++++++++
 crypto/kdf_sp800108.c                  | 149 ++++++++++++++++
 fs/crypto/Kconfig                      |   2 +-
 fs/crypto/fscrypt_private.h            |   4 +-
 fs/crypto/hkdf.c                       | 108 +++---------
 include/crypto/hkdf.h                  |  48 ++++++
 include/crypto/internal/kdf_selftest.h |  68 ++++++++
 include/crypto/kdf_sp800108.h          |  59 +++++++
 security/keys/Kconfig                  |   2 +-
 security/keys/dh.c                     | 118 ++-----------
 12 files changed, 617 insertions(+), 187 deletions(-)
 create mode 100644 crypto/hkdf.c
 create mode 100644 crypto/kdf_sp800108.c
 create mode 100644 include/crypto/hkdf.h
 create mode 100644 include/crypto/internal/kdf_selftest.h
 create mode 100644 include/crypto/kdf_sp800108.h

-- 
2.26.2




