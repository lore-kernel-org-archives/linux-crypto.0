Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CFCC282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 13:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2CC12133D
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 13:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548250657;
	bh=3a/MtQUpzEdTGF0DNHDAkp/SYrostyZCYJCi7oDxtKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hLmAgbULzq7ElJlzX6qgHUX2OgBR4awClgmSJ57tAueSDsKDbsZSyQ29Fp44CpZyX
	 ieatFQmcLsAucHD/39OjB1B4OHITzpdi1ZhFZlsJ5Is7fFDPI6w5Vprm5XLcPUGWXi
	 L0Bl4C8owz8RkQjjZ+MzAsygAPeSxCqTGH3jaXv0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfAWNhh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 08:37:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfAWNhh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 08:37:37 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FD1B20870;
        Wed, 23 Jan 2019 13:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548250656;
        bh=3a/MtQUpzEdTGF0DNHDAkp/SYrostyZCYJCi7oDxtKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HipdrgOStFWDbf0zUs9zEET6zNCrPVlQXhqPWgmb+AY8g52S532G+mqnWYldfSoC6
         cyc06EpUXiO045jVAu2mCe3i79IWqdc+jwNTxVmA2P6KMXf2dstb5ddzyQ7xNBhQvP
         SZWBTs+UTCSUchhARu7LppYhOqwpuPn1f6mjlr9g=
Date:   Wed, 23 Jan 2019 14:37:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Yael Chemla <yael.chemla@foss.arm.com>
Subject: Re: [PATCH 2/7] crypto: ccrree: no need to check return value of
 debugfs_create functions
Message-ID: <20190123133734.GA24700@kroah.com>
References: <20190122151422.14204-1-gregkh@linuxfoundation.org>
 <20190122151422.14204-3-gregkh@linuxfoundation.org>
 <CAOtvUMc92ghc4LjHYJ7z9r11Om82rw=mNdAqA1GYJMxmuUqCLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtvUMc92ghc4LjHYJ7z9r11Om82rw=mNdAqA1GYJMxmuUqCLw@mail.gmail.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 23, 2019 at 02:58:22PM +0200, Gilad Ben-Yossef wrote:
> Hi,
> 
> On Tue, Jan 22, 2019 at 5:14 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic should
> > never do something different based on this.
> 
> 
> 
> I get the part about not failing loading the driver just because some
> debugs entry isn't available,  but wont it be weird if
> debugfs_create_dir() fails but  debugfs_create_regset32() succeeds and
> we suddenly have weird files in the debugfs root dir?
> Not the end of the world of course but maybe it's better to avoid
> trying to create the files if the directory is not available?

See this patch to handle that theoretical issue:

	https://lore.kernel.org/lkml/20190123130917.GZ4087@dhcp22.suse.cz/T/#me91cc3d16185be13d64f85c8477c543cbda9baf6

thanks,

greg k-h
