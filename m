From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC] how to auto-load via-rng ?
Date: Fri, 15 May 2009 11:52:32 +0200
Message-ID: <20090515095232.GA3996@Chamillionaire.breakpoint.cc>
References: <20090510063337.GE12152@prithivi.gnumonks.org>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Harald Welte <HaraldWelte@viatech.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38136 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755514AbZEOJwe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 May 2009 05:52:34 -0400
Content-Disposition: inline
In-Reply-To: <20090510063337.GE12152@prithivi.gnumonks.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Harald Welte | 2009-05-10 14:33:37 [+0800]:

>Maybe it is too early during kernel startup to create a platform_device?
possible. without a trace and the hw atm I can't tell.

>Does anyone have an idea how to solve the problem? Is there a better method
>than a platform device?
I don't thing platform device is all that bad. Try to put your code in
module_init() so it gets called at a later point in time.

Another way to go would be to add an alias to the rnd module and probe
for it once the first user needs it. The benefit of this is, that there
is no need to add a platform here and others (s390 has the same
problem).

>Regards,

Sebastian
