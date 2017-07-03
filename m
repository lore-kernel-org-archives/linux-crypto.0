From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH v3 RESEND 5/5] crypto: ccp - remove ccp_present() check
 from device initialize
Date: Mon, 3 Jul 2017 10:51:22 -0500
Message-ID: <15b5c6d4-0df4-f94a-bdcd-783f7419aa1d@amd.com>
References: <20170629165406.13463-1-brijesh.singh@amd.com>
 <20170629165406.13463-6-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
To: "Singh, Brijesh" <brijesh.singh@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0053.outbound.protection.outlook.com ([104.47.40.53]:28070
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753276AbdGCPvp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jul 2017 11:51:45 -0400
In-Reply-To: <20170629165406.13463-6-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/29/2017 11:54 AM, Singh, Brijesh wrote:
> Since SP device driver supports multiples devices (e.g CCP, PSP), we
> should not fail the driver init just because CCP device is not found.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>  drivers/crypto/ccp/sp-dev.c | 12 ------------
>  1 file changed, 12 deletions(-)
>
> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> index edbf1bd9..a017233 100644
> --- a/drivers/crypto/ccp/sp-dev.c
> +++ b/drivers/crypto/ccp/sp-dev.c
> @@ -244,12 +244,6 @@ static int __init sp_mod_init(void)
>          if (ret)
>                  return ret;
>
> -       /* Don't leave the driver loaded if init failed */
> -       if (ccp_present() != 0) {
> -               sp_pci_exit();
> -               return -ENODEV;
> -       }
> -
>          return 0;
>  #endif
>
> @@ -260,12 +254,6 @@ static int __init sp_mod_init(void)
>          if (ret)
>                  return ret;
>
> -       /* Don't leave the driver loaded if init failed */
> -       if (ccp_present() != 0) {
> -               sp_platform_exit();
> -               return -ENODEV;
> -       }
> -
>          return 0;
>  #endif
>
> --
> 2.9.4
>
