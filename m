From: Valentin Rothberg <valentinrothberg@gmail.com>
Subject: Re: crypto: broken Kconfig option CRYPTO_NULL2
Date: Wed, 19 Aug 2015 09:58:07 +0200
Message-ID: <CAD3Xx4JqtJo=-KaO2F3po0AsjrNCRDM97GRrAZ2nnS2QFFu4QQ@mail.gmail.com>
References: <CAD3Xx4+R3f1H1vpRRcMEMfwMF-b7jggYhbk=V7JFg_=ujr-E+A@mail.gmail.com>
 <20150819075258.GA17628@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
	Andreas Ruprecht <andreas.ruprecht@fau.de>,
	hengelein Stefan <stefan.hengelein@fau.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38166 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbbHSH6h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Aug 2015 03:58:37 -0400
In-Reply-To: <20150819075258.GA17628@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 19, 2015 at 9:52 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Aug 19, 2015 at 09:49:37AM +0200, Valentin Rothberg wrote:
>>
>> your commit 149a39717dcc ("crypto: aead - Add type-safe geniv
>> init/exit helpers") has shown up in Linux next (i.e., next-20150818)
>> adding the following lines of code to crypto/Kconfig:
>
> Thanks but this was fixed two days ago.

Oups!  Sorry for the noise.  I obviously missed resetting my HEAD
before checking the report.

Kind regards,
 Valentin

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
