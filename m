Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0715C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 11:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9880F20718
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 11:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbfKVLLe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 06:11:34 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54084 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729410AbfKVLLc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 06:11:32 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iY6qZ-0005XE-QA; Fri, 22 Nov 2019 19:11:31 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iY6qY-0002m8-1L; Fri, 22 Nov 2019 19:11:30 +0800
Date:   Fri, 22 Nov 2019 19:11:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org,
        yamada.masahiro@socionext.com
Subject: Re: [PATCH] crypto: vmx - Avoid weird build failures
Message-ID: <20191122111129.nu5lr5nfxilsjsy5@gondor.apana.org.au>
References: <20191120112738.7031-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120112738.7031-1-mpe@ellerman.id.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 20, 2019 at 10:27:38PM +1100, Michael Ellerman wrote:
> In the vmx crypto Makefile we assign to a variable called TARGET and
> pass that to the aesp8-ppc.pl and ghashp8-ppc.pl scripts.
> 
> The variable is meant to describe what flavour of powerpc we're
> building for, eg. either 32 or 64-bit, and big or little endian.
> 
> Unfortunately TARGET is a fairly common name for a make variable, and
> if it happens that TARGET is specified as a command line parameter to
> make, the value specified on the command line will override our value.
> 
> In particular this can happen if the kernel Makefile is driven by an
> external Makefile that uses TARGET for something.
> 
> This leads to weird build failures, eg:
>   nonsense  at /build/linux/drivers/crypto/vmx/ghashp8-ppc.pl line 45.
>   /linux/drivers/crypto/vmx/Makefile:20: recipe for target 'drivers/crypto/vmx/ghashp8-ppc.S' failed
> 
> Which shows that we passed an empty value for $(TARGET) to the perl
> script, confirmed with make V=1:
> 
>   perl /linux/drivers/crypto/vmx/ghashp8-ppc.pl  > drivers/crypto/vmx/ghashp8-ppc.S
> 
> We can avoid this confusion by using override, to tell make that we
> don't want anything to override our variable, even a value specified
> on the command line. We can also use a less common name, given the
> script calls it "flavour", let's use that.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  drivers/crypto/vmx/Makefile | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
