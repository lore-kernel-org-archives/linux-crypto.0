Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB1E9C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 10:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82A6A21D7D
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 10:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HKFA7/+6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbfLKKeK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 05:34:10 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:36919 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbfLKKeK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 05:34:10 -0500
Received: by mail-il1-f193.google.com with SMTP id t9so19002324iln.4;
        Wed, 11 Dec 2019 02:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dOmVU46s6nV+n0B47S9FUyCMpYjTYJPpLDGRrRSRigA=;
        b=HKFA7/+6tylk60vhCVFcqc+BPuWBQ2OPBDe/7Z1erDUzjZdWn9QRbN1+/YWglnVRpn
         ZEyMWn00OVns4EbGCXtpU0/dDnHxoV6ixZFCdS3p6uqgLHVrt7kJ8l70cPNODSJznmew
         GTBvgWCcv11jqKiEUs9GCmdP+MvSIzaoYt4vmnWj7dbIAUv9FbR5qKotm0PRAVXDA4yH
         iahuo7fjQTrLs2z8qdkGTk6OINGZMKPhehiZrx8Ftzw0pVNfprfG0jAgUzM98MrZPrJ4
         MVTIOpe1l90Vv9OxHIKbGaI6szxgpEIcRlCp4fhF/GOmKxA/RdL2O4OnEza9M4B+RC5g
         JZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dOmVU46s6nV+n0B47S9FUyCMpYjTYJPpLDGRrRSRigA=;
        b=P8ACIax9nG7oH77diyXogQ3PPKvKmW1kUmR8ewb+DEUBO1uigoTsx+kRozMdlRPOKQ
         Tcwk7YdkKNrXmvrHK3KxReC13gOZcAB6jrv5NH/iC52UstMaaEWZf2T/KsdFVQyoMEJt
         f2ycVGMWX3dVenbGlHnNsoQQeuXeO51FqlpsgvHqKqrx0zy6jgzQxLEasH5QNyizvzr2
         es9y1/CuAnsKJUHNMGKtVJId5IlA/m0dFKxHZY65f20w864H33Ym+rNfmimZGGRiii0S
         fCgI6U9qMTH+GkaMZ5rHRe11pTMHqaNbwyEgz06/fxIUA9lKwfWJDT+ZCAvSLQ+qW9CU
         i8Wg==
X-Gm-Message-State: APjAAAXRnlFW7xNyNFW1OwXd1DD9NzA3+Nyuk2oRakJDDcjUw5Or1Ina
        eLmnk5R05Ii7pBCX74zBJ23ynrmuToIXVvLKAGI=
X-Google-Smtp-Source: APXvYqx9ymukFe/tBUQNK7wtKGmsWiAPG+2T6ub8VNY5LvUHiZqsh0RhNmlZhmC+X9W69a0rPzCnGegI2mJzlejoBIk=
X-Received: by 2002:a92:3919:: with SMTP id g25mr2235862ila.221.1576060449476;
 Wed, 11 Dec 2019 02:34:09 -0800 (PST)
MIME-Version: 1.0
References: <20191211084112.971-1-linux.amoon@gmail.com> <a4610efc-844a-2d43-5db1-cf813102e701@baylibre.com>
 <CANAwSgQOTA0mSvFW5otaCzFPHidhY7VFcrXZHjCD-1XkQpcx3w@mail.gmail.com> <20191211095043.3kngq7wh77xvadge@gondor.apana.org.au>
In-Reply-To: <20191211095043.3kngq7wh77xvadge@gondor.apana.org.au>
From:   Anand Moon <linux.amoon@gmail.com>
Date:   Wed, 11 Dec 2019 16:03:58 +0530
Message-ID: <CANAwSgTNX1Q4VWymXYyvcByFhr+f3C9AqpG2G7dQp+0DPLR-JA@mail.gmail.com>
Subject: Re: [PATCHv1 0/3] Enable crypto module on Amlogic GXBB SoC platform
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-amlogic@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Wed, 11 Dec 2019 at 15:20, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Dec 11, 2019 at 03:07:53PM +0530, Anand Moon wrote:
> >
> > name         : ecb(aes)
> > driver       : ecb-aes-gxl
> > module       : kernel
> > priority     : 400
> > refcnt       : 1
> > selftest     : passed
> > internal     : no
> > type         : skcipher
> > async        : yes
> > blocksize    : 16
> > min keysize  : 16
> > max keysize  : 32
> > ivsize       : 0
> > chunksize    : 16
> > walksize     : 16
> >
> > name         : cbc(aes)
> > driver       : cbc-aes-gxl
> > module       : kernel
> > priority     : 400
> > refcnt       : 1
> > selftest     : passed
> > internal     : no
> > type         : skcipher
> > async        : yes
> > blocksize    : 16
> > min keysize  : 16
> > max keysize  : 32
> > ivsize       : 16
> > chunksize    : 16
> > walksize     : 16
>
> Oh so you did actually get them loaded.  You need to run tcrypt with
> mode=500 instead of 200 to test the async ciphers.  Does that work?
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

I get kernel panic, I will try to look into this much closely.

[alarm@alarm ~]$ sudo modprobe tcrypt sec=1 mode=500
[sudo] password for alarm:
[  754.382673] tcrypt:
[  754.382673] testing speed of async ecb(aes) (ecb-aes-gxl) encryption
[  754.385583] tcrypt: test 0 (128 bit key, 16 byte blocks):
[  754.385774] SError Interrupt on CPU1, code 0xbf000000 -- SError
[  754.385776] CPU: 1 PID: 121 Comm: da832000.crypto Not tainted
5.5.0-rc1-00012-g6794862a16ef-dirty #3
[  754.385778] Hardware name: Hardkernel ODROID-C2 (DT)
[  754.385779] pstate: 60000005 (nZCv daif -PAN -UAO)
[  754.385781] pc : wait_for_completion_interruptible_timeout+0x20/0x120
[  754.385782] lr : meson_handle_cipher_request+0x344/0x700
[  754.385783] sp : ffff800011e9bca0
[  754.385784] x29: ffff800011e9bca0 x28: 0000000000000040
[  754.385787] x27: 0000000000000010 x26: 0000000000000000
[  754.385789] x25: 0000000000000000 x24: 0000000005300080
[  754.385792] x23: 0000000000000002 x22: ffff00006d08aa00
[  754.385795] x21: ffff00007f68c4d0 x20: ffff00007f68c4c8
[  754.385797] x19: 000000000000007d x18: 00000000000000ab
[  754.385800] x17: 000000000000006c x16: 000000000000001b
[  754.385802] x15: 000000000000000c x14: 0000000000000010
[  754.385805] x13: 0000000000000000 x12: 0000000000000000
[  754.385808] x11: 0000000000000001 x10: ffff8000119d7e80
[  754.385810] x9 : 0000000000000000 x8 : ffff800011add000
[  754.385813] x7 : 0000000000000000 x6 : 0000000000000000
[  754.385815] x5 : 0000000000000000 x4 : 0000000080800010
[  754.385818] x3 : ffff800011acd000 x2 : 000000006d093002
[  754.385820] x1 : 000000000000007d x0 : ffff00007f68c4c8
[  754.385824] Kernel panic - not syncing: Asynchronous SError Interrupt
[  754.385825] CPU: 1 PID: 121 Comm: da832000.crypto Not tainted
5.5.0-rc1-00012-g6794862a16ef-dirty #3
[  754.385827] Hardware name: Hardkernel ODROID-C2 (DT)
[  754.385828] Call trace:
[  754.385829]  dump_backtrace+0x0/0x188
[  754.385830]  show_stack+0x14/0x20
[  754.385831]  dump_stack+0xb4/0xfc
[  754.385832]  panic+0x158/0x320
[  754.385833]  nmi_panic+0x84/0x88
[  754.385834]  arm64_serror_panic+0x74/0x80
[  754.385835]  do_serror+0x80/0x138
[  754.385836]  el1_error+0x84/0x100
[  754.385838]  wait_for_completion_interruptible_timeout+0x20/0x120
[  754.385839]  meson_handle_cipher_request+0x344/0x700
[  754.385840]  crypto_pump_work+0x10c/0x228
[  754.385841]  kthread_worker_fn+0xa8/0x188
[  754.385842]  kthread+0xf0/0x120
[  754.385843]  ret_from_fork+0x10/0x18
[  754.385862] SMP: stopping secondary CPUs
[  754.385863] Kernel Offset: disabled
[  754.385864] CPU features: 0x00002,24002004
[  754.385865] Memory Limit: none

-Anand
