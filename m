From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] Staging: ccree: ssi_cipher.c: Correct spelling mistake.
Date: Wed, 6 Sep 2017 23:59:55 +0300
Message-ID: <20170906205955.s22ssdslev3o4yiq@mwanda>
References: <1504725863-8495-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 outreachy-kernel@googlegroups.com, linux-crypto@vger.kernel.org
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1504725863-8495-1-git-send-email-srishtishar@gmail.com>
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

On Thu, Sep 07, 2017 at 12:54:23AM +0530, Srishti Sharma wrote:
> Correct spelling of counter in comment .
> 
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
> ---
>  drivers/staging/ccree/ssi_cipher.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
> index 8d31a93..99232b2 100644
> --- a/drivers/staging/ccree/ssi_cipher.c
> +++ b/drivers/staging/ccree/ssi_cipher.c
> @@ -702,7 +702,7 @@ static int ssi_blkcipher_complete(struct device *dev,
> 
>  	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
> 
> -	/*Set the inflight couter value to local variable*/
> +	/*Set the inflight counter value to local variable*/
>  	inflight_counter =  ctx_p->drvdata->inflight_counter;

Sure, but it would be better to just delete the comment.  It's obvious.
But really just delete the local inflight_counter variable as well
because that's never used.

regards,
dan carpenter
