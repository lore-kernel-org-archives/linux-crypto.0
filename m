From: "Hook, Gary" <Gary.Hook@amd.com>
Subject: Re: [PATCH -next] crypto: ccp - Fix non static symbol warning
Date: Tue, 18 Oct 2016 19:13:19 +0000
Message-ID: <DM5PR12MB140402185DFE54E0714CAC8AFDD30@DM5PR12MB1404.namprd12.prod.outlook.com>
References: <1476716930-9831-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0051.outbound.protection.outlook.com ([104.47.37.51]:61616
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S964826AbcJRTNW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2016 15:13:22 -0400
In-Reply-To: <1476716930-9831-1-git-send-email-weiyj.lk@gmail.com>
Content-Language: en-US
Content-ID: <1167D8690ED3CA4DB08F6C7A7DBB7371@amdcloud.onmicrosoft.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/17/2016 10:08 AM, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
>
> Fixes the following sparse warning:
>
> drivers/crypto/ccp/ccp-dev.c:44:6: warning:
>  symbol 'ccp_error_codes' was not declared. Should it be static?
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/crypto/ccp/ccp-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
> index cafa633..c25515a 100644
> --- a/drivers/crypto/ccp/ccp-dev.c
> +++ b/drivers/crypto/ccp/ccp-dev.c
> @@ -41,7 +41,7 @@ struct ccp_tasklet_data {
>  };
>
>  /* Human-readable error strings */
> -char *ccp_error_codes[] =3D {
> +static char *ccp_error_codes[] =3D {
>  	"",
>  	"ERR 01: ILLEGAL_ENGINE",
>  	"ERR 02: ILLEGAL_KEY_ID",
>

Yes, excellent. Thank you.

Acked-by: Gary R Hook <gary.hook@amd.com>

--=20
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
