From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
Date: Fri, 20 Aug 2010 09:56:12 -0400
Message-ID: <20100820135612.GC4053@thunk.org>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
To: Miloslav =?utf-8?B?VHJtYcSN?= <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41103 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab0HTOPW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Aug 2010 10:15:22 -0400
Content-Disposition: inline
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 20, 2010 at 10:45:43AM +0200, Miloslav Trma=C4=8D wrote:
> Hello, following is a patchset providing an user-space interface to
> the kernel crypto API.  It is based on the older, BSD-compatible,
> implementation, but the user-space interface is different.

What's the goal of exporting the kernel crypto routines to userspace,
as opposed to just simply doing the crypto in userspace?  Is it to
access hardware crypto accelerators?  (1) I wasn't aware the kernel
crypto routines actually used crypto accelerators, and (2) more often
than not, by the time you take into account the time to move the
crypto context as well as the data into kernel space and back out, and
after you take into account price/performance, most hardware crypto
accellerators have marginal performance benefits; in fact, more often
than not, it's a lose.

If the goal is access to hardware-escrowed keys, don't we have the TPM
interface for that already?

So I'm bit at a list what's the whole point of this patch series.
Could you explain that in the documentation, please?  Especially for
crypto, explaining when something should be used, what the threat
model is, etc., is often very important.

Thanks, regards,

						- Ted
