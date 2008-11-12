From: "Barry G" <mr.scada@gmail.com>
Subject: Re: Enabling Talitos kills all IPsec traffic
Date: Wed, 12 Nov 2008 13:06:55 -0800
Message-ID: <61362e760811121306u5dc47da4o6f71dacb3f86bd21@mail.gmail.com>
References: <61362e760810231612s6fe4dfbfk1c63986881d7152e@mail.gmail.com>
	 <20081028190257.a0d5a6d8.kim.phillips@freescale.com>
	 <61362e760810291033i565bb105pe0c8056b8c5538d@mail.gmail.com>
	 <20081029194001.1264cf20.kim.phillips@freescale.com>
	 <61362e760810300958p70d96138xbadd42a53a6f4abc@mail.gmail.com>
	 <61362e760810301606y3ca2e6ffr669e020e27b9fa71@mail.gmail.com>
	 <E036452DB507994DAF931ADC4A56AE2002BA6DFC@az33exm25.fsl.freescale.net>
	 <61362e760810302317t1b70a31bs5340c9d74a62900d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Phillips Kim-R1AAHA" <Kim.Phillips@freescale.com>,
	linux-crypto@vger.kernel.org
To: "Nipper Lee" <Lee.Nipper@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:56165 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYKLVG4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Nov 2008 16:06:56 -0500
Received: by yx-out-2324.google.com with SMTP id 8so289447yxm.1
        for <linux-crypto@vger.kernel.org>; Wed, 12 Nov 2008 13:06:55 -0800 (PST)
In-Reply-To: <61362e760810302317t1b70a31bs5340c9d74a62900d@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>>> # grep talitos /proc/interrupts
>>>  24:          0   IPIC   Level     talitos
>>>
>>> What could cause this?
>>>

Doh!  After playing around for a few days, I figured it out:
>From the DTS File:
crypto@30000 {
...
interrupts = <0x11 0x8>;
...
};

Turns out SEC is Interrupt ID 11, which is 0xb or 11, but not 0x11.  Not
sure how that got into there.

Changing the DTS file results in a firing interrupt and HW accelerated
crypto traffic.

For the record, both IKEv1 and IKEv2 traffic works fine.  On my
test network between two 8347 devices we are getting ~44 Mbit throughput using
SHA256 and AES256.  Switching to SHA1 and AES128 gives me ~ 49 Mbit throughput
(half duplex, iperf reported).

Thanks Herbert, Kim, Lee,

Barry
