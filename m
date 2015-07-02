From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 08/10] crypto: omap-aes: gmc: Add algo info
Date: Thu, 02 Jul 2015 11:56:34 +0200
Message-ID: <11868978.OKt1rthESK@tauon.atsec.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com> <1996807.vhgJsDVnGm@tauon.atsec.com> <55950A72.4040004@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	davem@davemloft.net, linux-omap@vger.kernel.org,
	linux-kernel@vger.kernel.org, t-kristo@ti.com, nsekhar@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47885 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbbGBJ4i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 05:56:38 -0400
In-Reply-To: <55950A72.4040004@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 2. Juli 2015, 15:24:58 schrieb Lokesh Vutla:

Hi Lokesh,

>>> +{
>>> +	.cra_name		= "gcm(aes)",
>>> +	.cra_driver_name	= "gcm-aes-omap",
>>> +	.cra_priority		= 100,
>> 
>> Why did you choose the priority 100? The software implementations commonly
>> use 100. crypto/gcm.c uses the prio of the underlying cipher. In case of
>> ARM, there seem to be assembler implementations of AES which have the prio
>> of 200 or 300. So, such software implementation of gcm(aes) would have a
>> higher precedence than your hw implementation.
>
>Yes, you are right.
>Other hw algos in omap-aes also uses priority 100.
>Only sw and hw implementations are enabled right now and both are at same
>priority. And till now its lucky enough that hw algo gets picked.

Maybe those HW prios should be updated too?

Ciao
Stephan
