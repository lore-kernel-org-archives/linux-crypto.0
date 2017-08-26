From: Lars Persson <lars.persson@axis.com>
Subject: Re: [PATCH] crypto: axis - hide an unused variable
Date: Sat, 26 Aug 2017 07:57:32 +0000
Message-ID: <1CCBE64C-1CA2-4F45-B7B0-E8D2363846B5@axis.com>
References: <20170824222016.731342-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Jesper Nilsson <jespern@axis.com>,
        Niklas Cassel <niklass@axis.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel <linux-arm-kernel@axis.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170824222016.731342-1-arnd@arndb.de>
Content-Language: sv-SE
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


> 25 aug. 2017 kl. 01:20 skrev Arnd Bergmann <arnd@arndb.de>:
> 
> Without CONFIG_DEBUG_FS, we get a harmless warning:
> 
> drivers/crypto/axis/artpec6_crypto.c:352:23: error: 'dbgfs_root' defined but not used [-Werror=unused-variable]
> 
> This moves it into the #ifdef that hides the only user.
> 
> Fixes: a21eb94fc4d3 ("crypto: axis - add ARTPEC-6/7 crypto accelerator driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> drivers/crypto/axis/artpec6_crypto.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
> index d9fbbf01062b..0f9754e07719 100644
> --- a/drivers/crypto/axis/artpec6_crypto.c
> +++ b/drivers/crypto/axis/artpec6_crypto.c
> @@ -349,8 +349,6 @@ struct artpec6_crypto_aead_req_ctx {
> /* The crypto framework makes it hard to avoid this global. */
> static struct device *artpec6_crypto_dev;
> 
> -static struct dentry *dbgfs_root;
> -
> #ifdef CONFIG_FAULT_INJECTION
> static DECLARE_FAULT_ATTR(artpec6_crypto_fail_status_read);
> static DECLARE_FAULT_ATTR(artpec6_crypto_fail_dma_array_full);
> @@ -2984,6 +2982,8 @@ struct dbgfs_u32 {
>   char *desc;
> };
> 
> +static struct dentry *dbgfs_root;
> +
> static void artpec6_crypto_init_debugfs(void)
> {
>   dbgfs_root = debugfs_create_dir("artpec6_crypto", NULL);
> -- 
> 2.9.0
Acked-by: Lars Persson <larper@axis.com>

Thanks,
 Lars
