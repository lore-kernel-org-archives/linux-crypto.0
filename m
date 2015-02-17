From: Kees Cook <keescook@chromium.org>
Subject: Re: [BISECTED] 4943ba16 ("include crypto- module prefix") breaks wifi
Date: Tue, 17 Feb 2015 08:43:52 -0800
Message-ID: <CAGXu5jKMX+DxPQo=BstEKjyWxvLtnHcG44qyMN=os-U4NjM=Kg@mail.gmail.com>
References: <20150217030940.7890.qmail@ns.horizon.com>
	<CA+rthh_mM0YjHq86znWh_4vA-KO3T2yrA+h+K2StyUbtAonSXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: George Spelvin <linux@horizon.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:47737 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbbBQQnx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Feb 2015 11:43:53 -0500
Received: by mail-ob0-f173.google.com with SMTP id uy5so55257642obc.4
        for <linux-crypto@vger.kernel.org>; Tue, 17 Feb 2015 08:43:53 -0800 (PST)
In-Reply-To: <CA+rthh_mM0YjHq86znWh_4vA-KO3T2yrA+h+K2StyUbtAonSXQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 16, 2015 at 10:49 PM, Mathias Krause <minipli@googlemail.com> wrote:
> On 17 February 2015 at 04:09, George Spelvin <linux@horizon.com> wrote:
>> I discovered when (belatedly) testing 3.19-rc7 the other week that
>> my laptop wifi was broken and would no longer associate.
>>
>> Apparently this is causing some necessary crypto algorithms to fail to
>> load, breaking my wifi.
>>
>> Perhaps I'm displaying my ignorance of what's supposed to happen,
>> but shouldn't make install have installed some files with names like
>> /lib/modules/`uname r`/kernel/crypto/crypto-*.ko?
>
> No, the module names do not change. They just got another module alias
> with the "crypto-" prefix.

You can look at module aliases with "modinfo", for example:

$ modinfo raid5
...
alias:          raid6
alias:          raid5
alias:          md-level-6
alias:          md-raid6
alias:          md-personality-8
...

>
>> Or is it something only I'm hitting because I have a lot of common
>> crypto algorithms statically compiled into my kernel?
>>
>> CONFIG_CRYPTO_CBC=y
>> CONFIG_CRYPTO_HMAC=y
>> CONFIG_CRYPTO_MD5=y
>> CONFIG_CRYPTO_SHA1=y
>> CONFIG_CRYPTO_AES=y
>> CONFIG_CRYPTO_AES_586=y
>> CONFIG_CRYPTO_ARC4=y
>>
>> Trying this on kernel 4943ba16 produces instead an endless loop of:
>>
>> wlan1: SME: Trying to authenticate with aa:bb:cc:dd:ee:ff (SSID='FOO' freq=24xx MHz)
>> wlan1: Trying to associate with aa:bb:cc:dd:ee:ff (SSID='FOO' freq=24xx MHz)
>> wlan1: Associated with aa:bb:cc:dd:ee:ff
>> wlan1: WPA: Failed to set PTK to the driver (alg=3 keylen=16 bssid=aa:bb:cc:dd:ee:ff)
>> wlan1: CTRL-EVENT-DISCONNECTED bssid=aa:bb:cc:dd:ee:ff reason=1
>>
>>
>> The kernel logs are not particularly informative.
>>
>> They just go through the usual successful series, but end with
>>
>> wlan1: RxAssocResp from aa:bb:cc:dd:ee:ff (capab=0x431 status=0 aid=1)
>> wlan1: associated
>> wlan1: deauthenticating from 11:bb:cc:dd:ee:ff by local choice (Reason: 1=UNSPECIFIED)
>>
>> While successful connection ends before that last line.
>
> Commit 4943ba16bbc2 was incomplete and could have caused regressions
> like the above. Those should have been fixed with commits 4943ba16bbc2
> + 3e14dcf7cb80. However, those should be in v3.19-rc7 already, so I'm
> not much of a help here :(

Just so I can keep things straight, the commits, in order, were:

Crypto prefix added: 5d26a105b5a7
Template prefixing fixed: 4943ba16bbc2d
Arch-specific aliases fixed: 3e14dcf7cb80

And now my head-scratching: your bisect shows that v3.19-rc7 fails,
but that prior to 4943ba16bbc2, things work correctly? As in, when
_only_ 5d26a105b5a7 is in your tree things _work_?

I would expect 5d26a105b5a7 to be what breaks things, not
4943ba16bbc2d. I wonder if userspace is calling modprobe (via
wpa_supplicant) directly on old aliases that got removed? For example,
gcm.ko switched from "rfc4106" to "crypto-rfc4106".

Could you rename and instrument your /sbin/modprobe to do something like:

#!/bin/sh
echo "$@" >> /root/modprobe.log
exec /sbin/modprobe.bin "$@"

Perhaps there's something being explicitly requested rather than
having it be kernel auto-loaded?

-Kees

-- 
Kees Cook
Chrome OS Security
