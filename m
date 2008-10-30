From: "Barry G" <mr.scada@gmail.com>
Subject: Re: Enabling Talitos kills all IPsec traffic
Date: Thu, 30 Oct 2008 09:58:24 -0700
Message-ID: <61362e760810300958p70d96138xbadd42a53a6f4abc@mail.gmail.com>
References: <61362e760810231612s6fe4dfbfk1c63986881d7152e@mail.gmail.com>
	 <20081028190257.a0d5a6d8.kim.phillips@freescale.com>
	 <61362e760810291033i565bb105pe0c8056b8c5538d@mail.gmail.com>
	 <20081029194001.1264cf20.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Kim Phillips" <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:25665 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbYJ3Q60 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Oct 2008 12:58:26 -0400
Received: by yx-out-2324.google.com with SMTP id 8so279894yxm.1
        for <linux-crypto@vger.kernel.org>; Thu, 30 Oct 2008 09:58:24 -0700 (PDT)
In-Reply-To: <20081029194001.1264cf20.kim.phillips@freescale.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Selecting talitos also selects CRYPTO_AUTHENC.  Can you try sending
> traffic with CRYPTO_DEV_TALITOS unset and CRYPTO_AUTHENC set if you
> haven't already?

Certainly.  I compiled a kernel with CRYPTO_AUTHENC set and
CRYPTO_DEV_TALITOS unset.  This kernel works fine.  Both
encrypted and unencrypted traffic flow properly.

> If Strongswan works with authenc and s/w crypto (talitos unset), and
> the SEC is firing interrupts (grep talitos /proc/interrupts), can you
> try with the latest cryptodev-2.6 git tree?  There's an error reporting
> fix for talitos there that may manifest any h/w the error may be
> reporting, depending on the level of traffic.
Strongswan works with authenc enabled and talitos unset.  I don't
know about the SEC iterrupt because talitos isn't mentioned in /proc/interrupts
(probably due to CRYPTO_DEV_TALITOS not being set).

I am cloning cryptodev-2.6 right now and will report on what it does.

>
> Otherwise, if you still want to use Strongswan, you can keep talitos
> entropy support by commenting out the crypto algorithm registration
> section of talitos_probe().
Yea.  Now that I know I can get hw accel of aes-cbc, I would really like
to get talitos working happily.

Thanks,

Barry
