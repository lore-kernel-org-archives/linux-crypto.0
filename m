Return-Path: <SRS0=Odag=Z5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B732C43603
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Dec 2019 03:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58E1E21835
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Dec 2019 03:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfLGDkU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 22:40:20 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:44538 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfLGDkU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 22:40:20 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1idQx8-0002N4-V3; Sat, 07 Dec 2019 11:40:19 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1idQx7-00049e-PY; Sat, 07 Dec 2019 11:40:17 +0800
Date:   Sat, 7 Dec 2019 11:40:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/2] crypto: api - Do not zap spawn->alg
Message-ID: <20191207034017.6hy4wuua6f4ekmdr@gondor.apana.org.au>
References: <20191206143914.hfggirmmnjk27kx4@gondor.apana.org.au>
 <E1idElt-0001VY-O3@gondobar>
 <20191206225021.GF246840@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206225021.GF246840@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 06, 2019 at 02:50:21PM -0800, Eric Biggers wrote:
>
> This patch causes the below crash.

Yes I got carried away with rearranging the code in the function
crypto_more_spawns.  I shouldn't be using spawn as a list node
after doing the list_move call.  The code now looks like:

	n = list_prev_entry(spawn, list);
	list_move(&spawn->list, secondary_spawns);

	if (list_is_last(&n->list, stack))
		return top;

	n = list_next_entry(n, list);
	if (!spawn->dead)
		n->dead = false;

	return &n->inst->alg.cra_users;

> Also, some comments (e.g. for struct crypto_spawn and crypto_remove_spawns())
> would be really helpful to understand what's going on here.

crypto_remove_spawns is performing a depth-first walk on cra_users
without recursion.  In the specific case of a spawn removal triggered
by a new registration, we will halt the walk when we hit the
newly registered algorithm, and undo any actions that we did
on the path leading to that object.  The function crypto_more_spawns
performs the undo action.

I'll add this to crypto_remove_spawns.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
