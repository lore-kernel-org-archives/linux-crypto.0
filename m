From: Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH 2/2] crypto: s5p-sss - Handle unaligned buffers
Date: Mon, 7 Mar 2016 03:28:24 +0200
Message-ID: <56DCD938.7090100@mleia.com>
References: <1457259436-32560-1-git-send-email-krzk@kernel.org>
 <1457259436-32560-2-git-send-email-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Krzysztof Kozlowski <krzk@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457259436-32560-2-git-send-email-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Krzysztof,

On 06.03.2016 12:17, Krzysztof Kozlowski wrote:
> During crypto selftests on Odroid XU3 (Exynos5422) some of the
> algorithms failed because of passing AES-block unaligned source and
> destination buffers:

excuse my ignorance what are the crypto selftests you reference? Are they
run-time self tests run by crypto manager on algorithm registration?

> alg: skcipher: encryption failed on chunk test 1 for ecb-aes-s5p: ret=22
> 
> Handle such case by copying the buffers to a new aligned and contiguous
> space.

I'm not quite convinced that a particular crypto accelerator driver
is the right place for this change, at least I don't see in the change
anything S5P-SSS specific, but it might be good to add the change.

Briefly looking at other drivers similarly atmel-* and omap-* have
slow path fallbacks, ./rockchip/rk3288_crypto_ablkcipher.c fails like
s5p-sss etc.

Anyway since it is a valid improvement, please feel free to add my

Acked-by: Vladimir Zapolskiy <vz@mleia.com>

> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  drivers/crypto/s5p-sss.c | 149 +++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 137 insertions(+), 12 deletions(-)
> 
