From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [CRYPTO] cast6: inline bloat--
Date: Sat, 12 Jan 2008 11:57:42 +1100
Message-ID: <20080112005742.GA898@gondor.apana.org.au>
References: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi> <p73ve62nzzk.fsf@bingen.suse.de> <Pine.LNX.4.64.0801101114070.1408@kivilampi-30.cs.helsinki.fi> <20080110092555.GB25076@one.firstfloor.org> <20080110092746.GA11613@gondor.apana.org.au> <20080110133529.GA13851@Chamillionaire.breakpoint.cc> <20080110154650.GA29453@one.firstfloor.org> <20080112000937.GA23721@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andi Kleen <andi@firstfloor.org>,
	Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2234 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762787AbYALA5y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jan 2008 19:57:54 -0500
Content-Disposition: inline
In-Reply-To: <20080112000937.GA23721@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 12, 2008 at 01:09:37AM +0100, Sebastian Siewior wrote:
> 
> Long story short, according to this numbers I'm all for the not inline
> version.

Thanks for following this through!

> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 1ab8c01..a935abc 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -1705,6 +1705,12 @@ static void do_test(void)
>                 test_cipher_speed("salsa20", ENCRYPT, sec, NULL, 0,
>                                   salsa20_speed_template);
>                 break;
> +       case 207:
> +               test_cipher_speed("ecb(cast6)", ENCRYPT, sec, NULL, 0,
> +                               camellia_speed_template);
> +               test_cipher_speed("ecb(cast6)", DECRYPT, sec, NULL, 0,
> +                               camellia_speed_template);
> +               break;

Perhaps we should make a generic speed template that works for all
ciphers?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
