From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: RSA verification in the kernel
Date: Thu, 13 Jan 2011 11:57:18 +0100
Message-ID: <AANLkTikJcQtZsjitEmzOBEoF4cySHpdN9pKgper37hiH@mail.gmail.com>
References: <4D2EA764.4070109@nokia.com>
	<AANLkTi=O3Kn3u8-4P0MaFfzWBRY4P4bfE6a3n+xHt+EQ@mail.gmail.com>
	<4D2ED304.10306@nokia.com>
	<4D2ED44C.4040100@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33902 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab1AMK5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Jan 2011 05:57:19 -0500
Received: by qyj19 with SMTP id 19so5288695qyj.19
        for <linux-crypto@vger.kernel.org>; Thu, 13 Jan 2011 02:57:18 -0800 (PST)
In-Reply-To: <4D2ED44C.4040100@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 13, 2011 at 11:30 AM, Dmitry Kasatkin
<dmitry.kasatkin@nokia.com> wrote:
> Hi,
> License of that library is such
> --------------------------------------------------
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DO WHAT THE FUCK YOU WANT TO=
 PUBLIC LICENSE
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
Version 2, December 2004
> =C2=A0Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

I see that there is new maintainer of libtomcrypt and such and uses thi=
s
licence. This wasn't the case when I started working on that, thus
my code is based on the last public domain one released by Tom
(and is also pretty modified).

regards,
Nikos
