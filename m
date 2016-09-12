From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: Kernel panic - encryption/decryption failed when open file on Arm64
Date: Mon, 12 Sep 2016 18:40:15 +0100
Message-ID: <CAKv+Gu9jaVyJ4PYsxZfiZXB3Uezr26YWhSyE-g+n6-AuWFcneQ@mail.gmail.com>
References: <57D15BD3.40903@huawei.com> <20160908124709.GA26586@gondor.apana.org.au>
 <57D28CB8.4080904@huawei.com> <CAKv+Gu9JDCHDteOvgpEg4SJP4OKgM6=euF3pzBcXDJxTt=dAYg@mail.gmail.com>
 <CAKv+Gu8w+BuwxQjOtpnFPHnJNUzq7m0K+KJ8=FG2wHigaB54ng@mail.gmail.com> <00B10D30F2BAA743B48953A4D86C96D54C8A8A@SZXEMI506-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Xiakaixu <xiakaixu@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        "mh1@iki.fi" <mh1@iki.fi>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wangbintian <bintian.wang@huawei.com>,
        Huxinwei <huxinwei@huawei.com>,
        "zhangzhibin (C)" <zhangzhibin.zhang@huawei.com>
To: liushuoran <liushuoran@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36661 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754813AbcILRkR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Sep 2016 13:40:17 -0400
Received: by mail-oi0-f42.google.com with SMTP id q188so210048524oia.3
        for <linux-crypto@vger.kernel.org>; Mon, 12 Sep 2016 10:40:16 -0700 (PDT)
In-Reply-To: <00B10D30F2BAA743B48953A4D86C96D54C8A8A@SZXEMI506-MBS.china.huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12 September 2016 at 03:16, liushuoran <liushuoran@huawei.com> wrote:
> Hi Ard,
>
> Thanks for the prompt reply. With the patch, there is no panic anymore. B=
ut it seems that the encryption/decryption is not successful anyway.
>
> As Herbert points out, "If the page allocation fails in blkcipher_walk_ne=
xt it'll simply switch over to processing it block by block". So does that =
mean the encryption/decryption should be successful even if the page alloca=
tion fails? Please correct me if I misunderstand anything. Thanks in advanc=
e.
>

Perhaps Herbert can explain: I don't see how the 'n =3D 0' assignment
results in the correct path being taken; this chunk (blkcipher.c:252)

if (unlikely(n < bsize)) {
    err =3D blkcipher_next_slow(desc, walk, bsize, walk->alignmask);
    goto set_phys_lowmem;
}

is skipped due to the fact that n =3D=3D 0 and therefore bsize =3D=3D 0, an=
d
so the condition is always false for n =3D=3D 0

Therefore we end up here (blkcipher.c:257)

walk->nbytes =3D n;
if (walk->flags & BLKCIPHER_WALK_COPY) {
    err =3D blkcipher_next_copy(walk);
    goto set_phys_lowmem;
}

where blkcipher_next_copy() unconditionally calls memcpy() with
walk->page as destination (even though we ended up here due to the
fact that walk->page =3D=3D NULL)

So to me, it seems like we should be taking the blkcipher_next_slow()
path, which does a kmalloc() and bails with -ENOMEM if that fails.
