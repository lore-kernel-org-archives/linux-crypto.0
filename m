From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: Parity Error on keys used for DES crypto test
Date: Thu, 24 Apr 2014 15:08:57 +0200
Message-ID: <53590CE9.7030607@c-s.fr>
References: <535777C0.9090000@c-s.fr> <20140423185813.c885f8de953ed216b8895437@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:21250 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbaDXNI7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Apr 2014 09:08:59 -0400
In-Reply-To: <20140423185813.c885f8de953ed216b8895437@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Le 24/04/2014 01:58, Kim Phillips a =E9crit :
> On Wed, 23 Apr 2014 10:20:16 +0200
> leroy christophe <christophe.leroy@c-s.fr> wrote:
>
>> I'm altering the Freescale Talitos Driver in order to support the SE=
C1
>> security engine, and I have a big issue with the DES test vectors in
>> testmgr.h:
>>
>> The Sec Engine reports key parity error.
>>
>> Looking at the keys defined in testmgr.h for DES3, it looks like the=
re
>> is a real parity issue with the test vectors. A DES key is supposed =
to
>> have all bytes with an odd number of ones. It is not the case in the=
 key
>> below. At least the second byte 0xC0 has an even number of ones.
>>
>> static struct cipher_testvec des3_ede_cbc_enc_tv_template[] =3D {
>>       { /* Generated from openssl */
>>           .key    =3D "\xE9\xC0\xFF\x2E\x76\x0B\x64\x24"
>>                 "\x44\x4D\x99\x5A\x12\xD6\x40\xC0"
>>                 "\xEA\xC2\x84\xE8\x14\x95\xDB\xE8",
>>
>> So, how can this test vector work ?
> I'm not going to comment on the validity of the test key vector
> other than to say that you can turn off key parity errors in the
> SEC1 in the DEU Interrupt Control Register.
>
> Kim
>
Thanks, it works

Christophe
