From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: initcall calibrate_xor_blocks returned with preemption imbalance
Date: Fri, 11 Oct 2013 11:42:39 -0700
Message-ID: <5258469F.9070108@panasas.com>
References: <20131010090217.GB2541@localhost> <525710F3.1000209@panasas.com> <20131011012936.GB11191@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:59467 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3JKSmw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Oct 2013 14:42:52 -0400
In-Reply-To: <20131011012936.GB11191@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/10/2013 06:29 PM, Fengguang Wu wrote:
> 
> I'm running kernel build/boot/performance tests for *all* the public
> kernel git trees I'm aware of. If this is not necessary for your tree
> or some of the branches, sorry I can remove them from the test pool.
> 
>> I can see below:
>> 	Merge 'open-osd/exofs_ioctl' into devel-hourly-2013101007
>>

OK then there you have it then. Yes exofs_ioctl is a testing branch
that I also use with UML. And there for must carry this unfinished
patch.

Thankyou for the bisect. I will take this crash report and put
it on my todo for fixing the xor stuckness.

Have a good day
Boaz
