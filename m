From: Sam Protsenko <semen.protsenko@globallogic.com>
Subject: Re: [PATCH] crypto: omap-des: Fix "schedule while atomic" bug
Date: Thu, 10 Dec 2015 18:51:39 +0200
Message-ID: <CAJOTznX9JGGEs-hCeE-ZQ_XA9WW20L0wMSZ5Xb0jPb+3MyW6wg@mail.gmail.com>
References: <1449763619-11883-1-git-send-email-semen.protsenko@linaro.org>
Reply-To: semen.protsenko@globallogic.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Grygorii Strashko <grygorii.strashko@globallogic.com>,
	Lokesh Vutla <lokeshvutla@ti.com>,
	linux-omap <linux-omap@vger.kernel.org>
To: Semen Protsenko <semen.protsenko@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:36519 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbbLJQvk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Dec 2015 11:51:40 -0500
Received: by lbblt2 with SMTP id lt2so55305789lbb.3
        for <linux-crypto@vger.kernel.org>; Thu, 10 Dec 2015 08:51:39 -0800 (PST)
In-Reply-To: <1449763619-11883-1-git-send-email-semen.protsenko@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

+ Lokesh Vutla <lokeshvutla@ti.com>
+ linux-omap@vger.kernel.org

On Thu, Dec 10, 2015 at 6:06 PM, Semen Protsenko
<semen.protsenko@linaro.org> wrote:
>
> From: Sam Protsenko <semen.protsenko@linaro.org>
>
> When using DES module the next bug appears:
>
>     BUG: scheduling while atomic: kworker/0:1/63/0x00000102
>
> With backtrace as follows:
>
> <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< cut here >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>
> [<c0012294>] (dump_backtrace) from [<c00124ac>] (show_stack+0x18/0x1c)
> [<c0012494>] (show_stack) from [<c0752554>] (dump_stack+0x84/0xc4)
> [<c07524d0>] (dump_stack) from [<c0750218>] (__schedule_bug+0x54/0x64)
> [<c07501c4>] (__schedule_bug) from [<c07548a4>] (__schedule+0x4ac/0x53c)
> [<c07543f8>] (__schedule) from [<c075496c>] (schedule+0x38/0x88)
> [<c0754934>] (schedule) from [<c03c3984>] (rpm_resume+0x158/0x59c)
> [<c03c382c>] (rpm_resume) from [<c03c3e1c>] (__pm_runtime_resume+0x54/0x6c)
> [<c03c3dc8>] (__pm_runtime_resume) from [<c0568ff8>] (omap_des_handle_queue+0x154/0x7bc)
> [<c0568ea4>] (omap_des_handle_queue) from [<c05696b8>] (omap_des_crypt+0x58/0xbc)
> [<c0569660>] (omap_des_crypt) from [<c0569730>] (omap_des_cbc_decrypt+0x14/0x18)
> [<c056971c>] (omap_des_cbc_decrypt) from [<c0297534>] (authenc_verify_ahash_done+0xe0/0xe8)
> [<c0297454>] (authenc_verify_ahash_done) from [<c056a330>] (omap_sham_finish_req+0x58/0xa8)
> [<c056a2d8>] (omap_sham_finish_req) from [<c056b714>] (omap_sham_done_task+0x1c0/0x1e0)
> [<c056b554>] (omap_sham_done_task) from [<c003e53c>] (tasklet_action+0x80/0x118)
> [<c003e4bc>] (tasklet_action) from [<c003e740>] (__do_softirq+0x11c/0x260)
> [<c003e624>] (__do_softirq) from [<c003eb64>] (irq_exit+0xc0/0xfc)
> [<c003eaa4>] (irq_exit) from [<c000f1c4>] (handle_IRQ+0x4c/0x98)
> [<c000f178>] (handle_IRQ) from [<c0008568>] (gic_handle_irq+0x34/0x64)
> [<c0008534>] (gic_handle_irq) from [<c0758540>] (__irq_svc+0x40/0x70)
>
> <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< cut here >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>
> Insight was seen in drivers/crypto/omap-sham.c driver.
> All credits for this patch go to Grygorii Strashko.
>
> Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
> ---
>  drivers/crypto/omap-des.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
> index 0a70e46..db1ef28 100644
> --- a/drivers/crypto/omap-des.c
> +++ b/drivers/crypto/omap-des.c
> @@ -1086,6 +1086,7 @@ static int omap_des_probe(struct platform_device *pdev)
>         dd->phys_base = res->start;
>
>         pm_runtime_enable(dev);
> +       pm_runtime_irq_safe(dev);
>         err = pm_runtime_get_sync(dev);
>         if (err < 0) {
>                 pm_runtime_put_noidle(dev);
> --
> 2.6.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
