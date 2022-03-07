Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F1EC433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Mar 2022 19:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235042AbiCGTft (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Mar 2022 14:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiCGTfs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Mar 2022 14:35:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C724985954;
        Mon,  7 Mar 2022 11:34:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 762DEB81624;
        Mon,  7 Mar 2022 19:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2150C340EB;
        Mon,  7 Mar 2022 19:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646681691;
        bh=Kvgns/YlDo0vpvFknphX79mvF67+VFJcLl06LDvNsrM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fu2ZlMXzitDWAQ01ZFHTqqwokCMbErYBWePakLmsNTdU6gZPLz1EpG/h36SuDNFtH
         +WyL9Ulswhfxm1l03o6mZnBrNeFZ3Snch3DgdUGOA8F+KqlLQweDk2eApCRhOLueQ8
         +veMHeuAcrzCMozh0qHoZukKcK0AW4tRmXWeujoFhyqIxGQWjtOPdICTptOOaH/SLQ
         oZJzd9Wo4ELIfaYz81RmPrMVcn4b4z04ALWvaxHzRyrCVXOb+TwFq50zmpAockh0HX
         Dv5LwMd+W/Q8PCQQ5GMebS3bGl70L5hQDWVyscfQGqu3BXUDoJaMP57VH7dijdazE1
         XjPHl3JVwoLWw==
Date:   Mon, 7 Mar 2022 11:34:48 -0800
From:   Keith Busch <kbusch@kernel.org>
To:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com
Subject: Re: [PATCHv4 0/8] 64-bit data integrity field support
Message-ID: <20220307193448.GC3260574@dhcp-10-100-145-180.wdc.com>
References: <20220303201312.3255347-1-kbusch@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303201312.3255347-1-kbusch@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jens,

I believe this is looking ready at this point. Would it be too ambitious
to see this applied ahead of 5.18? The block layer provides the focal
point for new capabilities in this series, so I feel it should go
through that tree if you're okay with this.

Thanks,
Keith
