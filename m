From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v2 4/4] crypto: s5p-sss: Add aes-ctr support
Date: Mon, 17 Sep 2018 17:54:20 +0200
Message-ID: <20180917155422eucas1p2ea33c73f046cb19c7be5fac7e9191059~VOvLUVLIR0418604186eucas1p2i@eucas1p2.samsung.com>
References: <1537196970-5987-1-git-send-email-c.manszewski@samsung.com>
        <CGME20180917151011eucas1p274a1407a02081b49aa03da85cc9aec4c@eucas1p2.samsung.com>
        <20180917151011eucas1p274a1407a02081b49aa03da85cc9aec4c~VOImIjh2C1107511075eucas1p2w@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Christoph Manszewski <c.manszewski@samsung.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917151011eucas1p274a1407a02081b49aa03da85cc9aec4c~VOImIjh2C1107511075eucas1p2w@eucas1p2.samsung.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 17.09.2018 17:09, Christoph Manszewski wrote:
> Add support for aes counter(ctr) block cipher mode of operation for
> Exynos Hardware. In contrast to ecb and cbc modes, aes-ctr allows
> encyption/decryption for request sizes not being a multiple of 16(bytes).
> 
> Hardware requires block sizes being a multiple of 16(bytes). In order to
> achieve this, copy request source and destination memory, and align it's size
> to 16. That way hardware processes additional bytes, that are omitted
> when copying the result back to its original destination.
> 
> Tested on Odroid-U3 with Exynos 4412 CPU, kernel 4.19-rc2 with crypto
> run-time self test testmgr.
> 
> Signed-off-by: Christoph Manszewski <c.manszewski@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  drivers/crypto/s5p-sss.c | 45 ++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 40 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index ba8f2e2ea88f..0064be0e3941 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -1813,7 +1813,7 @@ static struct ahash_alg algs_sha1_md5_sha256[] = {
>  };
>  
>  static void s5p_set_aes(struct s5p_aes_dev *dev,
> -			const u8 *key, const u8 *iv,
> +			const u8 *key, const u8 *iv, const u8 *ctr,
>  			unsigned int keylen)
>  {
>  	void __iomem *keystart;
> @@ -1821,6 +1821,9 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
>  	if (iv)
>  		memcpy_toio(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
>  
> +	if (ctr)
> +		memcpy_toio(dev->aes_ioaddr + SSS_REG_AES_CNT_DATA(0), ctr, 0x10);
> +
>  	if (keylen == AES_KEYSIZE_256)
>  		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(0);
>  	else if (keylen == AES_KEYSIZE_192)
> @@ -1902,8 +1905,9 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
>  	u32 aes_control;
>  	unsigned long flags;
>  	int err;
> -	u8 *iv;
> +	u8 *iv, *ctr;
>  
> +	/* This sets bit [13:12] to 00, which selects 128-bit counter */

s/bit/bits/

This this,

Acked-by: Kamil Konieczny <k.konieczny@partner.samsung.com>

Thanks!
Kamil
