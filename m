From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [BISECTED] 4943ba16 ("include crypto- module prefix") breaks wifi
Date: Tue, 17 Feb 2015 07:49:02 +0100
Message-ID: <CA+rthh_mM0YjHq86znWh_4vA-KO3T2yrA+h+K2StyUbtAonSXQ@mail.gmail.com>
References: <20150217030940.7890.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Kees Cook <keescook@chromium.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:41806 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbbBQGtE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Feb 2015 01:49:04 -0500
Received: by mail-wg0-f43.google.com with SMTP id z12so19723035wgg.2
        for <linux-crypto@vger.kernel.org>; Mon, 16 Feb 2015 22:49:02 -0800 (PST)
In-Reply-To: <20150217030940.7890.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 17 February 2015 at 04:09, George Spelvin <linux@horizon.com> wrote:
> I discovered when (belatedly) testing 3.19-rc7 the other week that
> my laptop wifi was broken and would no longer associate.
>
> Apparently this is causing some necessary crypto algorithms to fail to
> load, breaking my wifi.
>
> Perhaps I'm displaying my ignorance of what's supposed to happen,
> but shouldn't make install have installed some files with names like
> /lib/modules/`uname r`/kernel/crypto/crypto-*.ko?

No, the module names do not change. They just got another module alias
with the "crypto-" prefix.

> Or is it something only I'm hitting because I have a lot of common
> crypto algorithms statically compiled into my kernel?
>
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=y
> CONFIG_CRYPTO_ARC4=y
>
> Trying this on kernel 4943ba16 produces instead an endless loop of:
>
> wlan1: SME: Trying to authenticate with aa:bb:cc:dd:ee:ff (SSID='FOO' freq=24xx MHz)
> wlan1: Trying to associate with aa:bb:cc:dd:ee:ff (SSID='FOO' freq=24xx MHz)
> wlan1: Associated with aa:bb:cc:dd:ee:ff
> wlan1: WPA: Failed to set PTK to the driver (alg=3 keylen=16 bssid=aa:bb:cc:dd:ee:ff)
> wlan1: CTRL-EVENT-DISCONNECTED bssid=aa:bb:cc:dd:ee:ff reason=1
>
>
> The kernel logs are not particularly informative.
>
> They just go through the usual successful series, but end with
>
> wlan1: RxAssocResp from aa:bb:cc:dd:ee:ff (capab=0x431 status=0 aid=1)
> wlan1: associated
> wlan1: deauthenticating from 11:bb:cc:dd:ee:ff by local choice (Reason: 1=UNSPECIFIED)
>
> While successful connection ends before that last line.

Commit 4943ba16bbc2 was incomplete and could have caused regressions
like the above. Those should have been fixed with commits 4943ba16bbc2
+ 3e14dcf7cb80. However, those should be in v3.19-rc7 already, so I'm
not much of a help here :(


Mathias
