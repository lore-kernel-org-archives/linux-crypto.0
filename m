Return-Path: <SRS0=nWKA=DA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3E8C2D0A8
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Sep 2020 18:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03BDE235F7
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Sep 2020 18:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600885362;
	bh=mlB6rdIZtIuoDKMYTjboUQQNek6n4dzbSSNWip0zkp8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=IXuccwUAPXgpRhcgANfZ269ejr00l4+8/SRrrot33y/buQX05QWu4tT5b2lC0OzBk
	 6M5kT/+nyrJF8KhapkoZHITDzUFkXFMmfehzs20U5aY67XLYoz+4v5Ao+C4NU0hPdO
	 1leX21vKYHW5Xb7ngbOPerXRTiJZU24ZOJST5vMI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgIWSWl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Sep 2020 14:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgIWSWl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Sep 2020 14:22:41 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 974FC20791;
        Wed, 23 Sep 2020 18:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600885360;
        bh=mlB6rdIZtIuoDKMYTjboUQQNek6n4dzbSSNWip0zkp8=;
        h=From:To:Cc:Subject:Date:From;
        b=M0yfp7By/VGzeOGWt4oNVxfMsa6ykpHR3Mbkae5j2QgYjdL+Q/ORwUAZXVzNDv/mD
         KeIIuzKRSAspny8mbnBKZzjV6ux2n6LuqqzROEAsL3V0XemwWBQ9W+y/7DI4xnx4Va
         ano9bw71rbfvfxikRr56NiHn9YXMf2rgmuqjnW5E=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        David Laight <David.Laight@aculab.com>
Subject: [PATCH 0/2] crypto: xor - defer and optimize boot time benchmark
Date:   Wed, 23 Sep 2020 20:22:28 +0200
Message-Id: <20200923182230.22715-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Doug reports [0] that the XOR boot time benchmark takes more time than
necessary, and runs at a time when there is little room for other
boot time tasks to run concurrently.

Let's fix this by #1 deferring the benchmark, and #2 uses a faster
implementation.

[0] https://lore.kernel.org/linux-arm-kernel/20200921172603.1.Id9450c1d3deef17718bd5368580a3c44895209ee@changeid/

Cc: Douglas Anderson <dianders@chromium.org>
Cc: David Laight <David.Laight@aculab.com>

Ard Biesheuvel (2):
  crypto: xor - defer load time benchmark to a later time
  crypto: xor - use ktime for template benchmarking

 crypto/xor.c | 65 +++++++++++++-------
 1 file changed, 43 insertions(+), 22 deletions(-)

-- 
2.17.1

