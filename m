From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH][next] staging: ccree: fix memory leaks in cc_ivgen_init
Date: Mon, 22 Jan 2018 09:13:48 +0200
Message-ID: <CAOtvUMdryGz_4ybsdM+EM7QrmcU4Eszo2ot_dO3oUpG9qA=dKg@mail.gmail.com>
References: <20180112161018.26595-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, kernel-janitors@vger.kernel.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Colin King <colin.king@canonical.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180112161018.26595-1-colin.king@canonical.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On Fri, Jan 12, 2018 at 6:10 PM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The current error exit path in function cc_ivgen_init via label
> 'out' free's resources from the drvdata->ivgen_handle context.
> However, drvdata->ivgen_handle has not been assigned to the
> context ivgen_ctx at this point, so the resources are not freed.
> Fix this by setting drvdata->ivgen_handle to ivgen_ctx as early
> as possible so that the clean up error exit return path can free
> the resources.
>
> Detected by CoveritScan, CID#1463795 ("Resource leak")
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/staging/ccree/cc_ivgen.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/ccree/cc_ivgen.c b/drivers/staging/ccree/cc_ivgen.c
> index 25a3131a93ce..c47f419b277b 100644
> --- a/drivers/staging/ccree/cc_ivgen.c
> +++ b/drivers/staging/ccree/cc_ivgen.c
> @@ -178,6 +178,8 @@ int cc_ivgen_init(struct cc_drvdata *drvdata)
>         if (!ivgen_ctx)
>                 return -ENOMEM;
>
> +       drvdata->ivgen_handle = ivgen_ctx;
> +
>         /* Allocate pool's header for initial enc. key/IV */
>         ivgen_ctx->pool_meta = dma_alloc_coherent(device, CC_IVPOOL_META_SIZE,
>                                                   &ivgen_ctx->pool_meta_dma,
> @@ -196,8 +198,6 @@ int cc_ivgen_init(struct cc_drvdata *drvdata)
>                 goto out;
>         }
>
> -       drvdata->ivgen_handle = ivgen_ctx;
> -
>         return cc_init_iv_sram(drvdata);
>
>  out:
> --
> 2.15.1
>

Good catch!

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
