Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79D9C2D0C0
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 21:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83E12208E4
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577656205;
	bh=7cCdW4Es32M3VWtm4dSdymCTWxuaGQtfVJz1UcrT3eM=;
	h=From:To:Subject:Date:List-ID:From;
	b=xxDgdSp+d7b+DJ0pGyLLyk8yvuCsPzsrWiQarg4a1r/imx+WfaeNQVCy4KsPRH59f
	 Ceas8+AwZY1CJ9Jgi9yvhk+OyjD/tcZLJXFIGBov2kX1DG4Xd2AWHupfebz8GEbbz2
	 joHq1jG1e7nj5FNMVx5prJUuobc2cflOSb55f/Y0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfL2VuE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Dec 2019 16:50:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbfL2VuE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Dec 2019 16:50:04 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50678206A4
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 21:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577656203;
        bh=7cCdW4Es32M3VWtm4dSdymCTWxuaGQtfVJz1UcrT3eM=;
        h=From:To:Subject:Date:From;
        b=hXzsd6p+ptW9OeR+BSWojxh/1s4C1NSxeiCvF4GzTj7uK+DiH0TxChPtCUOBTCK1H
         0YbBtN04pKdUa4RhuNRkUau7/kbxNIFZsxew0/uqskcATuUWY9TZafN58iW9yAoGno
         00vRAxHNyM5Db2Z89TopIv6mZ5RPsdtH8rSQSBeI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 0/6] crypto: remove old way of allocating and freeing instances
Date:   Sun, 29 Dec 2019 15:48:24 -0600
Message-Id: <20191229214830.260965-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series makes all crypto templates use the new way of freeing
instances where a ->free() method is installed to the instance struct
itself.  This replaces the weakly-typed method crypto_template::free().

skcipher and akcipher were already using the new way, while aead was
mostly but not always using the new way.  shash and ahash were using the
old way.  This series eliminates this inconsistency (and the redundant
code associated with it) by making everyone use the new way.

The last patch adds registration-time checks which verify that all
instances really have a ->free() method.

This series is an internal cleanup only; there are no changes for users
of the crypto API.

This series is based on top of my other series
"[PATCH 00/28] crypto: template instantiation cleanup".

Eric Biggers (6):
  crypto: hash - add support for new way of freeing instances
  crypto: geniv - convert to new way of freeing instances
  crypto: cryptd - convert to new way of freeing instances
  crypto: shash - convert shash_free_instance() to new style
  crypto: algapi - remove crypto_template::{alloc,free}()
  crypto: algapi - enforce that all instances have a ->free() method

 crypto/aead.c                   |  8 +++----
 crypto/ahash.c                  | 11 +++++++++
 crypto/akcipher.c               |  2 ++
 crypto/algapi.c                 |  5 ----
 crypto/algboss.c                | 12 +---------
 crypto/ccm.c                    |  5 ++--
 crypto/cmac.c                   |  5 ++--
 crypto/cryptd.c                 | 42 ++++++++++++++++-----------------
 crypto/echainiv.c               | 20 ++++------------
 crypto/geniv.c                  | 15 ++++++------
 crypto/hmac.c                   |  5 ++--
 crypto/seqiv.c                  | 20 ++++------------
 crypto/shash.c                  | 19 +++++++++++----
 crypto/skcipher.c               |  3 +++
 crypto/vmac.c                   |  5 ++--
 crypto/xcbc.c                   |  5 ++--
 include/crypto/algapi.h         |  2 --
 include/crypto/internal/geniv.h |  1 -
 include/crypto/internal/hash.h  |  4 +++-
 19 files changed, 89 insertions(+), 100 deletions(-)

-- 
2.24.1

