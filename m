From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Userland crypto api test cases and test programs?
Date: Fri, 25 Mar 2016 12:53:58 +0100
Message-ID: <81054680.8Q3YMCGLnO@positron.chronox.de>
References: <CAH8yC8kBn6kiowfPxjxMcOT+u2t5434LL6ia6KzhRzB6C9+Fng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33518 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbcCYLyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Mar 2016 07:54:01 -0400
In-Reply-To: <CAH8yC8kBn6kiowfPxjxMcOT+u2t5434LL6ia6KzhRzB6C9+Fng@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 25. M=E4rz 2016, 04:49:55 schrieb Jeffrey Walton:

Hi Jeffrey,

> Hi Everyone,
>=20
> I've been doing some testing of OpenSSL's upcoming 1.1.0. OpenSSL
> includes an Engine wrapper for the userland crypto exposed through th=
e
> kernel's AF_ALG socket domain.
>=20
> The upcoming code experiences somewhat unexplained failures on
> occasion. I think its partly related to the asynchronous ciphers. For
> example, trying to set the key for a skcipher results in EBUSY (devic=
e
> or resource busy).
>=20
> I'd like to examine the kernel's test cases and test programs to see
> how things are intended to be operated. However, searching the
> archives is not turning up much for past messages about it. For
> example, 0 hits for "asynchronous socket tests"
> (https://www.mail-archive.com/search?q=3Dasynchronous+socket+tests&l=3D=
linux-cry
> pto%40vger.kernel.org).
>=20
> Where can I find the kernel's test cases and test programs used for
> userland crypto api?

See https://github.com/tstruk/afalg_async_test
>=20
> Thanks you in advance.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypt=
o" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
