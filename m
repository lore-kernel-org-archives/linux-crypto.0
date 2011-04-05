From: Phil Sutter <phil@nwl.cc>
Subject: Re: aead: driver side documentation
Date: Tue, 5 Apr 2011 15:04:35 +0200
Message-ID: <20110405130435.GB15256@orbit.nwl.cc>
References: <20110404170337.GA1511@orbit.nwl.cc>
 <20110404203543.4f80b41b.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orbit.nwl.cc ([91.121.141.167]:43794 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab1DENEh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2011 09:04:37 -0400
Content-Disposition: inline
In-Reply-To: <20110404203543.4f80b41b.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Mon, Apr 04, 2011 at 08:35:43PM -0500, Kim Phillips wrote:
> On Mon, 4 Apr 2011 19:03:37 +0200
> Phil Sutter <phil@nwl.cc> wrote:
> 
> > I would like to enhance drivers/crypto/mv_cesa.c by an AEAD algorithm
> > (at least authenc(hmac(sha1),cbc(aes))), since the driver is able to do
> > both operations in one go.
> > 
> > Unfortunately, I have found little information about this task in
> > Documentation/ or the web. Am I missing something? It would be really
> > great if you could point me to the right direction here.
> 
> use existing drivers for guidance.  The following drivers implement
> those types of algorithms:

Thanks for the hint, although I've already found the "sample code". ;)
Was rather looking for something telling me what is crucial and what
options there are. Concrete code tends to just show the solution of a
specific problem. (My five cents to the question why code is often, but
seldomly good documentation.)

Grepping reveals IPSec (i.e., esp{4,6}.c) as the only user of AEAD so
far. Is this correct?

Greetings, Phil
