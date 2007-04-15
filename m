From: Michael Halcrow <mike@halcrow.us>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Sun, 15 Apr 2007 10:31:48 -0500
Message-ID: <20070415153147.GD18988@halcrow.us>
References: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com> <E1Hco0p-0007np-00@gondolin.me.apana.org.au> <20070414194434.GA18988@halcrow.us> <a781481a0704150406y7d256e8ft47e7ce8d71877f8d@mail.gmail.com> <a781481a0704150731w68933d2cr162437fe17b568b4@mail.gmail.com>
Reply-To: Michael Halcrow <mike@halcrow.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:26547 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbXDOPkO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Apr 2007 11:40:14 -0400
Content-Disposition: inline
In-Reply-To: <a781481a0704150731w68933d2cr162437fe17b568b4@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Apr 15, 2007 at 08:01:24PM +0530, Satyam Sharma wrote:
> I might be answering myself here, but clearly, removing the
> whitelist does not seem possible given the PGP-message-framework
> eCryptfs was designed in.

The whole cipher code thing is just posturing. eCryptfs could just as
easily write the cipher string out to the metadata and then pass that
verbatim to the crypto API on sys_open(). There's no hard-and-fast
rule that dictates that eCryptfs absolutely has to write anything out
to the metadata in any particular format.

Mike
