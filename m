Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6EBC0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 14:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C74F2218A4
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 14:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfGCO2l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 10:28:41 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52204 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCO2l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 10:28:41 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1higFT-0000gx-O9; Wed, 03 Jul 2019 22:28:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1higFS-0000X4-En; Wed, 03 Jul 2019 22:28:38 +0800
Date:   Wed, 3 Jul 2019 22:28:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Hook, Gary" <Gary.Hook@amd.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v2] crypto: ccp - Validate the the error value used to
 index error messages
Message-ID: <20190703142838.f6eszypus7yu62h3@gondor.apana.org.au>
References: <156165202737.28135.12079221811780949916.stgit@taos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156165202737.28135.12079221811780949916.stgit@taos>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 27, 2019 at 04:16:23PM +0000, Hook, Gary wrote:
> The error code read from the queue status register is only 6 bits wide,
> but we need to verify its value is within range before indexing the error
> messages.
> 
> Fixes: 81422badb3907 ("crypto: ccp - Make syslog errors human-readable")
> 
> Reported-by: Cfir Cohen <cfir@google.com>
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
> 
> Changes since v1:
>  - change parameter type to unsigned int and remove a check
> 
>  drivers/crypto/ccp/ccp-dev.c |   96 ++++++++++++++++++++++--------------------
>  drivers/crypto/ccp/ccp-dev.h |    2 -
>  2 files changed, 52 insertions(+), 46 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
