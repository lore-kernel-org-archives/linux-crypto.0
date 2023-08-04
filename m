Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C5AC001DE
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Aug 2023 08:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbjHDIVm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Aug 2023 04:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbjHDIVl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Aug 2023 04:21:41 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51489E6E
        for <linux-crypto@vger.kernel.org>; Fri,  4 Aug 2023 01:21:40 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qRq3y-003ZoP-IB; Fri, 04 Aug 2023 16:21:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Aug 2023 16:21:34 +0800
Date:   Fri, 4 Aug 2023 16:21:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christoph =?iso-8859-1?Q?M=FCllner?= 
        <christoph.muellner@vrull.eu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: Re: [PATCH] crypto: riscv/aes - Implement scalar Zkn version for RV32
Message-ID: <ZMy1DkYRBc1PxC8e@gondor.apana.org.au>
References: <20230726172958.1215472-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230726172958.1215472-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 26, 2023 at 07:29:58PM +0200, Ard Biesheuvel wrote:
> The generic AES implementation we rely on if no architecture specific
> one is available relies on lookup tables that are relatively large with
> respect to the typical L1 D-cache size, which not only affects
> performance, it may also result in timing variances that correlate with
> the encryption keys.
> 
> So we tend to avoid the generic code if we can, usually by using a
> driver that makes use of special AES instructions which supplant most of
> the logic of the table based implementation the AES algorithm.
> 
> The Zkn RISC-V extension provides another interesting take on this: it
> defines instructions operating on scalar registers that implement the
> table lookups without relying on tables in memory. Those tables carry
> 32-bit quantities, making them a natural fit for a 32-bit architecture.
> And given the use of scalars, we don't have to rely in in-kernel SIMD,
> which is a bonus.
> 
> So let's use the instructions to implement the core AES cipher for RV32.
> 
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Christoph Müllner <christoph.muellner@vrull.eu>
> Cc: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/riscv/crypto/Kconfig             |  12 ++
>  arch/riscv/crypto/Makefile            |   3 +
>  arch/riscv/crypto/aes-riscv32-glue.c  |  75 ++++++++++++
>  arch/riscv/crypto/aes-riscv32-zkned.S | 119 ++++++++++++++++++++
>  4 files changed, 209 insertions(+)

Hi Ard:

Any chance you could postpone this til after I've finished removing
crypto_cipher?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
