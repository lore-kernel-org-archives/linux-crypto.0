Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D589C33CA2
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 05:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CE972073A
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 05:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgAIFO2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 00:14:28 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:40400 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbgAIFO2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 00:14:28 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ipQ9L-0003Hv-D5; Thu, 09 Jan 2020 13:14:27 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ipQ9L-0003WS-8G; Thu, 09 Jan 2020 13:14:27 +0800
Date:   Thu, 9 Jan 2020 13:14:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: crypto4xx - reduce memory fragmentation
Message-ID: <20200109051427.2ojms7r2xonz4esh@gondor.apana.org.au>
References: <3913dbe4b3256ead342572f7aba726a60ab5fd43.1577917078.git.chunkeey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3913dbe4b3256ead342572f7aba726a60ab5fd43.1577917078.git.chunkeey@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 01, 2020 at 11:27:01PM +0100, Christian Lamparter wrote:
> With recent kernels (>5.2), the driver fails to probe, as the
> allocation of the driver's scatter buffer fails with -ENOMEM.
> 
> This happens in crypto4xx_build_sdr(). Where the driver tries
> to get 512KiB (=PPC4XX_SD_BUFFER_SIZE * PPC4XX_NUM_SD) of
> continuous memory. This big chunk is by design, since the driver
> uses this circumstance in the crypto4xx_copy_pkt_to_dst() to
> its advantage:
> "all scatter-buffers are all neatly organized in one big
> continuous ringbuffer; So scatterwalk_map_and_copy() can be
> instructed to copy a range of buffers in one go."
> 
> The PowerPC arch does not have support for DMA_CMA. Hence,
> this patch reorganizes the order in which the memory
> allocations are done. Since the driver itself is responsible
> for some of the issues.
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_core.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
