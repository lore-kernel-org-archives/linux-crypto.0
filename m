From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AF_ALG zero-size hash fails
Date: Tue, 9 Aug 2016 17:45:25 +0800
Message-ID: <20160809094525.GA6529@gondor.apana.org.au>
References: <20160809091834.GH1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: noloader@gmail.com, linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33029 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbcHIJpb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 05:45:31 -0400
Content-Disposition: inline
In-Reply-To: <20160809091834.GH1041@n2100.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 09, 2016 at 10:18:34AM +0100, Russell King - ARM Linux wrote:
> Hi,
> 
> While testing AF_ALG with openssl af-alg-rr, I've found that:
> 
> OPENSSL_CONF=/shared/crypto/openssl-imx.cnf openssl dgst -sha1 </dev/null
> 
> fails with a zero hash result:
> 
> socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
> close(3)                                = 0
> socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
> bind(3, {sa_family=AF_ALG, sa_data="hash\0\0\0\0\0\0\0\0\0\0"}, 88) = 0
> accept(3, 0, NULL)                      = 4
> fstat64(0, {st_mode=S_IFCHR|0666, st_rdev=makedev(1, 3), ...}) = 0
> ioctl(0, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 0xbed50d5c) = -1 ENOTTY (Inappropriate ioctl for device)
> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6fe4000
> read(0, "", 8192)                       = 0
> read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 20) = 20
> close(4)                                = 0
> close(3)                                = 0
> 
> tested with the Freescale CAAM driver with SHA1 and MD5 hashes, and
> the ARM SHA1 shash implementation.  Should there at least be a single
> write to the socket (of zero size) in this case, or should the kernel
> return the correct hash on the first read without a preceding
> write/send?

It's an oversight in the algif_hash code.  I'll get it fixed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
