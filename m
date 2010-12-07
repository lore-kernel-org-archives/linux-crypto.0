From: Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH] crypto: padlock: fix for non-64byte aligned data
Date: Tue, 7 Dec 2010 14:40:57 +0100
Message-ID: <20101207134057.GB24946@orbit.nwl.cc>
References: <1288893036-31704-1-git-send-email-phil@nwl.cc>
 <20101104184606.GA1994@gondor.apana.org.au>
 <20101105141238.GG29793@orbit.nwl.cc>
 <20101202061441.GA22378@gondor.apana.org.au>
 <20101207104141.GA24946@orbit.nwl.cc>
 <20101207113956.GA6128@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
	Nico Erfurth <ne@erfurth.eu>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orbit.nwl.cc ([91.121.169.95]:57408 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab0LGNk6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Dec 2010 08:40:58 -0500
Content-Disposition: inline
In-Reply-To: <20101207113956.GA6128@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Tue, Dec 07, 2010 at 07:39:56PM +0800, Herbert Xu wrote:
> On Tue, Dec 07, 2010 at 11:41:41AM +0100, Phil Sutter wrote:
> >
> > Yes, CONFIG_PREEMPT is active in my test system's kernel.
> 
> OK, can you see if the problem is still reproducible without
> preemption?

Yes, it is. I just redid the test with a CONFIG_PREEMPT_NONE kernel,
memory corruption occurs every time.

Greetings, Phil
