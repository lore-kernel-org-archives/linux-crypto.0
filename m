From: Stephan Mueller <smueller@chronox.de>
Subject: Re: tcrypt.ko module usage
Date: Sun, 08 Mar 2015 11:24:34 +0100
Message-ID: <3784222.mDI2Uyy5JW@tachyon.chronox.de>
References: <CAHTT9VK5+AEGv1nbi5des3coux=6cW1Qukr4Zzep0QzYj0XJCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: sri sowj <srisowj4linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:45952 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbbCHKYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Mar 2015 06:24:36 -0400
In-Reply-To: <CAHTT9VK5+AEGv1nbi5des3coux=6cW1Qukr4Zzep0QzYj0XJCQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 8. M=E4rz 2015, 14:32:53 schrieb sri sowj:

Hi sri,

> HI All,
>=20
>=20
> As I understand tcrypt.ko module purpose is to test different crypto
> algorithm from the kenrel space. Please can some one help me with
> below queries to understand tcrypt use cases.
>=20
> #1:If one need to test crypto algorithms with under laying crypto
> Hardware engine  using tcrypto module ,is there any method or
> procedure needs to be followed to hook crypto hardware engine with
> tcrypt module?
>=20
> As per my understanding its very much straight forward,like if i need
> to test aes algorithm then it will be some thing like  "insmod
> tcrypt.ko mode =3D 10"

That works if you ensured that your implementation has the highest prio=
rity of=20
all implementations marked with the cipher names listed in case 10 (as =
per=20
your example):

        case 10:
                ret +=3D tcrypt_test("ecb(aes)");
                ret +=3D tcrypt_test("cbc(aes)");
                ret +=3D tcrypt_test("lrw(aes)");
                ret +=3D tcrypt_test("xts(aes)");
                ret +=3D tcrypt_test("ctr(aes)");
                ret +=3D tcrypt_test("rfc3686(ctr(aes))");
                break;

>=20
> #2: Is there any way to test tcrypt module for some scenarios like
>        2.a:concurrency scenario where multiple processes/threads try
> to send a request for same algorithm

This is not implemented with tcrypt. But you can either expand tcrypt,=20
implement your own test, test it from user space with the speed test pr=
ovided=20
in [1] or use another implementation of the speed test that may easy be=
=20
expanded [2].

[1] http://www.chronox.de/libkcapi.html
[2] https://www.eperm.de/cryptoperf.html

>        2.b:multiple requests with a same tfm object

dto

>        2.c:back logged message scenarios like multiple methods will b=
e
> sent for processing while crypto engine is serving a request from sam=
e
> tfm object

dto
>=20
> #3:Is there any significance with
> "CONFIG_CRYPTO_MANAGER_DISABLE_TESTS" Flag? ,Because when I disable
> this flags I observed that tcrypt module
> fails with a message like "Failed to load transform for cbc(aes): -2"

This flag relates to the testmgr.c which implements known answer tests=20
executed at the time a cipher implementation is registered.
>=20
>=20
> BR,
> Srisowj
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypt=
o" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Ciao
Stephan
