From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Mon, 25 Apr 2016 09:55:14 +0200
Message-ID: <CAJU7zaJOSXefQkGb9H-uFr=Rxv16Gk=vYm60mOztS4uG=S0JcA@mail.gmail.com>
References: <9192755.iDgo3Omyqe@positron.chronox.de> <CAJU7zaL26c33wApqb=S_NCP9gTZPMGnQ+DACjEi6vnXfTq6XkA@mail.gmail.com>
 <1499137.D4Mft7n8bh@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Tso <tytso@mit.edu>, Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sandy Harris <sandyinchina@gmail.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:35238 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbcDYHzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 03:55:55 -0400
In-Reply-To: <1499137.D4Mft7n8bh@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 21, 2016 at 5:16 PM, Stephan Mueller <smueller@chronox.de> =
wrote:
>> > ... DRBG is =E2=80=9Cminimally=E2=80=9D seeded with 112^6 bits of =
entropy.
>> > This is commonly achieved even before user space is initiated.
>>
>> Unfortunately one of the issues of the /dev/urandom interface is the
>> fact that it may start providing random numbers even before the
>> seeding is complete. From the above quote, I understand that this
>> issue is not addressed by the new interface. That's a serious
>> limitation (of the current and inherited by the new implementation),
>> since most/all newly deployed systems from "cloud" images generate
>> keys using /dev/urandom (for sshd for example) on boot, and it is
>> unknown to these applications whether they operate with uninitialize=
d
>> seed.
> One more item to consider: If you do not want to change to use getran=
dom(2),
> the LRNG provides you with another means.

The main problem is not about willing to switch to getrandom() or not,
but finding any system where getrandom() exists. Today due to libc not
having the call, we can only use /dev/urandom and applications would
most likely continue to do so long time after getrandom() is
introduced to libc.

regards,
Nikos
