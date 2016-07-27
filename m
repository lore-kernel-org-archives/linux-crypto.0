From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] DH support: add KDF handling support
Date: Wed, 27 Jul 2016 11:11:53 +0200
Message-ID: <9486547.FUb4ORn15o@tauon.atsec.com>
References: <alpine.OSX.2.20.1607141618170.69287@istotlan-mobl1.amr.corp.intel.com> <1954976.nIU2Zma9Rk@tauon.atsec.com> <9263.1469606131@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33812 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbcG0JL4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jul 2016 05:11:56 -0400
In-Reply-To: <9263.1469606131@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 27. Juli 2016, 08:55:31 CEST schrieb David Howells:

Hi David,

> Mat Martineau <mathew.j.martineau@linux.intel.com> wrote:
> > > Though, shall I stuff the wrapper code back into the existing dh_compute
> > > functions or can I leave them as separate functions?
> > 
> > I'm not sure. In the existing code there's one keyctl wrapper per keyctl
> > command. A combined wrapper would need some extra logic to decide whether
> > kdfparams is passed in or not, which is different from existing code.
> 
> You shouldn't change the existing keyctl wrappers.  Feel free to add another
> one with extra arguments.

I created dh_compute_kdf and dh_compute_kdf_oi where the latter takes the 
other information from STDIN.
> 
> David



Ciao
Stephan
