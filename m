Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6C8CCA485
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 08:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbiF3ISA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 04:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbiF3IRO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 04:17:14 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1A642EDC;
        Thu, 30 Jun 2022 01:15:33 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o6pKc-00Cy6w-0i; Thu, 30 Jun 2022 18:15:23 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jun 2022 16:15:22 +0800
Date:   Thu, 30 Jun 2022 16:15:22 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jiang Jian <jiangjian@cdjrlc.com>
Cc:     davem@davemloft.net, leitao@debian.org, nayna@linux.ibm.com,
        pfsmorigo@gmail.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        jiangjian@cdjrlc.com
Subject: Re: [PATCH] crypto: vmx - drop unexpected word 'for' in comments
Message-ID: <Yr1bmlk7d2VmSR0c@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623103014.41269-1-jiangjian@cdjrlc.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jiang Jian <jiangjian@cdjrlc.com> wrote:
> there is an unexpected word 'for' in the comments that need to be dropped
> 
> file - drivers/crypto/vmx/ghashp8-ppc.pl
> line - 19
> 
> "# GHASH for for PowerISA v2.07."
> 
> changed to:
> 
> "# GHASH for PowerISA v2.07."
> 
> Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
> ---
> drivers/crypto/vmx/ghashp8-ppc.pl | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
