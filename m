From: Torben Viets <viets@web.de>
Subject: Re: LRW/XTS + Via Padlock Bug in 2.6.24-rc7?
Date: Fri, 11 Jan 2008 00:21:50 +0100
Message-ID: <4786A88E.4020503@web.de>
References: <E1JD4KF-0004T4-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:34100 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbYAJXYp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jan 2008 18:24:45 -0500
In-Reply-To: <E1JD4KF-0004T4-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Woot,

it works, in XTS and LRW mode thanks, but I have one last question (it 
sounds like I'm columbo ;) )

Why I can't see both in /proc/crypto and of course not use in int 
cryptsetup, till I make a /etc/init.d/udev restart ist ths a kernel bug, 
or a ubuntu bug?

Thanks

Torben Viets

Herbert Xu wrote:
> Torben Viets <Viets@web.de> wrote:
>   
>> After rebuilding the kernel, I tried: cryptsetup -c aes-xts-plain -s 256 luksFormat /dev/raid/test
>>
>> It does the same as before, dmesg says:
>>
>> general protection fault: 0000 [#1] 
>> Modules linked in: xt_TCPMSS xt_tcpmss iptable_mangle ipt_MASQUERADE xt_tcpudp pppoe pppox xt_mark xt_state iptable_nat nf_nat nf_conntrack_ipv4 iptable_filter ip_tables x_tables af_packet ppp_generic slhc aes_i586 dm_crypt dm_mod
>>
>> Pid: 4409, comm: kcryptd Not tainted (2.6.24-rc7 #2)
>> EIP: 0060:[<c03599cc>] EFLAGS: 00010282 CPU: 0
>> EIP is at aes_crypt_copy+0x2c/0x50
>> EAX: f62e1ff0 EBX: f60ab850 ECX: 00000001 EDX: f60ab830
>> ESI: f620dda8 EDI: f620dda8 EBP: f62e1ff0 ESP: f620dda8
>>     
>
> Oh I see.  I misdiagnosed the problem.  The problem is that for some
> reason gcc cannot guarantee 16-byte alignment for variables on the
> stack in the kernel.  As you can see from ESI/EDI above the temporary
> buffer is unaligned.
>
> Please try this patch instead.
>
> Thanks,
>   
