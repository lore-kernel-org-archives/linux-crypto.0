Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41561C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 07:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 020B964FE8
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 07:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCJHJ0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Mar 2021 02:09:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhCJHJN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Mar 2021 02:09:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3575D64F79;
        Wed, 10 Mar 2021 07:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615360153;
        bh=2ejpDQ6nuMFlVHCgovqC7k+L3svcA3KLqYxU3edplVg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JkvSSEb9JvkV0rabZRuafFGNyFs6JYnser8vb62WJ0k8CY7XDo+jlU2o0Q5HchSkt
         vb4ux211TMrfgNT/kuIkiWE2NSI8/ICAz001gnxgqXedckmmLZDgwm+200tCDhzuZo
         ZJZqfI/La0lnkqALdTspUP6ypU4f6VVimul/DyEhuuMl+DoVV43D0w+mfbV30WsEoU
         r2KtY0Rw1lt+b6OQx8CEHfdd+ov7NFKl68E5G5NQ5aHJHzc7/Ou87yCQjlBvdCRaSp
         LHx2jYE5vVNoNg2qYCRwxEbyB1ObczIftFcX47Fbts5S0whO8cj9ADEDKMCDoSQTur
         7y/NpAF37s0wA==
Date:   Tue, 9 Mar 2021 23:09:10 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Nicolas Pitre <nico@fluxnic.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 1/2] crypto: arm/aes-scalar - switch to common
 rev_32/mov_l macros
Message-ID: <YEhwlpKroXxo1hsT@sol.localdomain>
References: <20210307165424.165188-1-ardb@kernel.org>
 <20210307165424.165188-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307165424.165188-2-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 07, 2021 at 05:54:23PM +0100, Ard Biesheuvel wrote:
> The scalar AES implementation has some locally defined macros which
> reimplement things that are now available in macros defined in
> assembler.h. So let's switch to those.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Reviewed-by: Nicolas Pitre <nico@fluxnic.net>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Eric Biggers <ebiggers@google.com>

Although likewise, shouldn't the commit title say "rev_l" instead of "rev_32"?

- Eric
