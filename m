Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 593C8C2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 11:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38D8E613F1
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 11:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbhFQLfU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 07:35:20 -0400
Received: from verein.lst.de ([213.95.11.211]:58410 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231386AbhFQLfU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 07:35:20 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 99F0168C4E; Thu, 17 Jun 2021 13:33:09 +0200 (CEST)
Date:   Thu, 17 Jun 2021 13:33:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Hartmann <lukas@mntmn.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Marc Orr <marcorr@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Peter Gonda <pgonda@google.com>
Subject: Re: swiotlb/caamjr regression (Was: [GIT PULL] (swiotlb)
 stable/for-linus-5.12)
Message-ID: <20210617113309.GA17666@lst.de>
References: <YDkbCHHBUOmfI59K@Konrads-MacBook-Pro.local> <YL7XXNOnbaDgmTB9@atmark-techno.com> <2e899de2-4b69-c4b6-33a6-09fb8949d2fd@nxp.com> <20210611062153.GA30906@lst.de> <YMM8Ua0HMmErLIQg@0xbeefdead.lan> <CAMGD6P1v2JoJoxSuAYL8UjdtCaLCc4K_7xzVkumspeb0qn=LBQ@mail.gmail.com> <YMqW+/gQvM+uWUTw@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMqW+/gQvM+uWUTw@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 16, 2021 at 08:27:39PM -0400, Konrad Rzeszutek Wilk wrote:
> How unique is this NVMe? Should I be able to reproduce this with any
> type or is it specific to Google Cloud?

With swiotlb=force this should be reproducable everywhere.
