Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A4BC43463
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 20:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F795221EC
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 20:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgIRUvr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 16:51:47 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37712 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726267AbgIRUvr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 16:51:47 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 16:51:47 EDT
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 08IKg8qd028653
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 16:42:08 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id D318342003C; Fri, 18 Sep 2020 16:42:07 -0400 (EDT)
Date:   Fri, 18 Sep 2020 16:42:07 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] random: initialize ChaCha20 constants with correct
 endianness
Message-ID: <20200918204207.GC80112@mit.edu>
References: <20200916045013.142179-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916045013.142179-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 15, 2020 at 09:50:13PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> On big endian CPUs, the ChaCha20-based CRNG is using the wrong
> endianness for the ChaCha20 constants.
> 
> This doesn't matter cryptographically, but technically it means it's not
> ChaCha20 anymore.  Fix it to always use the standard constants.

I'll note that we're not technically ChaCha20 in terms of how we
handle the IV.  ChaCha20 is defined as having a 96 bit IV and a 32-bit
counter.  The counter is "usually initialized to be zero or one" (per
RFC 7539) and the counter is defined to be Little Endian.

We're currently not bothering to deal with Endian conversions with the
counter, and we're using a 64-bit counter, instead of a 32-bit
counter.  We also twiddle 32-bits of the state (crng->state[14]) by
XOR'ing it with RDRAND if available at each round, which is also a
spec violation.

WE also initialize the counter to be a random value, using the
input_pool or the primary crng state (if we are initializing the
secondary state), but given that the specification says _usually_ zero
or one, that's not an out-and-out spec violation.

As far as the other deviations / "spec violations" from ChaCha-20 are
concerned...  I'm "sorry not sorry".  :-)

I have no objections to changing things so that the first 4 words of
the crng state are more ChaCha-20-like, on the theory that most of the
cryptoanlysis work (both positive and negative) have been done with
the little-endian version of "expand 32-byte k".  I don't think it
really makes a difference, either positively or negatively.  But
technically we'd *still* not be using ChaCha20.  We could say that
we're using the ChaCha20 block function, regardless.

Cheers,

						- Ted
