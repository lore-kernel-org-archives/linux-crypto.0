From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rsa - fix a potential race condition in build
Date: Mon, 5 Dec 2016 14:48:00 +0800
Message-ID: <20161205064800.GA9496@gondor.apana.org.au>
References: <1480722064-31714-1-git-send-email-yang.shi@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Yang Shi <yang.shi@windriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49883 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750841AbcLEGs1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Dec 2016 01:48:27 -0500
Content-Disposition: inline
In-Reply-To: <1480722064-31714-1-git-send-email-yang.shi@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 02, 2016 at 03:41:04PM -0800, Yang Shi wrote:
> When building kernel with RSA enabled with multithreaded, the below
> compile failure might be caught:
> 
> | /buildarea/kernel-source/crypto/rsa_helper.c:18:28: fatal error: rsapubkey-asn1.h: No such file or directory
> | #include "rsapubkey-asn1.h"
> | ^
> | compilation terminated.
> | CC crypto/rsa-pkcs1pad.o
> | CC crypto/algboss.o
> | CC crypto/testmgr.o
> | make[3]: *** [/buildarea/kernel-source/scripts/Makefile.build:289: crypto/rsa_helper.o] Error 1
> | make[3]: *** Waiting for unfinished jobs....
> | make[2]: *** [/buildarea/kernel-source/Makefile:969: crypto] Error 2
> | make[1]: *** [Makefile:150: sub-make] Error 2
> | make: *** [Makefile:24: __sub-make] Error 2
> 
> The header file is not generated before rsa_helper is compiled, so
> adding dependency to avoid such issue.
> 
> Signed-off-by: Yang Shi <yang.shi@windriver.com>

This should already be fixed in the latest crypto tree.  Could
you please double-check?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
