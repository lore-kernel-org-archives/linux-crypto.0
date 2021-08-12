Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A1FC4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 12:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B246260FED
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 12:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbhHLMZq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 08:25:46 -0400
Received: from verein.lst.de ([213.95.11.211]:44106 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233613AbhHLMZp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 08:25:45 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6B43868B05; Thu, 12 Aug 2021 14:25:18 +0200 (CEST)
Date:   Thu, 12 Aug 2021 14:25:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 13/13] nvme: add non-standard ECDH and curve25517
 algorithms
Message-ID: <20210812122518.GA19050@lst.de>
References: <20210810124230.12161-1-hare@suse.de> <20210810124230.12161-14-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810124230.12161-14-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 10, 2021 at 02:42:30PM +0200, Hannes Reinecke wrote:
> TLS 1.3 specifies ECDH and curve25517 in addition to the FFDHE
> groups, and these are already implemented in the kernel.
> So add support for these non-standard groups for NVMe in-band
> authentication to validate the augmented challenge implementation.

If you think these are useful please add them to the standard.
