Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABD0C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 11:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 714312075C
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 11:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfBVL44 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:56:56 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:54794 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfBVL44 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 06:56:56 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gx9Rl-0000Wm-8g; Fri, 22 Feb 2019 19:56:53 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gx9Rf-0007AT-Jp; Fri, 22 Feb 2019 19:56:47 +0800
Date:   Fri, 22 Feb 2019 19:56:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, tglx@linutronix.de,
        Atul Gupta <atul.gupta@chelsio.com>,
        Harsh Jain <harsh@chelsio.com>
Subject: Re: [PATCH 1/2] crypto: chtls: remove cdev_list_lock
Message-ID: <20190222115647.ttck2z3tlrxezx6b@gondor.apana.org.au>
References: <20190211110251.17377-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211110251.17377-1-bigeasy@linutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 11, 2019 at 12:02:50PM +0100, Sebastian Andrzej Siewior wrote:
> Last user of cdev_list_lock was removed in commit
> 
>   6422ccc5fbefb ("crypto/chelsio/chtls: listen fails with multiadapt")
> 
> Cc: Atul Gupta <atul.gupta@chelsio.com>
> Cc: Harsh Jain <harsh@chelsio.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/crypto/chelsio/chtls/chtls_main.c | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
