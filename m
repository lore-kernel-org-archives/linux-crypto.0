From: David McCullough <David_Mccullough@securecomputing.com>
Subject: Re: Questions For Linux Crypto API
Date: Wed, 14 Oct 2009 21:44:04 +1000
Message-ID: <20091014114404.GA4435@securecomputing.com>
References: <EC64E4604C8024438259B683BB2514E1077BB35162@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Leo Yan <leoy@marvell.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dalsmrelay2.nai.com ([205.227.136.216]:48020 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932817AbZJNLva (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2009 07:51:30 -0400
Content-Disposition: inline
In-Reply-To: <EC64E4604C8024438259B683BB2514E1077BB35162@SC-VEXCH1.marvell.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Jivin Leo Yan lays it down ...
> 
> Hi, all
> 
> I am a newbie for Linux crypto.
> Recently I am warming up on Linux Crypto APIs and have some questions.
> Would you kindly give me some hints about it J ?
> 
> 1. Does Linux Crypto API now support user space or not? 
> I have googled the mailing list, and find some guys have committed some patches for it.
> But so far, in the Linux mainline (2.6.31) do not merge it. 
> So Linux Crypto API will support user space or not?

Someone else will know more about this.  People are working on it I think
but it's not there yet.

> 2. OCF has been ported to Linux, so will OCF integrate with Linux Crypto API or not?

OCF has a driver called cryptosoft that uses the linux crypto API.

> If Linux Crypto API will support the user space and provide the user space APIs, then OpenBSD Cryptographics Framework
> will directly use the Linux Crypto APIs or not? Otherwise 

Once linux has it's own user space API you will not need OCF to provide one,
but you will need to add/wait for support for applications like openssl etc
to use the linux API.

Cheers,
Davidm

-- 
David McCullough,  david_mccullough@securecomputing.com,  Ph:+61 734352815
McAfee - SnapGear  http://www.snapgear.com                http://www.uCdot.org
