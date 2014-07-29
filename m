From: Muran Hrun <muuhuu@gmail.com>
Subject: Re: DMA support for mv_cesa
Date: Tue, 29 Jul 2014 09:11:25 +0200
Message-ID: <CADP6xpugjge93GXhy7MTp3GujqvBdLp-uhrEo2ffOiJNCvB5fQ@mail.gmail.com>
References: <20140728163849.44ac7ec5@free-electrons.com>
	<20140728141757.GR23220@titan.lakedaemon.net>
	<CADP6xpuU1V0byRQDp7+=VB6Ao3uL-YxjwYd6YK+KWc51fJVDsg@mail.gmail.com>
	<20140728210556.GB28452@orbit.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org, Muran Hrun <muuhuu@gmail.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:34021 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaG2HL0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Jul 2014 03:11:26 -0400
Received: by mail-ig0-f193.google.com with SMTP id h18so133065igc.0
        for <linux-crypto@vger.kernel.org>; Tue, 29 Jul 2014 00:11:25 -0700 (PDT)
In-Reply-To: <20140728210556.GB28452@orbit.nwl.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ah, thanks for the answer.

I can assist with hw (DNS-320 and possibly other) to test on when time comes.

The goal would be to have a low cost encrypted NAS as fast as possible.

M

2014-07-28 23:05 GMT+02:00 Phil Sutter <phil@nwl.cc>:
> On Mon, Jul 28, 2014 at 03:24:43PM +0200, Muran Hrun wrote:
>> Hi,
>>
>> What is the status of DMA support for mv_cesa? I tried applying the patches at
>> git://nwl.cc/~n0-1/linux.git (cesa-dma branch)
>> on kernel 3.15.6 but the kernel just crashed on my DNS-320, when
>> accessing an encrypted volume. (Kernel 3.5rc2 in the respository did
>> not boot at all)
>
> Yes, this is pretty old, work in progress and almost certainly broken.
>
>> Is DMA support for mv_cesa still developed?
>
> I still have that in mind, but am buried in work.
>
> On the technical side, the interesting thing is providing for the
> various DMA engines Marvell has and probably will continue to bestow
> upon us.
>
> Cheers, Phil
