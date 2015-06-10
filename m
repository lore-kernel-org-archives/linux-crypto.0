From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH] crypto/drbg: report backend_cra_name when allocation
 fails
Date: Thu, 11 Jun 2015 08:38:06 +0900
Message-ID: <20150610233806.GA499@swordfish>
References: <1433942868-16447-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1433942868-16447-2-git-send-email-sergey.senozhatsky@gmail.com>
 <4705999.2gbf3TdHYZ@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	sergey.senozhatsky.work@gmail.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f193.google.com ([209.85.192.193]:33895 "EHLO
	mail-pd0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbbFJXhk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 19:37:40 -0400
Content-Disposition: inline
In-Reply-To: <4705999.2gbf3TdHYZ@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (06/10/15 17:09), Stephan Mueller wrote:
> Hi Sergey,
> 
> >Be more verbose and also report ->backend_cra_name when
> >crypto_alloc_shash() or crypto_alloc_cipher() fail in
> >drbg_init_hash_kernel() or drbg_init_sym_kernel()
> >correspondingly.
> >
> >Example
> > DRBG: could not allocate digest TFM handle: hmac(sha256)
> >
> >Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> Headscratch -- the Kconfig should have HMAC selected for compilation. When 
> HMAC is available (regardless whether it is a module or not), it is pulled in 
> by the kernel crypto API. Thus, there should not have been the error that HMAC 
> is missing.
> 
> Can you send your .config file, please?
> 

Hi Stephan,

sure, will post it later (as soon as I get back to my laptop).

	-ss
