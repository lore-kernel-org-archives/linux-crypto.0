Return-Path: <SRS0=ZKCq=6R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E263C28CBC
	for <linux-crypto@archiver.kernel.org>; Sun,  3 May 2020 16:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 699CA206B8
	for <linux-crypto@archiver.kernel.org>; Sun,  3 May 2020 16:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588522484;
	bh=v/GdpUiwhUEgyLIQs4iqBWqCrRSiBXU6uSbDJ7XGPiA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=1Sn6MmxJoiC2CQ7kf/Rwk/xIwghI8anvdfb9pFiqiqCPp+o4qFAZLTDT6IRsrRf2l
	 Irn4/lrxtmPGqUjJDzO+CoYGsa5ot+x115g/aPlR+jS5OFQG4lAUUTDpFUlySrO+ae
	 16QqQqvwi6GaTDpDElOz0WJYa18fFKYtI+nnqgvM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgECQOn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 May 2020 12:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbgECQOn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 May 2020 12:14:43 -0400
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB96924953;
        Sun,  3 May 2020 16:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588522482;
        bh=v/GdpUiwhUEgyLIQs4iqBWqCrRSiBXU6uSbDJ7XGPiA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HUw64GcCuh4QEKVQzd19hfQ6MuE85JT+aL8V+5myvA/ocJchkFZO3QDIbIZkKgTiO
         hUv4qdIVYpzKt8SY2tlrQA8nwQeSaSYT3HE3luy30EkCF2F7DEU1acSq3puJMyy/fU
         KMX6Ot8zwqoePdKP+366XeRo3Oqq7OXgONx8WNNA=
Received: by mail-il1-f176.google.com with SMTP id b18so9034538ilf.2;
        Sun, 03 May 2020 09:14:42 -0700 (PDT)
X-Gm-Message-State: AGi0PuYxeO46cs51BazEAU9BHCmXxslW0OuBxT4kKBQHCAkaMLFoZzLZ
        bOAhNW5jTf4qh7ifUXKC1iKVJy1xe83v5YwqidI=
X-Google-Smtp-Source: APiQypK7cKz3TGzrgiEEmohb3IEejW1GKi071ccK4M2qSXz7GkH9GOLTsLT+pVxFg8EWfCmzjA1ERwmumjj/PshL39U=
X-Received: by 2002:a92:39dd:: with SMTP id h90mr12778366ilf.80.1588522482062;
 Sun, 03 May 2020 09:14:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200502182427.104383-1-ebiggers@kernel.org>
In-Reply-To: <20200502182427.104383-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 3 May 2020 18:14:31 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEBR1FUHOfCo1G2tGVgZDdSsUx8ZrNdLqHbKP6Hw7LfMw@mail.gmail.com>
Message-ID: <CAMj1kXEBR1FUHOfCo1G2tGVgZDdSsUx8ZrNdLqHbKP6Hw7LfMw@mail.gmail.com>
Subject: Re: [PATCH 0/7] sha1 library cleanup
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Paolo Abeni <pabeni@redhat.com>,
        mptcp@lists.01.org, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 2 May 2020 at 20:28, Eric Biggers <ebiggers@kernel.org> wrote:
>
> <linux/cryptohash.h> sounds very generic and important, like it's the
> header to include if you're doing cryptographic hashing in the kernel.
> But actually it only includes the library implementation of the SHA-1
> compression function (not even the full SHA-1).  This should basically
> never be used anymore; SHA-1 is no longer considered secure, and there
> are much better ways to do cryptographic hashing in the kernel.
>
> Also the function is named just "sha_transform()", which makes it
> unclear which version of SHA is meant.
>
> Therefore, this series cleans things up by moving these SHA-1
> declarations into <crypto/sha.h> where they better belong, and changing
> the names to say SHA-1 rather than just SHA.
>
> As future work, we should split sha.h into sha1.h and sha2.h and try to
> remove the remaining uses of SHA-1.  For example, the remaining use in
> drivers/char/random.c is probably one that can be gotten rid of.
>
> This patch series applies to cryptodev/master.
>
> Eric Biggers (7):
>   mptcp: use SHA256_BLOCK_SIZE, not SHA_MESSAGE_BYTES
>   crypto: powerpc/sha1 - remove unused temporary workspace
>   crypto: powerpc/sha1 - prefix the "sha1_" functions
>   crypto: s390/sha1 - prefix the "sha1_" functions
>   crypto: lib/sha1 - rename "sha" to "sha1"
>   crypto: lib/sha1 - remove unnecessary includes of linux/cryptohash.h
>   crypto: lib/sha1 - fold linux/cryptohash.h into crypto/sha.h
>

For the series,

Acked-by: Ard Biesheuvel <ardb@kernel.org>

>  Documentation/security/siphash.rst          |  2 +-
>  arch/arm/crypto/sha1_glue.c                 |  1 -
>  arch/arm/crypto/sha1_neon_glue.c            |  1 -
>  arch/arm/crypto/sha256_glue.c               |  1 -
>  arch/arm/crypto/sha256_neon_glue.c          |  1 -
>  arch/arm/kernel/armksyms.c                  |  1 -
>  arch/arm64/crypto/sha256-glue.c             |  1 -
>  arch/arm64/crypto/sha512-glue.c             |  1 -
>  arch/microblaze/kernel/microblaze_ksyms.c   |  1 -
>  arch/mips/cavium-octeon/crypto/octeon-md5.c |  1 -
>  arch/powerpc/crypto/md5-glue.c              |  1 -
>  arch/powerpc/crypto/sha1-spe-glue.c         |  1 -
>  arch/powerpc/crypto/sha1.c                  | 33 ++++++++++-----------
>  arch/powerpc/crypto/sha256-spe-glue.c       |  1 -
>  arch/s390/crypto/sha1_s390.c                | 12 ++++----
>  arch/sparc/crypto/md5_glue.c                |  1 -
>  arch/sparc/crypto/sha1_glue.c               |  1 -
>  arch/sparc/crypto/sha256_glue.c             |  1 -
>  arch/sparc/crypto/sha512_glue.c             |  1 -
>  arch/unicore32/kernel/ksyms.c               |  1 -
>  arch/x86/crypto/sha1_ssse3_glue.c           |  1 -
>  arch/x86/crypto/sha256_ssse3_glue.c         |  1 -
>  arch/x86/crypto/sha512_ssse3_glue.c         |  1 -
>  crypto/sha1_generic.c                       |  5 ++--
>  drivers/char/random.c                       |  8 ++---
>  drivers/crypto/atmel-sha.c                  |  1 -
>  drivers/crypto/chelsio/chcr_algo.c          |  1 -
>  drivers/crypto/chelsio/chcr_ipsec.c         |  1 -
>  drivers/crypto/omap-sham.c                  |  1 -
>  fs/f2fs/hash.c                              |  1 -
>  include/crypto/sha.h                        | 10 +++++++
>  include/linux/cryptohash.h                  | 14 ---------
>  include/linux/filter.h                      |  4 +--
>  include/net/tcp.h                           |  1 -
>  kernel/bpf/core.c                           | 18 +++++------
>  lib/crypto/chacha.c                         |  1 -
>  lib/sha1.c                                  | 24 ++++++++-------
>  net/core/secure_seq.c                       |  1 -
>  net/ipv6/addrconf.c                         | 10 +++----
>  net/ipv6/seg6_hmac.c                        |  1 -
>  net/mptcp/crypto.c                          |  4 +--
>  41 files changed, 69 insertions(+), 104 deletions(-)
>  delete mode 100644 include/linux/cryptohash.h
>
>
> base-commit: 12b3cf9093542d9f752a4968815ece836159013f
> --
> 2.26.2
>
