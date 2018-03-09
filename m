From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: omap-sham: Remove useless check for non-null
 request
Date: Fri, 9 Mar 2018 23:19:53 +0800
Message-ID: <20180309151952.GG13567@gondor.apana.org.au>
References: <1519937413-24468-1-git-send-email-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Tero Kristo <t-kristo@ti.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1519937413-24468-1-git-send-email-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Mar 01, 2018 at 09:50:10PM +0100, Krzysztof Kozlowski wrote:
> ahash_request 'req' argument passed by the caller
> omap_sham_handle_queue() cannot be NULL here because it is obtained from
> non-NULL pointer via container_of().
> 
> This fixes smatch warning:
>     drivers/crypto/omap-sham.c:812 omap_sham_prepare_request() warn: variable dereferenced before check 'req' (see line 805)
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
