From: Anand Moon <linux.amoon@gmail.com>
Subject: Re: [PATCH] crypto: s5p-sss.c: Fix kernel Oops in AES-ECB mode
Date: Tue, 6 Feb 2018 22:18:26 +0530
Message-ID: <CANAwSgTO5_mL9GEYrXDJyKakY3JTeF+VxbCTuHczAvfVY0zUsg@mail.gmail.com>
References: <CGME20180205174022eucas1p101e8339284c1f0ac8f40f70c24de1c1f@eucas1p1.samsung.com>
 <224788c7-426b-d3a9-d0a6-412d2b8afb75@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:36091 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752259AbeBFQsr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Feb 2018 11:48:47 -0500
In-Reply-To: <224788c7-426b-d3a9-d0a6-412d2b8afb75@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kamil,

Thanks for providing the fix to this issue.

On 5 February 2018 at 23:10, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
>
> In AES-ECB mode crypt is done with key only, so any use of IV
> can cause kernel Oops, as reported by Anand Moon.

If possible could you avoid the name in commit message.

> Fixed it by using IV only in AES-CBC and AES-CTR.
>
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> Reported-by: Anand Moon <linux.amoon@gmail.com>

[snip]

Please add my. Tested on Odroid HC2

Tested-by: Anand Moon <linux.amoon@gmail.com>

Below are the result at my end.

aes-cbc-essiv:sha256 (128 bit key)
WRITE:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 11.7225 s, 71.6 MB/s
READ:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 22.112 s, 37.9 MB/s

aes-cbc-essiv:sha256 (256 bit key)
WRITE:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 13.096 s, 64.1 MB/s
READ:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 24.4165 s, 34.4 MB/s

aes-ctr-plain (128 bit key)
WRITE:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 11.2246 s, 74.7 MB/s
READ:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 20.426 s, 41.1 MB/s

aes-xts-plain64 (256 bit key)
WRITE:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 11.1533 s, 75.2 MB/s
READ:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 20.8821 s, 40.2 MB/s

aes-xts-plain64 (512 bit key)
WRITE:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 12.0614 s, 69.5 MB/s
READ:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 23.0717 s, 36.4 MB/s

twofish-cbc-essiv:sha256 (128 bit key)
WRITE:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 13.031 s, 64.4 MB/s
READ:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 20.7202 s, 40.5 MB/s

twofish-cbc-essiv:sha256 (256 bit key)
WRITE:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 12.9995 s, 64.5 MB/s
READ:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 24.2369 s, 34.6 MB/s

twofish-xts-plain64 (256 bit key)
WRITE:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 14.607 s, 57.4 MB/s
READ:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 26.2963 s, 31.9 MB/s

twofish-xts-plain64 (512 bit key)
WRITE:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 14.5783 s, 57.5 MB/s
READ:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 25.3593 s, 33.1 MB/s

serpent-cbc-essiv:sha256 (128 bit key)
WRITE:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 15.5157 s, 54.1 MB/s
READ:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 37.0526 s, 22.6 MB/s

serpent-cbc-essiv:sha256 (256 bit key)
WRITE:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 16.1138 s, 52.1 MB/s
READ:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 36.922 s, 22.7 MB/s

serpent-xts-plain64 (256 bit key)
WRITE:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 17.287 s, 48.5 MB/s
READ:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 39.279 s, 21.4 MB/s

serpent-xts-plain64 (512 bit key)
WRITE:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 16.9464 s, 49.5 MB/s
READ:
100+0 records in
100+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 38.3389 s, 21.9 MB/s

Best Regards
-Anand
