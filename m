From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 12680] New: Not having a VIA PadLock hardware
 incurs a long delay in probing on modules insertion attempt.
Date: Wed, 11 Feb 2009 09:16:47 -0800
Message-ID: <20090211091647.6607aea4.akpm@linux-foundation.org>
References: <bug-12680-10286@http.bugzilla.kernel.org/>
	<20090209130536.9a7a87cd.akpm@linux-foundation.org>
	<4992FC7E.3010207@orange.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	dm-devel@redhat.com
To: Valentin QUEQUET <v.quequet-techniques@orange.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756201AbZBKRTM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Feb 2009 12:19:12 -0500
In-Reply-To: <4992FC7E.3010207@orange.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


(cc dm-devel)

On Wed, 11 Feb 2009 17:27:42 +0100 Valentin QUEQUET <v.quequet-techniques@orange.fr> wrote:

> 
> I've finally found why my computer seems to hang (pause) quite lengthy 
> when I boot Pristine Linux 2.6.29-rcX... instead of Pristine Linux 
> 2.6.28.4 (for example).
> 
> The reason is that the cryptographic keys generation for the Device 
> Mapper takes longer with 2.6.29 than with 2.6.28 under certain 
> circumstances.

So it's device-mapper userspace?

Is this new behaviour in recent kernel versions?  Some kernel change
caused /dev/random accesses to wait for longer before sufficient
entropy has been gathered?


> To notice a non-negligible delay in the key generation phase, the system 
> must fit the following both 2 conditions:
> 
>    1) The system PRNG entropy pool must lack of entropy normally brought 
> in the form of environmental noise.
> 
>    2) The system must initiate its Device-Mapper-Encrypted (dm-crypt) 
> partitions with boot-time dynamically generated
>         cryptographic keys using "/dev/random" as key file. (the 3rd 
> field of "/etc/crypttab" ; see "man crypttab")
> 
> 
> Such a long delay in the key generation phase can be avoided if the 
> system fits either of the following 2 conditions:
> 
>    1) The excitated user stresses its keyboard and mouse (generates much 
> environmental noise) to provide the PRNG entropy pool with much entropy. 
> (Or some other peripheral generates noise : network interface, ...)
> 
>    2) The system initiates dm-crypt partitions using "/dev/urandom" as 
> key file.
> 
> 
> But in the scenario where both
>    1) environmental noise is reduced to the minimum (no user 
> 'excitation' and mouse and NIC unplugged)
> and
>    2) where dm-crypt partitions are initialized with "/dev/random" as 
> key file,
> there is a huge difference whether I boot Linux 2.6.28.y or Linux 
> 2.6.29-rcX... .
> 
> 
> In order to provide you with meaningful information but not too much, I 
> join a few "bootchart"-generated logs (bootchart*.tgz) plus their 
> ".svgz" corresponding diagrams (Pruned and Not-Pruned) for the following 
> test cases:
> 
> Having always environmental noise reduced at its minimum possible level.
> Using alternately 2.6.28 and 2.6.29 Linux versions.
> Using alternately "/dev/random" and "/dev/urandom" as dm-crypt key file.
> 
> There are then 4 test cases for which I join files, and for each test 
> case, I provide:
>    - The "bootchart*.tgz" bootchart report.
>    - The Not-Pruned ".svgz" corresponding SVG diagram.
>    - The Pruned ".svgz" corresponding SVG diagram.
> 
> Thus leading to the following 12 files:
> 
> -r--r--r-- 1 testr testr 174682 Feb 11 17:10 
> DevRandom_bootchart-2.6.28.4.BootChart_Report.tgz
> -r--r--r-- 1 testr testr 102648 Feb 11 17:10 
> DevRandom_bootchart-2.6.28.4.Not-Pruned_SVG_Diagram.svgz
> -r--r--r-- 1 testr testr  26010 Feb 11 17:10 
> DevRandom_bootchart-2.6.28.4.Pruned_SVG_Diagram.svgz
> -r--r--r-- 1 testr testr 327701 Feb 11 17:10 
> DevRandom_bootchart-2.6.29-rc4-git1.BootChart_Report.tgz
> -r--r--r-- 1 testr testr 175522 Feb 11 17:10 
> DevRandom_bootchart-2.6.29-rc4-git1.Not-Pruned_SVG_Diagram.svgz
> -r--r--r-- 1 testr testr  39844 Feb 11 17:10 
> DevRandom_bootchart-2.6.29-rc4-git1.Pruned_SVG_Diagram.svgz
> -r--r--r-- 1 testr testr 138401 Feb 11 17:10 
> DevUrandom_bootchart-2.6.28.4.BootChart_Report.tgz
> -r--r--r-- 1 testr testr  80691 Feb 11 17:10 
> DevUrandom_bootchart-2.6.28.4.Not-Pruned_SVG_Diagram.svgz
> -r--r--r-- 1 testr testr  21136 Feb 11 17:10 
> DevUrandom_bootchart-2.6.28.4.Pruned_SVG_Diagram.svgz
> -r--r--r-- 1 testr testr 152979 Feb 11 17:10 
> DevUrandom_bootchart-2.6.29-rc4-git1.BootChart_Report.tgz
> -r--r--r-- 1 testr testr  78323 Feb 11 17:10 
> DevUrandom_bootchart-2.6.29-rc4-git1.Not-Pruned_SVG_Diagram.svgz
> -r--r--r-- 1 testr testr  20745 Feb 11 17:10 
> DevUrandom_bootchart-2.6.29-rc4-git1.Pruned_SVG_Diagram.svgz
> 
> But for the sake of convenience, I tar them all as 
> "Dev-Random_regression_on_post-2.6.28_kernels.tar"
> 
> In hope my report will prove useful.
> 
> Sincerely,
> Valentin QUEQUET
> 
> n.b. : Don't hesitate to ask me for more files or explanations.
> 
