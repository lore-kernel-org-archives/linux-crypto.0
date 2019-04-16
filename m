Return-Path: <SRS0=uro5=SS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 497F3C10F13
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 06:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 160682075B
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 06:58:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Qz//NN1/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HWKfLa0N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbfDPG6V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Apr 2019 02:58:21 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41538 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727424AbfDPG6T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Apr 2019 02:58:19 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5006060FEB; Tue, 16 Apr 2019 06:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555397899;
        bh=mMOeFhSkVyCh3k2XBAuXneznP/1Nyf/7Mjaa+It1uM0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Qz//NN1/3mPtRRIUr/HNg9GELt/QDZC8kC+HcJxi256LPAZr0LsvAWnfpxdWUTPyE
         Hp3bn5/iouO9G+JnNM99cUiyx0avV0cwDlzCjLGIbik8BaRxwx5AJENLEwTP7on04o
         jnfCehDCukHEVdk18duAFqbZw4uRRXqNstHAUS6I=
Received: from [10.204.79.15] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A147260E41;
        Tue, 16 Apr 2019 06:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555397898;
        bh=mMOeFhSkVyCh3k2XBAuXneznP/1Nyf/7Mjaa+It1uM0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=HWKfLa0NnV/iYdNv2ek6LknUaez/mhuMMoMsHM8H6cAdl6xRcKMYMifgtgPqNLyMQ
         8sFnS1uc/pjmYlj1NZF/hMlDzBAdoj6A/dWjIzrvALzTBzH6ib/LHh4fbW075DhLWG
         WG/20r2YfxrxcKf4fr0KZgCcXOuyOhCmGZc9Uyfo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A147260E41
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH] crypto: caam: fix spelling mistake "cannote" -> "cannot"
To:     Colin King <colin.king@canonical.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190415124021.4659-1-colin.king@canonical.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <cd43bdfe-2748-ec47-3ceb-4da84f67cd89@codeaurora.org>
Date:   Tue, 16 Apr 2019 12:26:28 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190415124021.4659-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 4/15/2019 6:10 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a spelling mistake in an error message in the qi_error_list
> array. Fix this.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh

> ---
>   drivers/crypto/caam/error.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
> index 21a70fd32f5d..a4129a35a330 100644
> --- a/drivers/crypto/caam/error.c
> +++ b/drivers/crypto/caam/error.c
> @@ -138,7 +138,7 @@ static const struct {
>   	{ 0x46, "Annotation length exceeds offset (reuse mode)"},
>   	{ 0x48, "Annotation output enabled but ASA limited by ASAR (reuse mode)"},
>   	{ 0x49, "Data offset correction exceeds input frame data length (reuse mode)"},
> -	{ 0x4B, "Annotation output enabled but ASA cannote be expanded (frame list)"},
> +	{ 0x4B, "Annotation output enabled but ASA cannot be expanded (frame list)"},
>   	{ 0x51, "Unsupported IF reuse mode"},
>   	{ 0x52, "Unsupported FL use mode"},
>   	{ 0x53, "Unsupported RJD use mode"},
