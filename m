Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16AEBC432C3
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 19:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D511C22319
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 19:45:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Kob6o5l5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKRTpZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 14:45:25 -0500
Received: from mout.gmx.net ([212.227.17.20]:46283 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbfKRTpZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 14:45:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1574106298;
        bh=XSpYzjhcgiHHrYhcZHLykdCAj0e3wpqTkNXlUfzkU4o=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Kob6o5l5jdcqPStOSOAJau0p9oouSqofToVYgzuAbv8dHGLXf3UOzpelxCJoeeZdQ
         PlvPIgb+WEHwGwDKPU4e6rANIbrfeiWZFB+aLYApWxlwId/7mos3Jj5Vx6WztjEYP6
         o4HL5jyK4tEnrL5LVdUpJu2W+3V8hai9kcJorfyc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.176] ([37.4.249.101]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MKbkC-1iIQQo2sto-00Kxvf; Mon, 18
 Nov 2019 20:44:58 +0100
Subject: Re: [PATCH 3/3] ARM: dts: bcm2711: Enable HWRNG support
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Stephen Brennan <stephen@brennan.io>
Cc:     Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Branden <sbranden@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        Eric Anholt <eric@anholt.net>,
        Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org, Ray Jui <rjui@broadcom.com>,
        linux-arm-kernel@lists.infradead.org
References: <20191118075807.165126-1-stephen@brennan.io>
 <20191118075807.165126-4-stephen@brennan.io>
 <3209f601ad0537a7ef01e2a752f022ccf8816210.camel@suse.de>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <5cc711fd-4d47-5369-c424-363677334b9f@gmx.net>
Date:   Mon, 18 Nov 2019 20:44:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <3209f601ad0537a7ef01e2a752f022ccf8816210.camel@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:hOwNU8cCHONZ9O486Jwq2iYZo79fAwXMhOiTJGOJ2PlKe+8gm6Q
 UGZOE/CTkcMnh13XIW02vvGVxZLDBTfhtyX/V+eFjeKG0rSDSrVsYC2qS+YNqdTpolkbIr1
 67O8WyoHcMO0Pt+KOgbWoq45imjgCX1ZRtzKZ6z8dTO+YJtfGNVKw91mLvvOE+StvshZzFX
 9hmwXJS0vB8xxwCdtGr6A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:IR+/bxyYH8U=:KGTLKGtCmOSFtC86RHUyRn
 6tBB+OxxEMNzyMCEHd3PLrD51+ULa0dMFC6VFO6GSgSf8Qbc9YmGewKKfnFZSPJj1CQ63o0Eu
 YIvVXMzkYxK1Ym4dJQXgJ6xYwO9xn2Vz5AV5eeo9A/Xudzp3vtsx0Uh7cGUm8xtHOzAVZiKFM
 gP18EqKGWZLG9h5wuEm9R5TFO19ROMpvSP9kA8tQBedg8pwejpEjtPVgOpZaGHF2Vq4mo3f33
 ixgrEi9tK7b/L1P0OyDXmWFnQSh4zxDPrsrEwdnzedQfzUAaImRjZjUOwxVv3e+KLgBYcA1Dn
 lCHD2oeAh/MRII5QCGIm00VxQcG5dIquSyWB62p1R+GPvbsI5rlCNV7zvICgNdsUwQlWGmIjs
 5MVqLbWloeovB1G6M0NX8Uf5XwGLbe6aeDUPy7bX5WCwbTOHxhc11IpozjrONNJQji7PbGUFe
 bGjK49FUrzNQFkeYReJVw0ioZS0HhDh3OzzcjBlF4YJ8UT8hoLqRFFcxFWDZM1cPKLu6nwJj/
 5ZUUasjCFowFJ0d8Pa5CS3PRtiRWkddic2hR/t3dok7S93xnqbpqx04uNbhjnKek9lQME8rWV
 GzQn/Gx1tgACdbcIyaMWvTaf/n1Ugkk1UldXuWDICh6qBAquh1nWGU5lBNlKty9nqcf7eiuUL
 5OXXIKImipmMor65OEVHn38eGHqCCprKlwywlR1oqU4gzbw7yxZGh15okVFVZLdbyUgE+Oz5W
 J7nFv6u2bRj4CCBAn/skhbeWQGoJA9PQFrhEpKEi3oL/nyRnelSyp0TXVOVyfNDXzix8EskVJ
 V3EjiGpPqMs12Q4yiV3kKPbbLAnffb/OdtqMKXsMFuLs1SS/Ek+u+17CNr7NfqpYnMaLCFF8r
 LnTzE5w4FDLEQ890vHGFah/jCdH0hEJCDUNvIyYes+whaFKen2q9wa69F+F8h06TBE7Pr/qjL
 3dX1Frn9NBqOb7E36gRbhFYQK1Kxg/I/8g+qkNDwR0MWP0l9nSFSiO8WjHZ2K8Y5xTMP05kat
 DhlYiF7sJ79RkVOHApJaRlaPUfJwVjQww/0HuiOr1edGc6StO69beT+0R2WNTk83Buu1zcG2v
 EzQuqvmvvXH8ufwxcYV8YsMAbpnZQrbsfS3rCH0tnYHyfHZ3a9vUPHLBI58Py0+aAPRwTozp0
 eQ1npU3/B3X/xQTedc7ruIIhRdCvBZnj+VtLFiBzRoLIFO40y9i9q3EI2udLHptGcRmb6cHV1
 u3VU1rHYZgDFYg229qicqHv6Bn+KBoUXrpPN5NKwgRWjL02CtdXcA6ihZWfU=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Am 18.11.19 um 12:44 schrieb Nicolas Saenz Julienne:
> Hi Stephen,
>
> On Sun, 2019-11-17 at 23:58 -0800, Stephen Brennan wrote:
>> From: Stefan Wahren <wahrenst@gmx.net>
>>
>> This enables hardware random number generator support for the BCM2711
>> on the Raspberry Pi 4 board.
>>
>> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
>> Signed-off-by: Stephen Brennan <stephen@brennan.io>
>> ---
>>  arch/arm/boot/dts/bcm2711.dtsi | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711=
.dtsi
>> index ac83dac2e6ba..2c19e5de284a 100644
>> --- a/arch/arm/boot/dts/bcm2711.dtsi
>> +++ b/arch/arm/boot/dts/bcm2711.dtsi
>> @@ -92,10 +92,9 @@ pm: watchdog@7e100000 {
>>  		};
>>
>>  		rng@7e104000 {
>> +			compatible =3D "brcm,bcm2711-rng200";
>>  			interrupts =3D <GIC_SPI 125 IRQ_TYPE_LEVEL_HIGH>;
>> -
>> -			/* RNG is incompatible with brcm,bcm2835-rng */
>> -			status =3D "disabled";
>> +			status =3D "okay";
>>  		};
>>
>>  		uart2: serial@7e201400 {
> We inherit the reg property from bcm283x.dtsi, on which we only define a=
 size
> of 0x10 bytes. I gather from the driver that iproc-rng200's register spa=
ce is
> at least 0x28 bytes big. We should also update the 'reg' property to:
>
> 	reg =3D <0x7e104000 0x28>;

Thanks for sending and noticing. A proper solution would be to move the
whole rng node from bcm283x.dtsi to bcm283x-common.dtsi and define a
completely new rng node in bcm2711.dtsi.

Regards
Stefan

>
> Regards,
> Nicolas
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
