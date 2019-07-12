Return-Path: <SRS0=HUI/=VJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE5AC742B2
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 10:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E1A721019
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 10:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfGLKGy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jul 2019 06:06:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:43770 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfGLKGx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jul 2019 06:06:53 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hlsRw-0005RC-6Z; Fri, 12 Jul 2019 18:06:44 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hlsRo-0007zt-RH; Fri, 12 Jul 2019 18:06:36 +0800
Date:   Fri, 12 Jul 2019 18:06:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
        andrea.parri@amarulasolutions.com, boqun.feng@gmail.com,
        paulmck@linux.ibm.com, peterz@infradead.org,
        linux-arch@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: use smp_mb in padata_reorder to avoid orphaned
 padata jobs
Message-ID: <20190712100636.mqdr567p7ozanlyl@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711221205.29889-1-daniel.m.jordan@oracle.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
>
> CPU0                                 CPU1
> 
> padata_reorder                       padata_do_serial
>  LOAD reorder_objects  // 0
>                                       INC reorder_objects  // 1
>                                       padata_reorder
>                                         TRYLOCK pd->lock   // failed
>  UNLOCK pd->lock

I think this can't happen because CPU1 won't call padata_reorder
at all as it's the wrong CPU so it gets pushed back onto a work
queue which will go back to CPU0.

Steffen, could you please take a look at this as there clearly
is a problem here?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
