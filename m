Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7CDC432BE
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 06:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8249160EE6
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 06:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbhGWGND (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Jul 2021 02:13:03 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51490 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234164AbhGWGM7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jul 2021 02:12:59 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1m6p3s-0007C1-Sw; Fri, 23 Jul 2021 14:53:32 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1m6p3n-0002bE-GW; Fri, 23 Jul 2021 14:53:27 +0800
Date:   Fri, 23 Jul 2021 14:53:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        syzbot <syzbot+5d1bad8042a8f0e8117a@syzkaller.appspotmail.com>
Subject: Re: [PATCH] crypto: x86/aes-ni - add missing error checks in XTS code
Message-ID: <20210723065327.GA9958@gondor.apana.org.au>
References: <20210716165403.6115-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716165403.6115-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 16, 2021 at 06:54:03PM +0200, Ard Biesheuvel wrote:
> The updated XTS code fails to check the return code of skcipher_walk_virt,
> which may lead to skcipher_walk_abort() or skcipher_walk_done() being called
> while the walk argument is in an inconsistent state.
> 
> So check the return value after each such call, and bail on errors.
> 
> Fixes: 2481104fe98d ("crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper")
> Reported-by: Dave Hansen <dave.hansen@intel.com>
> Reported-by: syzbot <syzbot+5d1bad8042a8f0e8117a@syzkaller.appspotmail.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/crypto/aesni-intel_glue.c | 5 +++++
>  1 file changed, 5 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
