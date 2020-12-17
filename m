Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81172C4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 18:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D5E2238EF
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 18:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbgLQSgO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 13:36:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728704AbgLQSgO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 13:36:14 -0500
Date:   Thu, 17 Dec 2020 10:35:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608230134;
        bh=bsgEVksB18d9gZCVq8tL2GRU8y8mcH/PO5uuLzrab3w=;
        h=From:To:Subject:References:In-Reply-To:From;
        b=VeO38e7BGfZhrMCm7wp1pPgiZh/eXur5evzt+1zMgD9+gcV0g+0RLmtH1v3JbhMcw
         DQHnAU6OErubQKTHeYhhyQ7F+/wizFaymnRy4y6lJo5c4FCKWDNzDS4iVnz7Ldqkvi
         GgRt/ZxgJaHkHC+EEnb4DaJMaMEuD8DdJoFL1VPyOUfV895+kOWaNWCOfFwOwc126v
         HozPi8anfaA2PiAxFYjP06t/w6/ug3ZKDgsL+bfx5voK12rBOfpnKYvgTeb46BR/gM
         eIvbMt7NofefKPltRxtV7CRzg0JQj5ABZldw84B8Ca4dgtgcbH6n4zc/rEtVx/X7yO
         xBi0I4M3lil2w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     dsterba@suse.cz, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH 2/5] crypto: blake2b - define shash_alg structs using
 macros
Message-ID: <X9uk9KTpEUJkcr/T@sol.localdomain>
References: <20201215234708.105527-1-ebiggers@kernel.org>
 <20201215234708.105527-3-ebiggers@kernel.org>
 <20201217171517.GT6430@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217171517.GT6430@suse.cz>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 17, 2020 at 06:15:17PM +0100, David Sterba wrote:
> On Tue, Dec 15, 2020 at 03:47:05PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > The shash_alg structs for the four variants of BLAKE2b are identical
> > except for the algorithm name, driver name, and digest size.  So, avoid
> > code duplication by using a macro to define these structs.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 
> > +static struct shash_alg blake2b_algs[] = {
> > +	BLAKE2B_ALG("blake2b-160", "blake2b-160-generic",
> > +		    BLAKE2B_160_HASH_SIZE),
> 
> Spelling out the algo names as string is better as it is greppable and
> matches the module name, compared to using the #stringify macro
> operator.
> 

Yes, I considered trying to make it so that BLAKE2B_ALG(n) would generate the
names and constant for blake2b-$n, but it seemed better to keep it greppable.

- Eric
