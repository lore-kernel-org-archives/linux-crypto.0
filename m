From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: [PATCH 1/1] Added CRYPTO_ALG_KERN_DRIVER_ONLY flag (3rd attempt)
Date: Fri, 6 Jan 2012 10:02:08 +0100
Message-ID: <CAJU7zaJHVr-7XhbTz2yap6Am=-kRYbx+88fo2C3dvZFc8Vv3kg@mail.gmail.com>
References: <20120106013701.GA6484@gondor.apana.org.au>
	<4F06AE75.9050806@gnutls.org>
	<20120106082824.GA9152@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53385 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2AFJCL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jan 2012 04:02:11 -0500
Received: by wibhm6 with SMTP id hm6so923294wib.19
        for <linux-crypto@vger.kernel.org>; Fri, 06 Jan 2012 01:02:10 -0800 (PST)
In-Reply-To: <20120106082824.GA9152@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 6, 2012 at 9:28 AM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:

>> I needed this function in order to access the new flag without
>> relying on the structure format. The available crypto_tfm_alg_type()
>> would apply a mask and remove it, thus I added this function.
> Can you show me some example code so I can see how you intend
> to use it in userspace?

I intend to export the flag to use space as shown below. The idea is
to allow userspace libraries decide whether to use the acceleration
(i.e. if the CRYPTO_ALG_KERN_DRIVER_ONLY is not given they shouldn't
attempt to use the kernel algorithm).

How the flag is exported by cryptodev-linux:
http://repo.or.cz/w/cryptodev-linux.git/blob/aead:/ioctl.c#l716

An example of using it in userspace:
http://repo.or.cz/w/cryptodev-linux.git/blob/aead:/examples/aes.c#l43

regards,
Nikos
