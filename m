Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0DBCDB465
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Oct 2023 00:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbjJLAiW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 20:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbjJLAiW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 20:38:22 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CE598
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 17:38:19 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qqjiL-006C8R-Q5; Thu, 12 Oct 2023 08:38:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Oct 2023 08:38:14 +0800
Date:   Thu, 12 Oct 2023 08:38:14 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Denis Kenzior <denkenz@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        James Prestwood <prestwoj@gmail.com>
Subject: Re: Linux 6.5 broke iwd
Message-ID: <ZSc/9nUuF/d24iO6@gondor.apana.org.au>
References: <ab4d8025-a4cc-48c6-a6f0-1139e942e1db@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab4d8025-a4cc-48c6-a6f0-1139e942e1db@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 11, 2023 at 12:11:57PM -0500, Denis Kenzior wrote:
> Hi Herbert,
> 
> Looks like something in Linux 6.5 broke ell TLS unit tests (and thus likely
> WPA-Enterprise support).  I tried a git bisect and could narrow it down to a
> general area.  The last good commit was:
> 
> commit 6cb8815f41a966b217c0d9826c592254d72dcc31
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Thu Jun 15 18:28:48 2023 +0800
> 
>     crypto: sig - Add interface for sign/verify
> 
>     Split out the sign/verify functionality from the existing akcipher
>     interface.  Most algorithms in akcipher either support encryption
>     and decryption, or signing and verify.  Only one supports both.
> 
>     As a signature algorithm may not support encryption at all, these
>     two should be spearated.
> 
>     For now sig is simply a wrapper around akcipher as all algorithms
>     remain unchanged.  This is a first step and allows users to start
>     allocating sig instead of akcipher.
> 
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Narrowing down further didn't work due to:
> /usr/bin/ld: crypto/asymmetric_keys/x509_public_key.o: in function
> `x509_get_sig_params':
> x509_public_key.c:(.text+0x363): undefined reference to `sm2_compute_z_digest'
> collect2: error: ld returned 1 exit status

This looks like a Kconfig issue.  Please send me your .config file.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
