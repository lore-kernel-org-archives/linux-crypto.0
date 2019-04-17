Return-Path: <SRS0=UJZd=ST=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A77AC282DC
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 14:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BC37206BA
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 14:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555512203;
	bh=TjoCet4SUdHLl6Wp5fPXa7Tc/ci7wKaxu5Nvv2sWkj8=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:List-ID:From;
	b=KxbDrjGWxpj2cFB0h/NCy7e4FHOUb7K7lavOVVL0OTKnK3BZzRz1aLnwxemQ5I7nM
	 jX4xzva3vjOlQdlFVd9fCvVSgsbGSqywa5fFCotSc3X1JM1UT914xtdj4ninF5Wq/b
	 CntCGLKHLrxW9MGxAlTzgpQzPXwIjDVGpj8yGkO4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731996AbfDQOnW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731454AbfDQOnV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 10:43:21 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA54620663;
        Wed, 17 Apr 2019 14:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555512201;
        bh=TjoCet4SUdHLl6Wp5fPXa7Tc/ci7wKaxu5Nvv2sWkj8=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=WnaCyzlw0hAvSgdL1MzzxITKhZ3vts2t96vM199i1eCTWcs4e//mw6QGi6O5iFBQm
         shr+3smuIDFQ9MJMjHzEZJnIr+mLPX9ouXoh+gCDwdeQqdQcbArjqxkLpkftV8SiHy
         4xs6v5LrPDuFfdwRAPH94QC+mduniFqR0XDggbno=
Date:   Wed, 17 Apr 2019 16:43:17 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Andrej Shadura <andrew.shadura@collabora.co.uk>
cc:     Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        kernel@collabora.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3] HID: add driver for U2F Zero built-in LED and RNG
In-Reply-To: <d33b8772-bae6-1d20-8ff0-3397095f6e4b@collabora.co.uk>
Message-ID: <nycvar.YFH.7.76.1904171642020.9803@cbobk.fhfr.pm>
References: <20190401124200.17331-1-andrew.shadura@collabora.co.uk> <nycvar.YFH.7.76.1904101400520.9803@cbobk.fhfr.pm> <CAN+gG=H6TGtB68-XJ+Pg53EhL_M2m8MG1z33Yenvd9PhXJ=Oqw@mail.gmail.com> <nycvar.YFH.7.76.1904111234080.9803@cbobk.fhfr.pm>
 <d33b8772-bae6-1d20-8ff0-3397095f6e4b@collabora.co.uk>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 11 Apr 2019, Andrej Shadura wrote:

> >>> So I still am not really happy about this being wired up into generic HID
> >>> although it's really a USB driver, but we've discussed that already, and I
> >>> don't see any option that'd work substantially better in this case,
> >>> especially from the UX point of view. Oh well. Applied to for-5.2/u2fzero,
> >>> thanks!
> >>>
> >>
> >> Hi wish I were CC-ed on these threads.
> > 
> > Gah, for some reason I was convinced you were.
> > 
> >> My CI script now fails because hid-u2fzero.ko needs devm_hwrng_register 
> >> and the Kconfig doesn't force pulling the right dependency.
> 
> >> Also, you probably want to add in .probe() a check for the actual 
> >> transport driver (`hid_is_using_ll_driver(hdev, &usb_hid_driver)`) or 
> >> you can not use the usbhid functions without crashing the kernel.
> 
> Thanks, that’s very useful.
> 
> > Benjamin, I love your CI :)
> > 
> > Andrej, could you please send fixups on top of the applied patch?
> 
> Sure, will do.

I didn't receive any followup; the Kconfig dependency has already been 
fixed by Mao Wenan, and I've just queued the patch below on top of that as 
well.




From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] HID: u2fzero: fail probe if not using USB transport

u2fzero driver is USB-only. Therefore we have to give up in ->probe()
callback in case we're called with non-USB transport driver bound,
otherwise the kernel will crash trying to use USBHID API on a non-USB
transport.

Fixes: 42337b9d4d958("HID: add driver for U2F Zero built-in LED and RNG")
Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-u2fzero.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-u2fzero.c b/drivers/hid/hid-u2fzero.c
index d11a5cb56a0d..95e0807878c7 100644
--- a/drivers/hid/hid-u2fzero.c
+++ b/drivers/hid/hid-u2fzero.c
@@ -286,6 +286,9 @@ static int u2fzero_probe(struct hid_device *hdev,
 	unsigned int minor;
 	int ret;
 
+	if (!hid_is_using_ll_driver(hdev, &usb_hid_driver))
+		return -EINVAL;
+
 	dev = devm_kzalloc(&hdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL)
 		return -ENOMEM;

-- 
Jiri Kosina
SUSE Labs

