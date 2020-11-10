Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CAF8C388F7
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Nov 2020 19:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CE6120797
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Nov 2020 19:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="p6N8nP2I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbgKJTEw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Nov 2020 14:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgKJTEv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Nov 2020 14:04:51 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4EAC2076E;
        Tue, 10 Nov 2020 19:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605035091;
        bh=zoi//bFVy6DpPuPdFSj+j6qx9AVSJuO6+4BQUYF1cC8=;
        h=From:To:Cc:Subject:Date:From;
        b=p6N8nP2IGZZYEiOBxfn1Om9NJIyc5n/Wt7Ve5CWF580JoH4NJoqfi1IOJc0K8dR80
         wEFuUp97fWVZTnOZbzWuXb4OmmLA3KUqaRrbG2iD8rWiwIELSF7yqWaERrvDTMG3Py
         YSezCsoPxyI/PTHUn8r+8QIVbk+JMIgISdjl8/bI=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 0/4] crypto: aegis128 enhancements
Date:   Tue, 10 Nov 2020 20:04:40 +0100
Message-Id: <20201110190444.10634-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series supersedes [0] '[PATCH] crypto: aegis128/neon - optimize tail
block handling', which is included as patch #3 here, but hasn't been
modified substantially.

Patch #1 should probably go to -stable, even though aegis128 does not appear
to be widely used.

Patches #2 and #3 improve the SIMD code paths.

Patch #4 enables fuzz testing for the SIMD code by registering the generic
code as a separate driver if the SIMD code path is enabled.

Cc: Ondrej Mosnacek <omosnacek@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>

[0] https://lore.kernel.org/linux-crypto/20201107195516.13952-1-ardb@kernel.org/

Ard Biesheuvel (4):
  crypto: aegis128 - wipe plaintext and tag if decryption fails
  crypto: aegis128/neon - optimize tail block handling
  crypto: aegis128/neon - move final tag check to SIMD domain
  crypto: aegis128 - expose SIMD code path as separate driver

 crypto/aegis128-core.c       | 201 ++++++++++++++------
 crypto/aegis128-neon-inner.c | 122 ++++++++++--
 crypto/aegis128-neon.c       |  21 +-
 3 files changed, 263 insertions(+), 81 deletions(-)

-- 
2.17.1

