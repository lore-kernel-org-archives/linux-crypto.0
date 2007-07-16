From: David McCullough <David_Mccullough@securecomputing.com>
Subject: Re: OCF Support on linux 2.6.
Date: Tue, 17 Jul 2007 09:51:33 +1000
Message-ID: <20070716235133.GA27925@securecomputing.com>
References: <70a419b80707160248g57943dd3p6ed57fda2405014e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Nawang Chhetan <nawang.chhetan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:37159 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757921AbXGQAYn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jul 2007 20:24:43 -0400
Content-Disposition: inline
In-Reply-To: <70a419b80707160248g57943dd3p6ed57fda2405014e@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Jivin Nawang Chhetan lays it down ...
> Hi All,
> 
> I am trying to integrate OCF-linux with Quicksec on linux 2.6 kernels.
> Many versions of OCF-Linux have been released but wtihout clear
> demarcation of 2.6 kernel versions they support. All they mention is
> support for kernel verison 2.6.11 and later and the README within the
> distributions states it can be easily modified to support recent
> version of kernels( which is true, I did it for 2.6.17.7 )
> My Question here is that:
> Is there any good OCF-Linux documentation available ?

Only whats on the website.  Your best bet is to ask.
The current releases work for kernels up to 2.6.18 without
any major issues.  I should be doing a release this week with
everything up to 2.6.22 supported fully.  Just finishing off the
testing.

> What is/are the version of 2.6 kernel, the OCF-Linux is most
> stable/tested/developed for ?
> Further I tried to use SafeXcel-1141 hardware accelerator ( which is
> claimed to be supported) with OCF-Linux, but inserting the module
> safe.ko (after ocf.ko and cryptodev.ko ) hangs the machine (Kernel
> version 2.6.17.6 .).
> Do I need to insmod the SafeXcel-1141 driver too ?

I have used the safenet driver on SuperH and ARM platforms. It works
fine there.  I don't have any way to test it on x86 though.

It should work fine on 2.6.17, load everything with debug enabled
and see what happens.

If you are running on an x86_64 system, disable all the code in
"random.c" however,  it was broken on 64bits arches in older versions.

Cheers,
Davidm

-- 
David McCullough,  david_mccullough@securecomputing.com,   Ph:+61 734352815
Secure Computing - SnapGear  http://www.uCdot.org http://www.cyberguard.com
