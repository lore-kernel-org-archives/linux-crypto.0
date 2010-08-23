From: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
Date: Mon, 23 Aug 2010 11:34:54 +0200
Message-ID: <AANLkTi=8BqWJj6CEdm5QxvTSB+JiJCkEBFU4LDmHGwfX@mail.gmail.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
	<201008211908.03705.arnd@arndb.de>
	<4C70D72E.2040605@gmail.com>
	<201008231009.55037.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Miloslav_Trma=C4=8D?= <mitr@redhat.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
	linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55948 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab0HWJez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Aug 2010 05:34:55 -0400
In-Reply-To: <201008231009.55037.arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 23, 2010 at 10:09 AM, Arnd Bergmann <arnd@arndb.de> wrote:

>> This is an alternative design. There quite some reasons against that=
,
>> such as the auditing features. For me the main reason was =C2=A0that=
 there
>> was no way to make it as fast (zero-copy) as this design, for the
>> requirements we had (interface with existing crypto libraries throug=
h
>> pkcs11). Zero-copy is important since crypto operations might involv=
e
>> large chunks of data.
> You mean using a shared memory segment would not be possible without =
changing
> the libpkcs11 interface?

Indeed. The pkcs11 backend would have to copy the data to the shared
segment, thus high-performance applications requiring zero-copy, would
avoid to use this interface. Moreover if more than one applications
are using the interface, the shared segment it is going to be a
bottleneck. Having multiple shared segments might help, but I don't
know how practical is something like that with the posix ipc.

regards,
Nikos
