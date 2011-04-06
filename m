From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: aead: driver side documentation
Date: Tue, 5 Apr 2011 19:21:29 -0500
Message-ID: <20110405192129.d2778dec.kim.phillips@freescale.com>
References: <20110404170337.GA1511@orbit.nwl.cc>
	<20110404203543.4f80b41b.kim.phillips@freescale.com>
	<20110405130435.GB15256@orbit.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:33060 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1DFAVd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2011 20:21:33 -0400
In-Reply-To: <20110405130435.GB15256@orbit.nwl.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 5 Apr 2011 15:04:35 +0200
Phil Sutter <phil@nwl.cc> wrote:

> Hi,
> 
> On Mon, Apr 04, 2011 at 08:35:43PM -0500, Kim Phillips wrote:
> > On Mon, 4 Apr 2011 19:03:37 +0200
> > Phil Sutter <phil@nwl.cc> wrote:
> > 
> > > I would like to enhance drivers/crypto/mv_cesa.c by an AEAD algorithm
> > > (at least authenc(hmac(sha1),cbc(aes))), since the driver is able to do
> > > both operations in one go.
> > > 
> > > Unfortunately, I have found little information about this task in
> > > Documentation/ or the web. Am I missing something? It would be really
> > > great if you could point me to the right direction here.
> > 
> > use existing drivers for guidance.  The following drivers implement
> > those types of algorithms:
> 
> Thanks for the hint, although I've already found the "sample code". ;)
> Was rather looking for something telling me what is crucial and what
> options there are. Concrete code tends to just show the solution of a
> specific problem. (My five cents to the question why code is often, but
> seldomly good documentation.)
> 
> Grepping reveals IPSec (i.e., esp{4,6}.c) as the only user of AEAD so
> far. Is this correct?

yep.

I started to add test vectors from [1] to crypto/testmgr.c, but it
required that drivers not assume associated data, iv, and cipher data
were contiguous in memory, and since some of them do, I don't know if
such a contribution would be acceptable upstream.

then there's the rtnetlink dependencies I mention in [2] that
also make drivers fail AEAD testmgr tests in their setkey()
implementations, IIRC, because testmgr keys aren't RTA_OK.

Kim

[1] http://grouper.ieee.org/groups/1619/email/msg01966.html
[2] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg05533.html
