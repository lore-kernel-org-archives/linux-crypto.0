Return-Path: <SRS0=gJ+M=IF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AC5C433E6
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Mar 2021 16:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0E5D64F98
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Mar 2021 16:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhCGQyv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Mar 2021 11:54:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231314AbhCGQyf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Mar 2021 11:54:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EEB264F98;
        Sun,  7 Mar 2021 16:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615136075;
        bh=hF4AFhK88NIj45qdQXdYlBTiI1jez+BfYUTFHQwl0+c=;
        h=From:To:Cc:Subject:Date:From;
        b=sil0yzU/TRWX2NRSt3sJ0zv69p9tmwSxXdskYhZncnVXOntnKwn7c1GwNRo+uNCzk
         GSyeEjP1yrHeLM2E4uZ/qGN5bPZDdRSV4mPrYPqIB5K1yn2BEvA9JNG9RKTT4D6Ddu
         lABTduxzlJvvmIX5py28CkmCDBozb/bEuhKGx6A/0pnnv5U5nxvasqcDRm7dLxXx/H
         9mgRn7xrQqkDIMJMi8v3yS6lZC9psm4JchqeFzefO2na5tXkYqWPnFsBskEirtY2Vw
         RRjb9IF9PuYdEAxqGQ4Zkc4G0eEfIHEdMt24SZ64x4DkfS17h2yAmWmP0mLmJrb9Qh
         zAjrKa+UCQ9yg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Nicolas Pitre <nico@fluxnic.net>,
        Eric Biggers <ebiggers@google.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2 0/2] crypto: arm - clean up redundant helper macros
Date:   Sun,  7 Mar 2021 17:54:22 +0100
Message-Id: <20210307165424.165188-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that ARM's asm/assembler.h provides mov_l and rev_l macros, let's get
rid of the locally defined ones that live in the ChaCha and AES crypto code.

Changes since v1;
- drop the patch that introduces rev_l, it has been merged in v5.12-rc
- rev_32 was renamed to rev_l, so both patches were updated to reflect that
- add acks from Nico, Geert and Linux

Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Linus Walleij <linus.walleij@linaro.org>

Ard Biesheuvel (2):
  crypto: arm/aes-scalar - switch to common rev_32/mov_l macros
  crypto: arm/chacha-scalar - switch to common rev_32 macro

 arch/arm/crypto/aes-cipher-core.S    | 42 +++++--------------
 arch/arm/crypto/chacha-scalar-core.S | 43 ++++++--------------
 2 files changed, 23 insertions(+), 62 deletions(-)

-- 
2.30.1

