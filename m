Return-Path: <SRS0=1eZC=DR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FFBC352B9
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Oct 2020 22:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AF392067C
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Oct 2020 22:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602370649;
	bh=t2YgZVluuf4vryGXDuJmdnGG2MK0FpJGL36ekpajFyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=zvWyJQHj3tyQfpURCxRT08XM97PHP+aA4fxxNdYj9rpz+aVca8CkxvZhrqQNdgBBc
	 bntJ1QiszgEFdxVCf93nNW9Yda+LqzhzcuW0oM101iKyv6EriyHajUYPnrcr/T8BOu
	 CMYbEpSaa9lJTZOqhCYrG0JzfUAEf3N4IcH8TsNQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbgJJW52 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Oct 2020 18:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730406AbgJJSwY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Oct 2020 14:52:24 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DC1B224DE;
        Sat, 10 Oct 2020 18:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602354747;
        bh=t2YgZVluuf4vryGXDuJmdnGG2MK0FpJGL36ekpajFyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iJtOcZGh7MXDk3mHCLkO2CpBhVWoNQBXNq6tf8cfsTaZ6DpFprFeTrBnvbRhKd6KR
         ybWmbC57523Qg3vIUgF/Li8eFfwHMtvyz6IycfzpS+OMD7xzODZfvZAGtGdzMBnyDh
         8dyze2Gfxz8If89W7su1tb7C0SbjvOhXaiHWdMoQ=
Date:   Sat, 10 Oct 2020 11:32:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ye Bin <yebin10@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - Fix format argument warning
Message-ID: <20201010183226.GA1808@sol.localdomain>
References: <20201010021637.112091-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201010021637.112091-1-yebin10@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 10, 2020 at 10:16:37AM +0800, Ye Bin wrote:
> Fix follow warning:
> [crypto/testmgr.c:2317]: (warning) %d in format string (no. 5) requires
> 'int' but the argument type is 'unsigned int'.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  crypto/testmgr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index a64a639eddfa..aefa4b6b8d78 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -2315,7 +2315,7 @@ static void generate_random_aead_testvec(struct aead_request *req,
>  	if (vec->setkey_error == 0 && vec->setauthsize_error == 0)
>  		generate_aead_message(req, suite, vec, prefer_inauthentic);
>  	snprintf(name, max_namelen,
> -		 "\"random: alen=%u plen=%u authsize=%u klen=%u novrfy=%d\"",
> +		 "\"random: alen=%u plen=%u authsize=%u klen=%u novrfy=%u\"",
>  		 vec->alen, vec->plen, authsize, vec->klen, vec->novrfy);

Actually vec->novrfy is 'unsigned char', not 'unsigned int'.  Both %u and %d
will work, but %d is technically correct because 'unsigned char' gets promoted
to 'int'.  What tool are you using that claims this is wrong?

- Eric
