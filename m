Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01BDC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Dec 2021 08:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhLMII5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Dec 2021 03:08:57 -0500
Received: from verein.lst.de ([213.95.11.211]:46562 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229674AbhLMII4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Dec 2021 03:08:56 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id AED8C68BFE; Mon, 13 Dec 2021 09:08:53 +0100 (CET)
Date:   Mon, 13 Dec 2021 09:08:53 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCHv8 00/12] nvme: In-band authentication support
Message-ID: <20211213080853.GA21223@lst.de>
References: <20211202152358.60116-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202152358.60116-1-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

So if we want to make progress on this we need the first 3 patches
rewviewed by the crypto maintainers.  In fact I'd prefer to get them
merged through the crypto tree as well, and would make sure we have
a branch that pulls them in for the nvme changes.  I'll try to find
some time to review the nvme bits as well.
