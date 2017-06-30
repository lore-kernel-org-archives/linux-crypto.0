From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH] crypto: ccp-platform: print error message on
 platform_get_irq failure
Date: Fri, 30 Jun 2017 10:08:00 -0500
Message-ID: <cd383386-bdd1-c91a-09de-8c67d4503168@amd.com>
References: <20170630055952.GA6953@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0061.outbound.protection.outlook.com ([104.47.42.61]:9824
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751605AbdF3PIU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2017 11:08:20 -0400
In-Reply-To: <20170630055952.GA6953@embeddedgus>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/30/2017 12:59 AM, Gustavo A. R. Silva wrote:
> Print error message on platform_get_irq failure before return.
>
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  drivers/crypto/ccp/ccp-platform.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ccp/ccp-platform.c
> b/drivers/crypto/ccp/ccp-platform.c
> index e26969e..6020c4a 100644
> --- a/drivers/crypto/ccp/ccp-platform.c
> +++ b/drivers/crypto/ccp/ccp-platform.c
> @@ -66,8 +66,10 @@ static int ccp_get_irq(struct ccp_device *ccp)
>          int ret;
>
>          ret = platform_get_irq(pdev, 0);
> -       if (ret < 0)
> +       if (ret < 0) {
> +               dev_notice(dev, "unable to get IRQ (%d)\n", ret);
>                  return ret;
> +       }

Good find.

I'm all for better and more messages, but I'd like to see more detail 
here, and in the
later dev_notice(). Can we have the messages better reflect the failure 
points?

>
>          ccp->irq = ret;
>          ret = request_irq(ccp->irq, ccp->vdata->perform->irqhandler, 0,
> --
> 2.5.0
>
