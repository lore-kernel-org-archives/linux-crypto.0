From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto/drbg: report backend_cra_name when allocation fails
Date: Wed, 10 Jun 2015 17:09:44 +0200
Message-ID: <4705999.2gbf3TdHYZ@tauon.atsec.com>
References: <1433942868-16447-1-git-send-email-sergey.senozhatsky@gmail.com> <1433942868-16447-2-git-send-email-sergey.senozhatsky@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	sergey.senozhatsky.work@gmail.com
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46197 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbbFJPJv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 11:09:51 -0400
In-Reply-To: <1433942868-16447-2-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Wednesday 10 June 2015, 22:27:48 schrieb Sergey Senozhatsky:

Hi Sergey,

>Be more verbose and also report ->backend_cra_name when
>crypto_alloc_shash() or crypto_alloc_cipher() fail in
>drbg_init_hash_kernel() or drbg_init_sym_kernel()
>correspondingly.
>
>Example
> DRBG: could not allocate digest TFM handle: hmac(sha256)
>
>Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Headscratch -- the Kconfig should have HMAC selected for compilation. When 
HMAC is available (regardless whether it is a module or not), it is pulled in 
by the kernel crypto API. Thus, there should not have been the error that HMAC 
is missing.

Can you send your .config file, please?

Ciao
Stephan
