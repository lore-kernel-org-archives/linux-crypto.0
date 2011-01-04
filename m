From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Date: Tue, 04 Jan 2011 17:26:57 -0600
Message-ID: <4D23ACC1.3060005@lwfinger.net>
References: <20101231003735.GA24101@gondor.apana.org.au> <4D1D27E7.7030301@lwfinger.net> <20101231022550.GA2512@darkside.kls.lan> <20101231024653.GA24879@gondor.apana.org.au> <20101231085103.GA31935@darkside.kls.lan> <20110104043338.GA27604@gondor.apana.org.au> <20110104121957.GA27114@darkside.kls.lan> <20110104123824.GA31557@gondor.apana.org.au> <20110104125722.GC27114@darkside.kls.lan> <20110104224238.GA4978@gondor.apana.org.au> <20110104230644.GJ27114@darkside.kls.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Matt Mackall <mpm@selenic.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mail
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61175 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1ADX0w (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Jan 2011 18:26:52 -0500
In-Reply-To: <20110104230644.GJ27114@darkside.kls.lan>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/04/2011 05:06 PM, Mario 'BitKoenig' Holbe wrote:
> On Wed, Jan 05, 2011 at 09:42:38AM +1100, Herbert Xu wrote:
>> Can you please try this patch against vanilla to print out the
>> raw output of xstore?
> 
> # ps -ef | grep 'rng[d]'
> # cat /sys/devices/virtual/misc/hw_random/rng_available
> via 
> # hexdump -n 16 -C /dev/hwrng
> 00000000  00 ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|

This thread just keeps getting more and more interesting! :)

For reference, this is what I get for b43:

hexdump -n 16 -C /dev/hwrng
00000000  c7 87 ec 43 fa ac a8 c2  3b 0d a6 8f 3e 35 54 ee  |...C....;...>5T.|

Larry
