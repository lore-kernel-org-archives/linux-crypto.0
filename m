Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41EB7C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 12:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 098792171F
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 12:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dWJ++1Zx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbfCMMtK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 08:49:10 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43031 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCMMtK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 08:49:10 -0400
Received: by mail-lj1-f194.google.com with SMTP id z20so1423595ljj.10
        for <linux-crypto@vger.kernel.org>; Wed, 13 Mar 2019 05:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BUxwNawH0Tkoj9W4Y+LgqMF3Dj4FNiS+G8O18fL3gz4=;
        b=dWJ++1ZxXn2kwj8bTkU3e3JpyCx56eL1eTMUrgfBLnpdkOSno3iGnO8OH2Gx2IaeiV
         W3R9j65M+P06dVVux+g+BM+TK4l1tBI3or0/nNhuw8b9NhpjErnYzZCdEtKX6HLALLc+
         sbNkHy2FFjpVLY+1GssUPtK1tB7zu5k7xzswW6dTXTkdcQJ7hk5Iwz5Gd51Br6Xulz3k
         V/NkCQCEqSAMPFLNHJynX5Nhlgi+fzi0ExrljYWJjRjDBHZkPgv4ikOoS0MAuRUvTQl2
         ANG6P0tHMoGPnIjfSQ4uzzPbKWFQOvufzu319ytU6aSyuYIxMa7kY1TXuTWXyleON52F
         FuJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BUxwNawH0Tkoj9W4Y+LgqMF3Dj4FNiS+G8O18fL3gz4=;
        b=WgiIz08uvqzLgbUcIzIoFL4PqVJFOCqXEl+51LIkXv250uK7VN8ezXYQry+Zx26esL
         xQeQ+mvCHy0UmQ4al0PCIQBaZX1HTe6gOZon6lVyHxZqbYJpdCODApzaP4xiZCMgjfnZ
         AAz1zE04JIctSkZ2OUZh5Ar5xiL/8dZFFhO2VrIm1UbLH4oaw1hOhT0XVc/19nntba1B
         R4shTyYE83Yy1tSlDY6BhwaDLYy5fgE/zMx6yO/onM1OO/kFtJLL/z0oevurw0SShOlC
         xjuOGnju9M93fzWQN+nAs5qVC7Nn5RrdmIYPjoRalSJuntPBMDxmml2h45ouKgNUHRfC
         cO5A==
X-Gm-Message-State: APjAAAWZUh8WKV6mgo5CZUownrRSN/r7rRgo7WPYeJIQzj4ESPLb0CC2
        7F4sMnASllrKL5A8icCYkBGeHAAywjMgMb3lbUEolOWE
X-Google-Smtp-Source: APXvYqxiRw23DB4H+Q4RE8WR7r0uav5cgIzW2KBx6rHRuw6lGxcl8fz/JAKlfr4+f3vHrXvdQ0yK2PEp3MQ6cv8DtVk=
X-Received: by 2002:a2e:20b:: with SMTP id 11mr23199147ljc.41.1552481347202;
 Wed, 13 Mar 2019 05:49:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAAUqJDtsx6Sdv=6xAb1VWWjDF08y8wh2nsAypR8_x_e99a1Uwg@mail.gmail.com>
In-Reply-To: <CAAUqJDtsx6Sdv=6xAb1VWWjDF08y8wh2nsAypR8_x_e99a1Uwg@mail.gmail.com>
From:   =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date:   Wed, 13 Mar 2019 13:48:55 +0100
Message-ID: <CAAUqJDuegy=zw3SwQ1UsV881DjLSvZ9X3joFt89HkBy7y9=7pg@mail.gmail.com>
Subject: Re: BUG: p8_aes_ctr randomly returns wrong results
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     nayna@linux.ibm.com, leitao@debian.org, pfsmorigo@gmail.com,
        marcelo.cerri@canonical.com, leo.barbosa@canonical.com,
        linuxppc-dev@lists.ozlabs.org,
        Stephan Mueller <smueller@chronox.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

st 13. 3. 2019 o 13:37 Ondrej Mosn=C3=A1=C4=8Dek <omosnacek@gmail.com> nap=
=C3=ADsal(a):
> Hi,
>
> FYI, the p8_aes_ctr crypto driver (drivers/crypto/vmx/aes_ctr.c) seems
> to be seriously broken. When I do repeated encryption using libkcapi
> multiple times in a row, I sometimes get a wrong result. This happens
> more often with long messages (e.g. at 16 KiB it already happens very
> frequently).
>
> To reproduce:
> 1. Install or locally build libkcapi [1] (you will need the kcapi-enc
> binary in PATH) on a ppc64le system.
> 2. Run the following in bash:
> for i in {1..100}; do head -c $((16*1024)) /dev/zero | kcapi-enc -e -c
> 'ctr(aes)' -p test -s test --pbkdfiter 1 2>/dev/null | sha256sum; done
> | sort -u
>
> Expected result:
> All invocations produce output with identical checksum.
>
> Actual result:
> Multiple different checksums are produced.
>
> When I run 'rmmod vmx_crypto' before running the reproducer, I get
> only one (correct) checksum, so this is definitely a bug in the
> driver. Other ciphers (cbc(aes), xts(aes)) are not affected, even
> though the glue code is very similar. That leads me to believe the
> problem is somewhere in the assembly code.
>
> [1] http://github.com/smuellerDD/libkcapi
>
> Cheers,
> Ondrej

(Ah, forgot to compare email addresses with MAINTAINERS... let me try these=
)
