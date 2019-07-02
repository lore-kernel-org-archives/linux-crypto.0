Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE0DC5B578
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 00:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F2752173E
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 00:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562027126;
	bh=MPIDSjZSqrqTeWvWT//E/0wZy5fEnuIgGI95YyoSxss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=aFbUjbpzlETOsfVlrbGQg5dtGWbnXPp4Er7zhZ9/b4/OVDvEI8XoWst0ppbMooDMG
	 ehNI2I7c0LL0t30Dq0krnMhARpYQ4AZkC3ybHBlTYg0xx9jku4UOjJp3Yhn5ai8Q8J
	 JOTqH9do+2mHxEy+vUn75NSl+AACNAlZPGHkitr4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfGBAZZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jul 2019 20:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727023AbfGBAZY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jul 2019 20:25:24 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9319C21721;
        Tue,  2 Jul 2019 00:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562027123;
        bh=MPIDSjZSqrqTeWvWT//E/0wZy5fEnuIgGI95YyoSxss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K17hf1xlfaVcjMn/oGAGN5LYYVhtG4iXNAAmaxiEg6SyeDPInPxpVPw9wjAXFJ5Yg
         T+yiH8itPf3deW5gsoP+7cb8s7Psg8LUbHUvGwIGZ6WFZTbzcNOAvJrUISTps6zu/7
         S2f7kL+yDqHTPQbr/5Lua9vshmIaF/SqxhPY5dYg=
Date:   Mon, 1 Jul 2019 17:25:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Cfir Cohen <cfir@google.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp/gcm - use const time tag comparison.
Message-ID: <20190702002522.GA693@sol.localdomain>
References: <20190702000132.88836-1-cfir@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702000132.88836-1-cfir@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 01, 2019 at 05:01:32PM -0700, Cfir Cohen wrote:
> Avoid leaking GCM tag through timing side channel.
> 
> Signed-off-by: Cfir Cohen <cfir@google.com>
> ---
>  drivers/crypto/ccp/ccp-ops.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index db8de89d990f..633670220f6c 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -840,7 +840,8 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
>  		if (ret)
>  			goto e_tag;
>  
> -		ret = memcmp(tag.address, final_wa.address, AES_BLOCK_SIZE);
> +		ret = crypto_memneq(tag.address, final_wa.address,
> +				    AES_BLOCK_SIZE) ? -EBADMSG : 0;
>  		ccp_dm_free(&tag);
>  	}
>  
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 

Looks like this needs:

	Fixes: 36cf515b9bbe ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
	Cc: <stable@vger.kernel.org> # v4.12+

- Eric
