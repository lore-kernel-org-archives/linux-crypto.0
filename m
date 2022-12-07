Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D692AC352A1
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Dec 2022 10:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiLGKjv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Dec 2022 05:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLGKju (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2022 05:39:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255B61C7
        for <linux-crypto@vger.kernel.org>; Wed,  7 Dec 2022 02:39:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA91E612ED
        for <linux-crypto@vger.kernel.org>; Wed,  7 Dec 2022 10:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5384C433D6;
        Wed,  7 Dec 2022 10:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670409588;
        bh=UaU51mjjvEqzffoeoi31IzUxoHXD53qz+ANzmxo0Rkk=;
        h=From:To:Cc:Subject:Date:From;
        b=q9qZC5cCEfgWfyU2bXpus+XThf+wva3nXr9aW5sxQ/LpjLwCA+tO0fObw4niyDzEO
         0Wh/zwSUCiLyzeZ2NeWuG5Zg++i6NHQOnMx9IoXjIGCe9Li4opUBZ4aNWYZcM228+f
         VBK3BMQ2oJ0/QiCnEZzcq3amn3w8WLJt6EnEgQFVItemdeQ3AUkNYbZ9hyN3/rl5h/
         xfRh8qxoAGlu0xsOXqKrUo3N9x9L0Z96+7Uv1lNYNuDfLXtK4BuCkPt9n86iINTj+u
         aCzLzObBYzqHyjQnG7VucaAXA2r8htr8fBLpCR5WwVkuYBWk+yrt3JZfSxLtrF8pA6
         5PMlWhqvdEEyQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk
Cc:     linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 0/2] ARM: allow kernel mode NEON in softirq context
Date:   Wed,  7 Dec 2022 11:39:34 +0100
Message-Id: <20221207103936.2198407-1-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1946; i=ardb@kernel.org; h=from:subject; bh=UaU51mjjvEqzffoeoi31IzUxoHXD53qz+ANzmxo0Rkk=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjkG1k4gIk5BPXrKBYWIwEOYpVmyzuoJKtLUfjurOF GJASu7OJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY5BtZAAKCRDDTyI5ktmPJCVKDA CKv21UzwKXgkO/ZU9h4lfHB83WFeFw5gnytRKzYsoPzYddKyNiW9CstQUD3j7zpfCIQ/EK/zIQoOg4 XOZC/Y/SXyhzdrGrFL4n8SPxP2BCDyz4dm2UWAOEJvKx3Xr89FNB2qKnOjVALFAZG4sSG/AtsfTRfs yYkammk2Bc2NCzkqmPShUvevqzoHPPRRSGMVdOibE1smM25C/gvCZA6VXHyFGDTVewLjoYk380C0h5 H1iGw++5PhbuFH7FV/bThtarczx2USpHb4Aj/M98I5iZ0eIV47JSOW7tfALby2d0bhYogCXK78GFRK FsAkD/Si1NVF9h7wAaytWCpMHNmRYVncIZm/tTtrKRhJVZv2wsrB/3/orPD5VLEodjAVdNhWeCGGaW jGZo/uobU5mzVrwmNyz1HnAhNSovJBa05Y2be6xfMgBtk0vFEu6k+qic7qGGr0e7jhpPAFXtaXjpBy xOAQ8IxLVP9EUo+k4SGZ3p9wsHMIMqKnCdc2EgHCHWx30=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently on ARM, we only permit kernel mode NEON in task context, and
NEON based processing triggered from softirq context is queued for
asynchronous completion via the crypto API's cryptd layer.

For IPsec packet encryption involving highly performant crypto
implementations, this results in a substantial performance hit, and so
it would be desirable to permit those crypto operations to complete
synchronously even when invoked from softirq context.

For example, on a 1 GHz Cortex-A53 machine (SynQuacer), AES-256-GCM
executes in 7.2 cycles per byte, putting an upper bound of ~140 MB/s
on the achievable throughput of a single CPU.

Without these changes, an IPsec tunnel from a 32-bit VM to the 64-bit
host can achieve a throughput of 9.5 MB/s TX and 11.9 MB/s RX.

When the crypto algorithm is permitted to execute in softirq context,
the throughput increases to 16.5 MB/s TX and 41 MB/s RX.

(This is measured using debian's iperf3 3.11 with the default options)

So let's reorganize the VFP state handling so that it its critical
handling of the FPU registers runs with softirqs disabled. Then, update
the kernel_neon_begin()/end() logic to keep softirq processing disabled
as long as the NEON is being used in kernel mode.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>

Ard Biesheuvel (2):
  ARM: vfp: Manipulate VFP state with softirqs disabled
  ARM: permit non-nested kernel mode NEON in softirq context

 arch/arm/include/asm/assembler.h | 19 ++++++++++++-------
 arch/arm/include/asm/simd.h      |  8 ++++++++
 arch/arm/kernel/asm-offsets.c    |  1 +
 arch/arm/vfp/entry.S             |  4 ++--
 arch/arm/vfp/vfphw.S             |  4 ++--
 arch/arm/vfp/vfpmodule.c         | 19 ++++++++++++-------
 6 files changed, 37 insertions(+), 18 deletions(-)
 create mode 100644 arch/arm/include/asm/simd.h

-- 
2.35.1

