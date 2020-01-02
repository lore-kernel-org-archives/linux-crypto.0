Return-Path: <SRS0=AlyN=2X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6459CC2D0DD
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jan 2020 21:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 322D222314
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jan 2020 21:14:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eyu5H7tt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgABVOj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 16:14:39 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44516 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgABVOj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 16:14:39 -0500
Received: by mail-qk1-f195.google.com with SMTP id w127so32334602qkb.11
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jan 2020 13:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=V/OsTfrHJ4dnD2NS1w0Sn8mIRoSC4Lw2ATH8Gyo/s7A=;
        b=eyu5H7ttZi9tARS8Cnfzkprmox7MLOjyD16A2d2b2d3DmqWGIM+2rPuspcfRX03ERv
         nFNzaX9FKnsb9QugoWPC69vHQkGUdLRU0uorKMXlBRmMQRfJgoj5zyzOb6s4OmOuUjKK
         DAm4SwmIu7aHKNcBUyFxqZPj3KuymhHIrQzJIq4i3uwgzAP4zcBmXFInSurFXgI20ryK
         /TaoiUprQ2Vw7KtaRKEi8LUQF75dSR/bg1SLVwKYc+CtDTFZ+xQiNFn1pyS6/ErfCHMX
         K0/d2oI70PozVvhSkmRVOxioKabpWGXYpIzgHv+n58tJP3Rniy4iB2CIITZiEjtO0/kf
         RBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=V/OsTfrHJ4dnD2NS1w0Sn8mIRoSC4Lw2ATH8Gyo/s7A=;
        b=XeingvdU5LErNVb+mzjCaaCiX7no7tdzwDizbBVryX4GAjvhbsmUCkytVdjqAA7Ppz
         D2B0Ky/Y3wfJF0rIG3b9pFqrkZuVRb5B1fmoMtRVV5MI4F+SIJrgD5xMjRHEJ/GPuAS+
         u5GGjDMk6nU7rjN83HLTSHqYeEva2HoISmgVsoMg0oFs5gpS1vmuGfuX2IdXj4ZHNcGi
         8fbZLmICpRV+MTub9OF1mBIrq4JNom4Jn1B6myktLf0XLa/M/91cV9I8fFCM2/0uvn2Y
         bs65brZWZW1M1TTjLwCqTiZfsYnjPnNWXlzDhelkOk+x2cezIJJNPJP7ta1DojVJyhov
         PDEg==
X-Gm-Message-State: APjAAAXm90PIVIpfybNHxF2gUWyx2T17zL2VnSJe8El4V3oqabVlp1K7
        VqAdr6bpe5awsYEMOJ0D5OuQt4jL6/Xg1kMyY1KQVALv
X-Google-Smtp-Source: APXvYqzKZQF/maQ/u7E/LjcSzAwL1yTgluTQanRyn2kiZKmqKsLmo1zJnJYWInWF3r9zXMIbqaxKtB4B1dKiYpY77c8=
X-Received: by 2002:a05:620a:16bb:: with SMTP id s27mr71612515qkj.368.1577999678159;
 Thu, 02 Jan 2020 13:14:38 -0800 (PST)
MIME-Version: 1.0
References: <20191220190218.28884-1-cotequeiroz@gmail.com> <CAKv+Gu9ZXCK41xOavw+2KEhhsZq9BFH6mxXKPNomzB6q+DP_FQ@mail.gmail.com>
 <CAPxccB2LGANG8DcmF4nwUDOzDzf2RHX4S-4w9z6TcO9csu4xSw@mail.gmail.com>
In-Reply-To: <CAPxccB2LGANG8DcmF4nwUDOzDzf2RHX4S-4w9z6TcO9csu4xSw@mail.gmail.com>
From:   Eneas Queiroz <cotequeiroz@gmail.com>
Date:   Thu, 2 Jan 2020 18:14:12 -0300
Message-ID: <CAPxccB3atGOCi_Na8-7wceOTjGQ8twZCwzvP9zHuaMDdv6zv9w@mail.gmail.com>
Subject: Fwd: QCE hw-crypto DMA issues
To:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I'm changing the subject title, as the original series has been merged.

On Mon, Dec 23, 2019 at 6:46 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On Fri, 20 Dec 2019 at 20:02, Eneas U de Queiroz <cotequeiroz@gmail.com> wrote:
> >
> > I've been trying to make the Qualcomm Crypto Engine work with GCM-mode
> > AES.  I fixed some bugs, and added an option to build only hashes or
> > skciphers, as the VPN performance increases if you leave some of that to
> > the CPU.
> >
> > A discussion about this can be found here:
> > https://github.com/openwrt/openwrt/pull/2518
> >
> > I'm using openwrt to test this, and there's no support for kernel 5.x
> > yet.  So I have backported the recent skcipher updates, and tested this
> > with 4.19. I don't have the hardware with me, but I have run-tested
> > everything, working remotely.
> >
> > All of the skciphers directly implemented by the driver work.  They pass
> > the tcrypt tests, and also some tests from userspace using AF_ALG:
> > https://github.com/cotequeiroz/afalg_tests
> >
> > However, I can't get gcm(aes) to work.  When setting the gcm-mode key,
> > it sets the ctr(aes) key, then encrypt a block of zeroes, and uses that
> > as the ghash key.  The driver fails to perform that encryption.  I've
> > dumped the input and output data, and they apparently are not touched by
> > the QCE.  The IV, which written to a buffer appended to the results sg
> > list gets updated, but the results themselves are not.  I'm not sure
> > what goes wrong, if it is a DMA/cache problem, memory alignment, or
> > whatever.
> >
>
> This does sound like a DMA problem. I assume the accelerator is not
> cache coherent?
>
> In any case, it is dubious whether the round trip to the accelerator
> is worth it when encrypting the GHASH key. Just call aes_encrypt()
> instead, and do it in software.

ipsec still fails, even if I use software for every single-block
operation. I can perhaps leave that as an optimization, but it won't
fix the main issue.

> > If I take 'be128 hash' out of the 'data' struct, and kzalloc them
> > separately in crypto_gcm_setkey (crypto/gcm.c), it encrypts the data
> > just fine--perhaps the payload and the request struct can't be in the
> > same page?
> >
>
> Non-cache coherent DMA involves cache invalidation on inbound data. So
> if both the device and the CPU write to the same cacheline while the
> buffer is mapped for DMA from device to memory, one of the updates
> gets lost.

Can you give me any pointers/examples of how I can make this work?

Thanks,

Eneas
