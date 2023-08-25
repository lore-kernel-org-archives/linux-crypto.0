Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56DA9C3DA66
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Aug 2023 11:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242589AbjHYLPi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242252AbjHYLPV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2023 07:15:21 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CB41BD4
        for <linux-crypto@vger.kernel.org>; Fri, 25 Aug 2023 04:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
 s=s31663417; t=1692962097; x=1693566897; i=wahrenst@gmx.net;
 bh=ag7ZZJrR6AnRbhDqzjFQpfVPW5+ml1rsxIWxuMeejAc=;
 h=X-UI-Sender-Class:Date:To:Cc:From:Subject;
 b=KAV7l9m1szxOstZZypGlevyT+qVnXhanSmWSQ2ZDo9sGlf9vdzptEgY8iCDUoAIvLMcI0C9
 bNz2bULLM6v2ELJWyVab/QttvPR8b5qTKBcxfZJdybNUkfCJ0IjZa+qFr3gSB9dMI+ENfXct8
 QU1OYqEYWWl4/uQ0+yKEO/qtEDTl2IJfAfybBuEm7jo2z7YWNPg3w67lW1ECXGztgcFRNwm1z
 S8yYivkOFw8tCME75G5MBJIiAKtbGdLjAt6v1MlIoehSrp1LiujgY62XYXCFX6ZN09fopIORA
 80u7xVtRidSGUlPWVF7h5OQKZv27vIpulJrORbaHe1jgIrtPP0wA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.1.129] ([37.4.248.43]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MsHns-1pgyU702uo-00tiEm; Fri, 25
 Aug 2023 13:14:57 +0200
Message-ID: <bc97ece5-44a3-4c4e-77da-2db3eb66b128@gmx.net>
Date:   Fri, 25 Aug 2023 13:14:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Fainelli <florian.fainelli@broadcom.com>
Cc:     Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Andrei Coardos <aboutphysycs@gmail.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Linux regressions mailing list <regressions@lists.linux.dev>
From:   Stefan Wahren <wahrenst@gmx.net>
Subject: bcm2835-rng: Performance regression since 96cb9d055445
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2+9bU1tG93PnpnqWCmzUU6ey1yPjC9A9Zq/gYW0M7l4rfp8EpPA
 bdqOBTpdKeyZuTQ6AXAwwmuSZmypAqPrQeuX2nx/CYAhQBqMIRFddBZzsHMbano02FhZMLE
 UxYjt4MuvqzauYo0p5yHwPTbk1aB+Yq/Dk8JPaAvdYEUC/2tIGqrZG30sXn0LRbGo/xP7tg
 NWjCkNgAbTRLIaPBjcUpg==
UI-OutboundReport: notjunk:1;M01:P0:BrdXKMFkC+w=;j1/EcoGjXU4SQFixEZwTl2z9cZE
 mzSjOaFbzuznSNSUiio2oGLK+JJ+nMmWWt6IlxBbvxrqKiojqbzwzwOCi655Cru7ZLWDuwKQY
 tHGFXSkfCwN8Tck3kahJ+kyBpRc/UTzFnag3zcYrKAgeNKO8E5ZQzRyZrgePWLrDKWS4z+HUw
 QHjB0DbznJrIi5X0dJU4OMWtZ1CGIkHA9LJJ7BSWJauAPhsSfiChKeSH1SJSXWpbzPooG6Om6
 CbtFGMTgPSr4qr0RaCORf5j9OiNBIk36nQ60Po3ZPTod2n4L92KCm/e2OzVeI1JD1Tmg4LWEv
 KvOuwUi5F2PkxfiS+faJtCP++B4A8MwmQsb+Is5IupKc9XLZYruEp0eJSi2iKdUCgvRHRtn4m
 e1BtNHFTgELF0deYomZS1281y/hjVV7Ef6z8VNy68JsEjl1WeHtw8ddr9XOYzEYPDk0vOnjwE
 UurMFfOPTxecpsNVncP/ZFMoGl2jlC3Wu52+dv9yQhrDgsiTpytoyvF/TjdDtWFs8YQsj3UJC
 ASGMXkGk3HXVd6VQOT73PH4xRF3bOSbz5yfLf5WD8t+l+gquWQQocJENtf3S2G2eZJugJ5+/M
 mRDtZPWInVvUiLtZbxYkbfxy5vrO3U2RWRIm5Hk08YyJFWerZp7dPn+G+6c60HLMfJWLh/sQZ
 8W1+KKpaXTFXoiYeWi+0UXwOQnt4SVwRMGOdeoWRzvBjTs1Snsy9FgGqqyqqTQcP0ChIi1qGw
 mpNTHp9W6kOvx1rYfDLquD1kbxSGJdgVKF7n0rPfl0GRbdFQgGA1/INd7mPMdT2BrrRaIXR9O
 wbTsfxZCItTO4VtLLt3Cl25S92gJtd6oEpjRrmkhsiROJWtQWSs9Te/0daJxj5Sl2lhM/fixx
 QMqCR1h/GipTFt15xk9ZRDS7bO9iKPR36oxtaJ8NuwIP32Tjv8BGGs43zHEkQMWmjFJAMtVsl
 mphJqjOine7Dc2l+dB7NNWWMnPs=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

i didn't find the time to fix the performance regression in bcm2835-rng
which affects Raspberry Pi 0 - 3, so report it at least. AFAIK the first
report about this issue was here [1] and identified the offending commit:

96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of
  cpu_relax()")

#regzbot introduced: 96cb9d055445

I was able to reproduce this issue with a Raspberry Pi 3 B+ on Linux
6.5-rc6 (arm64/defconfig).

Before:
time sudo dd if=3D/dev/hwrng of=3D/dev/urandom count=3D1 bs=3D4096 status=
=3Dnone

real	3m29,002s
user	0m0,018s
sys	0m0,054s

After revert:
time sudo dd if=3D/dev/hwrng of=3D/dev/urandom count=3D1 bs=3D4096 status=
=3Dnone

real	0m0,150s
user	0m0,028s
sys	0m0,072s

I reporting this in the hope, someone has the time to fix this. Sorry
for not reporting this earlier.

Best regards

[1] - https://github.com/raspberrypi/linux/issues/5390
