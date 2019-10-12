Return-Path: <SRS0=sxdd=YF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641DBC4360C
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 20:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33EF221850
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 20:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570911616;
	bh=YIYi1aXNRP+OH+Apm03WWs+kylvIs7WZVZqljhJMypM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=znOhWbMVid0WFo+dQHmxIl9yYZt5Uvd0Tt6pTQsNEaftXiaUQzk5kH0U+RJVyGI8a
	 Kj3E05+BpghCmQ08doaH2vLjhdrHQuMJCxNiJEfhfJNRk/4CIPMnOENlCTgS65UymJ
	 dwZJrdpUOBTH5lSmAPy/LgnOi4QJcStebMXjF9b8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbfJLUUP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Oct 2019 16:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729413AbfJLUUO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Oct 2019 16:20:14 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E10CA20700;
        Sat, 12 Oct 2019 20:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570911612;
        bh=YIYi1aXNRP+OH+Apm03WWs+kylvIs7WZVZqljhJMypM=;
        h=From:To:Cc:Subject:Date:From;
        b=Wtcyyyj4WgWrdzYuvXPsmxBtee+NBOkA78/EDQol0K3HATlT85yB7khWhvEmm8aCK
         ONsEL5yZSf/9x8s+NEClmXeR9T/lG5Mp34ItZdV6+LRi0W0kxvI9mtUfby8/Q3/zGB
         b3LjhR15QwCNnjmXeQtga6uy39UO/Yv2FiI7juXA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-s390@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>
Subject: [RFT PATCH 0/3] crypto: s390 - convert to skcipher API
Date:   Sat, 12 Oct 2019 13:18:06 -0700
Message-Id: <20191012201809.160500-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series converts the glue code for the S390 CPACF implementations of
AES, DES, and 3DES modes from the deprecated "blkcipher" API to the
"skcipher" API.  This is needed in order for the blkcipher API to be
removed.

I've compiled this patchset, and the conversion is very similar to that
which has been done for many other crypto drivers.  But I don't have the
hardware to test it, nor is S390 CPACF supported by QEMU.  So I really
need someone with the hardware to test it.  You can do so by setting:

CONFIG_CRYPTO_HW=y
CONFIG_ZCRYPT=y
CONFIG_PKEY=y
CONFIG_CRYPTO_AES_S390=y
CONFIG_CRYPTO_PAES_S390=y
CONFIG_CRYPTO_DES_S390=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_XTS=y

Then boot and check for crypto self-test failures by running
'dmesg | grep alg'.

If there are test failures, please also check whether they were already
failing prior to this patchset.

This won't cover the "paes" ("protected key AES") algorithms, however,
since those don't have self-tests.  If anyone has any way to test those,
please do so.

Eric Biggers (3):
  crypto: s390/aes - convert to skcipher API
  crypto: s390/paes - convert to skcipher API
  crypto: s390/des - convert to skcipher API

 arch/s390/crypto/aes_s390.c  | 609 ++++++++++++++---------------------
 arch/s390/crypto/des_s390.c  | 419 ++++++++++--------------
 arch/s390/crypto/paes_s390.c | 414 ++++++++++--------------
 3 files changed, 580 insertions(+), 862 deletions(-)

-- 
2.23.0

