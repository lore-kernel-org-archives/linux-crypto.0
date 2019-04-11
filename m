Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1661CC10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 10:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0D442084D
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 10:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554978907;
	bh=BPu15EQCXncytuJ/klWU193XERiuL7U21XWAChE20MI=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:List-ID:From;
	b=GGs/hjO3CngDQthY4avn+d7zWaleyy0foRVahLQ0C4VL01Uo+vbwgdiK2CdxNkl87
	 vlcFhhxFW09kLRcHWgLfLpXw6RaKTsSiQ9ZNAmu6SBh2IHO2y6LpxITGJwv82HXaPn
	 tUg7xTlMhpzOqSRpta2zU8n70YNBBmPZqPDYA5D4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfDKKfG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 06:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfDKKfG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 06:35:06 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40AB82084D;
        Thu, 11 Apr 2019 10:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554978906;
        bh=BPu15EQCXncytuJ/klWU193XERiuL7U21XWAChE20MI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=t56eLH2gN7y1l9Ra3JxcOYyTnQn9Ab5RtTKrMmOablfO1vRBlJ34HHnLS2zqausMj
         kvPuVjrF+m3q3fepiT8ZxKWygVeXLA57JRsjI1Lyej+R25CQ1BV0073BLDJ7QQ/4xC
         VxsBF2ibjallHaXq5nnXErjFgOzfs0mLXiv+/I3g=
Date:   Thu, 11 Apr 2019 12:35:02 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Benjamin Tissoires <benjamin.tissoires@gmail.com>
cc:     Andrej Shadura <andrew.shadura@collabora.co.uk>,
        linux-input <linux-input@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        kernel@collabora.com, Theodore Ts'o <tytso@mit.edu>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3] HID: add driver for U2F Zero built-in LED and RNG
In-Reply-To: <CAN+gG=H6TGtB68-XJ+Pg53EhL_M2m8MG1z33Yenvd9PhXJ=Oqw@mail.gmail.com>
Message-ID: <nycvar.YFH.7.76.1904111234080.9803@cbobk.fhfr.pm>
References: <20190401124200.17331-1-andrew.shadura@collabora.co.uk> <nycvar.YFH.7.76.1904101400520.9803@cbobk.fhfr.pm> <CAN+gG=H6TGtB68-XJ+Pg53EhL_M2m8MG1z33Yenvd9PhXJ=Oqw@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 11 Apr 2019, Benjamin Tissoires wrote:

> > So I still am not really happy about this being wired up into generic HID
> > although it's really a USB driver, but we've discussed that already, and I
> > don't see any option that'd work substantially better in this case,
> > especially from the UX point of view. Oh well. Applied to for-5.2/u2fzero,
> > thanks!
> >
> 
> Hi wish I were CC-ed on these threads.

Gah, for some reason I was convinced you were.

> My CI script now fails because hid-u2fzero.ko needs devm_hwrng_register 
> and the Kconfig doesn't force pulling the right dependency.
> 
> Also, you probably want to add in .probe() a check for the actual 
> transport driver (`hid_is_using_ll_driver(hdev, &usb_hid_driver)`) or 
> you can not use the usbhid functions without crashing the kernel.

Benjamin, I love your CI :)

Andrej, could you please send fixups on top of the applied patch?

Thanks,

-- 
Jiri Kosina
SUSE Labs

