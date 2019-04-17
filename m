Return-Path: <SRS0=UJZd=ST=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3E7C282DA
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 14:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD3E22173C
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 14:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732105AbfDQOsA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:48:00 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55720 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729940AbfDQOr7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 10:47:59 -0400
Received: from [IPv6:2a02:ab04:3b9:5e00::3] (2a02-ab04-03b9-5e00-0000-0000-0000-0003.dynamic.v6.chello.sk [IPv6:2a02:ab04:3b9:5e00::3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: andrewsh)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 05E1627D805;
        Wed, 17 Apr 2019 15:47:56 +0100 (BST)
Subject: Re: [PATCH v3] HID: add driver for U2F Zero built-in LED and RNG
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        kernel@collabora.com, linux-crypto@vger.kernel.org
References: <20190401124200.17331-1-andrew.shadura@collabora.co.uk>
 <nycvar.YFH.7.76.1904101400520.9803@cbobk.fhfr.pm>
 <CAN+gG=H6TGtB68-XJ+Pg53EhL_M2m8MG1z33Yenvd9PhXJ=Oqw@mail.gmail.com>
 <nycvar.YFH.7.76.1904111234080.9803@cbobk.fhfr.pm>
 <d33b8772-bae6-1d20-8ff0-3397095f6e4b@collabora.co.uk>
 <nycvar.YFH.7.76.1904171642020.9803@cbobk.fhfr.pm>
From:   Andrej Shadura <andrew.shadura@collabora.co.uk>
Openpgp: preference=signencrypt
Autocrypt: addr=andrew.shadura@collabora.co.uk; prefer-encrypt=mutual;
 keydata=
 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
 Ooa/yj03j5gtPgECL7c=
Organization: Collabora
Message-ID: <3d07beba-2cd7-8d84-947e-095897fb3e0c@collabora.co.uk>
Date:   Wed, 17 Apr 2019 16:47:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.76.1904171642020.9803@cbobk.fhfr.pm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 17/04/2019 16:43, Jiri Kosina wrote:
> On Thu, 11 Apr 2019, Andrej Shadura wrote:
> 
>>>>> So I still am not really happy about this being wired up into generic HID
>>>>> although it's really a USB driver, but we've discussed that already, and I
>>>>> don't see any option that'd work substantially better in this case,
>>>>> especially from the UX point of view. Oh well. Applied to for-5.2/u2fzero,
>>>>> thanks!
>>>>>
>>>>
>>>> Hi wish I were CC-ed on these threads.
>>>
>>> Gah, for some reason I was convinced you were.
>>>
>>>> My CI script now fails because hid-u2fzero.ko needs devm_hwrng_register 
>>>> and the Kconfig doesn't force pulling the right dependency.
>>
>>>> Also, you probably want to add in .probe() a check for the actual 
>>>> transport driver (`hid_is_using_ll_driver(hdev, &usb_hid_driver)`) or 
>>>> you can not use the usbhid functions without crashing the kernel.
>>
>> Thanks, that’s very useful.
>>
>>> Benjamin, I love your CI :)
>>>
>>> Andrej, could you please send fixups on top of the applied patch?
>>
>> Sure, will do.
> 
> I didn't receive any followup; the Kconfig dependency has already been 
> fixed by Mao Wenan, and I've just queued the patch below on top of that as 
> well.

Sorry, I’ve had too much on my plate in the recent days, so I’ve
unfortunately been pushing this task off a bit. Thanks to both of you,
Mao and Jiří, both things should have really been done by me. I’ll try
to get those things right from the beginning the next time.

> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] HID: u2fzero: fail probe if not using USB transport
> 
> u2fzero driver is USB-only. Therefore we have to give up in ->probe()
> callback in case we're called with non-USB transport driver bound,
> otherwise the kernel will crash trying to use USBHID API on a non-USB
> transport.
> 
> Fixes: 42337b9d4d958("HID: add driver for U2F Zero built-in LED and RNG")
> Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/hid/hid-u2fzero.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/hid/hid-u2fzero.c b/drivers/hid/hid-u2fzero.c
> index d11a5cb56a0d..95e0807878c7 100644
> --- a/drivers/hid/hid-u2fzero.c
> +++ b/drivers/hid/hid-u2fzero.c
> @@ -286,6 +286,9 @@ static int u2fzero_probe(struct hid_device *hdev,
>  	unsigned int minor;
>  	int ret;
>  
> +	if (!hid_is_using_ll_driver(hdev, &usb_hid_driver))
> +		return -EINVAL;
> +
>  	dev = devm_kzalloc(&hdev->dev, sizeof(*dev), GFP_KERNEL);
>  	if (dev == NULL)
>  		return -ENOMEM;
> 


-- 
Cheers,
  Andrej
