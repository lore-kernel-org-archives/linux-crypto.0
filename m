From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH] MAINTAINERS: Add a new maintainer for the CCP driver
Date: Mon, 28 Mar 2016 14:29:03 -0500
Message-ID: <56F985FF.3050505@amd.com>
References: <20160321164321.22405.94570.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Gary Hook <gary.hook@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0080.outbound.protection.outlook.com ([157.56.111.80]:24608
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753567AbcC1TpX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Mar 2016 15:45:23 -0400
In-Reply-To: <20160321164321.22405.94570.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/21/2016 11:43 AM, Tom Lendacky wrote:
> Gary will be taking over future development of the CCP driver, so add
> him as a co-maintainer of the driver.
>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>   MAINTAINERS |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 30aca4a..8c42c07 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -623,6 +623,7 @@ F:	include/linux/altera_jtaguart.h
>   
>   AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER
>   M:	Tom Lendacky <thomas.lendacky@amd.com>
> +M:	Gary Hook <gary.hook@amd.com>
>   L:	linux-crypto@vger.kernel.org
>   S:	Supported
>   F:	drivers/crypto/ccp/
>

Acked-by: Gary Hook <gary.hook@amd.com>
