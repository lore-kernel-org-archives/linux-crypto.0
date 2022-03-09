Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9661AC433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Mar 2022 04:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiCIE6I (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Mar 2022 23:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCIE6H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Mar 2022 23:58:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052BA15D385;
        Tue,  8 Mar 2022 20:57:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C96EB81EEF;
        Wed,  9 Mar 2022 04:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEF1C340E8;
        Wed,  9 Mar 2022 04:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646801826;
        bh=L5U8vsPaENDSyYguGNWyibqEz/g1fEThZqDRlD+omU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pWqNKdghmGYn2ranoR14iRRFdhzL3REWYIJfUMbCtpzxEmL0R8ShO5qZ460ScxaeI
         lTHZX3VENrcohgn2dce8zXtkMVx/HeZewkyBTT2nYEXxSgJJOaZZ1rAO9FzaRS3BcI
         LOX8ZlMYzgOmNFXtp14w8xCHy0hbTe3mUVVGsm5P5WcqjasuE4NRjOR30jRD3RnzIh
         g/QEu2c9QWgY1g8kunf+A26B83h4e4SaxPthZC/tjJUvvd4R42tFuBvLbj8qncFI+M
         6p6w9hCIsy+tKtQCDaWXkNMEjoaiBdWHayHzOPDbiM+k+ygYIwfwPrtO0F/ZOvYQEz
         /rD0NMmOvrPOA==
Date:   Tue, 8 Mar 2022 20:57:04 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Vasily Gorbik <gor@linux.ibm.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        martin.petersen@oracle.com
Subject: Re: [PATCHv4 6/8] crypto: add rocksoft 64b crc guard tag framework
Message-ID: <YigzoKRJ1EHFRZY9@sol.localdomain>
References: <20220303201312.3255347-1-kbusch@kernel.org>
 <20220303201312.3255347-7-kbusch@kernel.org>
 <your-ad-here.call-01646770901-ext-3299@work.hours>
 <20220308202747.GA3502158@dhcp-10-100-145-180.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308202747.GA3502158@dhcp-10-100-145-180.wdc.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 08, 2022 at 12:27:47PM -0800, Keith Busch wrote:
> On Tue, Mar 08, 2022 at 09:21:41PM +0100, Vasily Gorbik wrote:
> > On Thu, Mar 03, 2022 at 12:13:10PM -0800, Keith Busch wrote:
> > > Hardware specific features may be able to calculate a crc64, so provide
> > > a framework for drivers to register their implementation. If nothing is
> > > registered, fallback to the generic table lookup implementation. The
> > > implementation is modeled after the crct10dif equivalent.
> > 
> > Hi Keith,
> > 
> > this is failing on big-endian systems. I get the following on s390:
> 
> Oh, I see the put_unaligned_le64() in chksum_final() was not the correct
> action. I'll send an update, thank you for the report.

Or you could make the digests in your test vectors have have a consistent byte
order, probably little endian.  That's how "shash" algorithms in the crypto API
normally work, including crc32 and crc32c; they produce bytes as output.  I see
that crct10dif violates that convention, and I assume you copied it from there.
I'm not sure you should do that; crct10dif might be more of a one-off quirk.

- Eric
