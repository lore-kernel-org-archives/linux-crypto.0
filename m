From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: kernel failure while loading X.509 certificate
Date: Thu, 18 Jan 2018 10:12:05 -0800
Message-ID: <20180118181205.4cwclwrh2x3zi5mz@gmail.com>
References: <88A6FE91-795D-4F17-BF8C-E597239A2C46@linaro.org>
 <F5505112-180F-4889-A73E-D0AB9054E58E@linaro.org>
 <CAK8P3a1E6YOXK2heCz0eiaQLpzpb6jjnvyNK_Y4Fu8bjZuPDZw@mail.gmail.com>
 <48DEA233-E708-4661-B5F0-15CEC60877E4@linaro.org>
 <20180117051627.GA15527@zzz.localdomain>
 <11931.1516187333@warthog.procyon.org.uk>
 <CBA47A21-8E0C-4DFD-ACE5-3872AEAAEEC4@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
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
Received: from mail-it0-f68.google.com ([209.85.214.68]:46385 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753501AbeARSMI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 13:12:08 -0500
Received: by mail-it0-f68.google.com with SMTP id c16so14510981itc.5
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2018 10:12:08 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CBA47A21-8E0C-4DFD-ACE5-3872AEAAEEC4@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 18, 2018 at 11:07:50AM +0100, Paolo Valente wrote:
> 
> 
> > Il giorno 17 gen 2018, alle ore 12:08, David Howells <dhowells@redhat.com> ha scritto:
> > 
> > If this happened during boot, it could be that you have an X.509 cert for
> > which the digest algorithm isn't built into the kernel.
> > 
> 
> Yeah.  I did look for such an inconsistency after that failure, but I
> didn't find it, most certainly because of my lack of expertise on
> this.
> 
> After the success with rc8, I retried with rc7, repeating the same
> streamline_config.pl procedure as the first time.  Of course, by
> Murphy's laws, rc7 worked this time.  Sorry for making you waste
> your time.  Should this happen again, I won't be so superficial not to
> make a backup of the offending config.
> 

No your report is still useful; I think there is a real kernel bug here,
probably reproducible using add_key() with type "asymmetric", where the
signature's hash algorithm isn't supported by the kernel.  I'll try to put
together a reproducer when I have a chance.  Thanks!

Eric
