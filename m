Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E47C2D0CE
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34CF3227BF
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024307;
	bh=5AZDXLJWUkzL8Rn69go/rZVHGmV8KzOV4YfcHR23mbg=;
	h=From:To:Subject:Date:List-ID:From;
	b=vhjZh9S5XfdeGGfDm/qLjTIPuK5HiBgqB91RJl919FMNvebp9XYZLOuZ35a8+wRYU
	 2RHh45kWeNz34WW/7mWit4VHJ8eGa7ZGwVeVyjR6MaTAhvIXOdSwV1kjDPgBJgpzjW
	 3XSEmbVeQQsiiv/Q0rpHNkpmPPNRfhxZ0J5vXwXw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgACEFG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:05:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgACEFG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:05:06 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6E4921D7D
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024305;
        bh=5AZDXLJWUkzL8Rn69go/rZVHGmV8KzOV4YfcHR23mbg=;
        h=From:To:Subject:Date:From;
        b=A8NG7xgv+spdANUERjOStI3zaWMjTG7C/KvJcWyRVr/fvOTX4yHbSggqvo+D8nnVx
         vzS1Xt83nmG8OCKzxd5FuOrdIH7OmK8lGo6YTGuGgekt2WOW0kgxpupS1AHVVmRF5C
         ZplZxoPocjHjyExxV4xEjbPVRT2wW0Om8r5a+JYE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 0/6] crypto: remove old way of allocating and freeing instances
Date:   Thu,  2 Jan 2020 20:04:34 -0800
Message-Id: <20200103040440.12375-1-ebiggers@kernel.org>
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
"[PATCH v2 00/28] crypto: template instantiation cleanup".

Changed v1 => v2:

  - Rebased onto v2 of the other series.

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

