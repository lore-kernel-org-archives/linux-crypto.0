From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH][TRIVIAL] crypto: ccp - fix typo "CPP"
Date: Thu, 20 Oct 2016 15:44:13 -0500
Message-ID: <031f3758-cef1-e237-e155-5e83cde9c304@amd.com>
References: <1476991259-4061-1-git-send-email-pebolle@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <trivial@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0041.outbound.protection.outlook.com ([104.47.42.41]:33198
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753398AbcJTUoa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2016 16:44:30 -0400
In-Reply-To: <1476991259-4061-1-git-send-email-pebolle@tiscali.nl>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/20/2016 02:20 PM, Paul Bolle wrote:
> The abbreviation for Cryptographic Coprocessor is "CCP".
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>  include/linux/ccp.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/ccp.h b/include/linux/ccp.h
> index a7653339fedb..c71dd8fa5764 100644
> --- a/include/linux/ccp.h
> +++ b/include/linux/ccp.h
> @@ -11,8 +11,8 @@
>   * published by the Free Software Foundation.
>   */
>
> -#ifndef __CPP_H__
> -#define __CPP_H__
> +#ifndef __CCP_H__
> +#define __CCP_H__
>
>  #include <linux/scatterlist.h>
>  #include <linux/workqueue.h>
> @@ -553,7 +553,7 @@ enum ccp_engine {
>  #define CCP_CMD_PASSTHRU_NO_DMA_MAP	0x00000002
>
>  /**
> - * struct ccp_cmd - CPP operation request
> + * struct ccp_cmd - CCP operation request
>   * @entry: list element (ccp driver use only)
>   * @work: work element used for callbacks (ccp driver use only)
>   * @ccp: CCP device to be run on (ccp driver use only)
>

-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
