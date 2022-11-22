Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8194C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 10:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiKVK62 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 05:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbiKVK60 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 05:58:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6F4D2FE
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 02:58:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA38861648
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 10:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A201DC433C1;
        Tue, 22 Nov 2022 10:58:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ONCPh/4X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1669114700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3cSGM3TupJhvcDlMtuVKHA+Qj5hqZiWQ7h/adAJwhZU=;
        b=ONCPh/4Xg9/R+Iql6O0nARnm2/BR8U9Fd4I0Pwr4aSJE92o7U0YwetvLlihzm8G7BCTfkm
        9x+5/b/HRDBmXitC1B9O5puspbNs2jMW/XCFQwGizen1iBcKRVYsCtQuxzJFBQpaQ5Wq47
        WWqttUgI0EFelNpoDaL3CGCfHyBpGY4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f5474f74 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 22 Nov 2022 10:58:19 +0000 (UTC)
Date:   Tue, 22 Nov 2022 11:58:16 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Andrej Shadura <andrew.shadura@collabora.co.uk>
Subject: Re: [PATCH] hwrng: u2fzero - account for high quality RNG
Message-ID: <Y3yrSFel+sK5Fvqx@zx2c4.com>
References: <20221119134259.2969204-1-Jason@zx2c4.com>
 <nycvar.YFH.7.76.2211221122220.6045@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.2211221122220.6045@cbobk.fhfr.pm>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 22, 2022 at 11:22:37AM +0100, Jiri Kosina wrote:
> On Sat, 19 Nov 2022, Jason A. Donenfeld wrote:
> 
> > The U2F zero apparently has a real TRNG in it with maximum quality, not
> > one with quality of "1", which was likely a misinterpretation of the
> > field as a boolean. So remove the assignment entirely, so that we get
> > the default quality setting.
> > 
> > In the u2f-zero firmware, the 0x21 RNG command used by this driver is
> > handled as such [1]:
> > 
> >   case U2F_CUSTOM_GET_RNG:
> >     if (atecc_send_recv(ATECC_CMD_RNG,ATECC_RNG_P1,ATECC_RNG_P2,
> >       NULL, 0,
> >       appdata.tmp,
> >       sizeof(appdata.tmp), &res) == 0 )
> >     {
> >       memmove(msg->pkt.init.payload, res.buf, 32);
> >       U2FHID_SET_LEN(msg, 32);
> >       usb_write((uint8_t*)msg, 64);
> >     }
> >     else
> >     {
> >       U2FHID_SET_LEN(msg, 0);
> >       usb_write((uint8_t*)msg, 64);
> >     }
> > 
> > This same call to `atecc_send_recv(ATECC_CMD_RNG,ATECC_RNG_P1,
> > ATECC_RNG_P2,...)` is then also used in the token's cryptographically
> > critical "u2f_new_keypair" function, as its rather straightforward
> > source of random bytes [2]:
> > 
> >   int8_t u2f_new_keypair(uint8_t * handle, uint8_t * appid, uint8_t * pubkey)
> >   {
> >     struct atecc_response res;
> >     uint8_t private_key[36];
> >     int i;
> > 
> >     watchdog();
> > 
> >     if (atecc_send_recv(ATECC_CMD_RNG,ATECC_RNG_P1,ATECC_RNG_P2,
> >       NULL, 0,
> >       appdata.tmp,
> >       sizeof(appdata.tmp), &res) != 0 )
> >     {
> >       return -1;
> >     }
> > 
> > So it seems rather plain that the ATECC RNG is considered to provide
> > good random numbers.
> > 
> > [1] https://github.com/conorpp/u2f-zero/blob/master/firmware/src/custom.c
> > [2] https://github.com/conorpp/u2f-zero/blob/master/firmware/src/u2f_atecc.c
> 
> Good catch, thanks Jason. Applied.

This should probably go via Herbert's tree, because it depends on some
changed handling for the zero quality field.

Jason
