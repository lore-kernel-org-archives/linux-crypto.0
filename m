From: David Howells <dhowells@redhat.com>
Subject: Re: key retention service: DH support
Date: Wed, 25 May 2016 11:58:26 +0100
Message-ID: <311.1464173906@warthog.procyon.org.uk>
References: <alpine.OSX.2.20.1605240851210.7071@tmhoole-mobl2.amr.corp.intel.com> <1884439.7dZQH0lY4q@tauon.atsec.com> <27639.1464073468@warthog.procyon.org.uk> <28895.1464074381@warthog.procyon.org.uk> <2025704.nsKCcck7Ux@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Stephan Mueller <smueller@chronox.de>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbcEYK6a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 May 2016 06:58:30 -0400
In-Reply-To: <alpine.OSX.2.20.1605240851210.7071@tmhoole-mobl2.amr.corp.intel.com>
Content-ID: <310.1464173906.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mat Martineau <mathew.j.martineau@linux.intel.com> wrote:

> Since the KDF patches are not yet merged, I'm not sure of the best way to
> accomodate the future feature. We could future-proof KEYCTL_DH_COMPUTE by
> adding a 5th arg, an optional pointer to KDF configuration (NAME and
> LABEL).

If we want to do this, it needs to be done before the merge window closes,
maybe by -rc2.  Just requiring the extra argument to be 0 for now and/or
extending struct keyctl_dh_params to include some must-be-zeroed spare space
would do for now.

David
