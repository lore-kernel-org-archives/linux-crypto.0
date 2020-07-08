Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B78C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 02:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C45042078B
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 02:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594175470;
	bh=deOqMgE6ri2ZQxDhkOiWPPcblPJS6MGFDkts87mWmsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=xSTZ13dRAYI9TrGNzgaGfVxuRqXp4jkqTQyDFycSFStUZDxA5GnZ/OU6EtcVuY6Cd
	 C+sJE8xjBhthZa32nHE5WNeQBID9FKCAXs/kUDDLXJPf6SJ6EWWJIMhGczAbi1aAPY
	 EXnDuKeUdwm8B++/4Ag0FjhxxMZwI6oYJ/hlU5oI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgGHCbK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jul 2020 22:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728366AbgGHCbK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jul 2020 22:31:10 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6CB720774;
        Wed,  8 Jul 2020 02:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594175469;
        bh=deOqMgE6ri2ZQxDhkOiWPPcblPJS6MGFDkts87mWmsw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AuyloZ1WUtC7nPR//VlWSDpgMfzctdo1HW4xOJy8aKgyyU1L0hQdOOmQ+i8WbxYcz
         Vh8izWn7dDqyoBk2GzT7k5jizGVtGwX9vUUBQNF2NBn6O6ZzZPWla6vbAgjt2/qGSE
         w8Qor0QXBlm6n3bvUlgw8roTV2/uXyTtpljagQ50=
Date:   Tue, 7 Jul 2020 19:31:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH] crypto: chacha - Add DEFINE_CHACHA_STATE macro
Message-ID: <20200708023108.GK839@sol.localdomain>
References: <20200706133733.GA6479@gondor.apana.org.au>
 <20200706190717.GB736284@gmail.com>
 <20200706223716.GA10958@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706223716.GA10958@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 07, 2020 at 08:37:16AM +1000, Herbert Xu wrote:
> On Mon, Jul 06, 2020 at 12:07:17PM -0700, Eric Biggers wrote:
> >
> > This changes chacha_state to be a pointer, which breaks clearing the state
> > because that uses sizeof(chacha_state):
> > 
> > 	memzero_explicit(chacha_state, sizeof(chacha_state));
> > 
> > It would need to be changed to use CHACHA_BLOCK_SIZE.
> 
> Good catch.  Thanks! Here's an update:
> 
> ---8<---
> As it stands the chacha state array is made 12 bytes bigger on
> x86 in order for it to be 16-byte aligned.  However, the array
> is not actually aligned until it hits the x86 code.
> 
> This patch moves the alignment to where the state array is defined.
> To do so a macro DEFINE_CHACHA_STATE has been added which takes
> care of all the work to ensure that it is actually aligned on the
> stack.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Hmm, __chacha20poly1305_encrypt() already uses:

	memzero_explicit(chacha_state, CHACHA_STATE_WORDS * sizeof(u32));

That's equivalent to CHACHA_BLOCK_SIZE now, but it would be best to use the same
constant everywhere.  Can you pick one or the other to use?

Also, in chacha20poly1305-selftest.c there's a state array that needs to be
converted to use the new macro:

        u32 chacha20_state[CHACHA_STATE_WORDS];

- Eric
