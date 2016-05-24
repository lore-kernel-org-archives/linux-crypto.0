From: Stephan Mueller <smueller@chronox.de>
Subject: Re: key retention service: DH support
Date: Tue, 24 May 2016 18:45:09 +0200
Message-ID: <1542958.TuajgKVjUG@positron.chronox.de>
References: <1884439.7dZQH0lY4q@tauon.atsec.com> <2025704.nsKCcck7Ux@tauon.atsec.com> <alpine.OSX.2.20.1605240851210.7071@tmhoole-mobl2.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34742 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302AbcEXQpN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 May 2016 12:45:13 -0400
In-Reply-To: <alpine.OSX.2.20.1605240851210.7071@tmhoole-mobl2.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 24. Mai 2016, 09:22:22 schrieb Mat Martineau:

Hi Mat, Herbert
> 
> KDF transformations would be extremely useful, but transforming the DH
> output using a KDF needs to be configurable. There are enough different
> uses for DH that it's important to have access to the raw values.
> 
> Since the KDF patches are not yet merged, I'm not sure of the best way to
> accomodate the future feature. We could future-proof KEYCTL_DH_COMPUTE by
> adding a 5th arg, an optional pointer to KDF configuration (NAME and
> LABEL). Or a separate KEYCTL_DH_COMPUTE_KDF command can be added later.

With that statement, Herbert, should we start looking into my KDF patches 
after the merge window closes?

Ciao
Stephan
