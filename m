Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D1FC43331
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 11:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 973CC208D6
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 11:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbgCXL4J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Mar 2020 07:56:09 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37414 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727238AbgCXL4J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Mar 2020 07:56:09 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jGi9Y-0005xY-1w; Tue, 24 Mar 2020 22:55:29 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 24 Mar 2020 22:55:27 +1100
Date:   Tue, 24 Mar 2020 22:55:27 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        clang-built-linux@googlegroups.com, linux-crypto@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 16/16] crypto: x86 - clean up
 poly1305-x86_64-cryptogams.S by 'make clean'
Message-ID: <20200324115527.GC31003@gondor.apana.org.au>
References: <20200324084821.29944-1-masahiroy@kernel.org>
 <20200324084821.29944-17-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324084821.29944-17-masahiroy@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 24, 2020 at 05:48:21PM +0900, Masahiro Yamada wrote:
> poly1305-x86_64-cryptogams.S is a generated file, so it should be
> cleaned up by 'make clean'.
> 
> Assigning it to the variable 'targets' teaches Kbuild that it is a
> generated file. However, this line is not evaluated while cleaning
> because scripts/Makefile.clean does not include include/config/auto.conf.
> 
> Removing the ifneq-conditional, so this file is correctly cleaned up.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
> 
>  arch/x86/crypto/Makefile | 2 --
>  1 file changed, 2 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
