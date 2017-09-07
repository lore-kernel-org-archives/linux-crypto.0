From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v5] Staging: ccree: Remove unused variable.
Date: Thu, 7 Sep 2017 11:50:31 +0300
Message-ID: <CAOtvUMc0zxtAnfZhL5M4A7mrYt9z-i58mr2SLtYpXJ5-eEo+QQ@mail.gmail.com>
References: <1504770561-5554-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        outreachy-kernel@googlegroups.com
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504770561-5554-1-git-send-email-srishtishar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On Thu, Sep 7, 2017 at 10:49 AM, Srishti Sharma <srishtishar@gmail.com> wrote:
> Remove the local variable inflight_counter as it is never used.
>
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
> ---

I've been meaning to clean that for some time now and never got around to do it.
Thank you! :-)

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>


> Changes in v5:
>  - Correct the format of the subject.
>  drivers/staging/ccree/ssi_cipher.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
> index 8d31a93..1ff3c8a 100644
> --- a/drivers/staging/ccree/ssi_cipher.c
> +++ b/drivers/staging/ccree/ssi_cipher.c
> @@ -697,13 +697,10 @@ static int ssi_blkcipher_complete(struct device *dev,
>                                   void __iomem *cc_base)
>  {
>         int completion_error = 0;
> -       u32 inflight_counter;
>         struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
>
>         ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
>
> -       /*Set the inflight couter value to local variable*/
> -       inflight_counter =  ctx_p->drvdata->inflight_counter;
>         /*Decrease the inflight counter*/
>         if (ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
>                 ctx_p->drvdata->inflight_counter--;
> --
> 2.7.4
>



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
