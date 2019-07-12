Return-Path: <SRS0=HUI/=VJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48ED7C742B3
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 10:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25FDF2084B
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 10:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfGLKSI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jul 2019 06:18:08 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:44124 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbfGLKSH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jul 2019 06:18:07 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hlscw-0005dZ-Q1; Fri, 12 Jul 2019 18:18:06 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hlsct-0008Km-Uh; Fri, 12 Jul 2019 18:18:03 +0800
Date:   Fri, 12 Jul 2019 18:18:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Hook, Gary" <Gary.Hook@amd.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Subject: Re: [PATCH v2] crypto: ccp - memset structure fields to zero before
 reuse
Message-ID: <20190712101803.7fhefacu6l33eu4u@gondor.apana.org.au>
References: <20190710000849.3131-1-gary.hook@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710000849.3131-1-gary.hook@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 10, 2019 at 12:09:22AM +0000, Hook, Gary wrote:
> The AES GCM function reuses an 'op' data structure, which members
> contain values that must be cleared for each (re)use.
> 
> This fix resolves a crypto self-test failure:
> alg: aead: gcm-aes-ccp encryption test failed (wrong result) on test vector 2, cfg="two even aligned splits"
> 
> Fixes: 36cf515b9bbe ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
> 
> Changes since v1:
>  - Explain in the commit message that this fix resolves a failed test
> 
>  drivers/crypto/ccp/ccp-ops.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
