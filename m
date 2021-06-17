Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39DE6C2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 05:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EC606128C
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 05:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhFQFOn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 01:14:43 -0400
Received: from verein.lst.de ([213.95.11.211]:57035 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhFQFOm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 01:14:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 91CAC68C4E; Thu, 17 Jun 2021 07:12:32 +0200 (CEST)
Date:   Thu, 17 Jun 2021 07:12:32 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>
Cc:     Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
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
Message-ID: <20210617051232.GB27192@lst.de>
References: <YDkbCHHBUOmfI59K@Konrads-MacBook-Pro.local> <YL7XXNOnbaDgmTB9@atmark-techno.com> <2e899de2-4b69-c4b6-33a6-09fb8949d2fd@nxp.com> <20210611062153.GA30906@lst.de> <YMM8Ua0HMmErLIQg@0xbeefdead.lan> <CAMGD6P1v2JoJoxSuAYL8UjdtCaLCc4K_7xzVkumspeb0qn=LBQ@mail.gmail.com> <YMqW+/gQvM+uWUTw@fedora> <YMqZswFnSNKk4Z7B@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMqZswFnSNKk4Z7B@atmark-techno.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 17, 2021 at 09:39:15AM +0900, Dominique MARTINET wrote:
> Konrad Rzeszutek Wilk wrote on Wed, Jun 16, 2021 at 08:27:39PM -0400:
> > Thank you for testing that - and this is a bummer indeed.
> 
> Hm, actually not that surprising if it was working without the offset
> adjustments and doing non-aligned mappings -- perhaps the nvme code just
> needs to round the offsets down instead of expecting swiotlb to do it?

It can't.  The whole point of the series was to keep the original offsets.
