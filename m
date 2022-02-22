Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C004DC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Feb 2022 19:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbiBVTzC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Feb 2022 14:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiBVTzC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Feb 2022 14:55:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57787C486B;
        Tue, 22 Feb 2022 11:54:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15425B81C5B;
        Tue, 22 Feb 2022 19:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EEAC340E8;
        Tue, 22 Feb 2022 19:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645559673;
        bh=2yoZXAZ2q0++zmDjP+ejRntLgW9usbykRPKM+jn7RvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F8UWrXJujLmvHh1w9CqBKy4QutjAMfCCUw/wULVyy+4whPVz+AQ6eIhIlZ5+tvwIF
         Uo6oIDK8PmySh3bxyFhbUoVovrdntR/sm7clciM6v5dW+KSTLkQ+TOXvsNAfFuQekU
         smFD6X+zDZiKjlpeYgxSinerPqxZdGO1YAzOh51O5n17SXSNsfynAh4TYGYm3R6Ml0
         VJrIy8r+nqrYalv3nLt5W4otYLms6QueecW67VJ7SpQ2nL3Q9MupfWvk97Sv1IeXkx
         wSPCXynfm22snba36Zg9KqZzFctDsZCQgVIvfWguIIbV+jddkxUz6YmtMFaRCEeQH8
         WyPUgnsOv6hXg==
Date:   Tue, 22 Feb 2022 11:54:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Keith Busch <kbusch@kernel.org>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        martin.petersen@oracle.com, colyli@suse.de
Subject: Re: [PATCHv3 06/10] crypto: add rocksoft 64b crc framework
Message-ID: <YhU/d6wn55/GWPxm@sol.localdomain>
References: <20220222163144.1782447-1-kbusch@kernel.org>
 <20220222163144.1782447-7-kbusch@kernel.org>
 <YhU+kuMhueXVQvxe@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhU+kuMhueXVQvxe@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 22, 2022 at 11:50:44AM -0800, Eric Biggers wrote:
> > +config CRC64_ROCKSOFT
> > +	tristate "CRC calculation for the Rocksoft^TM model CRC64"
> 
> I'm sure what the rules for trademarks are, but kernel source code usually
> doesn't have the trademark symbol/abbreviation scattered everywhere.
> 
> > +	select CRYPTO
> > +	select CRYPTO_CRC64_ROCKSOFT
> > +	help
> > +	  This option is only needed if a module that's not in the
> > +	  kernel tree needs to calculate CRC checks for use with the
> > +	  rocksoft model parameters.
> 
> Out-of-tree modules can't be the reason to have a kconfig option.  What is the
> real reason?

Also this option can be enabled without the CONFIG_CRC64 it depends on, which is
broken.

- Eric
