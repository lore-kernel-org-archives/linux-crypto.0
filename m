Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E6CC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Feb 2022 16:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239003AbiBYQCc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Feb 2022 11:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbiBYQCb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Feb 2022 11:02:31 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73CB1F1255;
        Fri, 25 Feb 2022 08:01:59 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9CA7268AA6; Fri, 25 Feb 2022 17:01:55 +0100 (CET)
Date:   Fri, 25 Feb 2022 17:01:55 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@kernel.org>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        martin.petersen@oracle.com, colyli@suse.de,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 01/10] block: support pi with extended metadata
Message-ID: <20220225160155.GA13610@lst.de>
References: <20220222163144.1782447-1-kbusch@kernel.org> <20220222163144.1782447-2-kbusch@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222163144.1782447-2-kbusch@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
