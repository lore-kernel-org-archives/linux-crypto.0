Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0AAC433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Feb 2022 18:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiBASSw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Feb 2022 13:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbiBASSk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Feb 2022 13:18:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC73C061759
        for <linux-crypto@vger.kernel.org>; Tue,  1 Feb 2022 10:18:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF6D261344
        for <linux-crypto@vger.kernel.org>; Tue,  1 Feb 2022 18:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8958C340ED;
        Tue,  1 Feb 2022 18:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643739519;
        bh=r6MEhJpQpa0z0aEWBKP/io+VfdeSVl2F4rwHr/pmlFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ee+BBXNJ+ztAgXhUhfF8o83N57ely/4P3XhzY6Yx2lksMQC6gz68nhldKxQOPSejU
         e1j6N87+9cL15xzoptfbsmvvMudsYFLTMucggl+XxXX3t/mcqYC4er0nOZqxRAxvMs
         NPacOeiFGaCx2yUFTpsQr+0Kjw59heElvkizDyhojMuZWdni/M16UsOse/jzQ+Ln1L
         C7hu3YgYJoDudREw7RrMU02LNBRENpfcnuDoqE6wWK8woc7l3TPLhB3CyruVZDHtuW
         xzKzGN+5tLddOCkmUt8Z9HcrJRVpxSursrDIQRhiTscxzTHPCQi3uvTbEo77jqwl6f
         T3yyjHbUbHc5A==
Date:   Tue, 1 Feb 2022 10:18:37 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH 6/7] crypto: x86/polyval: Add PCLMULQDQ accelerated
 implementation of POLYVAL
Message-ID: <Yfl5fRbt8cIwk6Jn@sol.localdomain>
References: <20220125014422.80552-1-nhuck@google.com>
 <20220125014422.80552-7-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125014422.80552-7-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 24, 2022 at 07:44:21PM -0600, Nathan Huckleberry wrote:
> Add hardware accelerated version of POLYVAL for x86-64 CPUs with
> PCLMULQDQ support.
> 
> This implementation is accelerated using PCLMULQDQ instructions to
> perform the finite field computations.  For added efficiency, 8 blocks
> of the plaintext are processed simultaneously by precomputing the first
> 8 powers of the key.
> 
> Schoolbook multiplication is used instead of Karatsuba multiplication
> because it was found to be slightly faster on x86-64 machines.
> Montgomery reduction must be used instead of Barrett reduction due to
> the difference in modulus between POLYVAL's field and other finite
> fields.
> 
> More information on POLYVAL can be found in the HCTR2 paper:
> Length-preserving encryption with HCTR2:
> https://eprint.iacr.org/2021/1441.pdf
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> ---
>  arch/x86/crypto/Makefile                     |   3 +
>  arch/x86/crypto/polyval-clmulni-intel_asm.S  | 319 +++++++++++++++++++

This file is causing a build-time warning:

	arch/x86/crypto/polyval-clmulni-intel_asm.o: warning: objtool: .text+0x0: unreachable instruction

- Eric
