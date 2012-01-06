From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: [PATCH 1/1] Added CRYPTO_ALG_KERN_DRIVER_ONLY flag (3rd attempt)
Date: Fri, 6 Jan 2012 10:29:22 +0100
Message-ID: <CAJU7zaL76J-856byTkLYh9HGqs7X3=XP3HyaiSAOcEJfVtSGuA@mail.gmail.com>
References: <20120106013701.GA6484@gondor.apana.org.au>
	<4F06AE75.9050806@gnutls.org>
	<20120106082824.GA9152@gondor.apana.org.au>
	<CAJU7zaJHVr-7XhbTz2yap6Am=-kRYbx+88fo2C3dvZFc8Vv3kg@mail.gmail.com>
	<20120106091206.GA9458@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45162 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab2AFJ3X (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jan 2012 04:29:23 -0500
Received: by wibhm6 with SMTP id hm6so934921wib.19
        for <linux-crypto@vger.kernel.org>; Fri, 06 Jan 2012 01:29:22 -0800 (PST)
In-Reply-To: <20120106091206.GA9458@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 6, 2012 at 10:12 AM, Herbert Xu
<herbert@gondor.hengli.com.au> wrote:

>> How the flag is exported by cryptodev-linux:
>> http://repo.or.cz/w/cryptodev-linux.git/blob/aead:/ioctl.c#l716
> Actually I was looking for code that uses crypto_tfm_alg_flags
> function.

The code above will use it once it is accepted. Now it accesses
directly the flags.

regards,
Nikos
