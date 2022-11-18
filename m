Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F00D3C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241700AbiKRJGD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbiKRJGC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:06:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EC313D4F
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 01:06:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52DE9623B2
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 09:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA63C433C1;
        Fri, 18 Nov 2022 09:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668762360;
        bh=AmskJwnFjVeOdt9cZPfGQ0GR5lO8GyHsCR8+zJUUzik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FSx3eVetBK2yfWCWPAEzS369Scr3LHzew8d3Yqvn+m25lfub2EMW/CEAt3kAyCJgp
         QUZUSmElrpjBJuHQ25uneJjwRUU8AHksBUxPiypR/+2c9duOe13KCip3KZpvKqWtNY
         Xu9b5dd3Qgh9rrPCbdWIIEOsEjC2vUTcFQg7ppVU/kvVKkEJGXmVp8+Kpu73Tgs4rE
         W6P9UGrg26co1ifjrrTVcjv5+YMG9OaRB8vpiobRl36kqLaN5NilTn0sjZncUqvQyH
         6tMwZQ1ho096WXL3ksHzoPnV07yK5FRPx9wopZCrzxp9kfBQGVCNbg3TyuTlbcXmvw
         X0Nzd3DZJ4zTA==
Date:   Fri, 18 Nov 2022 01:05:58 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi
Subject: Re: [PATCH v5 3/4] crypto: aria: implement aria-avx2
Message-ID: <Y3dK9hHXZSgpVdV1@sol.localdomain>
References: <20221118072252.10770-1-ap420073@gmail.com>
 <20221118072252.10770-4-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118072252.10770-4-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 18, 2022 at 07:22:51AM +0000, Taehee Yoo wrote:
> +SYM_FUNC_START(aria_aesni_avx2_encrypt_32way)

Please use SYM_TYPED_FUNC_START (and include <linux/cfi_types.h>) for all
assembly functions that are called via indirect function calls.  Otherwise the
code will crash when built with CONFIG_CFI_CLANG=y.

- Eric
