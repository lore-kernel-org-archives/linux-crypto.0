From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 12680] New: Not having a VIA PadLock hardware
 incurs a long delay in probing on modules insertion attempt.
Date: Mon, 9 Feb 2009 13:05:36 -0800
Message-ID: <20090209130536.9a7a87cd.akpm@linux-foundation.org>
References: <bug-12680-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugme-daemon@bugzilla.kernel.org, v.quequet-techniques@orange.fr
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753484AbZBIVFo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Feb 2009 16:05:44 -0500
In-Reply-To: <bug-12680-10286@http.bugzilla.kernel.org/>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Mon,  9 Feb 2009 09:12:59 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12680
> 
>            Summary: Not having a VIA PadLock hardware incurs a long delay in
>                     probing on modules insertion attempt.
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: Any 2.6.29 release candidate
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: drivers_other@kernel-bugs.osdl.org

hm, we don't seem to have a bugzilla category for crypto.

>         ReportedBy: v.quequet-techniques@orange.fr
> 
> 
> Latest working kernel version: 2.6.28.4
> Earliest failing kernel version: 2.6.29-rc1

I'll ask Rafael to track this as a post-2.6.28 regression.

> Distribution:
> Hardware Environment: IA32 i686 Athlon model 10
> Software Environment: Pristine kernel 2.6.29-rc4-git1 + Debian Lenny/Sid
> Problem Description: Not having a VIA PadLock hardware incurs a long delay in
> probing on modules insertion attempt:
> 
>   I can't say whether this abnormally long probe delay occurs on "padlock_aes"
> or "padlock_sha" module insertion attempt or both.
> 
>   I do not have such hardware indeed.
> 
> I've never observed this problem so far with Linux version <= 2.6.28.4 .
> 
> Steps to reproduce:
> 
> Power-on your system ;-)
> 
> In hope my report will prove useful.
> 

Neither of those drivers have changed in six months, so the breakage
must be elsewhere.

I guess this should be easy for others to reproduce.

How long is the "long" delay?

Please do this:

	add "log_buf_len=1M" to the kernel boot command line
	reboot

	dmesg -n 8
	modprobe padlock_aes &
	sleep 1
	echo t > /prog/sysrq-trigger
	dmesg -s 1000000 > foo

and then send us `foo'.  Pleas avoid wordwrapping it.

This will permit us to see where `modprobe' is getting stuck.

Thanks.

