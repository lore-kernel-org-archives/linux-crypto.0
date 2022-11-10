Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA8AC433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Nov 2022 08:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbiKJIPK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Nov 2022 03:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiKJIPJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Nov 2022 03:15:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172BE186E1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 00:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 974FD61DAC
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 08:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2CAC433D6
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 08:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668068105;
        bh=+PaxsYsNuacQ4/DIHfj/i5kVVq6f/BdmIPHYqS0rSWw=;
        h=From:To:Subject:Date:From;
        b=Z3kXVD4kI2iKfYCljIK68CVm9EJBvyJ8ax7WlKmasQm92z8jBZKHNSnWZSkl3PsCe
         2YWkn+fRpQ1Xghw4PQmvNAswO3sf7n80WB1+hW6Go8kIk3PEU3yT8wcdfjlTtCkpCF
         ZKyjspdf5jt8n76p/WGEaxUJh53JtXjRG3tF7Kw5bz3FczUXm/iJxBFQ4DXi2TCnw9
         siahCftL/hJyeyescaL+Zq/qHToWRefwrMp0HVnNgJi4diEyL7ge6eSNdmINIcBeDg
         xKJRwyCAfLUQuqyqorAuRu7oCCandLRalPJCBCHJxvTwThjorKkKPy1pHVsZ6uUhWK
         dS8mFPwWBQ7NA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 0/6] crypto: reduce overhead when self-tests disabled
Date:   Thu, 10 Nov 2022 00:13:40 -0800
Message-Id: <20221110081346.336046-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset makes it so that the self-test code doesn't still slow
things down when self-tests are disabled via the kconfig.

It also optimizes the registration of "internal" algorithms and silences
a noisy log message.

Eric Biggers (6):
  crypto: optimize algorithm registration when self-tests disabled
  crypto: optimize registration of internal algorithms
  crypto: compile out crypto_boot_test_finished when tests disabled
  crypto: skip kdf_sp800108 self-test when tests disabled
  crypto: silence noisy kdf_sp800108 self-test
  crypto: compile out test-related algboss code when tests disabled

 crypto/algapi.c       | 160 ++++++++++++++++++++++++------------------
 crypto/algboss.c      |  26 +++----
 crypto/api.c          |   8 ++-
 crypto/internal.h     |  13 +++-
 crypto/kdf_sp800108.c |  11 ++-
 5 files changed, 124 insertions(+), 94 deletions(-)


base-commit: f67dd6ce0723ad013395f20a3f79d8a437d3f455
-- 
2.38.1

