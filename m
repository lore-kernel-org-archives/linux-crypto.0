Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29179C001B0
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jul 2023 17:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjGGR6Q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Jul 2023 13:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbjGGR6P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2023 13:58:15 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637FF170F;
        Fri,  7 Jul 2023 10:58:09 -0700 (PDT)
Received: from i53875a50.versanet.de ([83.135.90.80] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1qHpiL-0001bc-JS; Fri, 07 Jul 2023 19:57:53 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     palmer@dabbelt.com, paul.walmsley@sifive.com,
        aou@eecs.berkeley.edu, davem@davemloft.net,
        conor.dooley@microchip.com, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        christoph.muellner@vrull.eu
Subject: Re: [PATCH v5 4/4] RISC-V: crypto: add accelerated GCM GHASH implementation
Date:   Fri, 07 Jul 2023 19:57:52 +0200
Message-ID: <2640941.X9hSmTKtgW@diego>
In-Reply-To: <ZIw6z7MNJ8Nq1q+k@gondor.apana.org.au>
References: <20230612210442.1805962-1-heiko.stuebner@vrull.eu>
 <20230612210442.1805962-5-heiko.stuebner@vrull.eu>
 <ZIw6z7MNJ8Nq1q+k@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 16. Juni 2023, 12:34:55 CEST schrieb Herbert Xu:
> On Mon, Jun 12, 2023 at 11:04:42PM +0200, Heiko Stuebner wrote:
> >
> > +struct riscv64_ghash_ctx {
> > +	void (*ghash_func)(u64 Xi[2], const u128 Htable[16],
> > +			   const u8 *inp, size_t len);
> > +
> > +	/* key used by vector asm */
> > +	u128 htable[16];
> > +	/* key used by software fallback */
> > +	be128 key;
> 
> Where is the fallback?

Thanks for catching this. The fallback is of course not needed for the
Zbc-based variants but only for the future vector-based variants.

So this should not be in here but instead get added once its user is too.
I've moved this over to that part, that I'll post separately.

Heiko


