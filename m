From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Test AEAD/authenc algorithms from userspace
Date: Wed, 21 Dec 2016 16:54:29 +0800
Message-ID: <20161221085429.GB29501@gondor.apana.org.au>
References: <CAFXBA=kStufh3TDe=+qQYmd2tNCj9hgXLUKBeoZHBs2VxRBRbQ@mail.gmail.com>
 <2943969.IiWKeGvEyD@tauon.atsec.com>
 <CAFXBA=ma8ZKeFfu-_DS1Nm=k0pwUatSabCmhwwwBMg45epOo_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45071 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755985AbcLURAE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Dec 2016 12:00:04 -0500
Content-Disposition: inline
In-Reply-To: <CAFXBA=ma8ZKeFfu-_DS1Nm=k0pwUatSabCmhwwwBMg45epOo_g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 19, 2016 at 04:08:11PM +0530, Harsh Jain wrote:
> Hi Herbert,
> 
> TLS default mode of operation is MAC-then-Encrypt for Authenc algos.
> Currently framework only supports EtM used in IPSec. User space
> programs like openssl cannot use af-alg interface to encrypt/decrypt
> in TLS mode.
> Are we going to support Mac-then-Encrypt mode in future kernel releases?

If someone finally adds TLS to the kernel then we'll likely do
something about it.  Otherwise you can just separate it out into
two operations via af-alg.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
