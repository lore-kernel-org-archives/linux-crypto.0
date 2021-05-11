Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB9EC433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 15:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27752611BE
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 15:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhEKPte (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 May 2021 11:49:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231561AbhEKPte (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 May 2021 11:49:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14D42611BE
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 15:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620748108;
        bh=qvGu5N9e3J5qm0k5VqgtPfsGKPldGY91CooQ0ICs9+M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=V5borhnociiZs3ZXmAyJ9i7Nci/cpDtfmpTkPWYcqegVxJqdS7/3ApHbg4N82WDx5
         A51dhH/RY0f7PtG1SQ50qs3itvHSUQT3J5qfEJkTmjFq6CrdSznHZ7DU6DfBCnM5fp
         VfIv5WHdZTir/RbQMY2NdpzIW+B+0daMx6GWi6VNNtPSwVmbZafd34T4TMVw9boWtr
         UxbXuuIM/AqKrRD0Cezazs27yzqVqx6omM2xi1JnnggHuSULv491AfySGZ0Nsd37Ew
         4GiIj0ZgP08cyWPisoEDDq00my2ehxbc8oyrtW+Crh7EO87XNTOc4EPEI7sRcWmul4
         QipDYHpG9gFkg==
Received: by mail-ot1-f42.google.com with SMTP id d25-20020a0568300459b02902f886f7dd43so4455806otc.6
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 08:48:28 -0700 (PDT)
X-Gm-Message-State: AOAM533t5xdJbxzu+TbhP+YIVZH2pgXRtGBPTomGgmGP48WJxO/yz0SG
        jYptaG/OSH2E7blx7I8/HkqyqoGZISYDN+ZBBxg=
X-Google-Smtp-Source: ABdhPJy7Rlph46TJ/eG38dMZTw42m9LaRbVr6HIyYI5KdT1jkugfMk6s5/ndRr7+rg05mGjaYPMLUnoiODaFtk35oz4=
X-Received: by 2002:a05:6830:4da:: with SMTP id s26mr26516091otd.77.1620748107244;
 Tue, 11 May 2021 08:48:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAE9cyGTQZXW-6YsmHu3mGSHonTztBszqaYske7PKgz0pWHxQKA@mail.gmail.com>
In-Reply-To: <CAE9cyGTQZXW-6YsmHu3mGSHonTztBszqaYske7PKgz0pWHxQKA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 11 May 2021 17:48:16 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHOVRDAt7-C8UKi=5=MAgQ9kQz=HUtiuK_gt7ch_i950w@mail.gmail.com>
Message-ID: <CAMj1kXHOVRDAt7-C8UKi=5=MAgQ9kQz=HUtiuK_gt7ch_i950w@mail.gmail.com>
Subject: Re: or should block size for xts.c set to 1 instead of AES block size?
To:     Kestrel seventyfour <kestrelseventyfour@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 7 May 2021 at 08:12, Kestrel seventyfour
<kestrelseventyfour@gmail.com> wrote:
>
> Hi,
>
> one more thought, shouldn't the block size for generic xts set to 1 in
> order to reflect that any input size length is allowed to the
> algorithm?
>

I think this was discussed at some point on the list, and Herbert
seemed to suggest that 1 was a better choice than AES_BLOCK_SIZE.
You'd have to set the chunksize, though, to ensure that the input is
presented in the right granularity, i.e., to ensure that the skcipher
walk layer never presents less than chunksize bytes unless it is the
end of the input.

However, this is a flag day change, so you'd need to update all
implementations at the same time. Otherwise, the extended tests (which
compare accelerated implementations with xts(ecb(aes-generic))) will
start failing on the cra_blocksize mismatch.
