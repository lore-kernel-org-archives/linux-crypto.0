Return-Path: <SRS0=ZGow=UW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC60C43613
	for <linux-crypto@archiver.kernel.org>; Sun, 23 Jun 2019 21:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A679520679
	for <linux-crypto@archiver.kernel.org>; Sun, 23 Jun 2019 21:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfFWVea (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 23 Jun 2019 17:34:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45354 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfFWVea (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Jun 2019 17:34:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDF99142DE3A5;
        Sun, 23 Jun 2019 14:34:26 -0700 (PDT)
Date:   Sun, 23 Jun 2019 14:34:24 -0700 (PDT)
Message-Id: <20190623.143424.1962536673442328783.davem@davemloft.net>
To:     gomonovych@gmail.com
Cc:     george.cherian@cavium.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: cavium remove casting dma_alloc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190623204849.22089-1-gomonovych@gmail.com>
References: <20190623204849.22089-1-gomonovych@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Jun 2019 14:34:27 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Vasyl Gomonovych <gomonovych@gmail.com>
Date: Sun, 23 Jun 2019 22:48:49 +0200

> @@ -233,7 +233,7 @@ static int alloc_command_queues(struct cpt_vf *cptvf,
>  
>  			c_size = (rem_q_size > qcsize_bytes) ? qcsize_bytes :
>  					rem_q_size;
> -			curr->head = (u8 *)dma_alloc_coherent(&pdev->dev,
> +			curr->head = dma_alloc_coherent(&pdev->dev,
>  							      c_size + CPT_NEXT_CHUNK_PTR_SIZE,
>  							      &curr->dma_addr,
>  							      GFP_KERNEL);

Please fix up the indentation of the 2nd, 3rd, and 4th line of the call
if you do this.  Each of those lines should start precisely at the
first column after the openning parenthesis of the first line.

Thank you.
