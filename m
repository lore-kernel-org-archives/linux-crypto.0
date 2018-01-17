From: David Howells <dhowells@redhat.com>
Subject: Re: kernel failure while loading X.509 certificate
Date: Wed, 17 Jan 2018 11:08:53 +0000
Message-ID: <11931.1516187333@warthog.procyon.org.uk>
References: <88A6FE91-795D-4F17-BF8C-E597239A2C46@linaro.org> <F5505112-180F-4889-A73E-D0AB9054E58E@linaro.org> <CAK8P3a1E6YOXK2heCz0eiaQLpzpb6jjnvyNK_Y4Fu8bjZuPDZw@mail.gmail.com> <48DEA233-E708-4661-B5F0-15CEC60877E4@linaro.org> <20180117051627.GA15527@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Eric Biggers <ebiggers3@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        crypto <linux-crypto@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
To: Paolo Valente <paolo.valente@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55609 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752276AbeAQLJC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jan 2018 06:09:02 -0500
In-Reply-To: <88A6FE91-795D-4F17-BF8C-E597239A2C46@linaro.org>
Content-ID: <11930.1516187333.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If this happened during boot, it could be that you have an X.509 cert for
which the digest algorithm isn't built into the kernel.

David
