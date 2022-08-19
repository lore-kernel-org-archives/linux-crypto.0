Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62CDC32771
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Aug 2022 11:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348610AbiHSLGO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Aug 2022 07:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348611AbiHSLFy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2022 07:05:54 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D75FEC43
        for <linux-crypto@vger.kernel.org>; Fri, 19 Aug 2022 04:05:24 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oOzoT-00Cpoy-PF; Fri, 19 Aug 2022 21:05:18 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Aug 2022 19:05:17 +0800
Date:   Fri, 19 Aug 2022 19:05:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Robert Elliott <elliott@hpe.com>
Cc:     tim.c.chen@linux.intel.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, toshi.kani@hpe.com,
        rwright@hpe.com, elliott@hpe.com
Subject: Re: [PATCH] crypto: x86/sha512 - load based on CPU features
Message-ID: <Yv9ubekvQiL3UGwd@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220813230431.2666-1-elliott@hpe.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Robert Elliott <elliott@hpe.com> wrote:
> x86 optimized crypto modules built as modules rather than built-in
> to the kernel end up as .ko files in the filesystem, e.g., in
> /usr/lib/modules. If the filesystem itself is a module, these might
> not be available when the crypto API is initialized, resulting in
> the generic implementation being used (e.g., sha512_transform rather
> than sha512_transform_avx2).
> 
> In one test case, CPU utilization in the sha512 function dropped
> from 15.34% to 7.18% after forcing loading of the optimized module.
> 
> Add module aliases for this x86 optimized crypto module based on CPU
> feature bits so udev gets a chance to load them later in the boot
> process when the filesystems are all running.
> 
> Signed-off-by: Robert Elliott <elliott@hpe.com>
> ---
> arch/x86/crypto/sha512_ssse3_glue.c | 10 ++++++++++
> 1 file changed, 10 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
