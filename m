From: Martin Hicks <mort@bork.org>
Subject: Re: [PATCH 0/2] crypto: talitos: Add AES-XTS mode
Date: Mon, 2 Mar 2015 17:03:11 -0500
Message-ID: <20150302220311.GB30523@darwin.bork.org>
References: <1424451610-5786-1-git-send-email-mort@bork.org>
 <54F464E4.8080204@freescale.com>
 <20150302214419.GA30523@darwin.bork.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	Milan Broz <gmazyland@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: Martin Hicks <mort@bork.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from darwin.bork.org ([65.49.60.145]:39291 "EHLO darwin.bork.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbbCBWDL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Mar 2015 17:03:11 -0500
Content-Disposition: inline
In-Reply-To: <20150302214419.GA30523@darwin.bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 02, 2015 at 04:44:19PM -0500, Martin Hicks wrote:
> 
> 			Write (MB/s)	Read (MB/s)
> Unencrypted		140		176
> aes-xts-plain64 512b	113		115
> aes-xts-plain64 4kB	71		56

I got the two AES lines backwards.  Sorry about that.

mh

-- 
Martin Hicks P.Eng.    |      mort@bork.org
Bork Consulting Inc.   |  +1 (613) 266-2296
