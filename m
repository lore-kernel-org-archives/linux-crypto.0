From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 0/6] Add support for ECDSA algorithm
Date: Mon, 06 Feb 2017 15:47:36 +0100
Message-ID: <2138507.SpNuf2QKdB@tauon.atsec.com>
References: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com> <113d3ef8-ef34-0651-71e7-be09ef55727e@nvidia.com> <20170202135721.GA5289@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Nitin Kumbhar <nkumbhar@nvidia.com>, davem@davemloft.net,
        linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55770 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754302AbdBFOro (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Feb 2017 09:47:44 -0500
In-Reply-To: <20170202135721.GA5289@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 2. Februar 2017, 21:57:21 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Jan 26, 2017 at 11:30:04AM +0530, Nitin Kumbhar wrote:
> > This ECDSA implementation is analogous to the RSA kernel implementation
> > for
> > signature generation / verification. It extends ECC family of algorithms
> > like ECDH to support signature verification using akcipher. This will be
> > used in a way similar to RSA.
> 
> Yes but RSA had an in-kernel user in the form of module signature
> verification.  We don't add algorithms to the kernel without
> actual users.  So this patch-set needs to come with an actual
> in-kernel user of ECDSA.

If I understood correctly, the crypto API should also provide device drivers 
for cryptographic accelerators to user space. This would be of special 
importance for asymmetric ciphers considering their resource intense 
operation.

As for each HW implementation there should be a SW fallback, shouldn't ECDSA 
therefore be added?

Please note that I am currently updating algif_akcipher to be en-par with 
algif_skcipher and algif_aead, including an AIO operation.

Ciao
Stephan
