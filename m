Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6905BC636D3
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Feb 2023 01:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjBCBgL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 20:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbjBCBgK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 20:36:10 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C93E4875BF;
        Thu,  2 Feb 2023 17:36:06 -0800 (PST)
Received: from [192.168.87.25] (unknown [50.35.78.176])
        by linux.microsoft.com (Postfix) with ESMTPSA id DE06D20B7102;
        Thu,  2 Feb 2023 17:36:05 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DE06D20B7102
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675388166;
        bh=uqFp07G5WGJwzKMyQ/L163FV3SqQaEfZIf2xxupW+nM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IQ9KW2u+8LZQ4MyxGsFFXhzh8OG+Xl/CMDe7QDDUM/Xb72rDgKmKokTn6KSWLO6dS
         o6wAkcRuXVWsDsUkOitQUXw2bCE2cnlsDSwAkTmskWFwZRoL/S5nwGlMWXnoUAFWc3
         TnWOmz7QtyQZSYDRnBkD5r33Z1ZNqWRpiF7AGq3Y=
Message-ID: <e2dd4a02-12cb-de5e-4b64-9d6a4a1ad316@linux.microsoft.com>
Date:   Thu, 2 Feb 2023 17:36:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 -next] crypto: aspeed: fix type warnings
To:     Neal Liu <neal_liu@aspeedtech.com>, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20230202070345.191514-1-neal_liu@aspeedtech.com>
Content-Language: en-US
From:   Dhananjay Phadke <dphadke@linux.microsoft.com>
In-Reply-To: <20230202070345.191514-1-neal_liu@aspeedtech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/1/2023 11:03 PM, Neal Liu wrote:
> This patch fixes following warnings:
> 
> 1. sparse: incorrect type in assignment (different base types)
> Fix: change to __le32 type.
> 2. sparse: cast removes address space '__iomem' of expression
> Fix: use readb to avoid dereferencing the memory.
> 
> Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
> ---
> Change since v1: keep iomem marker to remain its purpose.
> 
>   drivers/crypto/aspeed/aspeed-acry.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
> index 164c524015f0..f2429e699d14 100644
> --- a/drivers/crypto/aspeed/aspeed-acry.c
> +++ b/drivers/crypto/aspeed/aspeed-acry.c
> @@ -252,7 +252,7 @@ static int aspeed_acry_rsa_ctx_copy(struct aspeed_acry_dev *acry_dev, void *buf,
>   				    enum aspeed_rsa_key_mode mode)
>   {
>   	const u8 *src = xbuf;
> -	u32 *dw_buf = (u32 *)buf;
> +	__le32 *dw_buf = (__le32 *)buf;

All callers are passing acry_dev->buf_addr as buf, can just change that 
type to __le32 * and deref here directly?

>   	int nbits, ndw;
>   	int i, j, idx;
>   	u32 data = 0;
> @@ -302,7 +302,7 @@ static int aspeed_acry_rsa_ctx_copy(struct aspeed_acry_dev *acry_dev, void *buf,
>   static int aspeed_acry_rsa_transfer(struct aspeed_acry_dev *acry_dev)
>   {
>   	struct akcipher_request *req = acry_dev->req;
> -	u8 *sram_buffer = (u8 *)acry_dev->acry_sram;
> +	u8 __iomem *sram_buffer = (u8 __iomem *)acry_dev->acry_sram;

u8 cast seems unnecessary, readb takes (void *) and using "+ data_idx"
offset below anyway.


>   	struct scatterlist *out_sg = req->dst;
>   	static u8 dram_buffer[ASPEED_ACRY_SRAM_MAX_LEN];
>   	int leading_zero = 1;
> @@ -321,11 +321,11 @@ static int aspeed_acry_rsa_transfer(struct aspeed_acry_dev *acry_dev)
>   
>   	for (j = ASPEED_ACRY_SRAM_MAX_LEN - 1; j >= 0; j--) {
>   		data_idx = acry_dev->data_byte_mapping[j];
> -		if (sram_buffer[data_idx] == 0 && leading_zero) {
> +		if (readb(sram_buffer + data_idx) == 0 && leading_zero) {
>   			result_nbytes--;
>   		} else {
>   			leading_zero = 0;
> -			dram_buffer[i] = sram_buffer[data_idx];
> +			dram_buffer[i] = readb(sram_buffer + data_idx);
>   			i++;
>   		}
>   	}

