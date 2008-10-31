From: "Barry G" <mr.scada@gmail.com>
Subject: Re: Enabling Talitos kills all IPsec traffic
Date: Thu, 30 Oct 2008 23:17:14 -0700
Message-ID: <61362e760810302317t1b70a31bs5340c9d74a62900d@mail.gmail.com>
References: <61362e760810231612s6fe4dfbfk1c63986881d7152e@mail.gmail.com>
	 <20081028190257.a0d5a6d8.kim.phillips@freescale.com>
	 <61362e760810291033i565bb105pe0c8056b8c5538d@mail.gmail.com>
	 <20081029194001.1264cf20.kim.phillips@freescale.com>
	 <61362e760810300958p70d96138xbadd42a53a6f4abc@mail.gmail.com>
	 <61362e760810301606y3ca2e6ffr669e020e27b9fa71@mail.gmail.com>
	 <E036452DB507994DAF931ADC4A56AE2002BA6DFC@az33exm25.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Phillips Kim-R1AAHA" <Kim.Phillips@freescale.com>,
	linux-crypto@vger.kernel.org
To: "Nipper Lee" <Lee.Nipper@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:18067 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbYJaGRP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Oct 2008 02:17:15 -0400
Received: by yx-out-2324.google.com with SMTP id 8so456758yxm.1
        for <linux-crypto@vger.kernel.org>; Thu, 30 Oct 2008 23:17:14 -0700 (PDT)
In-Reply-To: <E036452DB507994DAF931ADC4A56AE2002BA6DFC@az33exm25.fsl.freescale.net>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Are you using ikev1 or ikev2 with strongswan ?
>

I am trying IKEv2 right now (charon).  I will try it when I get back to
my main computer with IKEv1.

>> # grep talitos /proc/interrupts
>>  24:          0   IPIC   Level     talitos
>>
>> What could cause this?
>>
>
> My feeble attempt to use ikev2 shows this too.

I guess its good to know I am not alone :-)

Thanks,

Barry
