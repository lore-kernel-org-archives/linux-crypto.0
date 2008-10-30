From: "Barry G" <mr.scada@gmail.com>
Subject: Re: Enabling Talitos kills all IPsec traffic
Date: Thu, 30 Oct 2008 16:06:35 -0700
Message-ID: <61362e760810301606y3ca2e6ffr669e020e27b9fa71@mail.gmail.com>
References: <61362e760810231612s6fe4dfbfk1c63986881d7152e@mail.gmail.com>
	 <20081028190257.a0d5a6d8.kim.phillips@freescale.com>
	 <61362e760810291033i565bb105pe0c8056b8c5538d@mail.gmail.com>
	 <20081029194001.1264cf20.kim.phillips@freescale.com>
	 <61362e760810300958p70d96138xbadd42a53a6f4abc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Kim Phillips" <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:39133 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbYJ3XGh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Oct 2008 19:06:37 -0400
Received: by yw-out-2324.google.com with SMTP id 9so396414ywe.1
        for <linux-crypto@vger.kernel.org>; Thu, 30 Oct 2008 16:06:35 -0700 (PDT)
In-Reply-To: <61362e760810300958p70d96138xbadd42a53a6f4abc@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> I am cloning cryptodev-2.6 right now and will report on what it does.

I cloned cryptdev-2.6 and have it running with talitos enabled on my devices.
I still have no ESP traffic, and dmesg shows no errors.

Something I did find that looks suspicious is talitos doesn't appear to be
firing interrupts.

# grep talitos /proc/interrupts
 24:          0   IPIC   Level     talitos

What could cause this?

Herbert: Thanks for the clarification on authenc.

Thanks,

Barry
