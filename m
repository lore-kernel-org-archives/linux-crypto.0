From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] Fix late crypto work queue initialization
Date: Thu, 20 Mar 2014 17:18:00 -0700
Message-ID: <1395361080.2970.29.camel@schen9-DESK>
References: <1395100347.2970.14.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Huang, Ying" <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1395100347.2970.14.camel@schen9-DESK>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2014-03-17 at 16:52 -0700, Tim Chen wrote:
> The crypto algorithm modules utilizing the crypto daemon could
> be used early when the system start up.  Using module_init
> does not guarantee that the daemon's work queue is initialized
> when the cypto alorithm depending on crypto_wq starts.  It is necessary
> to initialize the crypto work queue earlier at the subsystem
> init time to make sure that it is initialized
> when used.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  crypto/crypto_wq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/crypto_wq.c b/crypto/crypto_wq.c
> index adad92a..2f1b8d1 100644
> --- a/crypto/crypto_wq.c
> +++ b/crypto/crypto_wq.c
> @@ -33,7 +33,7 @@ static void __exit crypto_wq_exit(void)
>  	destroy_workqueue(kcrypto_wq);
>  }
>  
> -module_init(crypto_wq_init);
> +subsys_initcall(crypto_wq_init);
>  module_exit(crypto_wq_exit);
>  
>  MODULE_LICENSE("GPL");

Herbert,

Any feedback on this patch?

Thanks.

Tim
