Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CDCCA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A152B21D7B
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440676AbfJYPZ5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:25:57 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36034 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731226AbfJYPZ4 (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Fri, 25 Oct 2019 11:25:56 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iO1TP-0001sO-1w; Fri, 25 Oct 2019 23:25:55 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iO1TO-0007tU-AA; Fri, 25 Oct 2019 23:25:54 +0800
Date:   Fri, 25 Oct 2019 23:25:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Hook, Gary" <Gary.Hook@amd.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 3 0/2] Improve CCP error handling messages
Message-ID: <20191025152554.hxsr3utstiid3e5b@gondor.apana.org.au>
References: <157142758885.6869.11882127817423670946.stgit@taos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157142758885.6869.11882127817423670946.stgit@taos>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 18, 2019 at 07:39:59PM +0000, Hook, Gary wrote:
> This pair of patches is intended to clarify the messaging produced
> by the CCP driver when known, but non-critical, problems arise. The
> precipitating conditions can be determined based on simple, unalarming
> messages in the system log.
> 
> ---
> 
> Gary R Hook (2):
>       crypto: ccp - Change a message to reflect status instead of failure
>       crypto: ccp - Verify access to device registers before initializing
> 
> 
>  drivers/crypto/ccp/ccp-dev-v5.c |   14 +++++++++++++-
>  drivers/crypto/ccp/ccp-dev.c    |   15 ++++++++++++---
>  drivers/crypto/ccp/psp-dev.c    |   18 ++++++++++++++++--
>  3 files changed, 41 insertions(+), 6 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
