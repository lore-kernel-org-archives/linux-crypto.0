Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3828C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 16:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7537B64F7E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 16:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhBCQo2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 11:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhBCQoU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 11:44:20 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7657C061573;
        Wed,  3 Feb 2021 08:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=0gkoYoi9uQKgwTVu6Rbnyu+k/MFxhUElhBgoTIV0z0E=; b=of9AJ+WVGYyw47J2A5sKzPZKvy
        Ann4QQDt/QLyKSSLh8/KAtu7qMqRI+ZNuEgJ7HeZEGyoPYtC5A0y5qMPeA7wG9DbOuAZXHKf4krM7
        FbNXUugI1eb515bNsio6t4d+TGbMqPOHcv+VncHU4iYzxsO7a4go38ephx3BjIlacG368fF0ALjeP
        k0gKRun3nCsuKSL1f+m0Obtfx1ectkgu2WHnP3yOB0GiOFylyeI8OivMyDaQ1H+03yU7kCCnn0JBZ
        CId76txbV4JPoYya20Mu/A1QgvTz3X7qsjqyO7dw1OJQNCyLw5FGyTE0JVahgVa8HvaiyIlUoDBse
        YpaHMzxg==;
Received: from [2601:1c0:6280:3f0::2a53]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7LFg-0002h9-4y; Wed, 03 Feb 2021 16:43:36 +0000
Subject: Re: [PATCH] crypto: Fixed optimzation to optimization in the file
 crypto/xor.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210203153933.9443-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <befa11b1-a5e8-5f70-9fb0-fa91b754b571@infradead.org>
Date:   Wed, 3 Feb 2021 08:43:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210203153933.9443-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/3/21 7:39 AM, Bhaskar Chowdhury wrote:
> 
> s/optimzation/optimization/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  crypto/xor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/xor.c b/crypto/xor.c
> index eacbf4f93990..c046d074f522 100644
> --- a/crypto/xor.c
> +++ b/crypto/xor.c
> @@ -95,7 +95,7 @@ do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
>  	for (i = 0; i < 3; i++) {
>  		start = ktime_get();
>  		for (j = 0; j < REPS; j++) {
> -			mb(); /* prevent loop optimzation */
> +			mb(); /* prevent loop optimization */
>  			tmpl->do_2(BENCH_SIZE, b1, b2);
>  			mb();
>  		}
> --
> 2.26.2
> 


-- 
~Randy

