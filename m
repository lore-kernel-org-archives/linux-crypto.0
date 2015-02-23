From: sri sowj <srisowj4linux@gmail.com>
Subject: Re: communicating from the user space
Date: Mon, 23 Feb 2015 09:36:22 +0530
Message-ID: <CAHTT9VLJH4RFXBmGUeLSiiYjsvytb10NT+DyPeBkceVzuq3uRQ@mail.gmail.com>
References: <CAHTT9VLmj8A7V5t+P9Zc02r5nyv37VMfa=QwPOuiMS9WFdXUxg@mail.gmail.com>
	<1543956.4M98jElNTF@tachyon.chronox.de>
	<CAHTT9VKQ2nB92SgRsGYemgTO6tTDucKyOs-9uCQn9+vAweQwuQ@mail.gmail.com>
	<1989293.ccvZM8v2KA@tachyon.chronox.de>
	<1424640392.22199.3.camel@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephan Mueller <smueller@chronox.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35644 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbbBWEGW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 22 Feb 2015 23:06:22 -0500
Received: by pdbfl12 with SMTP id fl12so22428298pdb.2
        for <linux-crypto@vger.kernel.org>; Sun, 22 Feb 2015 20:06:22 -0800 (PST)
In-Reply-To: <1424640392.22199.3.camel@gnutls.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Nikos,

Please can you let me know my understanding regarding openssl and
crypto are correct?
I have mentioned my understanding in my earlier posts,but let me
mention it here again.

I want to interact with Crypto Hardware from user space using openssl
like libraries based applications through cryptodev-linux interface.

it looks like openssl comes with cryptodev-linux support(through
eng_cryptodev.c) .
When I downloaded openssl,eng_cryptodev.c file is available by default.

below link refers about eng_cryptodev.c for openssl support :

http://repo.or.cz/w/cryptodev-linux.git/commitdiff/56cc4e3b8b761cb34f928f4eee59755d1f0afc53

Note:looks like there are some additional changes done on
eng_cryptodev.c file available in updated openssl source code.

There seems to be some changes/patches  also available recently for
cryptodev-linux,below contains reference information.

http://rt.openssl.org/Ticket/Display.html?id=2770&user=guest&pass=guest


Please let me know if my understanding is incorrect .

one more thing while compiling openssl with above mentioned changes I
faced compilation issues in linux ,Please can you also let me know
whether there are per-requisites like any dependent libraries or
installing cryptodev-linux on host/target machine before compiling
openssl etc?

BR,
Srisowj


On Mon, Feb 23, 2015 at 2:56 AM, Nikos Mavrogiannopoulos
<nmav@gnutls.org> wrote:
> On Sun, 2015-02-22 at 16:04 +0100, Stephan Mueller wrote:
>> Am Sonntag, 22. Februar 2015, 18:32:34 schrieb sri sowj:
>>
>> Hi sri,
>>
>> > Hi Stephen,
>> >
>> > It was a great information with respective PF_ALG , I have explored a
>> > bit on openssl and algorithms prospect , Please let me know if
>> > anything to add to it.
>> >
>> > openssl crypto engine:
>> >
>> > below are the steps to enable openssl to communicate using pf/af_alg.
>> >
>> > #1:git clone http://src.carnivore.it/users/common/af_alg/
>> Yes, that is it. But it is not fully efficient as it does not use vmsplice
>> where appropriate. So, libkcapi should be faster in several use cases.
>
> When would vmsplice be appropriate? As far as I understand vmsplice adds
> a cost on operations for small data, which is the majority of use cases
> in crypto. In the measurements I did for cryptodev-linux [0] vmsplice
> did improve performance only for more than 64k packets which is never
> the case with real world crypto (TLS has a maximum of 14k for example).
>
> regards,
> Nikos
>
> [0]. http://cryptodev-linux.org/comparison.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
