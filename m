From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] AMCC Crypto4xx Device Driver v2
Date: Wed, 29 Oct 2008 14:14:28 +0100
Message-ID: <20081029131428.GA13501@Chamillionaire.breakpoint.cc>
References: <1225158336-8777-1-git-send-email-jhsiao@amcc.com> <1225158932.4768.29.camel@jhsiao-usb>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: James Hsiao <jhsiao@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48375 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbYJ2NOg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Oct 2008 09:14:36 -0400
Content-Disposition: inline
In-Reply-To: <1225158932.4768.29.camel@jhsiao-usb>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* James Hsiao | 2008-10-27 18:55:32 [-0700]:
>Kim suggest us submit this to linuxppc-dev for more review.
so do I

>> 
>> diff --git a/arch/powerpc/boot/dts/kilauea.dts b/arch/powerpc/boot/dts/kilauea.dts
>> index dececc4..58b48a0 100644
>> --- a/arch/powerpc/boot/dts/kilauea.dts
>> +++ b/arch/powerpc/boot/dts/kilauea.dts
>> @@ -1,4 +1,4 @@
>> -/*
>> +/* 
>>   * Device Tree Source for AMCC Kilauea (405EX)
>>   *
Usually we are removing leading/trailing blanks. Not the other way
around. 
I haven't seen this change in the submit at Date: Fri, 19 Sep 2008
16:46:43 -0700. Is this an updated version or does my mailbox leak
emails?

Sebastian
