Return-Path: <SRS0=3MGL=SB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5098C43381
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 10:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89754218FE
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 10:07:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NbRdSqup";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RZDdNy61"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbfC3KHy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Mar 2019 06:07:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44630 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730384AbfC3KHy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Mar 2019 06:07:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5CA586049C; Sat, 30 Mar 2019 10:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553940473;
        bh=z2zaiAd13SPJWn2OKMjOvjieJWbBfgP7dWuYtQ8gPOs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=NbRdSqupy+aDpjbhl4l/nomzfSGoDDDuScJCFmzog/MC8FwaANilQkYVhO/ZSuqk0
         V4XaxbYzx+rEVMmWA0Pjn3THMj9vKhY2IJanR/OnXOVTSc0BzQQ7JHpxoTUq9VYhIC
         4Gq9dDwAzh6Ns3jHqeV4w6n7EQDKDru1lWsiB+PU=
Received: from [10.79.174.164] (blr-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F0D9F6049C;
        Sat, 30 Mar 2019 10:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553940472;
        bh=z2zaiAd13SPJWn2OKMjOvjieJWbBfgP7dWuYtQ8gPOs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=RZDdNy61l13nIOzzOhLoWQR5nEIqHQIeeagRPJbrhJkg+U+3UJhX2CMyClHLcdAbP
         KCK4mNQX3ecU7e4m243Aj+Sa+ofFXqnzLdB8LtfqTTPkR9F98VDu2rkXxhlScHa1Ti
         qMQUffJqbr1DhzL54iYhQVeRcTn6kIAh3GvbQX/0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F0D9F6049C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH -next] crypto: mxs-dcp - return errcode in
 mxs_dcp_aes_enqueue and dcp_sha_update_fx
To:     Yue Haibing <yuehaibing@huawei.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net, shawnguo@kernel.org, s.hauer@pengutronix.de,
        kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20190330055221.24748-1-yuehaibing@huawei.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <b577d656-60d8-b00e-4ac0-24d0d318ee83@codeaurora.org>
Date:   Sat, 30 Mar 2019 15:37:41 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190330055221.24748-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 3/30/2019 11:22 AM, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
>
> 'err' is set in err path, but it's not returned to callers.
> Don't always return -EINPROGRESS, return err.


how this one sounds ?

'err' is set in error path inside crypto_enqueue_request(), but this is not getting
returned upstream but, always EINPROGRESS. Fix this by returning appropriate error value.


>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh


> ---
>   drivers/crypto/mxs-dcp.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> index a2105cf..494cfc4 100644
> --- a/drivers/crypto/mxs-dcp.c
> +++ b/drivers/crypto/mxs-dcp.c
> @@ -471,7 +471,7 @@ static int mxs_dcp_aes_enqueue(struct ablkcipher_request *req, int enc, int ecb)
>   
>   	wake_up_process(sdcp->thread[actx->chan]);
>   
> -	return -EINPROGRESS;
> +	return ret;
>   }
>   
>   static int mxs_dcp_aes_ecb_decrypt(struct ablkcipher_request *req)
> @@ -797,7 +797,7 @@ static int dcp_sha_update_fx(struct ahash_request *req, int fini)
>   	wake_up_process(sdcp->thread[actx->chan]);
>   	mutex_unlock(&actx->mutex);
>   
> -	return -EINPROGRESS;
> +	return ret;
>   }
>   
>   static int dcp_sha_update(struct ahash_request *req)
