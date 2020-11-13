Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F71C388F9
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 05:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 995A120A8B
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 05:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgKMFK0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Nov 2020 00:10:26 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33682 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgKMFKZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Nov 2020 00:10:25 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kdRLl-0000rU-AU; Fri, 13 Nov 2020 16:10:18 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2020 16:10:17 +1100
Date:   Fri, 13 Nov 2020 16:10:17 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org,
        Eric Biggers <ebiggers@google.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2] crypto: arm/chacha-neon - optimize for non-block size
 multiples
Message-ID: <20201113051017.GC8350@gondor.apana.org.au>
References: <20201103162809.28167-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103162809.28167-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 03, 2020 at 05:28:09PM +0100, Ard Biesheuvel wrote:
> The current NEON based ChaCha implementation for ARM is optimized for
> multiples of 4x the ChaCha block size (64 bytes). This makes sense for
> block encryption, but given that ChaCha is also often used in the
> context of networking, it makes sense to consider arbitrary length
> inputs as well.
> 
> For example, WireGuard typically uses 1420 byte packets, and performing
> ChaCha encryption involves 5 invocations of chacha_4block_xor_neon()
> and 3 invocations of chacha_block_xor_neon(), where the last one also
> involves a memcpy() using a buffer on the stack to process the final
> chunk of 1420 % 64 == 12 bytes.
> 
> Let's optimize for this case as well, by letting chacha_4block_xor_neon()
> deal with any input size between 64 and 256 bytes, using NEON permutation
> instructions and overlapping loads and stores. This way, the 140 byte
> tail of a 1420 byte input buffer can simply be processed in one go.
> 
> This results in the following performance improvements for 1420 byte
> blocks, without significant impact on power-of-2 input sizes. (Note
> that Raspberry Pi is widely used in combination with a 32-bit kernel,
> even though the core is 64-bit capable)
> 
>    Cortex-A8  (BeagleBone)       :   7%
>    Cortex-A15 (Calxeda Midway)   :  21%
>    Cortex-A53 (Raspberry Pi 3)   :   3%
>    Cortex-A72 (Raspberry Pi 4)   :  19%
> 
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> v2:
> - avoid memcpy() if the residual byte count is exactly 64 bytes
> - get rid of register based post increments, and simply rewind the src
>   pointer as needed (the dst pointer did not need the register post
>   increment in the first place)
> - add benchmark results for 32-bit CPUs to commit log.
> 
>  arch/arm/crypto/chacha-glue.c      | 34 +++----
>  arch/arm/crypto/chacha-neon-core.S | 97 ++++++++++++++++++--
>  2 files changed, 107 insertions(+), 24 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
