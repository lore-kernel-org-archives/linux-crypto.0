From: Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH 2/2] crypto: s5p-sss - Use memcpy_toio for iomem annotated
 memory
Date: Wed, 13 Jan 2016 05:01:46 +0200
Message-ID: <5695BE1A.20400@mleia.com>
References: <1452512751-4084-1-git-send-email-k.kozlowski.k@gmail.com> <1452512751-4084-2-git-send-email-k.kozlowski.k@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452512751-4084-2-git-send-email-k.kozlowski.k@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 11.01.2016 13:45, Krzysztof Kozlowski wrote:
> Use memcpy_toio to fix following sparse warning:
> 
> drivers/crypto/s5p-sss.c:386:40: warning: incorrect type in argument 1 (different address spaces)
> drivers/crypto/s5p-sss.c:386:40:    expected void *<noident>
> drivers/crypto/s5p-sss.c:386:40:    got void [noderef] <asn:2>*
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
> ---
>  drivers/crypto/s5p-sss.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Acked-by: Vladimir Zapolskiy <vz@mleia.com>

With best wishes,
Vladimir
