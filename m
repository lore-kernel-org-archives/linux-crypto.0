Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A35EB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jun 2023 10:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240978AbjFPK61 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jun 2023 06:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244639AbjFPK6O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2023 06:58:14 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C30468E;
        Fri, 16 Jun 2023 03:51:31 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qA6n9-003mBe-Da; Fri, 16 Jun 2023 18:34:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Jun 2023 18:34:55 +0800
Date:   Fri, 16 Jun 2023 18:34:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Heiko Stuebner <heiko@sntech.de>
Cc:     palmer@dabbelt.com, paul.walmsley@sifive.com,
        aou@eecs.berkeley.edu, davem@davemloft.net,
        conor.dooley@microchip.com, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        christoph.muellner@vrull.eu,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: Re: [PATCH v5 4/4] RISC-V: crypto: add accelerated GCM GHASH
 implementation
Message-ID: <ZIw6z7MNJ8Nq1q+k@gondor.apana.org.au>
References: <20230612210442.1805962-1-heiko.stuebner@vrull.eu>
 <20230612210442.1805962-5-heiko.stuebner@vrull.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612210442.1805962-5-heiko.stuebner@vrull.eu>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 12, 2023 at 11:04:42PM +0200, Heiko Stuebner wrote:
>
> +struct riscv64_ghash_ctx {
> +	void (*ghash_func)(u64 Xi[2], const u128 Htable[16],
> +			   const u8 *inp, size_t len);
> +
> +	/* key used by vector asm */
> +	u128 htable[16];
> +	/* key used by software fallback */
> +	be128 key;

Where is the fallback?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
