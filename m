Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8203C3A589
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 22:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EC902086C
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 22:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732335AbfHOWmL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 18:42:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57358 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731244AbfHOWmL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 18:42:11 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hyORd-0008M7-0C; Fri, 16 Aug 2019 08:42:09 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hyORb-0000ny-7G; Fri, 16 Aug 2019 08:42:07 +1000
Date:   Fri, 16 Aug 2019 08:42:07 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: crypto: hisilicon - Fix warning on printing %p with dma_addr_t
Message-ID: <20190815224207.GA3047@gondor.apana.org.au>
References: <20190815120313.GA29253@gondor.apana.org.au>
 <5D556981.2080309@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D556981.2080309@hisilicon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 15, 2019 at 10:17:37PM +0800, Zhou Wang wrote:
>
> > -	dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%pad\n", queue,
> > -		cmd, dma_addr);
> > +	dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%#lxad\n",
> > +		queue, cmd, (unsigned long)dma_addr);
> 
> Thanks. However, to be honest I can't get why we fix it like this.
> Can you give me a clue?

dma_addr_t is not a pointer.  It's an integer type and therefore
you need to print it out as such.

Actually my patch is buggy too, on some architectures it can be
a long long so we need to cast is such.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
