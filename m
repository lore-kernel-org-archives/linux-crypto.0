From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Outreachy kernel] [PATCH v2] Staging: ccree: ssi_cipher.c: Make
 comment more comprehensible.
Date: Wed, 6 Sep 2017 22:58:43 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1709062258000.2984@hadrien>
References: <1504731390-9536-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, outreachy-kernel@googlegroups.com,
 gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1504731390-9536-1-git-send-email-srishtishar@gmail.com>
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



On Thu, 7 Sep 2017, Srishti Sharma wrote:

> Edited comment to make it more comprehensible.
>
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
> ---
> Changes in v2:
>  - Make comment more comprehensible , instead of just correcting typos.
>  drivers/staging/ccree/ssi_cipher.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
> index 99232b2..fec2faa 100644
> --- a/drivers/staging/ccree/ssi_cipher.c
> +++ b/drivers/staging/ccree/ssi_cipher.c
> @@ -702,7 +702,9 @@ static int ssi_blkcipher_complete(struct device *dev,
>
>  	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
>
> -	/*Set the inflight counter value to local variable*/
> +	/*
> +	 * Save inflight_counter in a local variable.
> +	 */

This is the format for multiline comments.  Your comments is only one
line.  You just need to add spaces around the text, as compared to the
original version.

julia

>  	inflight_counter =  ctx_p->drvdata->inflight_counter;
>  	/*Decrease the inflight counter*/
>  	if (ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
> --
> 2.7.4
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1504731390-9536-1-git-send-email-srishtishar%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
