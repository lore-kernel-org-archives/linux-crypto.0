From: sri sowj <srisowj4linux@gmail.com>
Subject: Re: communicating from the user space
Date: Mon, 23 Feb 2015 21:17:31 +0530
Message-ID: <CAHTT9VLy4zJd6D7g4eVvwZD1KTHkDDUA0ma=kVQVZ2FzD5bJGw@mail.gmail.com>
References: <CAHTT9VLmj8A7V5t+P9Zc02r5nyv37VMfa=QwPOuiMS9WFdXUxg@mail.gmail.com>
	<1543956.4M98jElNTF@tachyon.chronox.de>
	<CAHTT9VKQ2nB92SgRsGYemgTO6tTDucKyOs-9uCQn9+vAweQwuQ@mail.gmail.com>
	<1989293.ccvZM8v2KA@tachyon.chronox.de>
	<1424640392.22199.3.camel@gnutls.org>
	<CAHTT9VLJH4RFXBmGUeLSiiYjsvytb10NT+DyPeBkceVzuq3uRQ@mail.gmail.com>
	<CAJU7zaL8r+vbhPY3NU-6tUKcFJS_vMHr2fVci+hAquXynBdP3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephan Mueller <smueller@chronox.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46906 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbbBWPrc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Feb 2015 10:47:32 -0500
Received: by pabkx10 with SMTP id kx10so28327586pab.13
        for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2015 07:47:31 -0800 (PST)
In-Reply-To: <CAJU7zaL8r+vbhPY3NU-6tUKcFJS_vMHr2fVci+hAquXynBdP3g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Nikos,

Thanks a lot for the information provided on openssl part for cryptodev=
-linux.

I have followed the steps mentioned in "
https://github.com/cryptodev-linux/cryptodev-linux/blob/master/INSTALL
"

But When I executed " make check" command I got following error,please
can you help me with this.

cc  -I..    -c -o cipher_comp.o cipher_comp.c
cc  -I..    -c -o openssl_wrapper.o openssl_wrapper.c
openssl_wrapper.c: In function =E2=80=98openssl_hmac=E2=80=99:
openssl_wrapper.c:136:5: error: invalid use of void expression
openssl_wrapper.c:144:3: error: invalid use of void expression
openssl_wrapper.c:152:3: error: invalid use of void expression
make[1]: *** [openssl_wrapper.o] Error 1
make[1]: Leaving directory `/home/srisowj/cryptodev/cryptodev-linux-1.6=
/tests'
make: *** [check] Error 2

BR,
& Srisowj

On Mon, Feb 23, 2015 at 1:57 PM, Nikos Mavrogiannopoulos
<nmav@gnutls.org> wrote:
> On Mon, Feb 23, 2015 at 5:06 AM, sri sowj <srisowj4linux@gmail.com> w=
rote:
>> Hi Nikos,
>>
>> Please can you let me know my understanding regarding openssl and
>> crypto are correct?
>> I have mentioned my understanding in my earlier posts,but let me
>> mention it here again.
>> I want to interact with Crypto Hardware from user space using openss=
l
>> like libraries based applications through cryptodev-linux interface.
>> it looks like openssl comes with cryptodev-linux support(through
>> eng_cryptodev.c) .
>> When I downloaded openssl,eng_cryptodev.c file is available by defau=
lt.
>> below link refers about eng_cryptodev.c for openssl support :
>> http://repo.or.cz/w/cryptodev-linux.git/commitdiff/56cc4e3b8b761cb34=
f928f4eee59755d1f0afc53
>
> That's a very old link. Note that openssl's cryptodev support works
> well for ciphers, but not for digests (hashes). So the best is to
> compile without digest support, or use the patches in
> https://github.com/openssl/openssl/pull/191
>
> The most current instructions are:
> https://github.com/cryptodev-linux/cryptodev-linux/blob/master/INSTAL=
L
> and in https://github.com/cryptodev-linux/cryptodev-linux
>
> regards,
> Nikos
