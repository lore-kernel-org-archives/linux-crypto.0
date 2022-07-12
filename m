Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBCDC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jul 2022 07:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiGLH2p (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiGLH2p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Jul 2022 03:28:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2467ACE3D
        for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2022 00:28:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9FB3B816C2
        for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2022 07:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D98BC3411E;
        Tue, 12 Jul 2022 07:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657610921;
        bh=LpTX8BtQ4nk3s/QpUBEBjyqybWzs+v3XLR2Bdeqf0p0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=reRLqpm9GgvTgHoyQYC923IczXG+CVC2LXpg+hFgwV3YXmwXQnTKchxyOl1ZYJTVC
         1aN0UiG2ViFdcJAfxxrDGk+rSSUCGel0aYO4MGPXgRwDIncvEFBREXfTqdO8m3RWrL
         4gVXn7AgLMwnnBO1J9/sGEeWm76ppEUs0zUbC4018qvVE7OY1ps58c2kYIGDiAyXFF
         PqtTZF8K0ohy8sRjrRKpQ1vF3fedTEg98ozCtqymW8QucUCZ/1FExg2FUdy6dxe5zm
         t3aXHCRBQFVcn+qVyUZQaO5BzK86WooLk0Z4YQY3yMM6/IrPBtI0L33l2t+vnbstPB
         MfwFST995TFhA==
Date:   Tue, 12 Jul 2022 00:28:39 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     GUO Zihua <guozihua@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH] arm64/crypto: poly1305 fix a read out-of-bound
Message-ID: <Ys0ip6SdCfWmbA1V@sol.localdomain>
References: <20220712033215.45960-1-guozihua@huawei.com>
 <Ys0d9KPadnltgwae@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys0d9KPadnltgwae@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 12, 2022 at 12:08:36AM -0700, Eric Biggers wrote:
> 
> Is the special reproducer really needed?  I'd expect this to be reproduced by
> the existing crypto self-tests just by booting a kernel built with both
> CONFIG_KASAN=y and CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.
> 

Ah, probably the self-tests don't find this because with poly1305 the key is
actually read from the "data", and for the self-tests the data addresses happens
to always be in the kernel direct map, so KASAN doesn't work for it (I think).
Ideally the self-tests would test with kmalloc'ed data buffers too, or a buffer
in vmalloc'ed memory that's directly followed by a guard page.

- Eric
