Return-Path: <SRS0=6qCq=6B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDF6C2BB1D
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Apr 2020 21:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D1AA206B9
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Apr 2020 21:34:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V6aPo1wP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgDQVey (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Apr 2020 17:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725873AbgDQVey (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Apr 2020 17:34:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BC5C061A0C;
        Fri, 17 Apr 2020 14:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=a/5VyyW0f5t2tlerVMS31oR1lXYo8UFpY6MnzoWeS1s=; b=V6aPo1wPf4WiRa46EFNg38APJd
        johrUKGR/XDYNfVUHf0eM48283ZCBSx4MuyMAlwIV+SxJrbOImRk1tNC1rpJjPYyqsW2wP6apdOUv
        yaXkH8D3dvvZx+gsidFWr30ejybsVZqGPyiitMEov95HEyKNeVwLTLkZSWUcYYvSCW4Hnj9YbGcxd
        jZvdKh2JKbpKCQMCnp4GiZP+DRVJWB8d1ToVIsB0i9I8eVJHNYALUduRm7IXmL/XR19uC6iY0Bpay
        x0+Wtjt70hyZw8kwtFETmSxKG5SGP1iZDoSZf0fLfB5J0FKAgV7VNNs4r2UgbZh48c5j64E3r+UR7
        Fwqq9q8Q==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPYdM-0003Q3-1g; Fri, 17 Apr 2020 21:34:48 +0000
Subject: Re: [PATCH] hwrng: cctrng - add missing include to linux/fips.h
To:     Hadar Gat <hadar.gat@arm.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1587155926-32663-1-git-send-email-hadar.gat@arm.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <096db769-a508-b0fa-f018-2c4c807061cb@infradead.org>
Date:   Fri, 17 Apr 2020 14:34:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1587155926-32663-1-git-send-email-hadar.gat@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/17/20 1:38 PM, Hadar Gat wrote:
> This fixes build failure when CONFIG_CRYPTO_FIPS is defined.
> 
> Signed-off-by: Hadar Gat <hadar.gat@arm.com>

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

> ---
>  drivers/char/hw_random/cctrng.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
> index bdcd562..e82716c 100644
> --- a/drivers/char/hw_random/cctrng.c
> +++ b/drivers/char/hw_random/cctrng.c
> @@ -15,6 +15,7 @@
>  #include <linux/completion.h>
>  #include <linux/of.h>
>  #include <linux/bitfield.h>
> +#include <linux/fips.h>
>  
>  #include "cctrng.h"
>  
> 

thanks.
-- 
~Randy
