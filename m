From: Sean Paul <seanpaul@chromium.org>
Subject: Re: [Outreachy kernel] [PATCH v2] Staging: ccree: Remove unused
 variable monitor_lock
Date: Mon, 11 Sep 2017 12:36:57 -0400
Message-ID: <CAOw6vb+CZWz39-6_dtPzwi4=mxJkp_fQ=saUrLG8TfFORZkSkA@mail.gmail.com>
References: <1505147317-13411-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, outreachy-kernel@googlegroups.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1505147317-13411-1-git-send-email-srishtishar@gmail.com>
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

On Mon, Sep 11, 2017 at 12:28 PM, Srishti Sharma <srishtishar@gmail.com> wrote:
> Remove the variable monitor_lock as it is not used anywhere.
>
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>

Reviewed-by: Sean Paul <seanpaul@chromium.org>

> ---
> Changes in v2:
>  -The variable that was not to be declared as volatile can be
>   eliminated as it is not being used anywhere.
>
>  drivers/staging/ccree/ssi_request_mgr.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
> index e5c2f92..b94a91f 100644
> --- a/drivers/staging/ccree/ssi_request_mgr.c
> +++ b/drivers/staging/ccree/ssi_request_mgr.c
> @@ -49,7 +49,6 @@ struct ssi_request_mgr_handle {
>         dma_addr_t dummy_comp_buff_dma;
>         struct cc_hw_desc monitor_desc;
>
> -       volatile unsigned long monitor_lock;
>  #ifdef COMP_IN_WQ
>         struct workqueue_struct *workq;
>         struct delayed_work compwork;
> --
> 2.7.4
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1505147317-13411-1-git-send-email-srishtishar%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.
