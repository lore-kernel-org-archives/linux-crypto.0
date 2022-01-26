Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B39A0C2BA4C
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 07:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237564AbiAZHH0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 02:07:26 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:32877 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiAZHHZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 02:07:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643180840;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=m+i9CLkjPEZN+mJvMVmyIOnfpp38EzSCqnnNuSmoaj4=;
    b=pOf8A+6pNwYueo3L0JJeQj7V3+KklzsYs5UFd7veRcFc/VHzOXOL2ZmkhudY8Q82vE
    aJSWsCAy+Y7UQDIFlf5u7H9euv60p/Y/1z2bu+URx3Bkv2XIc57X4xrcaoo1KpXwKdX0
    Q+2tzTt8czmUDYcL/gekg9lyGqfSpTpbHgXJE96G1vIfky55m6IAaXsmWBRbWPcB0pgI
    tvCNvpKH444gZ/uEBGBOHyZxq4/nWv26UGmHtaQEY1YfKmLMOmjkL/qJkR4tSDzPBT86
    kFiKm5HNfpL1kEuMdnpA3gVf80cGM6Cgpn83bMKMgt0Nr4salJa7Je6e96spe17eZR0D
    ITeg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJvScdWrN"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.38.0 DYNA|AUTH)
    with ESMTPSA id v5f65ay0Q77KiuP
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 26 Jan 2022 08:07:20 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: [PATCH 4/7] crypto: move Jitter RNG header include dir
Date:   Wed, 26 Jan 2022 08:04:23 +0100
Message-ID: <2612341.cojqenx9y0@positron.chronox.de>
In-Reply-To: <2486550.t9SDvczpPo@positron.chronox.de>
References: <2486550.t9SDvczpPo@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

To support the ESDM operation which uses the Jitter RNG separately
from the kernel crypto API, the header file must be accessible to
the ESDM code.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/jitterentropy-kcapi.c                        | 3 +--
 crypto/jitterentropy.c                              | 2 +-
 {crypto => include/crypto/internal}/jitterentropy.h | 0
 3 files changed, 2 insertions(+), 3 deletions(-)
 rename {crypto => include/crypto/internal}/jitterentropy.h (100%)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 2d115bec15ae..40bc51f32432 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -41,10 +41,9 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/time.h>
+#include <crypto/internal/jitterentropy.h>
 #include <crypto/internal/rng.h>
 
-#include "jitterentropy.h"
-
 /***************************************************************************
  * Helper function
  ***************************************************************************/
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 93bff3213823..81b80a4d3d3a 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -133,7 +133,7 @@ struct rand_data {
 #define JENT_ENTROPY_SAFETY_FACTOR	64
 
 #include <linux/fips.h>
-#include "jitterentropy.h"
+#include <crypto/internal/jitterentropy.h>
 
 /***************************************************************************
  * Adaptive Proportion Test
diff --git a/crypto/jitterentropy.h b/include/crypto/internal/jitterentropy.h
similarity index 100%
rename from crypto/jitterentropy.h
rename to include/crypto/internal/jitterentropy.h
-- 
2.33.1




