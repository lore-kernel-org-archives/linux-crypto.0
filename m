Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE5F9C8300B
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 11:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19769206E3
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 11:04:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="sr4Ku9Qa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgKTLEk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 06:04:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728014AbgKTLEk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 06:04:40 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C9D52222F;
        Fri, 20 Nov 2020 11:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605870279;
        bh=O3RUzgzm5aKbqil6zia6g9oZx5PcRSh6edvZu7zNyUY=;
        h=From:To:Cc:Subject:Date:From;
        b=sr4Ku9QaJx/UJAQ7R0a2J+1zsrcf2qk+erwmDgjLOQ0d+99/Tl1I4mzDf3mfINT4i
         JTJQFc8W31yeTfp/kCRj5mtaFwdSpsgGOhzhXTUo7SU99/pmsDvfYaF1fbW7qa4tds
         UR4TtR5uHcm+LgUFtuxrJbaEpIFBS7hnI7sppy8s=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2 0/3] crypto: tcrypt enhancements
Date:   Fri, 20 Nov 2020 12:04:30 +0100
Message-Id: <20201120110433.31090-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some tcrypt enhancements that I have been using locally to test and
benchmark crypto algorithms on the command line using KVM:
- allow tcrypt.ko to be builtin and defer its initialization to late_initcall
- add 1420 byte blocks to the list of benchmarked block sizes for AEADs and
  skciphers, to get an estimate of the performance in the context of a VPN

Changes since v1:
- use CONFIG_EXPERT not CONFIG_CRYPTO_MANAGER_EXTRA_TESTS to decide whether
  tcrypt.ko may be built in
- add Eric's ack to #1

Ard Biesheuvel (3):
  crypto: tcrypt - don't initialize at subsys_initcall time
  crypto: tcrypt - permit tcrypt.ko to be builtin
  crypto: tcrypt - include 1420 byte blocks in aead and skcipher
    benchmarks

 crypto/Kconfig  |  2 +-
 crypto/tcrypt.c | 83 +++++++++++---------
 2 files changed, 46 insertions(+), 39 deletions(-)

-- 
2.17.1

