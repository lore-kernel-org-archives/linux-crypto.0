From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Padlock with VIA Nano still crashing
Date: Tue, 28 Jul 2009 22:53:17 +0200
Message-ID: <20090728205317.GA17688@Chamillionaire.breakpoint.cc>
References: <4A6EB64E.3040209@erfurth.eu>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Nico Erfurth <ne@erfurth.eu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34594 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112AbZG1UxR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jul 2009 16:53:17 -0400
Content-Disposition: inline
In-Reply-To: <4A6EB64E.3040209@erfurth.eu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Nico Erfurth | 2009-07-28 10:26:54 [+0200]:

> Does anybody have an idea how I could get the crashdump so I can send it to 
> the list? If there is no other way I'll write it down next time.
If you have a serial port you could dump it there (console=ttyS0 in the
kernel command line).
Could you please provide /proc/cpuinfo? What parameters have you used to
create to setup your crypt partition (key size, cipher mode)?

I've tested crypto dev recently with ipsec and that seemed to work.

> Regards,
> Nico

Sebastian
