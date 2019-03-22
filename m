Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CCE8C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 12:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FEFD2070D
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 12:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731126AbfCVMnj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:43:39 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:49190 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732620AbfCVMni (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 08:43:38 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h7JWI-0003z1-7b; Fri, 22 Mar 2019 20:43:34 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h7JWF-0002wr-Jn; Fri, 22 Mar 2019 20:43:31 +0800
Date:   Fri, 22 Mar 2019 20:43:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Joe Perches <joe@perches.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [possible PATCH] crypto: sahara - Use #ifdef DEBUG not
 IS_ENABLED(DEBUG)
Message-ID: <20190322124331.s5iu4ontsakv7he5@gondor.apana.org.au>
References: <5ef0cab4dee128058a43f43c723c13924662e80d.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ef0cab4dee128058a43f43c723c13924662e80d.camel@perches.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 07, 2019 at 04:15:55PM -0800, Joe Perches wrote:
> Normal use of IS_ENABLED is with a CONFIG_<SYMBOL> and
> there is no -DDEBUG in the Makefile here.
> 
> Replace the IS_ENABLED(DEBUG) with #ifdef DEBUG/#endif
> blocks.
> 
> Miscellanea:
> 
> o Move the sahara_state array into the function that uses it.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/crypto/sahara.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)

Even if this is correct this is way too ugly.  The original code
at least compiled everything regardless of macros.  Your new code
won't detect compile errors in debugging code unless debugging is
enabled.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
