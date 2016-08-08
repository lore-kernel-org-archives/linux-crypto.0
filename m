From: Stephan Mueller <smueller@chronox.de>
Subject: Re: AF_ALG broken?
Date: Mon, 08 Aug 2016 20:18:32 +0200
Message-ID: <5469036.jmYhrDdAzD@positron.chronox.de>
References: <20160808164427.GB1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34238 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbcHHSSk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 14:18:40 -0400
In-Reply-To: <20160808164427.GB1041@n2100.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 8. August 2016, 17:44:27 CEST schrieb Russell King - ARM Linux:

Hi Russell,

> Hi,
> 
> When trying to use the openssl AF_ALG module with 4.8-rc1 with imx
> caam, I get this:
> 
> $ OPENSSL_CONF=/shared/crypto/openssl-imx.cnf strace openssl dgst -md5
> </bin/bash ...
> socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
> close(3)                                = 0
> socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
> bind(3, {sa_family=AF_ALG, sa_data="hash\0\0\0\0\0\0\0\0\0\0"}, 88) = 0
> accept(3, 0, NULL)                      = 4
> fstat64(0, {st_mode=S_IFREG|0755, st_size=666864, ...}) = 0
> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
> 0xb6fab000 read(0,
> "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\2\0(\0\1\0\0\0\21'\2\0004\0\0\0"..., 8192)
> = 8192 send(4,
> "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\2\0(\0\1\0\0\0\21'\2\0004\0\0\0"..., 8192,
> MSG_MORE) = -1 ENOKEY (Required key not available)
> 
> This used to work, so something in the kernel AF_ALG API has changed
> which has broken userspace.  Any ideas what's up, or where to look?

This seems to be the the change added by Herbert to fix a security issue. This 
caused a similar stirr in the cryptsetup user space tool.

I guess you are affected by 6de62f15b581f920ade22d758f4c338311c2f0d4


Ciao
Stephan
