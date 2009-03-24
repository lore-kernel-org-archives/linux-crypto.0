From: "G.Muruganandam" <gmuruga@gdatech.com>
Subject: Re: Talitos on MPC8548
Date: Mon, 23 Mar 2009 18:05:39 -0700
Message-ID: <200903240108.n2O185u14889@sierra.gdatech.com>
References: <200903191736.n2JHaCu20819@sierra.gdatech.com>
	<49C379E0.2090709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Cc: <lee.nipper@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from darwaza.gdatech.com ([66.237.41.98]:53058 "EHLO
	darwaza.gdatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbZCXBFm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Mar 2009 21:05:42 -0400
In-Reply-To: <49C379E0.2090709@gmail.com>
References: <200903191736.n2JHaCu20819@sierra.gdatech.com>
	<49C379E0.2090709@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Lee,

Thanks for the details on the talitos patch.
I followed the steps and applied the patches.
I am able to rebuild the kernel without any issues.

After going through the docs and some googling,
I am planning to use the following topologies using
MPC8548 boards ( I have two boards )
To start with, I'll use the topology I . Pl let me know
your comments.


Topology -I:
========
                                           10.15.109.101 
10.15.109.100
Host A--------------------------MPC8548 -----------------------------Host B
192.168.50.5         192.168.50.1


Topology-II:
========
                                      10.15.109.101     10.15.109.100
Host----------------------MPC8548-1--------------------MPC8548-2-----------Host
192.168.50.5     192.168.50.1 
192.168.1.1        192.168.1.10


Thanks
G.Muruganandam


G.Muruganandam wrote:

 >> 4) You should have better IPsec performance if you add the 
talitos patches made since
 >>     2.6.27 which are in the mainline kernel tree. (Linux 
2.6.29-rc8 includes 7 extra patches).
 >>     These could be added to 2.6.27.18 easily.

 > I tried applying the patch that you mentioned above. But I am 
encountering issue while
 > applying the same. Pl see below the command that I used and 
corresponding output.

 > [linux-2.6.27.18]$ patch -p1 -E --dry-run < patch-2.6.29-rc8

That's not what I intended. patch-2.6.29-rc8 has more
patches than you want.
What I meant was to apply only the talitos patches since 2.6.27
to a 2.6.27.18 kernel.

It's easier if you use git, the SCM tool used by linux.
The more you work with linux, the more valuable git skills will become.

I am attaching an archive with the patches I had intended.
You can apply the patches to the 2.6.27.18 kernel
that you are working with.

Save the archive above your linux-2.6.7.18 directory, then apply
the patches one at a time.  You can't use --dry-run because subsequent
patches depend on previous ones.

Here is how I would do it:

lee $ tar zxf talitos-since-2.6.27.tar.gz
lee $ cd linux-2.6.27.18
linux-2.6.27.18 $ for file in ../talitos-since-2.6.27/*
 > do
 > patch -p1 -i $file
 > done
patching file drivers/crypto/talitos.c
patching file drivers/crypto/talitos.c
patching file drivers/crypto/talitos.c
patching file drivers/crypto/talitos.h
patching file drivers/crypto/talitos.c
patching file drivers/crypto/talitos.h
patching file drivers/crypto/talitos.c
patching file crypto/fcrypt.c
patching file drivers/crypto/talitos.h
patching file drivers/crypto/talitos.c
linux-2.6.27.18 $

After doing the above, your kernel directory
has all the latest talitos patches applied.

Hope your testing goes well.

-Lee





At 04:11 AM 3/20/2009, Lee Nipper wrote:
>On Thu, Mar 19, 2009, G.Muruganandam <gmuruga@gdatech.com> wrote:
>
> > I would like to get a pointer to start testing talitos on the 
> MPC8548 board.
> > I have linux kernel 2.6.27.18 running on the custom designed MPC8548 board.
>
>This is how I would approach it:
>
>1) Look at the custom board's .dts file
>     and make sure it has a crypto section with properties
>     which match those in arch/powerpc/boot/dts/mpc8548cds.dts
>     from 2.6.27.18.
>
>2) talitos in 2.6.27.18 implements only ESP IPsec algorithms.
>     So if you need h/w accelerated plain cipher or digest
>     algorithms,there are not there.
>
>3) If IPsec is what you are interested in using, talitos implements
>     aes-cbc and 3des-cbc encryption, and hmac-sha1 & -sha256
>     & -md5 authentication. You can try it in 2.6.27.18.
>     Turn on the necessary CRYPTO kernel options as well
>     as applicable IPsec options.
>
>4) For better IPsec performance, add the talitos patches made since
>     2.6.27 which are in the mainline kernel tree.
>     (Linux 2.6.29-rc8 includes 7 extra patches).
>     These could be added to 2.6.27.18 easily.
>
>Lee
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

