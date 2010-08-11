From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Thu, 12 Aug 2010 02:10:28 +0300
Message-ID: <AANLkTimROobKnx6A5z0o1Kf94Mg+41nrfnRiJASdPmPC@mail.gmail.com>
References: <1281039477-29703-1-git-send-email-mitr@redhat.com>
	<AANLkTi=K_UtN6=7WXELfkZYOUGMdmiZv-nGM9OCmuowd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Miloslav_Trma=C4=8D?= <mitr@redhat.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Neil Horman <nhorman@redhat.com>, linux-crypto@vger.kernel.org
To: Linus Walleij <linus.walleij@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33468 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab0HKXK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Aug 2010 19:10:29 -0400
Received: by qwh6 with SMTP id 6so667365qwh.19
        for <linux-crypto@vger.kernel.org>; Wed, 11 Aug 2010 16:10:29 -0700 (PDT)
In-Reply-To: <AANLkTi=K_UtN6=7WXELfkZYOUGMdmiZv-nGM9OCmuowd@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2010/8/11 Linus Walleij <linus.walleij@stericsson.com>:

Hello,

> Hi Miloslav,
> =C2=A0 c.f how the ALSA mixer presents a lot of things to userspace w=
ithout
> =C2=A0 using any enums at all in /dev/snd/controlC0 for card 0. For e=
xample
> =C2=A0 in include/linux/soundcard.h you find the different control kn=
obs
> =C2=A0 enumerated with strings so as to avoid explicit enums.

This is a double edged sword. Although it provides freedom at the
userspace, it would also allow crypto algorithms that were not
considered by the original design to be used with unpredictable
results. Moreover typos are found at run-time rather than
compile-time. For this and similar reasons interfaces of crypto
libraries and PKCS #11 define explicitly the allowed algorithms. This
design followed this principle.

> 2. To avoid security hazards the API would benefit from being program=
med
> =C2=A0 with at least some secure programming concepts in mid. Input a=
rgument
> =C2=A0 checking separate from algorithm separate from output argument=
 checking,
> =C2=A0 and erasing of information from stacks and buffers. More or le=
ss

What do you consider as a threat here? Is it for the kernel returing
unerased buffers and stack to userspace?

> 3. A general interface for stream ciphers would be nice. The only dif=
ferences
> =C2=A0 are that they do not operate on blocks, but bits, and that the=
y
> always require
> =C2=A0 an IV. Arguably this can be added later if the aspect if just =
considered when
> =C2=A0 devising the interface. The recent discussion in this thread
> regarding netlink
> =C2=A0 points in a direction where streams are a natural part of the =
concept I
> =C2=A0 believe.

This interface works (or should) with any kind of cipher. It is
designed to be wrappable to a pkcs #11 module, to be used easily as
backend by existing crypto applications and libraries.

regards,
Nikos
