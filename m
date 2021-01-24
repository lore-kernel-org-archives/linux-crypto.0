Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17881C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Jan 2021 14:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0FAB22795
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Jan 2021 14:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbhAXOaF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Jan 2021 09:30:05 -0500
Received: from mout.gmx.net ([212.227.17.22]:41489 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbhAXOaE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Jan 2021 09:30:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1611498490;
        bh=pITkN1jgrIZQEV8bcGYzV8N4n5kUC2tLoNrCLsr0djs=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=EkGAPm6/g/3gHakZ8mHi0o40mOBFw1hFH28nZMVoBgiaHBB4VY9KdSEyw3l8a27uB
         dHkzXuXhMIjcMP6b50qHAYTuAndYQN1pxfT2DYX+lnVyXublaABwDNrggLesYTkb6C
         mgUTDM18wnlaU/YT6aaqnuAFT9RYTGA4q+TkE1yo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ls3530.fritz.box ([92.116.141.229]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MybGX-1lvGOC3fQ5-00z1pJ; Sun, 24
 Jan 2021 15:28:09 +0100
Date:   Sun, 24 Jan 2021 15:28:06 +0100
From:   Helge Deller <deller@gmx.de>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linux-parisc@vger.kernel.org
Subject: [PATCH] crypto: xor - avoid division by zero crash
Message-ID: <20210124142806.GA29180@ls3530.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:DqwH9uOTMV7uLE4HrG7t8H7vZ8mnUgJG9TgF8O/uBkVq33Oig7h
 xA92BwWn9hMlzvR40u/4PSaXykiiAcMal3xCT8PJqgQbWLXf5gWn7qLBaDraDiJkbLJGFIh
 YE6FaENZ8bIDH5PvdFbmdbAIxU8UnQFQDqwwuUMcnwkBe49QFdVis3a7xRRBysbMHhofwOy
 1+kwsUkB8mRx1yzCPiCtg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:fTdOwco2k5w=:fuG85PIE8hH1F8oVJHqoKf
 GgBteGdexlWiw+Rdq1rItp47ncCO+31vJJwPjJzR6TdVtGvxkJNg7htcyv7eGCSA6deNCH/TA
 xflnjxOhkL1eNrHoTV9FBU655PDVIu2XGO0zjZ43IOEvs6JQHk5UNcueseH4lBo0y4gGIVy7n
 sS6gepmmYssXxWtLkzC/whchTB7Ni4K6hx3aQ7XS92j/U3As/rqcGVJ3VPE+quyQZvoiz9V5j
 HfRYBkK/neOz2idJknVEqQdFOpDeVDKXas+7tR+PS9VBrkbdXvVlBiEaxD955loIDnpDhikyb
 kcbr7QMfuQWN5ojl9Squ4vFyU7aqsHC2Rx7cm7N5uY/EJ8rk2PK0EUDfkiZtuUPUEgHW5ZR15
 d9k+hsVy6UXw9MOnp+3G1E9XIRgcXON70LBemmg+FHcbJ7QDAmDybgEG4lJpNAd/pk18/D1hy
 IciEQk4UDQh8h81tdaSOw7kjV0QPYSkgeFFNMSwiLw8l5uIJlxhs7GK/AS9l4mtGV4i7iR1Lv
 6RlaMpGvAt3AHHmV/mTsOeUXeFXwGcRv0wl4PeZrEnFDyV2Ys6VCi/BiqxdOssp9RTo2xHV5t
 RrnnGfBy9N+6wkNHu0FXTmDSitf0lOcEZo8ToG2PYZI3sVaEVDys2Z6d5DN1PKBto9R72bvhV
 4gHcUIPjw9AFl+dx6g1LDy8u16H/b/tWxMkCDQsWN4W7Ee1h3oc39HInA1NuUMuH2VjotmQiZ
 31KW/20QrNGfFSL72KLR1RlnvwN1CksHTJLQEXNjyGQLsRtgUBN04CLTlTTBEv09PjKLrUCvA
 vtRVb4wcUC9Oa10jSPujlzjbpByasIGRA4HPsB/T+oBI2E2fzUQhvuifiS/cg3csDmuDbPSx2
 Pkm+R202HWQ14/N2NpQg==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On some of my parisc machines, this patch c055e3eae0f1 ("crypto: xor -
use ktime for template benchmarking") triggers a dividy-by-zero
exception because "min" becomes zero, which then leads to a kernel
crash.

It's not clear yet, why I see the issue only on some machines. At least
on those the measured time to run the xor speed tests becomes zero
nanoseconds. Maybe it's because gcc-10 optimizes the speed test out, or
because of some other changes in the time keeping routines.

In either case, the kernel should not crash.

This patch adds a workaround by reporting such cases with a kernel
warning and continues as if the xor tests would have run in 1 ns.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # 5.10+

---

diff --git a/crypto/xor.c b/crypto/xor.c
index eacbf4f93990..3639341bac7e 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -100,6 +100,8 @@ do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 			mb();
 		}
 		diff = ktime_sub(ktime_get(), start);
+		if (WARN_ON(diff == 0))
+			diff = 1;
 		if (diff < min)
 			min = diff;
 	}
