From: "cloudy.linux" <cloudy.linux@gmail.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Mon, 25 Jun 2012 22:25:01 +0800
Message-ID: <4FE874BD.2020909@gmail.com>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com> <1339806021-14271-1-git-send-email-gmbnomis@gmail.com> <20120618134718.GL9122@philter.vipri.net> <20120618201235.GA20755@schnuecks.de> <4FE1D09E.4040104@gmail.com> <20120620154131.GR9122@philter.vipri.net> <20120625134050.GB12294@philter.vipri.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, andrew@lunn.ch,
	Simon Baatz <gmbnomis@gmail.com>
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33320 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab2FYOZN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jun 2012 10:25:13 -0400
Received: by dady13 with SMTP id y13so5394623dad.19
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jun 2012 07:25:13 -0700 (PDT)
In-Reply-To: <20120625134050.GB12294@philter.vipri.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2012-6-25 21:40, Phil Sutter wrote:
> Hi,
>
> On Wed, Jun 20, 2012 at 05:41:31PM +0200, Phil Sutter wrote:
>> PS: I am currently working at the address decoding problem, will get
>> back to in a few days when I have something to test. So stay tuned!
>
> I have updated the cesa-dma branch at git://nwl.cc/~n0-1/linux.git with
> code setting the decoding windows. I hope this fixes the issues on
> orion. I decided not to publish the changes regarding the second DMA
> channel for now, as this seems to be support for a second crypto session
> (handled consecutively, so no real improvement) which is not supported
> anyway.
>
> Greetings, Phil
>
>
> Phil Sutter
> Software Engineer
>

Thanks Phil. I'm cloning your git now but the speed is really slow. Last 
time I tried to do this but had to cancel after hours of downloading (at 
only about 20% progress). So the previous tests were actually done with 
3.5-rc3 (I tried the up-to-date Linus' linux-git, but met compiling 
problem), of course with your patch and Simon's. Could you provide a 
diff based on your last round patch (diff to the not patched kernel 
should also be good, I think)?

In the mean time, I'm still trying with a cloning speed of 5KiB/s ...

Regards
Cloudy
