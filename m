Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F5AC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 16 May 2022 10:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241562AbiEPKIF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 May 2022 06:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241408AbiEPKH3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 May 2022 06:07:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F969FFE
        for <linux-crypto@vger.kernel.org>; Mon, 16 May 2022 03:07:21 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0] helo=igor.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <s.trumtrar@pengutronix.de>)
        id 1nqXd9-0000Hs-8p; Mon, 16 May 2022 12:07:11 +0200
References: <878rrqrgaj.fsf@pengutronix.de>
 <20220505192046.hczmzg7k6tz2rjv3@pengutronix.de>
 <20220505171000.48a9155b@kernel.org>
User-agent: mu4e 1.4.13; emacs 29.0.50
From:   Steffen Trumtrar <s.trumtrar@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-crypto@vger.kernel.org, io-uring@vger.kernel.org,
        kernel@pengutronix.de,
        Horia =?utf-8?Q?Geant?= =?utf-8?Q?=C4=83?= 
        <horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: Re: [BUG] Layerscape CAAM+kTLS+io_uring
Date:   Mon, 16 May 2022 12:06:27 +0200
In-reply-to: <20220505171000.48a9155b@kernel.org>
Message-ID: <87sfp9vlig.fsf@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: s.trumtrar@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 5 May 2022 21:20:46 +0200 Marc Kleine-Budde wrote:
>> Hello,
>>
>> no one seems to care about this problem. :/
>>
>> Maybe too many components are involved, I'm the respective maintainers
>> on Cc.
>>
>> Cc += the CAAM maintainers
>> Cc += the io_uring maintainers
>> Cc += the kTLS maintainers
>>
>> On 27.04.2022 10:20:40, Steffen Trumtrar wrote:
>> > Hi all,
>> >
>> > I have a Layerscape-1046a based board where I'm trying to use a
>> > combination of liburing (v2.0) with splice, kTLS and CAAM (kernel
>> > v5.17). The problem I see is that on shutdown the last bytes are
>> > missing. It looks like io_uring is not waiting for all completions
>> > from the CAAM driver.
>> >
>> > With ARM-ASM instead of the CAAM, the setup works fine.
>>
>> What's the difference between the CAAM and ARM-ASM crypto? Without
>> looking into the code I think the CAAM is asynchron while ARM-ASM is
>> synchron. Is this worth investigating?
>
> Sounds like
> 20ffc7adf53a ("net/tls: missing received data after fast remote close")

That fixes something in tls_sw. I have a kernel that includes this
patch. So this sounds right, but can't be it, right?


Best regards,
Steffen

--
Pengutronix e.K.                | Dipl.-Inform. Steffen Trumtrar |
Steuerwalder Str. 21            | https://www.pengutronix.de/    |
31137 Hildesheim, Germany       | Phone: +49-5121-206917-0       |
Amtsgericht Hildesheim, HRA 2686| Fax:   +49-5121-206917-5555    |
