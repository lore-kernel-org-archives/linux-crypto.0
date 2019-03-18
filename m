Return-Path: <SRS0=sPcw=RV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88189C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 14:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5829D20872
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 14:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552920300;
	bh=HwXCDnAmAfVpJA6mMpOMq52cSwatbsyVLSlmJQw+e3Q=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:List-ID:From;
	b=uxgbF2qlYjySJt63T0gtFfEkdT5ZM9X4lNAi2YC2PPTSmuLp/K7aNEm3WMcizRiMr
	 V78p1FypsqNnT1lRqv8LPXkNqUMGzXX1VlGcFwQG726lTd23rHMsU13q62SQniyOOq
	 SDFExoVqh2pMS+igP1Dxuyq9O0ez2kTYAkeiDp1g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfCROo7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Mar 2019 10:44:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbfCROo7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Mar 2019 10:44:59 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 072C320850;
        Mon, 18 Mar 2019 14:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552920298;
        bh=HwXCDnAmAfVpJA6mMpOMq52cSwatbsyVLSlmJQw+e3Q=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=1vNwvI52i00JZparX3X62xkkFJOAFiMQ/5aoQvs+dRDl2mya/UVN7b4oRILrhSBoE
         o54lnpHIVxD4lUwf9T1bZ4noSmJEPO2VnbCIWY11VcvSnON8vYkgQKfP859l75TkMT
         zb8EHh6FzCbCDvz0tPb6DMLdW/8Ne//qEaSGPZOE=
Date:   Mon, 18 Mar 2019 15:44:55 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Andrej Shadura <andrew.shadura@collabora.co.uk>
cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        kernel@collabora.com, Theodore Ts'o <tytso@mit.edu>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] HID: add driver for U2F Zero built-in LED and RNG
In-Reply-To: <20190309183213.7598-1-andrew.shadura@collabora.co.uk>
Message-ID: <nycvar.YFH.7.76.1903181542260.19912@cbobk.fhfr.pm>
References: <20190309183213.7598-1-andrew.shadura@collabora.co.uk>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 9 Mar 2019, Andrej Shadura wrote:

> U2F Zero supports custom commands for blinking the LED and getting data
> from the internal hardware RNG. Expose the blinking function as a LED
> device, and the internal hardware RNG as an HWRNG so that it can be used
> to feed the enthropy pool.
> 
> Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
> ---
> 
> This version of the patch sets the quality to 1.
> 
> ---
>  drivers/hid/Kconfig       |  15 ++
>  drivers/hid/Makefile      |   1 +
>  drivers/hid/hid-ids.h     |   1 +
>  drivers/hid/hid-u2fzero.c | 371 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 388 insertions(+)
>  create mode 100644 drivers/hid/hid-u2fzero.c
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 41e9935fc584..4f1b8939561d 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -989,6 +989,21 @@ config HID_UDRAW_PS3
>  	  Say Y here if you want to use the THQ uDraw gaming tablet for
>  	  the PS3.
>  
> +config HID_U2FZERO
> +	tristate "U2F Zero LED and RNG support"
> +	depends on HID
> +	depends on LEDS_CLASS
> +	help
> +	  Support for the LED of the U2F Zero device.
> +
> +	  U2F Zero supports custom commands for blinking the LED
> +	  and getting data from the internal hardware RNG.
> +	  The internal hardware can be used to feed the enthropy pool.
> +
> +	  U2F Zero only supports blinking its LED, so this driver doesn't
> +	  allow setting the brightness to anything but 1, which will
> +	  trigger a single blink and immediately reset to back 0.
> +

This driver isn't really a generic (transport-agnostic) one (which also 
means it's missing USB dependency in Kconfig btw).

Is there a reason why it can't be abstracted that way so that it'd fit our 
principal model in HID subsystem?

Also, I've looked at it really briefly, but can't it be easily implemented 
in userspace?

Thanks,

-- 
Jiri Kosina
SUSE Labs

