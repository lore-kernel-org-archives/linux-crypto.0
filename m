Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C640BC433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 09:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8219F61A42
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 09:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhCZJfE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Mar 2021 05:35:04 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35558 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230394AbhCZJem (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Mar 2021 05:34:42 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lPirS-0003ci-Qv; Fri, 26 Mar 2021 20:34:35 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Mar 2021 20:34:34 +1100
Date:   Fri, 26 Mar 2021 20:34:34 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Aditya Srivastava <yashsri421@gmail.com>
Cc:     lukas.bulwahn@gmail.com, corbet@lwn.net, rdunlap@infradead.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: amcc: fix incorrect kernel-doc comment syntax in
 files
Message-ID: <20210326093434.GQ12658@gondor.apana.org.au>
References: <20210321120832.12837-1-yashsri421@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210321120832.12837-1-yashsri421@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 21, 2021 at 05:38:32PM +0530, Aditya Srivastava wrote:
> The opening comment mark '/**' is used for highlighting the beginning of
> kernel-doc comments.
> There are certain files in drivers/crypto/amcc, which follow this syntax,
> but the content inside does not comply with kernel-doc.
> Such lines were probably not meant for kernel-doc parsing, but are parsed
> due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
> causes unexpected warnings from kernel-doc.
> 
> E.g., presence of kernel-doc like comment in
> drivers/crypto/amcc/crypto4xx_alg.c at header, and some other lines,
> causes these warnings by kernel-doc:
> 
> "warning: expecting prototype for AMCC SoC PPC4xx Crypto Driver(). Prototype was for set_dynamic_sa_command_0() instead"
> "warning: Function parameter or member 'dir' not described in 'set_dynamic_sa_command_0'"
> etc..
> 
> Provide a simple fix by replacing such occurrences with general comment
> format, i.e. '/*', to prevent kernel-doc from parsing it.
> 
> Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_alg.c     | 12 ++++++------
>  drivers/crypto/amcc/crypto4xx_core.c    | 18 +++++++++---------
>  drivers/crypto/amcc/crypto4xx_core.h    |  4 ++--
>  drivers/crypto/amcc/crypto4xx_reg_def.h |  8 ++++----
>  drivers/crypto/amcc/crypto4xx_sa.h      | 18 +++++++++---------
>  drivers/crypto/amcc/crypto4xx_trng.h    |  2 +-
>  6 files changed, 31 insertions(+), 31 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
