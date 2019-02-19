Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01EFDC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 10:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4D3A21773
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 10:11:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lLqsH+/t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfBSKL3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 05:11:29 -0500
Received: from mail-it1-f170.google.com ([209.85.166.170]:50798 "EHLO
        mail-it1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfBSKL3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 05:11:29 -0500
Received: by mail-it1-f170.google.com with SMTP id m137so4803979ita.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 Feb 2019 02:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L0cZ0tVqtW9kfItlciv+ga9j/6Pg5sRtl7YtijL5Qfw=;
        b=lLqsH+/tJTMh73Z5IHIhmGvCRCWpnuvmHd2p0gJ+v+A/UoqB8owwb2A01rttc3OKND
         aK4lVZxI5V2XF63HbnIqzk2OqZannL6Ja5rT1Ag9cqfkYPoNzkfUBQo2Ffewy3epE0FY
         rQcliu1z89+qy/0+CDvhkOAoe76wk+rQOhK4lU/Tr8ItnAPox36BO5q5ZZUN/MmsckR5
         E9WA+X0dnaIc4dNWN5zWjE0LFHbTxIIkhRSIEa86bSvePQQ+aUX0d+kBuSQQu0LaHIhc
         dQqRg5irgzWJk6F5EXdDp0uDyJEIJYfLf613rOe0ZKH5Orqgwx0B0lW1RhpucHzH40Jp
         w3Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L0cZ0tVqtW9kfItlciv+ga9j/6Pg5sRtl7YtijL5Qfw=;
        b=rmQ6EZxpOaGpceiu9+cIq3t/kzzGn/N22+A719gE/s37CAOk3mwGVz0+24tptwP+Bz
         O7JKMIb2QThbrDKZf/ZxGIPaOHVJIzAtETD7zzVm5F8VD5tqLtCKO8LSwnuP/AoygHvR
         /GeIL+pXVeR8ElLqjuZXHWB5Hh2r0vpqqHhZAgdaF761mzzC1Ayjs05tRWJ5ZwEk1+vS
         NF2p5hjzmj5d1blZmpjxMVlmTcM75+paoDmMwC3dFlShZfAsVx6xXXAnFWaHWITEzXQJ
         /nG0gROICA7MMjWOMC/wUcsSHks39sJyuDCnK9oQP/vxBEUSolnkAbQSAS0b4d7OGlFT
         fNLw==
X-Gm-Message-State: AHQUAuZ2x09kyLIgoS9c4KTgmznsdUrwkgk/xEY6o2/Nwd/5XMvsYXYP
        qljoGffDMSk6tILXYvBuw7bYso1vV+8Qq9vgrHUsAg==
X-Google-Smtp-Source: AHgI3IazTFGtyUp+ZG5NwknbpPVzij/BGpd9sn0Xp+gcI6OxPlqcnr64aq35v0OOe+8lj9Y1/3OQC+0v7f8xiPgCRD4=
X-Received: by 2002:a24:1947:: with SMTP id b68mr1551697itb.121.1550571087965;
 Tue, 19 Feb 2019 02:11:27 -0800 (PST)
MIME-Version: 1.0
References: <CGME20190215185148epcas3p23960bfe37c629ebb2103e673509949f4@epcas3p2.samsung.com>
 <20190215185058.GB12909@gmail.com> <a78f8033-954f-8b59-b361-557acef3acdd@partner.samsung.com>
In-Reply-To: <a78f8033-954f-8b59-b361-557acef3acdd@partner.samsung.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 19 Feb 2019 11:11:16 +0100
Message-ID: <CAKv+Gu_6QNOWN8wd+dpvGocrLhQjvNS4SpMaVqZ86uWtT70yiw@mail.gmail.com>
Subject: Re: [Bug] s5p-sss crypto driver doesn't set next AES-CBC IV
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Christoph Manszewski <c.manszewski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 19 Feb 2019 at 10:58, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
>
> Hi,
>
> On 15.02.2019 19:51, Eric Biggers wrote:
> > Hello,
> >
> > The AES-CBC implementation in the s5p-sss crypto driver is failing the improved
> > crypto self-tests I currently have out for review.  The improved tests check
> > that all CBC implementations update the IV buffer to be the last ciphertext
> > block.  This has always been required so that requests can be chained, but
> > unfortunately it wasn't tested for by the self-tests until now.
> >
> > See the boot logs for Exynos platforms from the KernelCI job here:
> > https://kernelci.org/boot/all/job/ardb/branch/for-kernelci/kernel/v5.0-rc1-149-g64c945c018af/
> >
> > alg: skcipher: cbc-aes-s5p encryption test failed (wrong output IV) on test vector 0, cfg=\"in-place\"
> > 00000000: 3d af ba 42 9d 9e b4 30 b4 22 da 80 2c 9f ac 41
> > [...]
>
> I checked dmesg logs after my patch with:
>
> root@target:~# dmesg |grep alg: |grep aes
> [    4.087168] crypto: alg: self-tests for aes-generic (aes) passed
> [    6.305202] crypto: alg: self-tests for ecb-aes-s5p (ecb(aes)) passed
> [    6.405489] crypto: alg: self-tests for cbc-aes-s5p (cbc(aes)) passed
> [    6.505000] crypto: alg: self-tests for ctr-aes-s5p (ctr(aes)) passed
>
> and I noticed there are no cbc-aes-generic nor ctr-aes-generic
>
> Did you test them in separate tree ? Why they are not registered in /proc/crypto ?
>

Generic CBC and CTR are template based, so they are only instantiated on demand.
