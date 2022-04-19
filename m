Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214D6C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Apr 2022 04:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348368AbiDSEgu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Apr 2022 00:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348346AbiDSEgr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Apr 2022 00:36:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C89A2F03D
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 21:33:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67DA4B81135
        for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2022 04:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4DCC385A5;
        Tue, 19 Apr 2022 04:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650342832;
        bh=ERbTfVr1p9Bgf4ihbKXPpcYlphiEnr4Iq3Ts3RgKnis=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=md2CRBcbakRo8UESItuhDI59RmyYFJmR5RcWQ7xb4BtSZWh+WJLFYtssc0Aevc1Qv
         NfVoZSuD8c3/bdwqvdknTWxLd858yJk0b3BSWzCZyANzjmoz448jfVy6mNUzjHlWV6
         xWeUT6HbgWCv5Kbmw/9E4tJMu3sxzWxOBhUc7J2LD7LvRrJDgQ7eX8JAcOSZQkyyQ5
         N68oYTiXZC9Ox0Y7L0qdi7Jmqdx3jF6ePsQPvTPbuBpr1TW8kU5ChI1wraN3TcXN5D
         XSxmV3vAqiUbEFtkN4gZiHvqVbCGsiW8HTwmt0MDygzZgPZaTEq7LC/l/OLto+UGht
         kbMvfj30aBkXg==
Date:   Mon, 18 Apr 2022 21:33:50 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 5/8] crypto: arm64/aes-xctr: Add accelerated
 implementation of XCTR
Message-ID: <Yl47rptSdSetygym@sol.localdomain>
References: <20220412172816.917723-1-nhuck@google.com>
 <20220412172816.917723-6-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412172816.917723-6-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 12, 2022 at 05:28:13PM +0000, Nathan Huckleberry wrote:
> diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
> index dc35eb0245c5..ac37e2f7ca84 100644
> --- a/arch/arm64/crypto/aes-modes.S
> +++ b/arch/arm64/crypto/aes-modes.S
> @@ -479,6 +479,140 @@ ST5(	mov		v3.16b, v4.16b			)
>  	b		.Lctrout
>  AES_FUNC_END(aes_ctr_encrypt)
>  
> +	/*
> +	 * aes_xctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
> +	 *		   int bytes, u8 const ctr[], u8 finalbuf[], int
> +	 *		   byte_ctr)
> +	 */
> +

What is the 'finalbuf' parameter for?  It is never used.

Why is byte_ctr an 'int' here but an 'unsigned int' in the .c file?

It looks like 'ctr' is actually the IV; perhaps it should be called 'iv' to
distinguish it from the byte_ctr?

As mentioned elsewhere, please don't have a line break between a parameter's
type and name.

Generally, comments and register aliases would be super helpful throughout the
code.  As-is, this is much harder to read than the x86 version...

Also, this function is heavily duplicated with aes_ctr_encrypt.  Did you
consider generating both from a single macro, like you did with the x86 version?

> +	umov		x12, vctr.d[0]		/* keep ctr in reg */

/* keep first 8 bytes of IV in reg */

> +	lsr		x7, x7, #4

x7 needs to be w7, since it corresponds to a 32-bit parameter ('int byte_ctr').
The upper 32 bits of the register are not guaranteed to be zero.

> +	sub		x7, x11, #MAX_STRIDE
> +	eor		x7, x12, x7
> +	ins		v0.d[0], x7
> +	sub		x7, x11, #MAX_STRIDE - 1
> +	sub		x8, x11, #MAX_STRIDE - 2
> +	eor		x7, x7, x12
> +	sub		x9, x11, #MAX_STRIDE - 3
> +	mov		v1.d[0], x7
> +	eor		x8, x8, x12
> +	eor		x9, x9, x12
> +ST5(	sub		x10, x11, #MAX_STRIDE - 4)
> +	mov		v2.d[0], x8
> +	eor		x10, x10, x12
> +	mov		v3.d[0], x9
> +ST5(	mov		v4.d[0], x10			)

There seem to be some unnecessarily tight instruction dependencies here.  E.g.,
the first 3 instructions are all sequential.  Are there not enough free
registers to write it otherwise?  I.e. do all the sub's first, then the eor's,
then the mov's.

The trailing parenthesis after #MAX_STRIDE - 4 should be indented another level.
As-is it looks like a typo.

Why does one place use 'ins' and the others use 'mov'?

- Eric
