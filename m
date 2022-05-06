Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BC0C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  6 May 2022 10:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390956AbiEFK1M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 May 2022 06:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390953AbiEFK1L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 May 2022 06:27:11 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5500063BF4;
        Fri,  6 May 2022 03:23:29 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nmv7K-00AgLS-Hp; Fri, 06 May 2022 20:23:24 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 May 2022 18:23:22 +0800
Date:   Fri, 6 May 2022 18:23:22 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: vmx - Align the short log with Makefile cleanups
Message-ID: <YnT3GtU975OsXVuN@gondor.apana.org.au>
References: <20220501130749.1123387-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501130749.1123387-1-masahiroy@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, May 01, 2022 at 10:07:49PM +0900, Masahiro Yamada wrote:
> I notieced the log is not properly aligned:
> 
>   PERL drivers/crypto/vmx/aesp8-ppc.S
>   CC [M]  fs/xfs/xfs_reflink.o
>   PERL drivers/crypto/vmx/ghashp8-ppc.S
>   CC [M]  drivers/crypto/vmx/aes.o
> 
> Add some spaces after 'PERL'.
> 
> While I was here, I cleaned up the Makefile:
> 
>  - Merge the two similar rules
> 
>  - Remove redundant 'clean-files' (Having 'targets' is enough)
> 
>  - Move the flavour into the build command
> 
> This still avoids the build failures fixed by commit 4ee812f6143d
> ("crypto: vmx - Avoid weird build failures").
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
> 
>  drivers/crypto/vmx/Makefile | 17 +++--------------
>  1 file changed, 3 insertions(+), 14 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
