From: Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH] crypto: s5p-sss - Use consistent indentation for
 variables and members
Date: Sat, 28 May 2016 22:33:36 +0300
Message-ID: <5749F290.1010205@mleia.com>
References: <1464349780-27674-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464349780-27674-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Krzysztof,

On 27.05.2016 14:49, Krzysztof Kozlowski wrote:
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

it looks like a trivial and nice change, thank you.

Acked-by: Vladimir Zapolskiy <vz@mleia.com>
