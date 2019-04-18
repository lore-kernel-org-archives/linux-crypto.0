Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95AAC10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4FE220675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389069AbfDROXz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:23:55 -0400
Received: from [5.180.42.13] ([5.180.42.13]:55118 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388806AbfDROXz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 10:23:55 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hH7x9-0004ke-N7; Thu, 18 Apr 2019 22:23:51 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hH7x8-0004Bn-0h; Thu, 18 Apr 2019 22:23:50 +0800
Date:   Thu, 18 Apr 2019 22:23:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Joe Perches <joe@perches.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: sahara: Convert IS_ENABLED uses to
 __is_defined
Message-ID: <20190418142349.ood6asawybbxy44j@gondor.apana.org.au>
References: <3c15d21d2b6896e76e8801dc07de2bae1dadceb1.1554827560.git.joe@perches.com>
 <320188162965670a5a0a90f693f8082229b88ee2.1554827560.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <320188162965670a5a0a90f693f8082229b88ee2.1554827560.git.joe@perches.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 09, 2019 at 09:33:13AM -0700, Joe Perches wrote:
> IS_ENABLED should be reserved for CONFIG_<FOO> uses so convert
> the uses of IS_ENABLED with a #define to __is_defined.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/crypto/sahara.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
