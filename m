Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2175AC4320A
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 23:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F38E6610E5
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 23:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbhHRXfx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Aug 2021 19:35:53 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53344 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234794AbhHRXfv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Aug 2021 19:35:51 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mGV5P-0003eP-8C; Thu, 19 Aug 2021 07:35:07 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mGV5M-00060d-Le; Thu, 19 Aug 2021 07:35:04 +0800
Date:   Thu, 19 Aug 2021 07:35:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
Cc:     zhenwei pi <pizhenwei@bytedance.com>, dhowells@redhat.com,
        davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PING: [PATCH] crypto: public_key: fix overflow during implicit
 conversion
Message-ID: <20210818233504.GA23076@gondor.apana.org.au>
References: <20210810063954.628244-1-pizhenwei@bytedance.com>
 <4dcd4254-030b-4489-d5d3-e320eb2953e7@bytedance.com>
 <74aef8a2f2331358371a87931e632287dad9af59.camel@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74aef8a2f2331358371a87931e632287dad9af59.camel@iki.fi>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 18, 2021 at 03:33:32PM +0300, Jarkko Sakkinen wrote:
> On Wed, 2021-08-18 at 16:33 +0800, zhenwei pi wrote:
> > PING
> 
> Please, do not top-post.
> 
> You are lacking Herbert Xu:

I think he already cc'ed me but this patch really belongs to David
Howells' tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
