From: David McCullough <David_Mccullough@securecomputing.com>
Subject: Re: Questions For Linux Crypto API
Date: Thu, 15 Oct 2009 13:02:22 +1000
Message-ID: <20091015030222.GC31655@securecomputing.com>
References: <EC64E4604C8024438259B683BB2514E1077BB35162@SC-VEXCH1.marvell.com> <20091014114404.GA4435@securecomputing.com> <EC64E4604C8024438259B683BB2514E1077BB35417@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Leo Yan <leoy@marvell.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dalsmrelay2.nai.com ([205.227.136.216]:51335 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752192AbZJODEo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2009 23:04:44 -0400
Content-Disposition: inline
In-Reply-To: <EC64E4604C8024438259B683BB2514E1077BB35417@SC-VEXCH1.marvell.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Jivin Leo Yan lays it down ...
>  
> hi, David
> 
> Very appreciate for your answer. :-)
> 
> Please see my inline comments.
>  
> Best Regards,
> Leo Yan
> 
> 
> -----Original Message-----
> From: David McCullough [mailto:David_Mccullough@securecomputing.com] 
> Sent: 2009?10?14? 19:44
> To: Leo Yan
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: Questions For Linux Crypto API
> 
> 
> Jivin Leo Yan lays it down ...
> > 
> > Hi, all
> > 
> > I am a newbie for Linux crypto.
> > Recently I am warming up on Linux Crypto APIs and have some questions.
> > Would you kindly give me some hints about it J ?
> > 
> > 1. Does Linux Crypto API now support user space or not? 
> > I have googled the mailing list, and find some guys have committed some patches for it.
> > But so far, in the Linux mainline (2.6.31) do not merge it. 
> > So Linux Crypto API will support user space or not?
> 
> Someone else will know more about this.  People are working on it I think but it's not there yet.
> 
> > 2. OCF has been ported to Linux, so will OCF integrate with Linux Crypto API or not?
> 
> OCF has a driver called cryptosoft that uses the linux crypto API.
> 
> [leo]: thanks a lot. I got it.
> 
> > If Linux Crypto API will support the user space and provide the user 
> > space APIs, then OpenBSD Cryptographics Framework will directly use 
> > the Linux Crypto APIs or not? Otherwise
> 
> Once linux has it's own user space API you will not need OCF to provide one, but you will need to add/wait for support for applications like openssl etc to use the linux API.
> 
> [leo]: 
> This user space API you referred is the standard API on Linux, or the POSIX APIs? I googled and can NOT find it.
> Can you give me further more guide for it?

A linux native interface for userspace to kernel crypto doesn't "completely"
exist yet,  So there is nothing to find (other than patches to this list
IIRC).

It has nothing to do with posix or or standard API's at this point.

OCF will give you such an interface,  some people are working on another one
just for linux,

Cheers,
Davidm



> So i think the framework looks like below, is it right?
> |-------------------------------------------------|
> | Linux User space Crypto API             |                                                                              User Space
> |-------------------------------------------------|
>                                ^
> ------------------------|---------------------------------------------------------------------------------------
>                                v
> |-------------------------------------------------|------------------------------------------- |                   Kernel Space
> | Dedicated Device Driver for it            |Linux Crypto API                           | => this is the API maintained by Herbert in kernel space
> |-------------------------------------------------|--------------------------------------------|
> 
> 
> Cheers,
> Davidm
> 
> --
> David McCullough,  david_mccullough@securecomputing.com,  Ph:+61 734352815
> McAfee - SnapGear  http://www.snapgear.com                http://www.uCdot.org
> 
> 

-- 
David McCullough,  david_mccullough@securecomputing.com,  Ph:+61 734352815
McAfee - SnapGear  http://www.snapgear.com                http://www.uCdot.org
