From: "Nipper Lee" <Lee.Nipper@freescale.com>
Subject: RE: Enabling Talitos kills all IPsec traffic
Date: Thu, 30 Oct 2008 16:11:23 -0700
Message-ID: <E036452DB507994DAF931ADC4A56AE2002BA6DFC@az33exm25.fsl.freescale.net>
References: <61362e760810231612s6fe4dfbfk1c63986881d7152e@mail.gmail.com> <20081028190257.a0d5a6d8.kim.phillips@freescale.com> <61362e760810291033i565bb105pe0c8056b8c5538d@mail.gmail.com> <20081029194001.1264cf20.kim.phillips@freescale.com> <61362e760810300958p70d96138xbadd42a53a6f4abc@mail.gmail.com> <61362e760810301606y3ca2e6ffr669e020e27b9fa71@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>
To: "Barry G" <mr.scada@gmail.com>,
	"Phillips Kim-R1AAHA" <Kim.Phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:64891 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbYJ3XLv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Oct 2008 19:11:51 -0400
Received: from de01smr01.freescale.net (de01smr01.freescale.net [10.208.0.31])
	by az33egw02.freescale.net (8.12.11/az33egw02) with ESMTP id m9UNBbhP024526
	for <linux-crypto@vger.kernel.org>; Thu, 30 Oct 2008 16:11:48 -0700 (MST)
Received: from az33exm25.fsl.freescale.net (az33exm25.am.freescale.net [10.64.32.16])
	by de01smr01.freescale.net (8.13.1/8.13.0) with ESMTP id m9UNBa5q010741
	for <linux-crypto@vger.kernel.org>; Thu, 30 Oct 2008 18:11:37 -0500 (CDT)
Content-class: urn:content-classes:message
In-Reply-To: <61362e760810301606y3ca2e6ffr669e020e27b9fa71@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> From: linux-crypto-owner@vger.kernel.org 
> [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Barry G

> I still have no ESP traffic, and dmesg shows no errors.
> 

Hi Barry,

Are you using ikev1 or ikev2 with strongswan ?

I have a simple strongswan example which works with talitos aes256,
but it uses ikev1 (pluto). 

> Something I did find that looks suspicious is talitos doesn't 
> appear to be
> firing interrupts.
> 
> # grep talitos /proc/interrupts
>  24:          0   IPIC   Level     talitos
> 
> What could cause this?
> 

My feeble attempt to use ikev2 shows this too.

Lee
