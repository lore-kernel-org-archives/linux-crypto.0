From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: Deadlock on poweroff
Date: Sun, 07 Oct 2012 22:35:01 +0530
Message-ID: <5071B63D.4020300@linux.vnet.ibm.com>
References: <20121007024711.GA21403@shutemov.name> <20121007160311.GE2485@linux.vnet.ibm.com> <20121007165012.GA23535@shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:60689 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2JGRFw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Oct 2012 13:05:52 -0400
Received: from /spool/local
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <srivatsa.bhat@linux.vnet.ibm.com>;
	Sun, 7 Oct 2012 22:35:49 +0530
In-Reply-To: <20121007165012.GA23535@shutemov.name>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/07/2012 10:20 PM, Kirill A. Shutemov wrote:
> On Sun, Oct 07, 2012 at 09:03:11AM -0700, Paul E. McKenney wrote:
>> On Sun, Oct 07, 2012 at 05:47:11AM +0300, Kirill A. Shutemov wrote:
>>> Hi Paul and all,
>>>
>>> With commit 755609a9087fa983f567dc5452b2fa7b089b591f I've got deadlock on
>>> poweroff.
>>>
>>> It guess it happens because of race for cpu_hotplug.lock:
>>>
>>> 	CPU A					CPU B
>>> disable_nonboot_cpus()
>>> _cpu_down()
>>> cpu_hotplug_begin()
>>>  mutex_lock(&cpu_hotplug.lock);
>>> __cpu_notify()
>>> padata_cpu_callback()
>>> __padata_remove_cpu()
>>> padata_replace()
>>> synchronize_rcu()
>>> 					rcu_gp_kthread()
>>> 					get_online_cpus();
>>> 					mutex_lock(&cpu_hotplug.lock);
>>>
>>> Have you seen the issue before?
>>
>> This is a new one for me.  Does the following (very lightly tested)
>> patch help?
> 
> Works for me. Thanks.
> 

Could you share the patch please? Looks like it didn't hit the mailing
lists.. 

Regards,
Srivatsa S. Bhat
