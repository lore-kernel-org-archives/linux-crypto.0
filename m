Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254C3C0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 14:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9F8A21850
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 14:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfGCO25 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 10:28:57 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52220 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCO25 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 10:28:57 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1higFk-0000hS-1D; Wed, 03 Jul 2019 22:28:56 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1higFj-0000XI-LD; Wed, 03 Jul 2019 22:28:55 +0800
Date:   Wed, 3 Jul 2019 22:28:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Hook, Gary" <Gary.Hook@amd.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: ccp - Switch to SPDX license identifiers
Message-ID: <20190703142855.s7gdjvtinopd7s4b@gondor.apana.org.au>
References: <156165260743.2771.16127676244934163227.stgit@sosrh3.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156165260743.2771.16127676244934163227.stgit@sosrh3.amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 27, 2019 at 04:23:29PM +0000, Hook, Gary wrote:
> Add an SPDX identifier and remove any specific statements.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
>  drivers/crypto/ccp/ccp-crypto-aes-cmac.c   |    5 +----
>  drivers/crypto/ccp/ccp-crypto-aes-galois.c |    5 +----
>  drivers/crypto/ccp/ccp-crypto-aes-xts.c    |    5 +----
>  drivers/crypto/ccp/ccp-crypto-aes.c        |    4 ----
>  drivers/crypto/ccp/ccp-crypto-des3.c       |    5 +----
>  drivers/crypto/ccp/ccp-crypto-main.c       |    5 +----
>  drivers/crypto/ccp/ccp-crypto-rsa.c        |    5 +----
>  drivers/crypto/ccp/ccp-crypto-sha.c        |    5 +----
>  drivers/crypto/ccp/ccp-crypto.h            |    5 +----
>  drivers/crypto/ccp/ccp-debugfs.c           |    5 +----
>  drivers/crypto/ccp/ccp-dev-v3.c            |    5 +----
>  drivers/crypto/ccp/ccp-dev-v5.c            |    5 +----
>  drivers/crypto/ccp/ccp-dev.c               |    5 +----
>  drivers/crypto/ccp/ccp-dev.h               |    5 +----
>  drivers/crypto/ccp/ccp-dmaengine.c         |    5 +----
>  drivers/crypto/ccp/ccp-ops.c               |    4 ----
>  drivers/crypto/ccp/psp-dev.c               |    5 +----
>  drivers/crypto/ccp/psp-dev.h               |    5 +----
>  drivers/crypto/ccp/sp-dev.c                |    5 +----
>  drivers/crypto/ccp/sp-dev.h                |    5 +----
>  drivers/crypto/ccp/sp-pci.c                |    5 +----
>  drivers/crypto/ccp/sp-platform.c           |    5 +----
>  22 files changed, 20 insertions(+), 88 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
