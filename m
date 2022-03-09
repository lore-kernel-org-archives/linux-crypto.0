Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63DDDC433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Mar 2022 03:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiCIDWf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Mar 2022 22:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiCIDWe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Mar 2022 22:22:34 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F9414E95E;
        Tue,  8 Mar 2022 19:21:37 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nRmtJ-0002wo-Pl; Wed, 09 Mar 2022 14:21:34 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 09 Mar 2022 15:21:33 +1200
Date:   Wed, 9 Mar 2022 15:21:33 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     =?utf-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Cc:     linux-kernel@vger.kernel.org, thomas.lendacky@amd.com,
        john.allen@amd.com, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, davispuh@gmail.com
Subject: Re: [PATCH] ccp: ccp_dmaengine_unregister release dma channels
Message-ID: <YigdPfAF8y3LBtl2@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220228031545.11639-1-davispuh@gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Dāvis Mosāns <davispuh@gmail.com> wrote:
> ccp_dmaengine_register adds dma_chan->device_node to dma_dev->channels list
> but ccp_dmaengine_unregister didn't remove them.
> That can cause crashes in various dmaengine methods that tries to use dma_dev->channels
> 
> Signed-off-by: Dāvis Mosāns <davispuh@gmail.com>
> ---
> drivers/crypto/ccp/ccp-dmaengine.c | 16 ++++++++++++++++
> 1 file changed, 16 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
