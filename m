Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C366EC7EE25
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Jun 2023 03:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbjFJDMx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 23:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbjFJDMv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 23:12:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E243ABE
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 20:12:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6341B614D7
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2023 03:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1C3C433D2;
        Sat, 10 Jun 2023 03:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686366769;
        bh=hDgLUE58CZZjcWdU0alB/OfGbFD3iQcCVZ+s4WpqbKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HR6smhS+7xGAHZ6JeM3IT2St3Zr1PLhxsRTIU+dhPCN38GBpqjXznAj5JaaaTFued
         /2M6BmTKKSrnqB1+cZchlLE5rnM0iJb8CcYYOjdZ/trhdlFqBXaTB54qZ7sse1kiAf
         aKdRIcOJi2K8pzqoWGpPvh79NDTsXVeoraMD6GN7j6pzqQ4M1SOhCFgVEZzLkIMhkN
         BjIJSjGEzWyQCkulyNKjjPzeV57XfcMBKm5o5Q0HEcb6jF5VTtgSt1znopdxo4mjJF
         grG01WEkdDpwWnJurMBfrY3AnDkouWcGMtK/L3OKDYG2Q+ptCGLM1KJVb9Fv+0Jig8
         c3hfLhmUsK+tQ==
Date:   Fri, 9 Jun 2023 20:12:48 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH 0/3] crypto - some SPDX cleanups for arch code
Message-ID: <20230610031248.GC872@sol.localdomain>
References: <20230606173127.4050254-1-ardb@kernel.org>
 <20230607043730.GB941@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607043730.GB941@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 06, 2023 at 09:37:30PM -0700, Eric Biggers wrote:
> On Tue, Jun 06, 2023 at 07:31:24PM +0200, Ard Biesheuvel wrote:
> > Some SPDX cleanups for the arch crypto code on ARM, arm64 and x86
> > 
> > Ard Biesheuvel (3):
> >   crypto: arm64 - add some missing SPDX headers
> >   crypto: arm - add some missing SPDX headers
> >   crypto: x86 - add some missing SPDX headers
> > 
> >  arch/arm/crypto/chacha-neon-core.S          | 10 +----
> >  arch/arm/crypto/crc32-ce-core.S             | 30 ++-----------
> >  arch/arm/crypto/crct10dif-ce-core.S         | 40 +----------------
> >  arch/arm64/crypto/chacha-neon-core.S        | 10 +----
> >  arch/arm64/crypto/chacha-neon-glue.c        | 10 +----
> >  arch/arm64/crypto/crct10dif-ce-core.S       | 40 +----------------
> >  arch/x86/crypto/aesni-intel_avx-x86_64.S    | 36 +--------------
> >  arch/x86/crypto/camellia-aesni-avx-asm_64.S |  7 +--
> >  arch/x86/crypto/crc32-pclmul_glue.c         | 24 +---------
> >  arch/x86/crypto/crc32c-pcl-intel-asm_64.S   | 29 +-----------
> >  arch/x86/crypto/crct10dif-pcl-asm_64.S      | 36 +--------------
> >  arch/x86/crypto/crct10dif-pclmul_glue.c     | 16 +------
> >  arch/x86/crypto/sha1_avx2_x86_64_asm.S      | 46 +-------------------
> >  arch/x86/crypto/sha1_ni_asm.S               | 46 +-------------------
> >  arch/x86/crypto/sha256-avx-asm.S            | 28 +-----------
> >  arch/x86/crypto/sha256-avx2-asm.S           | 29 +-----------
> >  arch/x86/crypto/sha256-ssse3-asm.S          | 29 +-----------
> >  arch/x86/crypto/sha256_ni_asm.S             | 46 +-------------------
> >  arch/x86/crypto/sha256_ssse3_glue.c         | 15 +------
> >  arch/x86/crypto/sha512-avx-asm.S            | 29 +-----------
> >  arch/x86/crypto/sha512-avx2-asm.S           | 29 +-----------
> >  arch/x86/crypto/sha512-ssse3-asm.S          | 29 +-----------
> >  arch/x86/crypto/sha512_ssse3_glue.c         | 16 +------
> >  arch/x86/crypto/twofish_glue.c              | 16 +------
> >  24 files changed, 26 insertions(+), 620 deletions(-)
> 
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> 

Actually, given the discussion on the other thread
https://lore.kernel.org/r/20230607053940.39078-10-bagasdotme@gmail.com, maybe it
would be best to hold off on this for now?  Or at least split this series into
more patches, such that each patch does only one "type" of SPDX replacement.

I still think these conversions are probably fine, but some points that perhaps
need an explicit explanation are:

* Using GPL-2.0-only for files like chacha-neon-core.S whose file header says
  GPL v2, but also says GPL v2 or later.

* Replacing with SPDX on files that explicitly say "DO NOT ALTER OR REMOVE
  COPYRIGHT NOTICES OR THIS FILE HEADER."

* Using BSD-3-Clause when the license text in the file header has the copyright
  holder name instead of "copyright holder", thus making it not an exact
  word-for-word match with LICENSES/preferred/BSD-3-Clause.  (It seems there are
  specific rules for variations that have been approved, e.g. see
  https://github.com/spdx/license-list-XML/blob/main/src/BSD-3-Clause.xml and
  https://spdx.github.io/spdx-spec/v2.2.2/license-matching-guidelines-and-templates)

* Using "GPL-2.0-only OR BSD-3-Clause" for the two crct10dif-ce-core.S files.
  They have an unusual file header, and it could be argued that some
  contributions to those files were intended to be licensed under GPL-2.0-only.
  FWIW, I am fine with either license for my contributions to those files.

- Eric
