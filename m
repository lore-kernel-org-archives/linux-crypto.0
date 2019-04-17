Return-Path: <SRS0=UJZd=ST=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0374BC282DA
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 20:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0AFA217D7
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 20:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555532651;
	bh=xXeYjPW8tSIyQ8F+e79vTH5TgcdPGBP16JTZdNjRCKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=YqYocJzeXcxgW7ZTRZmMvzwL4QTGghGNjBsVo/MT2vZhGNjNmA41nhrtfqVphaS3V
	 KN6p2BniecuBrWcDNvxmZUEd1jL5/loJuri+XBnAItXsqe8kof21lp97M7/rYwF12n
	 x1VX7nxjagrpZ46MxtqeB2uT/pifAnC3MDCpVHCw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfDQUYL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 16:24:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbfDQUYK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 16:24:10 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10F2C206BA;
        Wed, 17 Apr 2019 20:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555532650;
        bh=xXeYjPW8tSIyQ8F+e79vTH5TgcdPGBP16JTZdNjRCKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W9Om0G04tIxMeV23xviuFBWo6mqOSehxjS9za5uqzkusl1BNhzQ+aNWdgdblm+SNK
         b5CzI61Zlu20vkdSNNWkiko7slVhImspSBtiWdm5LjoNnqt78b5wxAHcO9KW9fZLi8
         V2SYrPIU/I+Ov26gTFA8FSsh8GlwnKOUTuRFuRzs=
Date:   Wed, 17 Apr 2019 13:24:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Question regarding crypto scatterlists / testmgr
Message-ID: <20190417202407.GA96242@gmail.com>
References: <AM6PR09MB352386B26E3F632D6FE2FDDDD2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR09MB352386B26E3F632D6FE2FDDDD2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Wed, Apr 17, 2019 at 07:51:08PM +0000, Pascal Van Leeuwen wrote:
> Hi,
> 
> I'm trying to fix the inside-secure driver to pass all testmgr
> tests and I have one final issue remaining with the AEAD ciphers.
> As it was not clear at all what the exact problem was, I spent
> some time reverse engineering testmgr and I got the distinct
> impression that it is using scatter particles that cross page
> boundaries. On purpose, even.
> 
> While the inside-secure driver is built on the premise that
> scatter particles are continuous in device space. As I can't
> think of any reason why you would want to scatter/gather other
> than to handle virtual-to-physical address translation ...
> In any case, this should affect all other other operations as
> well, but maybe those just got "lucky" by getting particles
> that were still contiguous in device space, despite the page
> crossing (to *really* verify this, you would have to fully
> randomize your page allocation!)
> 
> Anyway, assuming that I *should* be able to handle particles
> that are *not* contiguous in device space, then there should
> probably already exist some function in the kernel API that
> converts a scatterlist with non-contiguous particles into a
> scatterlist with contiguous particles, taking into account the
> presence of an IOMMU? Considering pretty much every device
> driver would need to do that?
> Does anyone know which function(s) to use for that?
> 
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
> 

Indeed, since v5.1, testmgr tests scatterlist elements that cross a page.
However, the pages are guaranteed to be *physically* contiguous.  Does
dma_map_sg() not handle this?

BTW, this isn't just a theoretical case.  Many crypto API users do crypto on
kmalloced buffers, and those can cross a page boundary, especially if they are
large.  All software crypto algorithms handle this case.

The fact that these types of issues are just being considered now certainly
isn't raising my confidence in the hardware crypto drivers in the kernel...

- Eric
