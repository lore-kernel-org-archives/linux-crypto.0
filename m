Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFAE8C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Feb 2022 16:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242667AbiBYQNj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Feb 2022 11:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242666AbiBYQNe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Feb 2022 11:13:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9684D9F8;
        Fri, 25 Feb 2022 08:13:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 634D961743;
        Fri, 25 Feb 2022 16:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C090C340E7;
        Fri, 25 Feb 2022 16:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645805581;
        bh=jt01kIc8j089u4k2Qkwdo2wyv3o+TW0lyH1J9zmLffY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mtsCG6GWUXJc3Bz0PD+LGadcwO49hYXB9NxWwK58IRveizIGJHxPcl/nCtE9xDB3O
         zzUF3KVgw5qJhG4u3RaGtW1rOebnEJo6nyfO4ed9pMr7IOgujwZHqRdb3l0LUa/xdO
         1Y22GWteHEf5kfOz4bfoty8L1/jT2nsSMVVEZgU4JaYe+JomrfvrT1ZQrhgVAKMVV5
         BVRB70E5ynby6zEgleP5g85w3DsopvUV962TRS6mDzIigOUNH4OG1iCuAMShznJIwI
         4JwDzSI3XRPpKfQam2qHoRSf2yNBadLgfV9TRLtWmArvp+5yE6ZBEl6B+BOA5Kaotm
         8TpOo2S0DJneQ==
Date:   Fri, 25 Feb 2022 08:12:59 -0800
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk,
        martin.petersen@oracle.com, colyli@suse.de
Subject: Re: [PATCHv3 07/10] lib: add crc64 tests
Message-ID: <20220225161259.GA4111669@dhcp-10-100-145-180.wdc.com>
References: <20220222163144.1782447-1-kbusch@kernel.org>
 <20220222163144.1782447-8-kbusch@kernel.org>
 <20220225160509.GE13610@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225160509.GE13610@lst.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 25, 2022 at 05:05:09PM +0100, Christoph Hellwig wrote:
> On Tue, Feb 22, 2022 at 08:31:41AM -0800, Keith Busch wrote:
> > Provide a module to test the rocksoft crc64 calculations with well known
> > inputs and exepected values. Check the generic table implementation and
> > whatever module is registered from the crypto library, and compare their
> > speeds.
> 
> The code looks good, but isn't the trent to use the kunit framework
> for these kinds of tests these days?

I don't have experience with kunit, but I'll look into that.

I am already changing the way this gets tested. Eric recommended adding
to the crypto "testmgr", and I've done that on my private tree. That
test framework exercises a lot more than this this patch, and it did
reveal a problem with how I've implemented the initial XOR when the
buffer is split, so I have some minor updates coming soon.
