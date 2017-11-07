From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 5/8] staging: ccree: fold common code into function
Date: Tue, 7 Nov 2017 13:40:31 +0300
Message-ID: <20171107104031.kffrjerag2viukyo@mwanda>
References: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
 <1510047606-5589-6-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1510047606-5589-6-git-send-email-gilad@benyossef.com>
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

On Tue, Nov 07, 2017 at 09:40:01AM +0000, Gilad Ben-Yossef wrote:
> @@ -669,21 +690,12 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
>  	}
>  	if (drvdata->coherent &&
>  	    (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) &&
> -	    likely(req->src == req->dst)) {
> -		u32 size_to_skip = req->assoclen;
> -
> -		if (areq_ctx->is_gcm4543)
> -			size_to_skip += crypto_aead_ivsize(tfm);
> +	    likely(req->src == req->dst))

Don't remove the curly braces from this one.  Multi-line indents get
curly braces for readability.

>  
> -		/* copy mac to a temporary location to deal with possible
> +		/* copy back mac from temporary location to deal with possible
>  		 * data memory overriding that caused by cache coherence problem.
>  		 */
> -		cc_copy_sg_portion(dev, areq_ctx->backup_mac, req->src,
> -				   (size_to_skip + req->cryptlen -
> -				    areq_ctx->req_authsize),
> -				   (size_to_skip + req->cryptlen),
> -				   SSI_SG_FROM_BUF);
> -	}
> +		cc_copy_mac(dev, req, SSI_SG_FROM_BUF);
>  }

regards,
dan carpenter
