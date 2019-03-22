Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060BBC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB7E120693
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730915AbfCVNEc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:04:32 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:49496 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730773AbfCVNEc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 09:04:32 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h7JqX-0006JH-L9; Fri, 22 Mar 2019 21:04:29 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h7JqS-0005en-TJ; Fri, 22 Mar 2019 21:04:24 +0800
Date:   Fri, 22 Mar 2019 21:04:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Axtens <dja@axtens.net>
Cc:     omosnacek@gmail.com, linux-crypto@vger.kernel.org,
        marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
Message-ID: <20190322130424.rtzrkcosziol4moi@gondor.apana.org.au>
References: <20190315020901.16509-1-dja@axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190315020901.16509-1-dja@axtens.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 15, 2019 at 01:09:01PM +1100, Daniel Axtens wrote:
> The original assembly imported from OpenSSL has two copy-paste
> errors in handling CTR mode. When dealing with a 2 or 3 block tail,
> the code branches to the CBC decryption exit path, rather than to
> the CTR exit path.
> 
> This leads to corruption of the IV, which leads to subsequent blocks
> being corrupted.
> 
> This can be detected with libkcapi test suite, which is available at
> https://github.com/smuellerDD/libkcapi
> 
> Reported-by: Ondrej Mosnáček <omosnacek@gmail.com>
> Fixes: 5c380d623ed3 ("crypto: vmx - Add support for VMS instructions by ASM")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Axtens <dja@axtens.net>
> ---
>  drivers/crypto/vmx/aesp8-ppc.pl | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
