Return-Path: <SRS0=WH6x=DO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0944CC4363C
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 06:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5B0720797
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 06:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgJGGuy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Oct 2020 02:50:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36490 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgJGGuy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Oct 2020 02:50:54 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kQ3Hk-0001e2-PL; Wed, 07 Oct 2020 17:50:49 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 Oct 2020 17:50:48 +1100
Date:   Wed, 7 Oct 2020 17:50:48 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Kim Phillips <kim.phillips@arm.com>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] crypto: talitos - Fix sparse warnings
Message-ID: <20201007065048.GA25944@gondor.apana.org.au>
References: <20201002115236.GA14707@gondor.apana.org.au>
 <be222fed-425b-d55c-3efc-9c4e873ccf8e@csgroup.eu>
 <20201002124223.GA1547@gondor.apana.org.au>
 <20201002124341.GA1587@gondor.apana.org.au>
 <20201003191553.Horde.qhVjpQA-iJND7COibFfWZQ7@messagerie.c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003191553.Horde.qhVjpQA-iJND7COibFfWZQ7@messagerie.c-s.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 03, 2020 at 07:15:53PM +0200, Christophe Leroy wrote:
>
> The following changes fix the sparse warnings with less churn:

Yes that works too.  Can you please submit this patch?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
