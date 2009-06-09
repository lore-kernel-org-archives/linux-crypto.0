From: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [patch 0/3] crypto: padlock-aes: enable on VIA Nano
Date: Wed, 10 Jun 2009 02:45:52 +0800
Message-ID: <20090609184552.GL5304@prithivi.gnumonks.org>
References: <20090609103533.0c334594@dhcp-100-2-144.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:41356 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZFISuI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2009 14:50:08 -0400
Content-Disposition: inline
In-Reply-To: <20090609103533.0c334594@dhcp-100-2-144.bos.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 09, 2009 at 10:35:33AM -0400, Chuck Ebbert wrote:
> The VIA Nano has a bug that makes the padlock unit fetch extra data
> during encryption operations. Add workarounds for that, and enable
> the driver on x86_64.

Thanks!

Where did you get the errata from, and what kind of document / revision is it?
I have not seen that document so far.

I've asked Centaur to confirm the errata, also inquired whether there will be
a microcode update or a new stepping to fix it.  If yes, we should add proper
checks to the workaround to make sure it's only enabled when we need it.

Out of curiosity: Only the ACE (crypto) is affected, not PHE (hashing)?

I'll also put on my todo list to do some actual benchmarking to determine
how much impact this bug has.  I expect especially for storage encryption,
many crypto operations will be page aligned and thus need the extra memcpy :(

p.s.: the patch to enable padlock on x86_64 is already in the crypto-dev tree,
as far as I know.  Interestingly, I have not observed this problem so far,
despite running dm-crypt on a nano for quite some time. 

Cheers,
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
