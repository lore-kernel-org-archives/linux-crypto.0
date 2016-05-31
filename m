From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: s5p-sss - Use consistent indentation for
 variables and members
Date: Tue, 31 May 2016 18:19:54 +0800
Message-ID: <20160531101954.GN15376@gondor.apana.org.au>
References: <1464349780-27674-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, Vladimir Zapolskiy <vz@mleia.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464349780-27674-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 27, 2016 at 01:49:40PM +0200, Krzysztof Kozlowski wrote:
> Bring some consistency by:
> 1. Replacing fixed-space indentation of structure members with just
>    tabs.
> 2. Remove indentation in declaration of local variable between type and
>    name.  Driver was mixing usage of such indentation and lack of it.
>    When removing indentation, reorder variables in
>    reversed-christmas-tree order with first variables being initialized
>    ones.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
