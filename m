From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: kernel failure while loading X.509 certificate
Date: Thu, 18 Jan 2018 11:07:50 +0100
Message-ID: <CBA47A21-8E0C-4DFD-ACE5-3872AEAAEEC4@linaro.org>
References: <88A6FE91-795D-4F17-BF8C-E597239A2C46@linaro.org>
 <F5505112-180F-4889-A73E-D0AB9054E58E@linaro.org>
 <CAK8P3a1E6YOXK2heCz0eiaQLpzpb6jjnvyNK_Y4Fu8bjZuPDZw@mail.gmail.com>
 <48DEA233-E708-4661-B5F0-15CEC60877E4@linaro.org>
 <20180117051627.GA15527@zzz.localdomain>
 <11931.1516187333@warthog.procyon.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Eric Biggers <ebiggers3@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        crypto <linux-crypto@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:41584 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755127AbeARKHz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 05:07:55 -0500
Received: by mail-lf0-f44.google.com with SMTP id f136so4390479lff.8
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2018 02:07:54 -0800 (PST)
In-Reply-To: <11931.1516187333@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> Il giorno 17 gen 2018, alle ore 12:08, David Howells =
<dhowells@redhat.com> ha scritto:
>=20
> If this happened during boot, it could be that you have an X.509 cert =
for
> which the digest algorithm isn't built into the kernel.
>=20

Yeah.  I did look for such an inconsistency after that failure, but I
didn't find it, most certainly because of my lack of expertise on
this.

After the success with rc8, I retried with rc7, repeating the same
streamline_config.pl procedure as the first time.  Of course, by
Murphy's laws, rc7 worked this time.  Sorry for making you waste
your time.  Should this happen again, I won't be so superficial not to
make a backup of the offending config.

Thanks,
Paolo

> David
