From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [uml/do_xor_speed] WARNING: CPU: 0 PID: 1 at init/main.c:708
 do_one_initcall()
Date: Thu, 10 Apr 2014 10:38:40 +0300
Message-ID: <53464A80.3060202@panasas.com>
References: <20140410065330.GB2132@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Jet Chen <jet.chen@intel.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from natasha.panasas.com ([209.166.131.148]:53226 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964877AbaDJHn6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Apr 2014 03:43:58 -0400
In-Reply-To: <20140410065330.GB2132@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/10/2014 09:53 AM, Fengguang Wu wrote:
> Hi Boaz,
> 
> I catch the below warning again in
> 
> git://git.open-osd.org/linux-open-osd.git raid6
> 

OK Thanks. Daa I thought I fixed it but I forgot the obvious problem.

I pushed a new tree I think it might be good this time. (finally)

Thanks
Boaz


> commit 60e833d86a01ad9d8204a04b8db324106ab50395
> Author:     Boaz Harrosh <bharrosh@panasas.com>
> AuthorDate: Thu Jul 19 15:22:37 2012 +0300
> Commit:     Boaz Harrosh <bharrosh@panasas.com>
> CommitDate: Tue Apr 8 08:42:14 2014 +0300
> 
>     RFC: do_xor_speed Broken on UML do to jiffies
>     
>     Remember that hang I reported a while back on UML. Well
>     I'm at it again, and it still hangs and I found why.
>     
>     I have dprinted jiffies and it never advances during the
>     loop at do_xor_speed. There for it is stuck in an endless
>     loop. I have also dprinted current_kernel_time() and it
>     returns the same constant value as well.
>     
>     Note that it does usually work on UML, only during
>     the modprobe of xor.ko while that test is running. It looks
>     like some lucking is preventing the clock from ticking.
>     
>     However ktime_get_ts does work for me so I changed the code
>     as below, so I can work. See how I put several safety
>     guards, to never get hangs again.
>     And I think my time based approach is more accurate then
>     previous system.
>     
>     UML guys please investigate the jiffies issue? what is
>     xor.ko not doing right?
>     
>     Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> 
<>
> [    0.383315] WARNING: CPU: 0 PID: 1 at init/main.c:708 do_one_initcall+0x11d/0x136()
