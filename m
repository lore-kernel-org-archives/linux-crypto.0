From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH] crypto: s5p-sss: fix incorrect usage of scatterlists api
Date: Tue, 26 Apr 2016 09:45:32 +0200
Message-ID: <571F1C9C.9060205@samsung.com>
References: <1461655766-27346-1-git-send-email-m.szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	stable@vger.kernel.org
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-reply-to: <1461655766-27346-1-git-send-email-m.szyprowski@samsung.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 04/26/2016 09:29 AM, Marek Szyprowski wrote:
> sg_dma_len() macro can be used only on scattelists which are mapped, so
> all calls to it before dma_map_sg() are invalid. Replace them by proper
> check for direct sg segment length read.
> 
> Fixes: a49e490c7a8a ("crypto: s5p-sss - add S5PV210 advanced crypto engine support")
> Fixes: 9e4a1100a445 ("crypto: s5p-sss - Handle unaligned buffers")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/crypto/s5p-sss.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof
