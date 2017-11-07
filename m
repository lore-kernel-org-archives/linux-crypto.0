From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 3/8] staging: ccree: simplify AEAD using local var
Date: Tue, 7 Nov 2017 13:35:23 +0300
Message-ID: <20171107103523.ests5w6m3c7ria73@mwanda>
References: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
 <1510047606-5589-4-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1510047606-5589-4-git-send-email-gilad@benyossef.com>
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

On Tue, Nov 07, 2017 at 09:39:59AM +0000, Gilad Ben-Yossef wrote:
> Make the code more readable by using a local variable
> for commonly use expression in the AEAD part of the driver.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/staging/ccree/ssi_aead.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
> index 0b5b230..f1a3976 100644
> --- a/drivers/staging/ccree/ssi_aead.c
> +++ b/drivers/staging/ccree/ssi_aead.c
> @@ -251,13 +251,11 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
>  		}
>  	} else { /*ENCRYPT*/
>  		if (unlikely(areq_ctx->is_icv_fragmented)) {
> +			u32 loc = areq->cryptlen + areq_ctx->dst_offset;

"loc" isn't a very canonical name.  At first I thought this was "pos"
or maybe "end" but now I'm thinking this is "skip"?  I don't know what
this variable is.

> +
>  			cc_copy_sg_portion(dev, areq_ctx->mac_buf,
> -					   areq_ctx->dst_sgl,
> -					   (areq->cryptlen +
> -					    areq_ctx->dst_offset),
> -					   (areq->cryptlen +
> -					    areq_ctx->dst_offset +
> -					    ctx->authsize),
> +					   areq_ctx->dst_sgl, loc,
> +					   (loc + ctx->authsize),
>  					   SSI_SG_FROM_BUF);
>  		}

regards,
dan carpenter
