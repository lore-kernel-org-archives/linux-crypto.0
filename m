From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: s5p-sss.c: Fix kernel Oops in AES-ECB mode
Date: Thu, 15 Feb 2018 23:53:13 +0800
Message-ID: <20180215155312.GR7352@gondor.apana.org.au>
References: <CGME20180207155211eucas1p2d8d04871aaeb49efc30909d46e47e028@eucas1p2.samsung.com>
 <77384548-9870-40b8-46fc-4bd62747efd6@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Anand Moon <linux.amoon@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <77384548-9870-40b8-46fc-4bd62747efd6@partner.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 07, 2018 at 04:52:09PM +0100, Kamil Konieczny wrote:
> In AES-ECB mode crypt is done with key only, so any use of IV
> can cause kernel Oops. Use IV only in AES-CBC and AES-CTR.
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> Reported-by: Anand Moon <linux.amoon@gmail.com>
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> Tested-by: Anand Moon <linux.amoon@gmail.com>
> Cc: stable@vger.kernel.org # can be applied after commit 8f9702aad138
> 
> ---
> version 3:
> Change commit message: drop 'Fixes: 8f9702aad138' as the error was
> introduced earlier.

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
