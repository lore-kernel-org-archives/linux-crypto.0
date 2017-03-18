From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [ANNOUNCE] /dev/random - a new approach (code for 4.11-rc1)
Date: Sat, 18 Mar 2017 09:18:17 +0100
Message-ID: <17325553.qTOCmu80z1@positron.chronox.de>
References: <2785457.pDyvZpZC2q@positron.chronox.de> <CAHmME9oopUxc3fdRERdhHk=GYJuqAonhRBhmyUQE81fPdLn9Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58100 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750990AbdCRITQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Mar 2017 04:19:16 -0400
In-Reply-To: <CAHmME9oopUxc3fdRERdhHk=GYJuqAonhRBhmyUQE81fPdLn9Zw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 17. März 2017, 16:31:29 CET schrieb Jason A. Donenfeld:

Hi Jason,

> Hey Stephan,
> 
> Have you considered submitting this without so many options? For
> example -- just unconditionally using ChaCha20 instead of the
> configurable crypto API functions? And either removing the FIPS140
> compliance code, and either unconditionally including it, or just
> getting rid of it? And finally just making this a part of the kernel
> directly, instead of adding this as a standalone optional component?

Submitting that with various options removed is no problem as the core concept 
of my implementation is to be flexible to allow folks to easily add new noise 
sources or a DRNG replacement.

Yet, there are reasons for the different options:

- some folks want to use a known good and proven DRNG for post-processing 
(hence the offer for using an SP800-90A DRBG)

- some folks want a DRNG that is not tied to the kernel crypto API (hence the 
offer for the ChaCha20 DRNG)

- some folks need the FIPS continuous self test and some do not.

The idea for the solution in the LRNG code is that a user shall not be 
involved with these compile-time decisions. All options that are present are 
based on other kernel configuration options:

- if the kernel crypto API is present and the SP800-90A DRBG is compiled, then 
the LRNG uses the SP800-90A DRBG

- as a user may compile in different types of the SP800-90A DRBG, the LRNG 
will use the one that is available

- if no kernel crypto API is compiled, it uses the ChaCha20 DRNG

- if FIPS support is not compiled, the FIPS continuous test is not compiled

Thus, a user does not get in touch with all the options in the LRNG code. 
Shouldn't that be a good argument to keep these options?

I would like to add the LRNG code directly to the kernel and I can offer an 
official patch instead of such out-of-tree code. However, in the past I got 
shot down when I suggested an inclusion.

Ciao
Stephan
