Return-Path: <SRS0=3MGL=SB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BA5C43381
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 10:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0A07218A6
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 10:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FgevB7sx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aZpVgTG3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbfC3KPR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Mar 2019 06:15:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48946 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730477AbfC3KPR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Mar 2019 06:15:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0E74B6085C; Sat, 30 Mar 2019 10:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553940916;
        bh=dAY4LleUIKUPnP1Sj34jaVgzayQpYUpvtThUXFyGO+k=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FgevB7sxOgGMhRNr29M24jubzhsrr5i5JnD7TeeN7srURtkQq5kGarlUgPIXSBMM2
         6NB/g4E9wgQmlOgA1jk+/tkgEXYMUuYtSnruwQwNeSW7QlPmYyfBO4s3yBilFdEiYP
         9C8nIwfNWzzNnt6MSfqyztLbUerORF1dR339hi/E=
Received: from [10.79.169.73] (blr-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8B5016087A;
        Sat, 30 Mar 2019 10:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553940913;
        bh=dAY4LleUIKUPnP1Sj34jaVgzayQpYUpvtThUXFyGO+k=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=aZpVgTG3nWg0/dhh1ImFDTYj6si7nwedMjsNvRhe4fmwthht5GIAVUUZckRsqPY3e
         Ly5iKied7H9aSPXoRy9UNh0U42wMEKlo/gQdF/GwzfEG0F73PAcDK5hB+/OA3erhY1
         IWjTglQb1qm+qMITg/PlPQ0GVosjaFscl8EjRqnA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8B5016087A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH -next] crypto: marvell - remove set but not used variable
 'index'
To:     Yue Haibing <yuehaibing@huawei.com>, bbrezillon@kernel.org,
        arno@natisbad.org, herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20190330052858.24128-1-yuehaibing@huawei.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <cd033699-1660-a92e-08ec-0bdfa3113428@codeaurora.org>
Date:   Sat, 30 Mar 2019 15:45:05 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190330052858.24128-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 3/30/2019 10:58 AM, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/crypto/marvell/hash.c: In function 'mv_cesa_ahash_pad_req':
> drivers/crypto/marvell/hash.c:138:15: warning: variable 'index' set but not used [-Wunused-but-set-variable]
>
> It's never used and can be removed.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh

> ---
>   drivers/crypto/marvell/hash.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index 99ff54c..fd456dd 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -135,11 +135,10 @@ static int mv_cesa_ahash_pad_len(struct mv_cesa_ahash_req *creq)
>   
>   static int mv_cesa_ahash_pad_req(struct mv_cesa_ahash_req *creq, u8 *buf)
>   {
> -	unsigned int index, padlen;
> +	unsigned int padlen;
>   
>   	buf[0] = 0x80;
>   	/* Pad out to 56 mod 64 */
> -	index = creq->len & CESA_HASH_BLOCK_SIZE_MSK;
>   	padlen = mv_cesa_ahash_pad_len(creq);
>   	memset(buf + 1, 0, padlen - 1);
>   
