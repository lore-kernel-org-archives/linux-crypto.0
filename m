Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E257C10F03
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 07:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50A58217D7
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 07:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfDYHvz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 03:51:55 -0400
Received: from [5.180.42.13] ([5.180.42.13]:52396 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727631AbfDYHvz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 03:51:55 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hJZAd-0002Ld-KA; Thu, 25 Apr 2019 15:51:51 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hJZAc-00027I-24; Thu, 25 Apr 2019 15:51:50 +0800
Date:   Thu, 25 Apr 2019 15:51:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     linux-crypto@vger.kernel.org, yamada.masahiro@socionext.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ux500 - use ccflags-y instead of
 CFLAGS_<basename>.o
Message-ID: <20190425075150.fznwa2ozhjpt5cxz@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190419053757.18892-1-yamada.masahiro@socionext.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Masahiro Yamada <yamada.masahiro@socionext.com> wrote:
> Instead of adding CFLAGS_<basename>.o to every file, let's use
> ccflags-y, which is effective for all C files in the directory.
> 
> No behavior change.
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
> 
> drivers/crypto/ux500/cryp/Makefile | 6 +-----
> 1 file changed, 1 insertion(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
