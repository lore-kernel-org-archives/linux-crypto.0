Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B93C2BBCA
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 20:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B29C239FC
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 20:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbgLPU6W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:58:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbgLPU6W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 15:58:22 -0500
Date:   Wed, 16 Dec 2020 12:57:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608152261;
        bh=viofYwz833+SXySywARvfU6DoIA9TUTOn97MKwUYtnE=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=BI887NRgaOuR+iwG6q094fMoxRDnUezJlQMZlS7fuKeNTqbigsW8DYVLUd2z/r6Y/
         TuoSa9YSnP/v7+wJrIa0UU4PqHqhfActK7EvH56gfKJ6LCaXtplQYAKuoEDuFFjGU1
         X2LkrfxwXzRMC/VHH6jB1hThcS1keWOlpj3Lmr/nkQ94ab6w/rVo82wvQun7c7KX9C
         4WwJ4Z0Ex/R+07z18N7bEgjcOWBYT+Hd0UGFs8PmUPOGwiikOYhpzDHFUb3pX+WhVb
         9m4u/RYO5Vr6dlbb9SOtrtgl7ilPNj0IH+jsffBPzb1V85w7Fy0OB6aHN4u3aoEmJg
         m+ofeKgybtLfQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH 5/5] crypto: arm/blake2b - add NEON-optimized BLAKE2b
 implementation
Message-ID: <X9p0xJ17pCtunLnh@gmail.com>
References: <20201215234708.105527-1-ebiggers@kernel.org>
 <20201215234708.105527-6-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215234708.105527-6-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 15, 2020 at 03:47:08PM -0800, Eric Biggers wrote:
> +// Execute one round of BLAKE2b by updating the state matrix v[0..15] in the
> +// NEON registers q0-q7.  The message block is in q8..q15.  The stack pointer
> +// points to a 32-byte aligned buffer containing a copy of q8 and q9, so that
> +// they can be reloaded if q8 and q9 are used as temporary registers.  The macro
> +// arguments s0-s15 give the order in which the message words are used in this
> +// round.  'final' is "true" if this is the final round, i.e. round 12 of 12.
> +.macro	_blake2b_round	s0, s1, s2, s3, s4, s5, s6, s7, \
> +			s8, s9, s10, s11, s12, s13, s14, s15, final="false"
[...]
> +	// Reloading q8-q9 can be skipped on the final round.
> +.if \final != "true"
> +	vld1.8		{q8-q9}, [sp, :256]
> +.endif
> +.endm
[...]
> +	_blake2b_round 14, 10,  4,  8,  9, 15, 13,  6, \
> +			1, 12,  0,  2, 11,  7, 5,   3,  "true"

Apparently using the strings "true" and "false" here sometimes causes a build
error where they get treated as symbols
(https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/2JPD4H3VFBSKWPUCPEPRAXBVMSR2UCQI/),
though somehow it worked fine for me.  I'll change this to use 1 and 0 instead.

- Eric
