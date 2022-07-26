Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E952FC00140
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 14:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbiGZO0R (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 10:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbiGZO0Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 10:26:16 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E451231
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 07:26:15 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id q14so11326642iod.3
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 07:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yVHkxq57TzEVqXp8kOXlD0/zRPCbREzhHv/ILW3eR1I=;
        b=Ew7PlsT6zBaV5HgUxbUZBZH8ry6+tTVKlj5uQsyJntO+uyM2DkHAuFovHGc82DVAb7
         URpU0MTKVIn7oPHypJLqDn2ZOQ9oUgfur9LLgWyPhD/rcJ49EDlGQxI/y3ChcNcp4Nnr
         YvonrYdy6IN0lTS0GurTplPx2QUC63OUXYLEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yVHkxq57TzEVqXp8kOXlD0/zRPCbREzhHv/ILW3eR1I=;
        b=ZPDvoYQbF1f+ZXfVDyS6be70onM47lR5QGLwOtB27QXJkfFMlNxi/ML/I7Plht6AWn
         vY4t0Lx1mQtIb288bYZvWJ39DiOKW5hKNg0gdXce2jwlq2VxwMR1EYJSI2+blE53wFgq
         LpxiOkuh+hcJgN46LGBeao0iWR0TmLWxLnk7uDE5jXIHrpyttPTQjKb3GTiVUjgOMTbF
         7IY+Th6d9fRvNYBe4kYN4TVDCGvqhQ1DQ3uWqzYdkaslxQa/tY5RDXe1n1IrO0cla1xM
         yQOXHL3qTNa2zM1Ly7bak19KArhPmXcw/uoy4P2gRBEEq/Lgpd2DnTjleeS6BGbE9QxA
         kB6w==
X-Gm-Message-State: AJIora9r9COEsOBW5H2e2IwRYOc/FA4JifrjcnvPCR9Z/uZn0vQdz7mW
        JFM0GUvTeQ1tJS1XiICSkR8Oem/0IO7VbEQI52xApg==
X-Google-Smtp-Source: AGRyM1stn1GPr80VsNvqf5Z/Obbchm35wMPAa8vEbk5W2h8uyoEJWl35Q9ok5nuwpleuLtlODHHlCVZmfQnPDqmg6Cw=
X-Received: by 2002:a05:6638:3f0e:b0:341:6c92:171d with SMTP id
 ck14-20020a0566383f0e00b003416c92171dmr6974612jab.0.1658845574739; Tue, 26
 Jul 2022 07:26:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220726090021.1529148-1-zhangxiaoxu5@huawei.com>
In-Reply-To: <20220726090021.1529148-1-zhangxiaoxu5@huawei.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Tue, 26 Jul 2022 15:26:03 +0100
Message-ID: <CALrw=nHzkwGx2kJeJ4LYe4ckPU=hDw=pqi7w_Z8UoyF6UD4d_w@mail.gmail.com>
Subject: Re: [PATCH -next] crypto: testmgr - fix oob read when test RSA vectors
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-crypto <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, errelln@fb.com,
        alexandre.torgue@foss.st.com,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 26, 2022 at 9:01 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>
> The definition of key before coefficient should not add comma.
> Otherwise there will be OOB read happened as follow:
>
>   BUG: KASAN: global-out-of-bounds in test_akcipher_one+0x1ae/0xb20
>   Read of size 607 at addr ffffffff99f95ac0 by task cryptomgr_test/198
>
>   CPU: 5 PID: 198 Comm: cryptomgr_test Not tainted 5.19.0-rc7-next-20220722-00002-g4628e935ed92-dirty #1
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x34/0x44
>    print_report.cold+0x59/0x682
>    kasan_report+0xa3/0x120
>    kasan_check_range+0x145/0x1a0
>    memcpy+0x20/0x60
>    test_akcipher_one+0x1ae/0xb20
>    alg_test_akcipher+0x94/0xb0
>    alg_test.part.0+0x467/0x510
>    cryptomgr_test+0x36/0x60
>    kthread+0x165/0x1a0
>    ret_from_fork+0x1f/0x30
>    </TASK>
>
> Remove the comma before coefficient.

Thanks for the report, but it was already fixed in commit 9d2bb9a7
("crypto: testmgr - some more fixes to RSA test vectors
"), which is already on the latest linux-next.

> Fixes: 79e6e2f3f3ff3 ("crypto: testmgr - populate RSA CRT parameters in RSA test vectors")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  crypto/testmgr.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index dee88510f58d..57da8c8b4574 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -273,7 +273,7 @@ static const struct akcipher_testvec rsa_tv_template[] = {
>         "\x61\xAD\xBD\x3A\x8A\x7E\x99\x1C\x5C\x05\x56\xA9\x4C\x31\x46\xA7"
>         "\xF9\x80\x3F\x8F\x6F\x8A\xE3\x42\xE9\x31\xFD\x8A\xE4\x7A\x22\x0D"
>         "\x1B\x99\xA4\x95\x84\x98\x07\xFE\x39\xF9\x24\x5A\x98\x36\xDA\x3D"
> -       "\x02\x41", /* coefficient - integer of 65 bytes */
> +       "\x02\x41" /* coefficient - integer of 65 bytes */
>         "\x00\xB0\x6C\x4F\xDA\xBB\x63\x01\x19\x8D\x26\x5B\xDB\xAE\x94\x23"
>         "\xB3\x80\xF2\x71\xF7\x34\x53\x88\x50\x93\x07\x7F\xCD\x39\xE2\x11"
>         "\x9F\xC9\x86\x32\x15\x4F\x58\x83\xB1\x67\xA9\x67\xBF\x40\x2B\x4E"
> @@ -370,7 +370,7 @@ static const struct akcipher_testvec rsa_tv_template[] = {
>         "\x6A\x37\x3B\x86\x6C\x51\x37\x5B\x1D\x79\xF2\xA3\x43\x10\xC6\xA7"
>         "\x21\x79\x6D\xF9\xE9\x04\x6A\xE8\x32\xFF\xAE\xFD\x1C\x7B\x8C\x29"
>         "\x13\xA3\x0C\xB2\xAD\xEC\x6C\x0F\x8D\x27\x12\x7B\x48\xB2\xDB\x31"
> -       "\x02\x81\x81", /* coefficient - integer of 129 bytes */
> +       "\x02\x81\x81" /* coefficient - integer of 129 bytes */
>         "\x00\x8D\x1B\x05\xCA\x24\x1F\x0C\x53\x19\x52\x74\x63\x21\xFA\x78"
>         "\x46\x79\xAF\x5C\xDE\x30\xA4\x6C\x20\x38\xE6\x97\x39\xB8\x7A\x70"
>         "\x0D\x8B\x6C\x6D\x13\x74\xD5\x1C\xDE\xA9\xF4\x60\x37\xFE\x68\x77"
> --
> 2.31.1
>

Regards,
Ignat
