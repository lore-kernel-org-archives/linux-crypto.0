Return-Path: <SRS0=sxdd=YF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CEB7C4360C
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 04:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3233D21929
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 04:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570855268;
	bh=ip7Nb00jzBWztmBph7CZwtdVG3BuzLMxefuhK/GHeoY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=hvN/UQcncl6z8LLvKgHrTbxRvf54ogIgfwTKFgZCXp6pGbCcQHfvq4ye8ILRgGZHk
	 GM24xLbzpLVXzUYgBqtN3VBqYQvNQ815FMS0dKj9fOSQ1AglcGnxzect6M5zCQNIyd
	 XG6fCuqgVXQMkA4DaeMwX2tfnJhAk2AU/V/k1/Ig=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfJLElH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Oct 2019 00:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfJLElH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Oct 2019 00:41:07 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8473A206CD;
        Sat, 12 Oct 2019 04:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570855266;
        bh=ip7Nb00jzBWztmBph7CZwtdVG3BuzLMxefuhK/GHeoY=;
        h=From:To:Cc:Subject:Date:From;
        b=onVLMtLVYyIQiicnnvXyDSo7MIXJk0N6vgDh3UrvyUUmxBklUGW35XncqLNlq7Q24
         V6wfS6zlvB/V+dnw+vajsZyVhSEwqTZfMuIxqNOqmrfXgD9jFH9RK7fCzd6xJAs953
         gH3ta8E8H4bf7ZpQRAUe6bPlpA24uXTeU2ttmwkU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     sparclinux@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [RFT PATCH 0/3] crypto: sparc - convert to skcipher API
Date:   Fri, 11 Oct 2019 21:38:47 -0700
Message-Id: <20191012043850.340957-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series converts the glue code for the SPARC64 crypto opcodes
implementations of AES, Camellia, DES, and 3DES modes from the
deprecated "blkcipher" API to the "skcipher" API.  This is needed in
order for the blkcipher API to be removed.

I've compiled this patchset, and the conversion is very similar to that
which has been done for many other crypto drivers.  But I don't have the
hardware to test it, nor are SPARC64 crypto opcodes supported by QEMU.
So I really need someone with the hardware to test it.  You can do so by
setting:

CONFIG_CRYPTO_AES_SPARC64=y
CONFIG_CRYPTO_CAMELLIA_SPARC64=y
CONFIG_CRYPTO_DES_SPARC64=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_ECB=y

Then boot and check for crypto self-test failures by running
'dmesg | grep alg'.

If there are test failures, please also check whether they were already
failing prior to this patchset.

Eric Biggers (3):
  crypto: sparc/aes - convert to skcipher API
  crypto: sparc/camellia - convert to skcipher API
  crypto: sparc/des - convert to skcipher API

 arch/sparc/crypto/aes_glue.c      | 310 +++++++++----------
 arch/sparc/crypto/camellia_glue.c | 217 ++++++-------
 arch/sparc/crypto/des_glue.c      | 499 ++++++++++++++----------------
 crypto/Kconfig                    |   5 +-
 4 files changed, 468 insertions(+), 563 deletions(-)

-- 
2.23.0

