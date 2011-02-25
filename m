From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2.6.37.2 1/1] crypto: Uninitialized variable fix.
Date: Fri, 25 Feb 2011 10:09:55 -0800
Message-ID: <20110225180955.GA22156@suse.de>
References: <4D67EDC4.3020103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Atul Sowani <sowani@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299Ab1BYSKS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Feb 2011 13:10:18 -0500
Content-Disposition: inline
In-Reply-To: <4D67EDC4.3020103@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 25, 2011 at 11:28:28PM +0530, Atul Sowani wrote:
> Array inter[4] was uninitialized in anubis_crypt() and was causing
> compiler warning. Added the array initialization.
> 
> Signed-off-by: Atul Sowani <sowani@gmail.com>
> ---
> 
> diff a/crypto/anubis.c b/crypto/anubis.c
> --- a/crypto/anubis.c   2011-02-25 04:39:00.000000000 +0530
> +++ b/crypto/anubis.c   2011-02-25 23:07:12.000000000 +0530
> @@ -578,7 +578,7 @@ static void anubis_crypt(u32 roundKey[AN
>         __be32 *dst = (__be32 *)ciphertext;
>         int i, r;
>         u32 state[4];
> -       u32 inter[4];
> +       u32 inter[4] = { 0, 0, 0, 0 };

That's nice, it looks like a bug in the compiler, preinitializing this
variable doesn't fix any real bug.

sorry,

greg k-h
