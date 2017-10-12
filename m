From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/4] crypto: Add driver for JZ4780 PRNG
Date: Thu, 12 Oct 2017 22:30:11 +0800
Message-ID: <20171012143011.GA30173@gondor.apana.org.au>
References: <20170918140241.24003-1-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: robh+dt@kernel.org, ralf@linux-mips.org, davem@davemloft.net,
        paul@crapouillou.net, linux-crypto@vger.kernel.org,
        linux-mips@linux-mips.org, malat@debian.org, noloader@gmail.com
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37248 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbdJLOal (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2017 10:30:41 -0400
Content-Disposition: inline
In-Reply-To: <20170918140241.24003-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 18, 2017 at 07:32:37PM +0530, PrasannaKumar Muralidharan wrote:
> This patch series adds support of pseudo random number generator found
> in Ingenic's JZ4780 and X1000 SoC.
> 
> Create cgublock node which has CGU and RNG node as its children. The
> cgublock node uses "simple-bus" compatible which helps in exposing CGU
> and RNG nodes without changing CGU driver. Add 'syscon' compatible in
> CGU node in jz4780.dtsi. The jz4780-rng driver uses regmap exposed via
> syscon interface to access the RNG registers. CGU driver is not
> modified in this patch set as registers used by CGU driver and this
> driver are different.
> 
> PrasannaKumar Muralidharan (4):
>   crypto: jz4780-rng: Add JZ4780 PRNG devicetree binding documentation
>   crypto: jz4780-rng: Add Ingenic JZ4780 hardware PRNG driver
>   crypto: jz4780-rng: Add RNG node to jz4780.dtsi
>   crypto: jz4780-rng: Enable PRNG support in CI20 defconfig

Please indicate which patches are intended to go through the crypto
trees.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
