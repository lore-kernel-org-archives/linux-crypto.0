From: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [PATCH] crypto: padlock: fix for non-64byte aligned data
Date: Wed, 8 Dec 2010 08:08:13 +0800
Message-ID: <20101208000813.GC10791@prithivi.gnumonks.org>
References: <1288893036-31704-1-git-send-email-phil@nwl.cc>
 <20101104184606.GA1994@gondor.apana.org.au>
 <20101105141238.GG29793@orbit.nwl.cc>
 <20101202061441.GA22378@gondor.apana.org.au>
 <20101207104141.GA24946@orbit.nwl.cc>
 <20101207113956.GA6128@gondor.apana.org.au>
 <20101207134057.GB24946@orbit.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
	Nico Erfurth <ne@erfurth.eu>, Michal Ludvig <michal@logix.cz>
To: Phil Sutter <phil@nwl.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:49692 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab0LHAIn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Dec 2010 19:08:43 -0500
Content-Disposition: inline
In-Reply-To: <20101207134057.GB24946@orbit.nwl.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sorry for jumping into this thread so late.

I am almost constantly on business travel (without any VIA system with me), so
I cannot try to reproduce the problem.  It probably has never shown up before
since my typical test case is dm-crypt and there you will of course never see
any unaligned buffers for encryption.

I'm returning home on December 11, and hopfeully can do some testing at
that time.

Is there a list of machines (/proc/cpuinfo) on which the problem has shown up
so far?

Regards,
	Harald
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
