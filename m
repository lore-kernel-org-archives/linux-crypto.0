Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB842C4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Dec 2022 17:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiLNRUH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Dec 2022 12:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237475AbiLNRUG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Dec 2022 12:20:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262CE234
        for <linux-crypto@vger.kernel.org>; Wed, 14 Dec 2022 09:20:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6AF761B57
        for <linux-crypto@vger.kernel.org>; Wed, 14 Dec 2022 17:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ADAC433EF;
        Wed, 14 Dec 2022 17:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671038405;
        bh=XWtsKbE9iuk7f0Um+MKAjDwq1pDOT0QK4pPZPKz8TcA=;
        h=From:To:Cc:Subject:Date:From;
        b=r4dD/38EVosAR5puFxigbqp7wKuVO1WthL18qS0fn0oarpBdTOSv3h9kC+xkEz5cz
         VbwP8cOW5RIn6q0KiH5eMIGpvwvnC4KbWW7XOiTD09swNhLWdUxqjHbnJ4o35giKrl
         7aUn3a4FuWHpE9DHBvdvUQQjS8hu9FZOIhZtObChxAXcJN9/JCb2uLjugmdI5W1tBF
         VtnQY4cDyDKNr1Oiqa12lLZcEqpYoFjoGgCAYYWJpQW7nicQep1eZrU3+WNsU3ecbR
         PC7fPAdKFJ871ZtTMijFlQjU5o5hxbCWvba3CGuNZFQS7P/GXEy03B5n6ktJvo1zgT
         lx9WmnJLoDTBQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 0/4] crypto: Accelerated GCM for IPSec on ARM/arm64
Date:   Wed, 14 Dec 2022 18:19:53 +0100
Message-Id: <20221214171957.2833419-1-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1542; i=ardb@kernel.org; h=from:subject; bh=XWtsKbE9iuk7f0Um+MKAjDwq1pDOT0QK4pPZPKz8TcA=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjmgW2GZBAcgDI5G2wN6nICnek+q+Xc8GouD5GrN3Z h40ahh2JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY5oFtgAKCRDDTyI5ktmPJB48DA Cmn/5HnYlpgVSzQJKeVX+osiTHf+0kFhpuqjw7cOlfqf0u16MKvRQ3URfgtTErdykw+AZpP+YfHhFd Oe0Yo6dwN06xxxBPuKnPPRz8mzLBJ4WNv3alflzjl8wo0gpZfARMaMoEHtmNpLEfwMWX6LDLXkrYoS +yKvldQT8f/smNo9WeZJP4AJmPkDn0huctsk998tWVmSHvKf9GODpTTUqW8TxIBIx3ODbX28EMoam2 vjHjC/5xX6kQhGUSXTKhZEvQmP5BMJ0eeUocKBiSyJcK7nd2EB0WxkdAH88G3mqNYeht6gmw/wI6zY at0/oH9hcf8xy+JE0Q/IfsAdrh24TX7FGIhG+iwqR8v0ZBxTL4m/O9tXCSYmDL4fHnyXz2YPZsC4IZ SRV+HuMFuHQFWhhJ/ERu997leaokZz0aFOFrl2ILsk5Mq7OkpYTIyZD8QMMWDcdHssd3DvMHZFvfWA sL1+cgBiJaDCGcZ9wkjOZm6UI9AMJNJbUL0M1P4ldtVms=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a v2 as patch #1 was sent out in isolation a couple of days ago.

As it turns out, we can get ~10% speedup for RFC4106 on arm64
(Cortex-A53) by giving it the same treatment as ARM, i.e., avoid the
generic template and implement RFC4106 encapsulation directly in the
driver

Patch #3 adds larger key sizes to the tcrypt benchmark for RFC4106

Patch #4 fixes some prose on AEAD that turned out to be inaccurate.

Changes since v1:
- minor tweaks to the asm code in patch #1, one of which to fix a Clang
  build error

Note: patch #1 depends on the softirq context patches for kernel mode
NEON I sent out last week. More specifically, this implements a sync
AEAD that does not implement a !simd fallback, as AEADs are not callable
in hard IRQ context anyway.

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>

Ard Biesheuvel (4):
  crypto: arm/ghash - implement fused AES/GHASH version of AES-GCM
  crypto: arm64/gcm - add RFC4106 support
  crypto: tcrypt - include larger key sizes in RFC4106 benchmark
  crypto: aead - fix inaccurate documentation

 arch/arm/crypto/Kconfig           |   2 +
 arch/arm/crypto/ghash-ce-core.S   | 382 +++++++++++++++++-
 arch/arm/crypto/ghash-ce-glue.c   | 424 +++++++++++++++++++-
 arch/arm64/crypto/ghash-ce-glue.c | 145 +++++--
 crypto/tcrypt.c                   |   8 +-
 crypto/tcrypt.h                   |   2 +-
 include/crypto/aead.h             |  20 +-
 7 files changed, 913 insertions(+), 70 deletions(-)

-- 
2.35.1

