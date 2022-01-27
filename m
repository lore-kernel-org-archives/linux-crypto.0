Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68784C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 11:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235870AbiA0Lf5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 06:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiA0Lf5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 06:35:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCA4C061714
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 03:35:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D4D76186B
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 11:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A405C340E4;
        Thu, 27 Jan 2022 11:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643283356;
        bh=NuvZnz3CW/nBcxm/gE2l5SFlfboUY1WnGEzTxNUzBrA=;
        h=From:To:Cc:Subject:Date:From;
        b=HbqNDdbBr/iqGOUR7EhJYqK0QAwqd0pvihS8PmBIUeWawmDj71sYJzotvsat0liu1
         Shw/zS7htEfMx/8bQzn8JuWrBQS2rCdRR9ks6ehqjQJT5YY9CvVue91+QRP7YnrzvA
         o2mZJDZApKU7S6zUcUwRj4Kv8HD4ICOnwVL2SSoyn8/h/7ZtHM05hfmece1wvhJgVz
         huLrjaA4kfttfiU04aJ5UdNVeluYbQ0y5ul00/q9I2xHWVy9qwmEM+tDgMVvjZM+i6
         0P07Q78kJH80ObONoZYvQWqwabQuH+z7jyQy8fh04YLX3an8PZW/CLzAf3UVlJ1vei
         agq8481IGsB2w==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 0/3] crypto: arm - simplify bit sliced AES 
Date:   Thu, 27 Jan 2022 12:35:42 +0100
Message-Id: <20220127113545.7821-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=708; h=from:subject; bh=NuvZnz3CW/nBcxm/gE2l5SFlfboUY1WnGEzTxNUzBrA=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8oOPP03D1WWSXJjskYwDwopSgrJF95LUKJAND639 gO4UV0GJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfKDjwAKCRDDTyI5ktmPJCmQC/ oD8nQb6dkgu0ZS+w/zs2c4T31wY614UHaIJlQYLMm4istE9iM815OCQotT70elWaXzhrm4wHZXafpG 9rSnIj8DlnbxJOtN6E4U7j6mLhpp43YJjcD/3hEsbSgKD5KXtc6PPOb4GWQsbhQCtKnsgx2HTMzUjb GBig5fjckcZfBpAYI83cUqIH/59ZvFvJUTgqfy/WNBI1pki/NEZ6LZiyD9Ysb1OfF1IrhrQxxzSezB VC5oQ/iTuP/ylM49/5FhUJYqKasQuKl0wQRa01mhYd/595ILlc4yfrE50mDOIsmcUE+E1bq5wB6oCS +QeIRDT40WoFiDK2M8fGwxivOZyPyvsUwaYq2+7COY9+4ee8HxlMKZtNxnq3d3lqruIiHNbN6q2mgL 6u6pBxJJbOsjGvElYtl2lgvVsA/VqkCXINmB/21ov86VuqGf6a+wtu1MMHoDXKPyhfQOZyBKg3muYG iRz1KdGILj2I4hMF7UEZe3lOxwNfMpxV4ehJwxkoPufJA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This contains a couple of improvements/simplifications for the bit
sliced AES driver implemented on ARM and arm64.

Ard Biesheuvel (3):
  crypto: arm/aes-neonbs-ctr - deal with non-multiples of AES block size
  crypto: arm64/aes-neonbs-ctr - fallback to plain NEON for final chunk
  crypto: arm64/aes-neonbs-xts - use plain NEON for non-power-of-2 input
    sizes

 arch/arm/crypto/aes-neonbs-core.S   | 105 ++++----
 arch/arm/crypto/aes-neonbs-glue.c   |  35 ++-
 arch/arm64/crypto/aes-glue.c        |   1 +
 arch/arm64/crypto/aes-neonbs-core.S | 264 +++++---------------
 arch/arm64/crypto/aes-neonbs-glue.c |  97 ++++---
 5 files changed, 189 insertions(+), 313 deletions(-)

-- 
2.30.2

