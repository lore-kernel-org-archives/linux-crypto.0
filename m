From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v5 1/2] crypto: skcipher AF_ALG - overhaul memory management
Date: Sun, 19 Mar 2017 05:34:17 +0100
Message-ID: <10084414.H7YYMriRbE@positron.chronox.de>
References: <2523592.mde6d2a8Lg@positron.chronox.de> <1797510.JnIj36BbdJ@tauon.atsec.com> <20170316095248.GA11996@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58130 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751186AbdCSEed (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Mar 2017 00:34:33 -0400
In-Reply-To: <20170316095248.GA11996@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 16. März 2017, 10:52:48 CET schrieb Herbert Xu:

Hi Herbert,
> 
> First of all you're only limiting the amount of memory occupied
> by the SG list which is not the same thing as the memory pinned
> down by the actual recvmsg.

When considering af_alg_make_sg, the function iov_iter_get_pages is used to 
obtain the user space pages for recvmsg. When looking closely at that 
function, I would understand that the user space pages are pinned into memory 
and made accessible from kernel space. That said, I would infer from the code 
that no kernel-local memory is allocated for the real data. Similar to zero-
copy, pages are shared between kernel and user that will hold the crypto 
operation result (ciphertext for enc or plaintext for dec).

Therefore, I would infer that the memory usage of the discussed code is 
limited to the skcipher_rsgl meta data which is limited by sock_kmalloc. This 
finally would imply that the kernel will not occupy more memory than allocated 
by sock_kmalloc.

Or am I missing something?

Thanks
Stephan
