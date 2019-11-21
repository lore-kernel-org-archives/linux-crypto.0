Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE80EC43215
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 10:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5938206CB
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 10:14:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="CWKQRgVh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKUKOx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 05:14:53 -0500
Received: from mout.gmx.net ([212.227.15.18]:49805 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbfKUKOx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 05:14:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1574331269;
        bh=ZWabn5cPEZdM/dU9k7wTedMC47TS5i2tDFXWn60+DOs=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=CWKQRgVhuOIUhCNpJUY3dP41+GKdPHtHldjxJ1DvtdOEyZjH1/Mi+/G76Hfrijjb7
         zoHRD4yikNARTFY+9FAqGXjCYHcw8zbzQxPKcZSH/0GcZ+it0ZmyH4MDrutWuTu4kB
         zye1MDAFNaLL11W8qpIY35e8yhEkSMw3Pt+c9eb8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.176] ([37.4.249.139]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N5VDE-1hn2lC4AWo-016tzL; Thu, 21
 Nov 2019 11:14:29 +0100
Subject: Re: [PATCH v3 0/4] Raspberry Pi 4 HWRNG Support
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Stephen Brennan <stephen@brennan.io>
Cc:     Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Branden <sbranden@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Ray Jui <rjui@broadcom.com>,
        Eric Anholt <eric@anholt.net>,
        Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org
References: <20191120031622.88949-1-stephen@brennan.io>
 <99554159-6abb-6ea5-aebb-57a148a59b78@gmx.net>
 <6aaa37d2cbe91c177b7be2d7f8aa3846efe3dc34.camel@suse.de>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <79995d88-ad9c-e2cc-3f79-0fc9cf8352d2@gmx.net>
Date:   Thu, 21 Nov 2019 11:14:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <6aaa37d2cbe91c177b7be2d7f8aa3846efe3dc34.camel@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:oeIJr8IJyuJ/vS51pMEcSu7Yj39vWst+y+r9CPsXWP7HunwteIc
 egP5Y8cxeEiRXU4LvKDlX/9esGv2STZa/M/Q7404ZUthVaybzTLQLFi4tnQ2/AMGHQinzFa
 A/kE0mGrtwiBGKZE+/3ZxYjKn2NR/+cwIWadtynSh2CnxuCjSn8cAqQNx2HX4OVjiTZL34z
 OcWQPE/GGnLpp3QxQzdgQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vn0z0Y9b/OQ=:KFcXAJndPuH1F9vw1xhnWE
 ogT6+YtFfNMMJex53vqOrvjeTkqxvqEDCOmjmXuA7x9HdvyH+R3dkVxeA/h6cGVSgb+YESv0U
 Jh+ZgANrfvCs4asrWXujNysoqmXEwi1cFg+o/q5G0ZKJ7DeaBL3qSHnrBFzXeiDHcTT7UKfu/
 uoubAdDAWJ4M9YT2qQh1su1VBSa/HziBvFvRRVtTdeyNh3m5zKm3pZLbTkHXIJ1mow6vadeuV
 4zz2v5XZTav0n28BJqwW6lM7rLQFr/9bkTPEPhIsjF8rmlxRNk4UEZ7FbPMlJpz9+WSI6cn+9
 jbScYxCFRoYRJ/GEbpd+f5rP1T+nuXIR5CpMg7lMqRoampgdzjBbzK7/ub897h3XIsSlc/VBZ
 lm99I/aIlsNsnCE/XnrKoo4VIhYousiwvT5G/ZrVefLRvgouaDr98O+pBMJGYRN5Zmzlvicfd
 co7/1M5WXwKqE4GU0A9P7GuPuDTKFPeSRjQdOkRBFGltfm4B0yG1qsoYjBR/V+kumCKAkTwi2
 GH8D+EaxdiF5ubLN+WR+Njn1C7Z+xIAeglgfq6BuONF3HxSuOaY/lHGkpJNLLx41w3WfCA59T
 qdEsLMONJ4qxFHXWH+xABpNqgu725FfOlAdm9Ovu4b5IkduS5ahvYRcY34ouhsYSe8N99ndYx
 hJmNFpGhIYvLRz+k5r6smWWGht8TIRaCD3Tl1WbImosaYdj6jAQjhuCIc/Nv4uKWRb1O48D+C
 oYQSj0fTUTRy9692QDfxV8qbbHpRqdovHkWax5mGZ6tSIymGVSdemAZQJLeweMg0yaKR9fyo1
 dBOcMFzVnzEYy36vyqJsXTyhsaa91Jn8pNf8X055SXruU8eANLqzTMW2DFPrc2IEcgUmoqsFg
 mEvo/1IU0lP98GfQ5grsqEHoVXuFVAgOTExTCd40jTsUfn0x8WTPJjCq7nvYodn01xOonsauY
 LpQ2v0+1oCu5AhgxHn2SjTyc+9w3siFlsV373D3BKgeJ32hD6HnXdy2BjfLvbG2P8sb8CXbTC
 Q57gqNwV6a8cMX3NrdcppqCZ1PE+qXvd8Qladi6rKLM0rGrFnToukkd3qOPoqhsWMBhlu/wom
 gRwajYI98pxl019XccgxkJ7xPk+uYMgrIc4cMFkHq5k49w6eph1jepbNOd8IYmCL1i4SHgb3R
 WMEORmGvMXxlEkf0whZ7EdHCa4zrZeLQ+FixyOH7g6uw1eud0quCTufLmPLpmk/63AbrKxuXc
 VqqDW2HlvkjOw/jLJcYYiGGMCnPBiP2NcQp+B6C9/cdOzZVcCggaokriGAKw=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Am 20.11.19 um 20:50 schrieb Nicolas Saenz Julienne:
> On Wed, 2019-11-20 at 17:16 +0100, Stefan Wahren wrote:
>> Hi Stephen,
>>
>> Am 20.11.19 um 04:16 schrieb Stephen Brennan:
>>> This patch series enables support for the HWRNG included on the Raspberry
>>> Pi 4.  It is simply a rebase of Stefan's branch [1]. I went ahead and
>>> tested this out on a Pi 4.  Prior to this patch series, attempting to use
>>> the hwrng gives:
>>>
>>>     $ head -c 2 /dev/hwrng
>>>     head: /dev/hwrng: Input/output error
>>>
>>> After this series, the same command gives two random bytes.
>> just a note: a more expressive test would be running rngtest (package
>> rng-tools) on this device.
> Just had a go at it,
>
> root@rpi4:~# rngtest -c 1000 < /dev/hwrng
> rngtest 2-unofficial-mt.14
> Copyright (c) 2004 by Henrique de Moraes Holschuh
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 998
> rngtest: FIPS 140-2 failures: 2
> rngtest: FIPS 140-2(2001-10-10) Monobit: 0
> rngtest: FIPS 140-2(2001-10-10) Poker: 1
> rngtest: FIPS 140-2(2001-10-10) Runs: 0
> rngtest: FIPS 140-2(2001-10-10) Long run: 1
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=1.284; avg=113.786; max=126.213)Kibits/s
> rngtest: FIPS tests speed: (min=17.122; avg=28.268; max=28.812)Mibits/s
> rngtest: Program run time: 172323761 microseconds
>
> AFAIR (Arch wiki) some small failures are acceptable.
>
> Regards,
> Nicolas
>
thanks for the results. AFAIR the downstream implementation [1] has a
significant higher input speed. So there is possibly some room for
optimizations later.

Regards
Stefan

[1] -
https://github.com/raspberrypi/linux/commit/5e74aadfd1e0e6c00994521863ba044ce25b40de

