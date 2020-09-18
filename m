Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C0AC43463
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 21:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 534E62311C
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 21:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600466231;
	bh=M2ymt5VyVluo+swpXbiQnd51bPzkhNt3xUmhoufvUIY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ifSmaCSMJwmGvXGXbhx3TwhqWleWfEM5etuKutcZWqATL0NGDcIM4ppuJWy7dTnN5
	 0LaMWV6l4aC4LXJRUj78GmgqaqdOzLTouoFxMM7StqV3ucivZ6YsBsa/NB36LCiWhM
	 K3PFidFB7OUlmS96q+t4XCl5mkjYmYaJPg4THU6k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgIRV5K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 17:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbgIRV5H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 17:57:07 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E946B208DB;
        Fri, 18 Sep 2020 21:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600466227;
        bh=M2ymt5VyVluo+swpXbiQnd51bPzkhNt3xUmhoufvUIY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MXG/PwQbkKmRQDF6rZe4IAiHFw0J6P90zyPelaUywAme1vDb4BxX3c88acDOiJMZ8
         do3OvgMIQFNBkwDdG7oe0fTEx3Iv0MGu+C/sppq/2GHvir9qA95vMCmjG2wGP7ljLD
         zqIFxS1iCmprqDlWh56VA6sACsNE3o7Mpp12S51k=
Date:   Fri, 18 Sep 2020 14:57:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] random: initialize ChaCha20 constants with correct
 endianness
Message-ID: <20200918215705.GA126697@gmail.com>
References: <20200916045013.142179-1-ebiggers@kernel.org>
 <20200918204207.GC80112@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918204207.GC80112@mit.edu>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 18, 2020 at 04:42:07PM -0400, Theodore Y. Ts'o wrote:
>
> We're currently not bothering to deal with Endian conversions with the counter

Endianness conversion for the counter isn't needed because the implementation
only treats it as words, not as bytes.

(Exception: the counter does get filled with random bytes.  But that doesn't
matter, since they're random bytes.)

> we're using a 64-bit counter, instead of a 32-bit counter.

The original ChaCha paper (https://cr.yp.to/chacha/chacha-20080128.pdf) uses a
64-bit counter.  RFC 7539 decided to reduce it to 32-bit and expand the nonce to
96-bit.  So there are two variants, and we're using the original variant.

Alternatively, we're using RFC 7539 where we happen to increment the nonce each
time the counter wraps to 0.  That's an equivalent interpretation.

> We also twiddle 32-bits of the state (crng->state[14]) by XOR'ing it with
> RDRAND if available at each round, which is also a spec violation.

It's not after each ChaCha round, but rather after generating each block of
output.  ChaCha expands each key into 2^64 randomly accessible streams, each
containing 2^64 randomly accessible 64-byte blocks.  (Alternatively, RFC 7539
interprets those same 2^128 blocks as 2^96 streams, each with 2^32 blocks.)

So basically the output of the CRNG is:

	ChaCha20(key=k, counter=n, nonce=random(), len=64)
	ChaCha20(key=k, counter=n+1, nonce=random(), len=64)
	ChaCha20(key=k, counter=n+2, nonce=random(), len=64)

instead of:

	ChaCha20(key=k, counter=n, nonce=random(), len=<very large>)

It's still ChaCha20.  It's just that instead of doing one big invocation of
ChaCha20 where we take lots of consecutive blocks from a single stream, we do a
lot of smaller invocations where we take output from randomly selected streams.

> WE also initialize the counter to be a random value, using the
> input_pool or the primary crng state (if we are initializing the
> secondary state), but given that the specification says _usually_ zero
> or one, that's not an out-and-out spec violation.

The original ChaCha paper doesn't say that the counter has to be initialized to
0.  It just says each key generates 2^64 randomly accessible streams, each
containing 2^64 randomly accessible 64-byte blocks.  Naturally, most users want
to start the counter at 0, but that's not a *requirement*.

> I have no objections to changing things so that the first 4 words of
> the crng state are more ChaCha-20-like, on the theory that most of the
> cryptoanlysis work (both positive and negative) have been done with
> the little-endian version of "expand 32-byte k".  I don't think it
> really makes a difference, either positively or negatively.  But
> technically we'd *still* not be using ChaCha20.  We could say that
> we're using the ChaCha20 block function, regardless.

The endianness of the constants is the only thing that makes it so that the CRNG
isn't necessarily actually using ChaCha20 as defined by the original paper.
Everything else is just different ways of describing the series of calls that
are made to the ChaCha20 block function.

- Eric
