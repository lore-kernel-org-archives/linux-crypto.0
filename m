From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] arm: new W macro to WORD_ACCESS
Date: Wed, 16 Sep 2009 19:38:47 +0100
Message-ID: <20090916183847.GA16457@n2100.arm.linux.org.uk>
References: <200909161601.35662.elendil@planet.nl> <20090916175812.GA18993@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Frans Pop <elendil@planet.nl>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42387 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbZIPSmb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2009 14:42:31 -0400
Content-Disposition: inline
In-Reply-To: <20090916175812.GA18993@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 16, 2009 at 07:58:12PM +0200, Sebastian Andrzej Siewior wrote:
> leads to a build error because the crypto/cast6.c defines a function
> which is named W.

W has nothing to do with the access size, so this change makes it _really_
confusing.  What it's about is telling the compiler to use the ARM 32-bit
version of the instruction coding when building for Thumb2 (which
can intermix Thumb and ARM instruction sets.)

So the macro needs to be renamed... NAK on this patch as it stands.
