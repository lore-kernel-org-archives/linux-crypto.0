Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C231C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 13:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DAB7239FF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 13:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbhAUNIg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 08:08:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731814AbhAUNI3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 08:08:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 179C7239FD;
        Thu, 21 Jan 2021 13:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611234465;
        bh=YOLy5V9zCsd0VdLNZdRnLke4JNoqkqrO1XUAhv6wabk=;
        h=From:To:Cc:Subject:Date:From;
        b=U8vDVBBrgZycZ2cPVPqXtAPnYBHPqZLe20Q3RwGjRawaxlT9EDRjhhXITZAb9H1RA
         kLAisBjXdiMgDjRPRe3bxJwNDGVvxxxXq2OTo9k1CsCCSRftVcd6aRVC8viz+9/lPh
         vLX1QSiFl+WCgryzywxorSr/1fTDt67kCKyL8cnyXHZifKSOrF0JVXiSKGC4F3GDsR
         EmPuSV/7mJhSpzXp6T7H1Hp0NyvjdsETfYx3CPZk3c6VxZ2sTg118BbvSkw2WBUM2y
         Ma+/M++be9gpB/lLJZ3CFwtqOn6iNcqE2QVdqEGUddzOYLT+SUxQQbAX9QFqCJQcxE
         9MhY5LgokNqxg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/5] crypto: remove some obsolete algorithms
Date:   Thu, 21 Jan 2021 14:07:28 +0100
Message-Id: <20210121130733.1649-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove a set of algorithms that are never used in the kernel, and are
highly unlikely to be depended upon by user space either.

Cc: Eric Biggers <ebiggers@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>

Ard Biesheuvel (5):
  crypto: remove RIPE-MD 128 hash algorithm
  crypto: remove RIPE-MD 256 hash algorithm
  crypto: remove RIPE-MD 320 hash algorithm
  crypto: remove Tiger 128/160/192 hash algorithms
  crypto: remove Salsa20 stream cipher algorithm

 .../device-mapper/dm-integrity.rst            |    4 +-
 crypto/Kconfig                                |   62 -
 crypto/Makefile                               |    4 -
 crypto/ripemd.h                               |   14 -
 crypto/rmd128.c                               |  323 ----
 crypto/rmd256.c                               |  342 ----
 crypto/rmd320.c                               |  391 -----
 crypto/salsa20_generic.c                      |  212 ---
 crypto/tcrypt.c                               |   87 +-
 crypto/testmgr.c                              |   48 -
 crypto/testmgr.h                              | 1553 -----------------
 crypto/tgr192.c                               |  682 --------
 12 files changed, 3 insertions(+), 3719 deletions(-)
 delete mode 100644 crypto/rmd128.c
 delete mode 100644 crypto/rmd256.c
 delete mode 100644 crypto/rmd320.c
 delete mode 100644 crypto/salsa20_generic.c
 delete mode 100644 crypto/tgr192.c

-- 
2.17.1

