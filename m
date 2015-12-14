From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: omap-des: Fix "schedule while atomic" bug
Date: Mon, 14 Dec 2015 21:32:56 +0800
Message-ID: <20151214133256.GB1829@gondor.apana.org.au>
References: <1449763619-11883-1-git-send-email-semen.protsenko@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Grygorii Strashko <grygorii.strashko@globallogic.com>
To: Semen Protsenko <semen.protsenko@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45397 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbbLNNdG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Dec 2015 08:33:06 -0500
Content-Disposition: inline
In-Reply-To: <1449763619-11883-1-git-send-email-semen.protsenko@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 10, 2015 at 06:06:59PM +0200, Semen Protsenko wrote:
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

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
