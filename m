From: "George Spelvin" <linux@horizon.com>
Subject: [BISECTED] 4943ba16 ("include crypto- module prefix") breaks wifi
Date: 16 Feb 2015 22:09:40 -0500
Message-ID: <20150217030940.7890.qmail@ns.horizon.com>
Cc: herbert@gondor.apana.org.au, linux@horizon.com,
	minipli@googlemail.com
To: keescook@chromium.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:60495 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753168AbbBQDQX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Feb 2015 22:16:23 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I discovered when (belatedly) testing 3.19-rc7 the other week that
my laptop wifi was broken and would no longer associate.

I wasted a lot of time trying to bisect changes in net/wireless and
net/drivers wireless before figuring out that it was sonewhere else in
the kernel.  An unrestricted bisect quickly homed in on this commit.

Apparently this is causing some necessary crypto algorithms to fail to
load, breaking my wifi.

Perhaps I'm displaying my ignorance of what's supposed to happen,
but shouldn't make install have installed some files with names like
/lib/modules/`uname r`/kernel/crypto/crypto-*.ko?

Or is it something only I'm hitting because I have a lot of common
crypto algorithms statically compiled into my kernel?

CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_ARC4=y


In more detail, when things are working,  (such as on commit 4943ba1^
= 476c7fe2), wpa_supplicant logs:

wlan1: SME: Trying to authenticate with aa:bb:cc:dd:ee:ff (SSID='FOO' freq=24xx MHz)
wlan1: Trying to associate with aa:bb:cc:dd:ee:ff (SSID='FOO' freq=24xx MHz)
wlan1: Associated with aa:bb:cc:dd:ee:ff
wlan1: WPA: Key negotiation completed with aa:bb:cc:dd:ee:ff [PTK=CCMP GTK=CCMP]
wlan1: CTRL-EVENT-CONNECTED - Connection to aa:bb:cc:dd:ee:ff completed (aith) [id=0 id_str=]

Followed by group rekeying completed messages at 10 minute intervals.

Trying this on kernel 4943ba16 produces instead an endless loop of:

wlan1: SME: Trying to authenticate with aa:bb:cc:dd:ee:ff (SSID='FOO' freq=24xx MHz)
wlan1: Trying to associate with aa:bb:cc:dd:ee:ff (SSID='FOO' freq=24xx MHz)
wlan1: Associated with aa:bb:cc:dd:ee:ff
wlan1: WPA: Failed to set PTK to the driver (alg=3 keylen=16 bssid=aa:bb:cc:dd:ee:ff)
wlan1: CTRL-EVENT-DISCONNECTED bssid=aa:bb:cc:dd:ee:ff reason=1


The kernel logs are not particularly informative.

They just go through the usual successful series, but end with

wlan1: RxAssocResp from aa:bb:cc:dd:ee:ff (capab=0x431 status=0 aid=1)
wlan1: associated
wlan1: deauthenticating from 11:bb:cc:dd:ee:ff by local choice (Reason: 1=UNSPECIFIED)

While successful connection ends before that last line.
