Return-Path: <SRS0=Yf/g=65=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3758EC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 19:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13CFB2076A
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 19:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589570227;
	bh=XBx66mGVJ7Tbb+phuQ5uMEEIItH+a9pVZe/h/WYga1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DvTp2Bmm8oUZUA/5k/crPLBWjA5S3Zr9NfeWdCPc2sF0lLU05+M0UGUPyC69EmEOA
	 xewdN2kC/xwisqFHWaRF5crG4Fnt1Jh5k4GRVvJcuCumX1uewcha750HFMzyyzCFP+
	 2q01t8MV0z08XZK1NXgvp5JDExdOYdqjckqySywY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgEOTRG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 May 2020 15:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgEOTRG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 May 2020 15:17:06 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9E7E20727;
        Fri, 15 May 2020 19:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589570226;
        bh=XBx66mGVJ7Tbb+phuQ5uMEEIItH+a9pVZe/h/WYga1s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1UWKkNNKCuIzrl5u6+/k8AYmsz01h1u+HcEBJ/L4lKNuC3iBVSz/ZOmmaLj2uBfL7
         ccDTssausF1EHjwGCk5y0XHUwHVwYRWaSsoGGmaIz2XUhlgAYJXiRdhDUn4GSKxFP9
         4VHfJV9HpwUW4vcJPE890Gi8KFTgoAPCFWyG//Xw=
Date:   Fri, 15 May 2020 12:17:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>
Cc:     linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ubifs: fix wrong use of crypto_shash_descsize()
Message-ID: <20200515191704.GE1009@sol.localdomain>
References: <20200502055945.1008194-1-ebiggers@kernel.org>
 <20200504071644.GS5877@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504071644.GS5877@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 04, 2020 at 09:16:44AM +0200, Sascha Hauer wrote:
> On Fri, May 01, 2020 at 10:59:45PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > crypto_shash_descsize() returns the size of the shash_desc context
> > needed to compute the hash, not the size of the hash itself.
> > 
> > crypto_shash_digestsize() would be correct, or alternatively using
> > c->hash_len and c->hmac_desc_len which already store the correct values.
> > But actually it's simpler to just use stack arrays, so do that instead.
> > 
> > Fixes: 49525e5eecca ("ubifs: Add helper functions for authentication support")
> > Fixes: da8ef65f9573 ("ubifs: Authenticate replayed journal")
> > Cc: <stable@vger.kernel.org> # v4.20+
> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Looks better that way, thanks.
> 
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> 

Richard, could you take this through the ubifs tree for 5.8?

- Eric
