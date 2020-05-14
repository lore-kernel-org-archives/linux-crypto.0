Return-Path: <SRS0=peSz=64=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1BBC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 19:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0949F2065D
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 19:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgENTxC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 May 2020 15:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727833AbgENTxC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 May 2020 15:53:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1E8C061A0C;
        Thu, 14 May 2020 12:53:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BAD84128D3243;
        Thu, 14 May 2020 12:53:01 -0700 (PDT)
Date:   Thu, 14 May 2020 12:53:00 -0700 (PDT)
Message-Id: <20200514.125300.1860838845258685507.davem@davemloft.net>
To:     ayush.sawal@chelsio.com
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, manojmalviya@chelsio.com
Subject: Re: [PATCH net-next 1/2] Crypto/chcr: Fixes compilations warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514075330.25542-2-ayush.sawal@chelsio.com>
References: <20200514075330.25542-1-ayush.sawal@chelsio.com>
        <20200514075330.25542-2-ayush.sawal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 12:53:02 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>
Date: Thu, 14 May 2020 13:23:29 +0530

> @@ -256,7 +256,7 @@ static void get_aes_decrypt_key(unsigned char *dec_key,
>  		return;
>  	}
>  	for (i = 0; i < nk; i++)
> -		w_ring[i] = be32_to_cpu(*(u32 *)&key[4 * i]);
> +		w_ring[i] = be32_to_cpu(*(__be32 *)&key[4 * i]);
>  
>  	i = 0;

If the key stored is a big endian value, please fix the type
of ablkctx->key to be __be32 instead of making the driver so
ugly with unnecessary casts all over the place.

This is a really lazy and sloppy way to fix these warnings, and
I'm not applying stuff like this, sorry.
