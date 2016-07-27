From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] DH support: add KDF handling support
Date: Wed, 27 Jul 2016 08:55:31 +0100
Message-ID: <9263.1469606131@warthog.procyon.org.uk>
References: <alpine.OSX.2.20.1607141618170.69287@istotlan-mobl1.amr.corp.intel.com> <4161793.TTVXSVQtZL@positron.chronox.de> <1652054.TS73CfBaWe@positron.chronox.de> <alpine.OSX.2.20.1607131520480.52983@mjmartin-mac01.local> <1954976.nIU2Zma9Rk@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Stephan Mueller <smueller@chronox.de>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbcG0Hze (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jul 2016 03:55:34 -0400
In-Reply-To: <alpine.OSX.2.20.1607141618170.69287@istotlan-mobl1.amr.corp.intel.com>
Content-ID: <9262.1469606131.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mat Martineau <mathew.j.martineau@linux.intel.com> wrote:

> > Though, shall I stuff the wrapper code back into the existing dh_compute
> > functions or can I leave them as separate functions?
> 
> I'm not sure. In the existing code there's one keyctl wrapper per keyctl
> command. A combined wrapper would need some extra logic to decide whether
> kdfparams is passed in or not, which is different from existing code.

You shouldn't change the existing keyctl wrappers.  Feel free to add another
one with extra arguments.

David
