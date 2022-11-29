Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F1D0C4167B
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Nov 2022 16:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbiK2Qyr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Nov 2022 11:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbiK2QyQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2022 11:54:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3106F6CA27
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2022 08:49:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C081CB816D8
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2022 16:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7D1C433C1;
        Tue, 29 Nov 2022 16:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669740542;
        bh=6iD2n0KHW8TQQqOuIVsk1zfdUPSdWiqEGvFsqtmVE7E=;
        h=From:To:Cc:Subject:Date:From;
        b=Sb0ipLDfk5kQdcsM4wmUtcFLzK9m5epoz0HSqko75uYGTRi/YEMHMnXkyeYFLY2gS
         NJaChgtn2o+bHU88vvQHL+V3u6Ve4tBKw7BU+nw9A13eSuPjbdufdR4teE4dR7n5yp
         kyAkORy5dQLn0TvfBQ2WHY0oXng+jSpSpUvdEsGzyk9EARTD+MMV8PFA6sl9j9CzX2
         sIBImN5RFFDpxfJMXxDLH9FMXTmVKSe9GkNecUlDjLmk9GvcG0eFTDY8X2mjJGWbn1
         WByvWJQjRWyr8264yzVjFC+yvqBfMKCwG5DSsX4KImP6XX+ngJclihUyI5H7/wAyU0
         lffTmWo17Ebyg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        keescook@chromium.org, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 0/4] crypto: arm64 - use frame_push/pop macros
Date:   Tue, 29 Nov 2022 17:48:48 +0100
Message-Id: <20221129164852.2051561-1-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=996; i=ardb@kernel.org; h=from:subject; bh=6iD2n0KHW8TQQqOuIVsk1zfdUPSdWiqEGvFsqtmVE7E=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjhjftS+8JXLMKyuRpTCfIGjThLbU/Fr25SDCzLPjb sI+y5HKJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY4Y37QAKCRDDTyI5ktmPJC2yC/ 0SkhQTbDeLV3Zu+PlBiBC/3qMF18khEHhIjEXVgxeLzRsbg81e9xXmU5HVpGFwRIUbBH/vLQA1tU+F LDDr4tWv4FuaeH19RyaTNVvJI7ROFNVZAlufP+q4a2KQE9tCU7Cs0wagwH+jzgvi3Q0Ek5KJanCjsC wn13aSffEZVy60nWmHfbw56eYtI3Ew9KcdBikphpU6Ql3Y97R3S3D5viWEpGcmzYRoXYWi8XhCn3z3 Klw2guXz/r9VsV+5enE8ZLLz6k63xHI0duOkWvNvNzqYnrY73zrgxTokI1TQB6My9D5e9OXivKA6Z5 pKWkPCgpqMhE03I5R0QjsXn+f9zf73T6y3Pi037OTCV7Rb0vd0ij1Ufbk7W6U65hmibKuML6zt9Dqy aJIPSzGBZ2h1mdZB/9WyF+N35loclzGyARQ8BrX27vy3wC3y2RcPHXMJyG/F14pIeioYQ+vLRXOgXF tXG5Jeug5ZrB1k7hq+KmU9PDm/98Ex9bh5PnY0uGFeilE=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We have a pair of macros on arm64 that can be used in asm code to set up
and tear down the stack frame when implementing a non-leaf function.

We will be adding support for shadow call stack and pointer
authentication to those macros, so that the code in question is less
likely to be abused for someone's ROP/JOP enjoyment. So let's fix the
existing crypto code to use those macros where they should be used.

Ard Biesheuvel (4):
  crypto: arm64/aes-neonbs - use frame_push/pop consistently
  crypto: arm64/aes-modes - use frame_push/pop macros consistently
  crypto: arm64/crct10dif - use frame_push/pop macros consistently
  crypto: arm64/ghash-ce - use frame_push/pop macros consistently

 arch/arm64/crypto/aes-modes.S         | 34 +++++++-------------
 arch/arm64/crypto/aes-neonbs-core.S   | 16 ++++-----
 arch/arm64/crypto/crct10dif-ce-core.S |  5 ++-
 arch/arm64/crypto/ghash-ce-core.S     |  8 ++---
 4 files changed, 24 insertions(+), 39 deletions(-)

-- 
2.35.1

