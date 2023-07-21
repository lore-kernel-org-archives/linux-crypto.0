Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8490EB64DC
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Jul 2023 12:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjGUMeD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jul 2023 08:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjGUMeD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2023 08:34:03 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602751737
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2023 05:34:01 -0700 (PDT)
Received: from [192.168.1.141] ([37.4.248.68]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MUXlA-1qVWON3TjU-00QSmU; Fri, 21 Jul 2023 14:28:31 +0200
Message-ID: <68c6b70a-8d6c-08b5-46ce-243607479d5c@i2se.com>
Date:   Fri, 21 Jul 2023 14:28:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
From:   Stefan Wahren <stefan.wahren@i2se.com>
Subject: Bug: jitter entropy health test unreliable on Rpi 4 (arm64)
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Joachim Vandersmissen <git@jvdsn.com>,
        John Cabaj <john.cabaj@canonical.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:cUVq2TaxOhGl3uJfKhr9hk7tqeyphJIlVla3fSFACstGIKkghEi
 i/XyMyOFBT4yUF6QKLy9ggmybi0DfYr+dXmAjtAW17WchOd/ffFbT1LNJqb3P3DHIZmhquo
 5lrRs+uo4ruYjw94tncZIQoWOARK2ssUcL1vVa3kVhD8ApvfndEwDfdwu1IsuGeWmMcegtP
 DA+kHZsHQrB8t/Ks1FoMQ==
UI-OutboundReport: notjunk:1;M01:P0:9/oQCEGb2qs=;ZJQsCn+YeRABO6RohH3GnVzOqi3
 9D7bN3fbUsXQ6VtD6xpCDQXDs0KsOWxS0gCOdPJT9R/wbowzWQsXEBwLmtyudNVyRarKI8RME
 5sV0aCk6aiCjz8ftVpUh/4g0Ms8khb9ZatzT6e8yYTStGF9Z+0K5bIKkZMI9gtWFkuiPYL5x+
 lLZPmjUcONmaVYgv6R4cRmh6K26DnqaOifoKLdJ+eDhXRU0wavTdupZwNaY4rAL1VrjDqLnBz
 7uoOpxhhtXNRxLe6eCZhkZDB/XjglVy9uxvTVhu8XzENNnRqdVbCOAjk0gIhZmhL/laT04m1p
 quKfPpR4k1FgxfkyJbPzGjH/B5dAY+MwpcxyChbXZhTEZU7tMyet//RpJnO5mXKx5sCNQO0/8
 4K6oR36Q6BrIX3BKJqxr+HiLWqQgdO8AZTVONeYB4uyYxIGaA3vk0PZ3zJeZFaIA9E5eVjdrc
 awyUtiAFXWPw4Q5ZOGLzDMoCl4chVIDFMO7off+somBqs3pyrJhKNmFzGMlnYSzgyuDy/IVOO
 yOYNgOuBx9i8lJ0ARtMuJT9NkwQUqY4sQqrlq2vOF2M2ozyqDPWnCWGFZjsxZJA0cVltGsPjT
 jVJt9dFQdZ2eoGFbh1HpUZxMOym7j5L/Uk6oJA9cPR42SHbw4lOvUsphQNex784iyo7TenqJf
 KnLDrFit11kt6VH0KDJf3ZsuW+MHt3ckdhaROHILLQ==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

i recently tested Linux 6.5-rc2 on the Raspberry Pi 4 (arm64/defconfig) 
and noticed the following message:

[    0.136349] jitterentropy: Initialization failed with host not 
compliant with requirements: 9

Since Linux 6.5-rc2 this message occurs in around about 1 of 2 cases 
during boot. In Linux 6.4 this message i never saw this message.

I bisected this issue:
git bisect start
# good: [6995e2de6891c724bfeb2db33d7b87775f913ad1] Linux 6.4
git bisect good 6995e2de6891c724bfeb2db33d7b87775f913ad1
# bad: [fdf0eaf11452d72945af31804e2a1048ee1b574c] Linux 6.5-rc2
git bisect bad fdf0eaf11452d72945af31804e2a1048ee1b574c
# good: [1b722407a13b7f8658d2e26917791f32805980a2] Merge tag 
'drm-next-2023-06-29' of git://anongit.freedesktop.org/drm/drm
git bisect good 1b722407a13b7f8658d2e26917791f32805980a2
# bad: [0a1c979c6b7dfe5b6c105d0f0f9f068b5eb07e25] Merge tag 
'libnvdimm-for-6.5' of 
git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
git bisect bad 0a1c979c6b7dfe5b6c105d0f0f9f068b5eb07e25
# good: [0873694a339821277d9f2cae7ef981a1283b44f5] Merge tag 
'soc-defconfig-6.5' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect good 0873694a339821277d9f2cae7ef981a1283b44f5
# good: [1546cd4bfda49fd6faad47eb30f4e744e2d79a8f] Merge tag 
'ata-6.5-rc1' of 
git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata
git bisect good 1546cd4bfda49fd6faad47eb30f4e744e2d79a8f
# good: [9c3255a8f3946a4c8844f1e2e093313f3b71cb30] Merge tag 
'platform-drivers-x86-v6.5-1' of 
git://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86
git bisect good 9c3255a8f3946a4c8844f1e2e093313f3b71cb30
# good: [9070577ae9d6065e447d422bdf85a09f89eaa9e8] Merge tag 
'pci-v6.5-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci
git bisect good 9070577ae9d6065e447d422bdf85a09f89eaa9e8
# bad: [486bfb05913ac9969a3a71a4dc48f17f31cb162d] crypto: akcipher - Do 
not copy dst if it is NULL
git bisect bad 486bfb05913ac9969a3a71a4dc48f17f31cb162d
# good: [506579e88caf882b91ff2c62a203af793f468183] hwrng: cn10k - Add 
extended trng register support
git bisect good 506579e88caf882b91ff2c62a203af793f468183
# bad: [2be0d806e25e7b068113187f9245575914daf0dc] crypto: caam - add a 
test for the RNG
git bisect bad 2be0d806e25e7b068113187f9245575914daf0dc
# bad: [eb7713f5ca97697b92f225127440d1525119b8de] crypto: qat - unmap 
buffer before free for DH
git bisect bad eb7713f5ca97697b92f225127440d1525119b8de
# bad: [1d217fa26680b074dbb44f6183f971a5304eaf8b] dt-bindings: qcom-qce: 
Add compatibles for SM6115 and QCM2290
git bisect bad 1d217fa26680b074dbb44f6183f971a5304eaf8b
# bad: [755b4e7f7c224e10af10edafe34577b5512f7cbb] crypto: atmel - Switch 
i2c drivers back to use .probe()
git bisect bad 755b4e7f7c224e10af10edafe34577b5512f7cbb
# bad: [d23659769ad1bf2cbafaa0efcbae20ef1a74f77e] crypto: jitter - 
correct health test during initialization
git bisect bad d23659769ad1bf2cbafaa0efcbae20ef1a74f77e
# first bad commit: [d23659769ad1bf2cbafaa0efcbae20ef1a74f77e] crypto: 
jitter - correct health test during initialization

Even if this commit only reveal this issue, it would be helpful to get 
some guidance here. My expectation would be that a health check works 
reliable.

Thanks
