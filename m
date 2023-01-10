Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE22C54EBE
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 07:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjAJHrL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 02:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjAJHrK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 02:47:10 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE4C178B2
        for <linux-crypto@vger.kernel.org>; Mon,  9 Jan 2023 23:47:09 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pF9Lf-00FwsK-2p; Tue, 10 Jan 2023 15:47:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Jan 2023 15:47:07 +0800
Date:   Tue, 10 Jan 2023 15:47:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Markus Stockhausen <markus.stockhausen@gmx.de>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 2/6] crypto/realtek: core functions
Message-ID: <Y70X+1alkLmnWBhR@gondor.apana.org.au>
References: <Y7fjvoc28CUza3qf@gondor.apana.org.au>
 <000f04f6ed4aef9bb4a67ae00fc259922f88090c.camel@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000f04f6ed4aef9bb4a67ae00fc259922f88090c.camel@gmx.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 06, 2023 at 05:17:16PM +0100, Markus Stockhausen wrote:
>
> Thanks, I need to check this again. CPU sets ownership bit in that
> descriptor to OWNED_BY_ASIC and after processing we expect that engine
> has set it back to OWNED_BY_CPU. So bidirectional operation is somehow
> needed.

For each bi-directional mapping, you must call

	dma_sync_single_for_cpu

before you read what the hardware has just written.  Then you make
your changes, and once you are done you do

	dma_sync_single_for_device

Note that you must ensure that the hardware does not modify the
memory area after you have called

	dma_sync_single_for_cpu

and before the next

	dma_sync_single_for_device

call.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
