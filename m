Return-Path: <SRS0=juXm=2K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62897C43603
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 07:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4027724679
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 07:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfLTHJ4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Dec 2019 02:09:56 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:59040 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbfLTHJ4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Dec 2019 02:09:56 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iiCQ1-0000Ar-1m; Fri, 20 Dec 2019 15:09:49 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iiCPz-0007uD-82; Fri, 20 Dec 2019 15:09:47 +0800
Date:   Fri, 20 Dec 2019 15:09:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mark Brown <broonie@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] arm64: crypto: Use modern annotations for assembly
 functions
Message-ID: <20191220070947.5me6oi2nqrinigao@gondor.apana.org.au>
References: <20191213154910.32479-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213154910.32479-1-broonie@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 13, 2019 at 03:49:10PM +0000, Mark Brown wrote:
> In an effort to clarify and simplify the annotation of assembly functions
> in the kernel new macros have been introduced. These replace ENTRY and
> ENDPROC and also add a new annotation for static functions which previously
> had no ENTRY equivalent. Update the annotations in the crypto code to the
> new macros.
> 
> There are a small number of files imported from OpenSSL where the assembly
> is generated using perl programs, these are not currently annotated at all
> and have not been modified.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> 
> I'm intending to do this for all the rest of the asm too, this is the
> simplest directory and there's no direct interdependencies so starting
> here.
> 
>  arch/arm64/crypto/aes-ce-ccm-core.S   | 16 +++++------
>  arch/arm64/crypto/aes-ce-core.S       | 16 +++++------
>  arch/arm64/crypto/aes-ce.S            |  4 +--
>  arch/arm64/crypto/aes-cipher-core.S   |  8 +++---
>  arch/arm64/crypto/aes-modes.S         | 16 +++++------
>  arch/arm64/crypto/aes-neon.S          |  4 +--
>  arch/arm64/crypto/aes-neonbs-core.S   | 40 +++++++++++++--------------
>  arch/arm64/crypto/chacha-neon-core.S  | 16 +++++------
>  arch/arm64/crypto/crct10dif-ce-core.S | 12 ++++----
>  arch/arm64/crypto/ghash-ce-core.S     |  8 +++---
>  arch/arm64/crypto/nh-neon-core.S      |  4 +--
>  arch/arm64/crypto/sha1-ce-core.S      |  4 +--
>  arch/arm64/crypto/sha2-ce-core.S      |  4 +--
>  arch/arm64/crypto/sha3-ce-core.S      |  4 +--
>  arch/arm64/crypto/sha512-ce-core.S    |  4 +--
>  arch/arm64/crypto/sm3-ce-core.S       |  4 +--
>  arch/arm64/crypto/sm4-ce-core.S       |  4 +--
>  17 files changed, 84 insertions(+), 84 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
