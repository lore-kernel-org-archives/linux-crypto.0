Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75F5C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1C2A2089E
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405616AbfHIGVK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 02:21:10 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37522 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405603AbfHIGVK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 02:21:10 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hvyGr-0007Tk-EU; Fri, 09 Aug 2019 16:21:01 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hvyGn-0002tT-S8; Fri, 09 Aug 2019 16:20:57 +1000
Date:   Fri, 9 Aug 2019 16:20:57 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: initialize pd->cpu with effective cpumask
Message-ID: <20190809062057.GR10392@gondor.apana.org.au>
References: <20190808160535.27219-1-daniel.m.jordan@oracle.com>
 <84c4dc26-856a-7641-db38-62fa62ce8034@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84c4dc26-856a-7641-db38-62fa62ce8034@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 08, 2019 at 12:54:16PM -0400, Daniel Jordan wrote:
> On 8/8/19 12:05 PM, Daniel Jordan wrote:
> >Fixes: 726e431130f3 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")
> 
> Should be
> 
> 	 6fc4dbcf0276 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
