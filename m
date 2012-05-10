From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: CRYPTO_ALG_ASYNC
Date: Thu, 10 May 2012 12:33:40 +0300
Message-ID: <CALLzPKYc0wBtTiNtDGgY09D_7MJPtwBoQ1AS_U-Jsg02+hEPOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757881Ab2EJJdl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 May 2012 05:33:41 -0400
Received: by pbbro8 with SMTP id ro8so5771332pbb.25
        for <linux-crypto@vger.kernel.org>; Thu, 10 May 2012 02:33:40 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert,

CRYPTO_ALG_ASYNC is heavily used like:

    crypto_alloc_shash(hash_alg, 0, CRYPTO_ALG_ASYNC);
or
   .cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
   .cra_flags = CRYPTO_ALG_TYPE_AHASH |  CRYPTO_ALG_ASYNC,

I see that only place where it is tested is in
ablockcipher.c:crypto_default_geniv()

What is actually meaning of that?

and setting it for hash??

Thanks,
Dmitry
