Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D67C433DB
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Jan 2021 20:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 247B2207C9
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Jan 2021 20:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbhACUcI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Jan 2021 15:32:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:60814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbhACUcI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Jan 2021 15:32:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54D1320780
        for <linux-crypto@vger.kernel.org>; Sun,  3 Jan 2021 20:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609705887;
        bh=bDzNSin3o6TEaStUl7MW4rakaNL4H31F3oAqUFB5YVo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FhyfIbGDBdfZUjmUEak4RSgdxs+BdD6ZG2WeBNxp0+XZ0YnRFxq8WVBYTHov3FiiU
         wuIs331sNEYmFejftqG2ZIu0lx5UEdm3LbMsyFbJHdru/AXL3EtvM9oGWXNXe3/M0r
         EfUQgT5/CyzT5/1SeNqMhEYyfpYXD8i6G4guyP04RN4poaUPO4zVFhX7MYispAcbFR
         aKkVd/NPOfVWEUrtOXuFAnErBRG5nDYWlhilwdZbiZpULiAX5/cgQxDrWHi9DEwr7h
         kJrdnm2IBWUyk5lT5q9DNOKXXr9+0d1Xol5PFDSyvxYkfmqhK+WMU6YjXkg9nDjy6Z
         0Fm2bOwfUqdOw==
Received: by mail-ot1-f48.google.com with SMTP id d8so24285139otq.6
        for <linux-crypto@vger.kernel.org>; Sun, 03 Jan 2021 12:31:27 -0800 (PST)
X-Gm-Message-State: AOAM533sYQVSld7LJpnMEXOoWeUBk0w6ASyvPjEyP6ltvcEQZ/a+tMp9
        RuzDmFS2iu82K5QwdArC7yLHCkojcrqw9hu49zk=
X-Google-Smtp-Source: ABdhPJwBXPIDDX31Fe7MQtaYnQzq2qdbK2yRTcbqCJjzVluoBnqe8Ex1kYu+sQnm7LWuIZW6M5EFhgw4lmpMo6dALoE=
X-Received: by 2002:a9d:12c:: with SMTP id 41mr49609361otu.77.1609705886723;
 Sun, 03 Jan 2021 12:31:26 -0800 (PST)
MIME-Version: 1.0
References: <20201231164155.21792-3-ardb@kernel.org> <202101010632.59pt4uvv-lkp@intel.com>
In-Reply-To: <202101010632.59pt4uvv-lkp@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 3 Jan 2021 21:31:15 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFZ77ptJXqp-JWembc-U6ouhZs3G8079Y+qkPQ47VQogA@mail.gmail.com>
Message-ID: <CAMj1kXFZ77ptJXqp-JWembc-U6ouhZs3G8079Y+qkPQ47VQogA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: x86/aes-ni-xts - rewrite and drop
 indirections via glue helper
To:     kernel test robot <lkp@intel.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kbuild-all@lists.01.org, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Uros Bizjak <ubizjak@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 31 Dec 2020 at 23:37, kernel test robot <lkp@intel.com> wrote:
>
> Hi Ard,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on cryptodev/master]
> [also build test ERROR on crypto/master linus/master v5.11-rc1 next-20201223]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>

This is a false positive, and the cover letter mentions that these
patches depend on the cts(cbc(aes)) patch which is now in the
cryptodev tree

I will try to remember to use --base next time.


> url:    https://github.com/0day-ci/linux/commits/Ard-Biesheuvel/crypto-x86-aes-ni-xts-recover-and-improve-performance/20210101-004902
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> config: x86_64-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/0day-ci/linux/commit/120e62f276c7436572e8a67ecfb9bbb1125bfd8d
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Ard-Biesheuvel/crypto-x86-aes-ni-xts-recover-and-improve-performance/20210101-004902
>         git checkout 120e62f276c7436572e8a67ecfb9bbb1125bfd8d
>         # save the attached .config to linux build tree
>         make W=1 ARCH=x86_64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    ld: arch/x86/crypto/aesni-intel_asm.o: in function `aesni_xts_encrypt':
> >> (.text+0x8909): undefined reference to `.Lcts_permute_table'
>    ld: arch/x86/crypto/aesni-intel_asm.o: in function `aesni_xts_decrypt':
>    (.text+0x8af6): undefined reference to `.Lcts_permute_table'
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
