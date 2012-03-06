From: David McCullough <david_mccullough@mcafee.com>
Subject: Re: [Openswan Users] Openswan IPsec: ARM cortex SoC board to board
 ping works but board to Ubuntu does not
Date: Tue, 6 Mar 2012 21:38:48 +1000
Message-ID: <20120306113848.GA27988@mcafee.com>
References: <CAGgcXb7dMetJ0OS498X9Fn3Py6OAfWhN2j+kA1HzyJFzbfJ_tg@mail.gmail.com>
 <alpine.LFD.2.02.1203020853410.7465@bofh.nohats.ca>
 <CAGgcXb4WUxOBYn46kTX13HAD-3BT9hxDD+svx1BB-kC-oMuf3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <users@openswan.org>, <linux-crypto@vger.kernel.org>
To: satpal parmar <systems.satpal@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sncsmrelay2.nai.com ([67.97.80.206]:60834 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965161Ab2CFLkW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Mar 2012 06:40:22 -0500
Content-Disposition: inline
In-Reply-To: <CAGgcXb4WUxOBYn46kTX13HAD-3BT9hxDD+svx1BB-kC-oMuf3w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Jivin satpal parmar lays it down ...
> Sorry for that confusion Paul. Yes you are right we need both an
> encryption algorithm and and authentication algorithm for  IPsec to
> work. As per my understanding we can do this either in H/W through
> some security engine or accelerators or through s/w libraries already
> supported in Linux. IPsec stack will first look for H/W  support and
> if it fails it will fall back to s/w libraries.
> 
> On my SOC we have H/W support for AES/DES/SHA-MD5 with driver support
> from TI. So when I say ping works with AES/DES I mean I see ESP
> packets going and received both side in wireshark when I ping board to
> PC(Ubuntu) or vice versa. So from above understanding I assume what is
> happening is encryption is handled by AES/DES hardware and
> authentication is been done in S/W. (Is there any better way to
> confirm other then wireshark ?)
> 
> But when I include SHA-MD5 h/w driver support this arrangement fail to
> work. I do see ESP packets going from board and Ubuntu side but none
> of the sides are able to  receive/handle these esp packets. This
> configuration /ping works fine  when I connect another board in place
> of Ubuntu on other side . It's a strange behavior I am trying to
> debug.

If you can get two of your boards to communicate using openswan,  but
cannot get one of your boards to talk to a PC running ubuntu then I would
say that there is a problem with the HW implementation of the hashing
functions (md5/sha) and it is somehow incorrect,  but consistent.

For example,  if the hashing always returned 0x1234,  the two boards would
interoperate,  but it wouldn't work with any other system.

You should start by testing those and comparing their output against the
kernels software implementations.

Cheers,
Davidm

> I think David can help us in understanding this situation better?
> 
> @David: Hello David! Hope you are doing fine. I am back to bug you
> again! Please have a look at this mail and let me know if my
> explanation of behavior is consistent with your understanding of
> IPsec.
> 
> Thanks for your response everyone. I will update if I make any
> progress on this issue.
> 
> -SP
> 
> 
> On Fri, Mar 2, 2012 at 7:27 PM, Paul Wouters <paul@nohats.ca> wrote:
> > On Fri, 2 Mar 2012, satpal parmar wrote:
> >
> >>
> >> I recently ported Openswan on ARM cortex based SOC running linux
> >> 2.6.37 (ipsec netkey stack) and openswan 2.6.23. On this board I have
> >> H/W accelerator support for AES/DES/SHA.
> >>
> >> (http://processors.wiki.ti.com/index.php/Installing_AM387x_C6A814x_DM814x_Crypto_Support).
> >> AES/DES crypto operation are working fine and I am able to ping
> >> through IPsec tunnel from my board to PC and vice versa.
> >
> >
> > Did you need to patch anything for openswan? Can you share your patches
> > with us?
> >
> >
> >> However when
> >> I am trying ping with SHA-MD5 I am not able to ping ??to and from
> >> Ubuntu machine .
> >
> >
> >
> >> My ubuntu machine details:
> >> root@vnl-desktop:~# uname -a
> >> Linux vnl-desktop 2.6.32-33-generic #72-Ubuntu SMP Fri Jul 29 21:08:37
> >> UTC 2011 i686 GNU/Linux
> >>
> >> MYost probably it could be a IPsec configuration issue on Ubuntu
> >> machine but I am not able to locate ??what configuration could affect
> >> behavior of only one crypto algorithm. Since I am using same
> >> configuration for IPsec for testing all Crypto algo supported in H/W
> >> (DES/AES/SHA-MD5 )and ??I am successfully able to ping through IPSec
> >> tunnel for DES and AES.
> >
> >
> > I am not sure what you mean when you bundle "sha-md5" and "des and aes".
> > A tunnel needs both an encryption algorithm (aes or 3des) and an
> > authentication algothim (sha1, sha2, md5, etc). So for your tunnel
> > to work, you would always be using either md5 or sha? Since you say
> > some tunnels work, those algorithms must be working?
> >
> > I am not sure I understand exacly what works and what does not work.
> >
> > Paul
> 
> 

-- 
David McCullough,      david_mccullough@mcafee.com,  Ph:+61 734352815
McAfee - SnapGear      http://www.mcafee.com         http://www.uCdot.org
