From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 8/8] staging: ccree: remove BUG macro usage
Date: Wed, 6 Sep 2017 22:28:21 +0300
Message-ID: <20170906192821.4ytcxj436uyug6pr@mwanda>
References: <1504429011-25514-1-git-send-email-gilad@benyossef.com>
 <1504429011-25514-9-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1504429011-25514-9-git-send-email-gilad@benyossef.com>
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

On Sun, Sep 03, 2017 at 11:56:50AM +0300, Gilad Ben-Yossef wrote:
> @@ -1154,7 +1150,8 @@ static inline int ssi_buffer_mgr_aead_chain_data(
>  		//if have reached the end of the sgl, then this is unexpected
>  		if (!areq_ctx->src_sgl) {
>  			SSI_LOG_ERR("reached end of sg list. unexpected\n");
> -			BUG();
> +			return -EINVAL;
> +			goto chain_data_exit;

You've got a direct return followed by a goto.

It's a do-nothing goto that just returns rc.  I hate those.  I've tried
to review locking bugs to see if single returns prevent future
programmers from introducing new error paths which don't unlock.  They
don't really help...

regards,
dan carpenter
