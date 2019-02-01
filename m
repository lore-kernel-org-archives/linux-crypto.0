Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE20C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DE3020870
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbfBAGvN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 01:51:13 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:57038 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfBAGvN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 01:51:13 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gpSfL-0000Cw-Le; Fri, 01 Feb 2019 14:51:07 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gpSfI-0005nt-FR; Fri, 01 Feb 2019 14:51:04 +0800
Date:   Fri, 1 Feb 2019 14:51:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     linux-crypto@vger.kernel.org, Harsh Jain <harsh@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: prefix header search paths with $(srctree)/
Message-ID: <20190201065104.vo7oi4y2eooja2dh@gondor.apana.org.au>
References: <1548388176-11325-1-git-send-email-yamada.masahiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548388176-11325-1-git-send-email-yamada.masahiro@socionext.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 25, 2019 at 12:49:36PM +0900, Masahiro Yamada wrote:
> Currently, the Kbuild core manipulates header search paths in a crazy
> way [1].
> 
> To fix this mess, I want all Makefiles to add explicit $(srctree)/ to
> the search paths in the srctree. Some Makefiles are already written in
> that way, but not all. The goal of this work is to make the notation
> consistent, and finally get rid of the gross hacks.
> 
> Having whitespaces after -I does not matter since commit 48f6e3cf5bc6
> ("kbuild: do not drop -I without parameter").
> 
> [1]: https://patchwork.kernel.org/patch/9632347/
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
> 
>  drivers/crypto/chelsio/Makefile            | 2 +-
>  drivers/crypto/chelsio/chtls/Makefile      | 3 ++-
>  drivers/crypto/qat/qat_c3xxx/Makefile      | 2 +-
>  drivers/crypto/qat/qat_c3xxxvf/Makefile    | 2 +-
>  drivers/crypto/qat/qat_c62x/Makefile       | 2 +-
>  drivers/crypto/qat/qat_c62xvf/Makefile     | 2 +-
>  drivers/crypto/qat/qat_dh895xcc/Makefile   | 2 +-
>  drivers/crypto/qat/qat_dh895xccvf/Makefile | 2 +-
>  8 files changed, 9 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
