Return-Path: <SRS0=sPcw=RV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EECAC43381
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 14:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F91020850
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 14:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfCROvc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Mar 2019 10:51:32 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60046 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbfCROvc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Mar 2019 10:51:32 -0400
Received: from [IPv6:2a02:ab04:3b9:5e00::4] (2a02-ab04-03b9-5e00-0000-0000-0000-0004.dynamic.v6.chello.sk [IPv6:2a02:ab04:3b9:5e00::4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: andrewsh)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 09A5127C5A0;
        Mon, 18 Mar 2019 14:51:29 +0000 (GMT)
Subject: Re: [PATCH v2] HID: add driver for U2F Zero built-in LED and RNG
To:     =?UTF-8?B?SmnFmcOtIEtvc2luYQ==?= <jikos@kernel.org>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        kernel@collabora.com, Theodore Ts'o <tytso@mit.edu>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        linux-crypto@vger.kernel.org
References: <20190309183213.7598-1-andrew.shadura@collabora.co.uk>
 <nycvar.YFH.7.76.1903181542260.19912@cbobk.fhfr.pm>
From:   Andrej Shadura <andrew.shadura@collabora.co.uk>
Openpgp: preference=signencrypt
Autocrypt: addr=andrew.shadura@collabora.co.uk; prefer-encrypt=mutual;
 keydata=
 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
 Ooa/yj03j5gtPgECL7c=
Organization: Collabora
Message-ID: <02f265dd-5ccd-7c42-2bde-b7c5e354cd69@collabora.co.uk>
Date:   Mon, 18 Mar 2019 15:51:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.76.1903181542260.19912@cbobk.fhfr.pm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 18/03/2019 15:44, Jiri Kosina wrote:
> On Sat, 9 Mar 2019, Andrej Shadura wrote:
> 
>> U2F Zero supports custom commands for blinking the LED and getting data
>> from the internal hardware RNG. Expose the blinking function as a LED
>> device, and the internal hardware RNG as an HWRNG so that it can be used
>> to feed the enthropy pool.
>>
>> Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
>> ---
>>
>> This version of the patch sets the quality to 1.
>>
>> ---
>>  drivers/hid/Kconfig       |  15 ++
>>  drivers/hid/Makefile      |   1 +
>>  drivers/hid/hid-ids.h     |   1 +
>>  drivers/hid/hid-u2fzero.c | 371 ++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 388 insertions(+)
>>  create mode 100644 drivers/hid/hid-u2fzero.c
>>
>> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
>> index 41e9935fc584..4f1b8939561d 100644
>> --- a/drivers/hid/Kconfig
>> +++ b/drivers/hid/Kconfig
>> @@ -989,6 +989,21 @@ config HID_UDRAW_PS3
>>  	  Say Y here if you want to use the THQ uDraw gaming tablet for
>>  	  the PS3.
>>  
>> +config HID_U2FZERO
>> +	tristate "U2F Zero LED and RNG support"
>> +	depends on HID
>> +	depends on LEDS_CLASS
>> +	help
>> +	  Support for the LED of the U2F Zero device.
>> +
>> +	  U2F Zero supports custom commands for blinking the LED
>> +	  and getting data from the internal hardware RNG.
>> +	  The internal hardware can be used to feed the enthropy pool.
>> +
>> +	  U2F Zero only supports blinking its LED, so this driver doesn't
>> +	  allow setting the brightness to anything but 1, which will
>> +	  trigger a single blink and immediately reset to back 0.
>> +
> 
> This driver isn't really a generic (transport-agnostic) one (which also 
> means it's missing USB dependency in Kconfig btw).

Thanks, I forgot that one.

> Is there a reason why it can't be abstracted that way so that it'd fit our 
> principal model in HID subsystem?

I tried and I failed. The HID subsystem doesn’t provide the
functionality necessary to implement the protocol, or maybe I’m missing
something, but I haven’t found a way.

> Also, I've looked at it really briefly, but can't it be easily implemented 
> in userspace?

Well, it could, but I would like this to work out of the box without a
need of extra userspace code (the RNG mainly, the LED support was just
an additional "why not" thing).

-- 
Cheers,
  Andrej
