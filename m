From: Valentin QUEQUET <v.quequet-techniques@orange.fr>
Subject: Re: [Bugme-new] [Bug 12680] New: Not having a VIA PadLock hardware
 incurs a long delay in probing on modules insertion attempt.
Date: Mon, 09 Feb 2009 22:59:37 +0100
Message-ID: <4990A749.5090801@orange.fr>
References: <bug-12680-10286@http.bugzilla.kernel.org/> <20090209130536.9a7a87cd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp23.orange.fr ([80.12.242.97]:38422 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbZBIWB1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Feb 2009 17:01:27 -0500
In-Reply-To: <20090209130536.9a7a87cd.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andrew Morton wrote :
> 
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Mon,  9 Feb 2009 09:12:59 -0800 (PST)
> bugme-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=12680
>>
>>            Summary: Not having a VIA PadLock hardware incurs a long delay in
>>                     probing on modules insertion attempt.
>>            Product: Drivers
>>            Version: 2.5
>>      KernelVersion: Any 2.6.29 release candidate
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: Other
>>         AssignedTo: drivers_other@kernel-bugs.osdl.org
> 
> hm, we don't seem to have a bugzilla category for crypto.
> 
>>         ReportedBy: v.quequet-techniques@orange.fr
>>
>>
>> Latest working kernel version: 2.6.28.4
>> Earliest failing kernel version: 2.6.29-rc1
> 
> I'll ask Rafael to track this as a post-2.6.28 regression.
> 
>> Distribution:
>> Hardware Environment: IA32 i686 Athlon model 10
>> Software Environment: Pristine kernel 2.6.29-rc4-git1 + Debian Lenny/Sid
>> Problem Description: Not having a VIA PadLock hardware incurs a long delay in
>> probing on modules insertion attempt:
>>
>>   I can't say whether this abnormally long probe delay occurs on "padlock_aes"
>> or "padlock_sha" module insertion attempt or both.
>>
>>   I do not have such hardware indeed.
>>
>> I've never observed this problem so far with Linux version <= 2.6.28.4 .
>>
>> Steps to reproduce:
>>
>> Power-on your system ;-)
>>
>> In hope my report will prove useful.
>>
> 
> Neither of those drivers have changed in six months, so the breakage
> must be elsewhere.

Hello,

I fear you're right:

It's setting up an LVM volume which takes over 20 seconds, sometimes 
more than 1 minute on my system when I run Linux 2.6.29-rcX... ; and no 
problem with Linux <= 2.6.28.4 though.

I understand this is quite a vague description of the trouble, and I'm 
considering more analysis in the near future.

This might be a Debian Lenny/Sid specific bug. I'm sorry for my 
eagerness to fill in my initial bug report, because I wrongly considered 
PadLock-related modules responsible for that delay.

> I guess this should be easy for others to reproduce.
> 
> How long is the "long" delay?
> 
> Please do this:
> 
> 	add "log_buf_len=1M" to the kernel boot command line
> 	reboot
> 
> 	dmesg -n 8
> 	modprobe padlock_aes &
> 	sleep 1
> 	echo t > /prog/sysrq-trigger
> 	dmesg -s 1000000 > foo
> 
> and then send us `foo'.  Pleas avoid wordwrapping it.
> 
> This will permit us to see where `modprobe' is getting stuck.

No delay observed doing these commands ; I was wrong.

> Thanks.

Thanks too.

On the Debian Lenny/Sid average user point of view, it is still a 
post-2.6.28 regression, though. Note: I only did comparisons between 
different Pristine kernel versions.

But I am sorry not having more accurate clues about that trouble.

In hope my report will prove useful.

Sincerely,
Valentin QUEQUET

