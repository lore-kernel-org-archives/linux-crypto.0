Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E09C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 21:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EFA0222DF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 21:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfKSVxw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 16:53:52 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:47936 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbfKSVxw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 16:53:52 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iXBRT-0008JI-AN; Wed, 20 Nov 2019 05:53:47 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iXBRR-0007Yb-Vw; Wed, 20 Nov 2019 05:53:46 +0800
Date:   Wed, 20 Nov 2019 05:53:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Remove broken queue flushing
Message-ID: <20191119215345.jr7y47b37ivshwcm@gondor.apana.org.au>
References: <20191119051731.yev6dcsp2znjaagz@gondor.apana.org.au>
 <20191119192405.imfi6q4u3g2zgstc@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119192405.imfi6q4u3g2zgstc@ca-dmjordan1.us.oracle.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 19, 2019 at 02:24:05PM -0500, Daniel Jordan wrote:
>
> __padata_free unconditionally frees pd, so a padata job might choke on it
> later.  padata_do_parallel calls seem safe because they use RCU, but it seems
> possible that a job could call padata_do_serial after the instance is gone.

Actually __padata_free no longer frees the pd after my patch.

We should also mandate that __padata_free can only be called after
all jobs have completed.  This is already the case with pcrypt.

In fact we should discuss merging padata into pcrypt.  It's been
10 years and not a single user of padata has emerged in the kernel.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
