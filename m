Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA3BC4167D
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Oct 2023 13:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbjJ3N2Z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Oct 2023 09:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbjJ3N2Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2023 09:28:25 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E3AC6
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 06:28:19 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D70A26732A; Mon, 30 Oct 2023 14:28:16 +0100 (CET)
Date:   Mon, 30 Oct 2023 14:28:16 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] nvme-auth: use crypto_shash_tfm_digest()
Message-ID: <20231030132816.GC21741@lst.de>
References: <20231029050040.154563-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231029050040.154563-1-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 28, 2023 at 10:00:40PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Simplify nvme_auth_augmented_challenge() by using
> crypto_shash_tfm_digest() instead of an alloc+init+update+final
> sequence.  This should also improve performance.

Nice:

Reviewed-by: Christoph Hellwig <hch@lst.de>
