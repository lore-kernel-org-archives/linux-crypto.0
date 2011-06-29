From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: caam - fix operator precedence in shared
 descriptor allocation
Date: Wed, 29 Jun 2011 11:12:26 -0500
Message-ID: <20110629111226.0ffca866.kim.phillips@freescale.com>
References: <20110523184523.62654cb1.kim.phillips@freescale.com>
	<20110526033044.GB14500@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	Kumar Gala <kumar.gala@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:36116
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756048Ab1F2QMz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2011 12:12:55 -0400
In-Reply-To: <20110526033044.GB14500@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 26 May 2011 13:30:44 +1000
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Mon, May 23, 2011 at 06:45:23PM -0500, Kim Phillips wrote:
> > setkey allocates 16 bytes (CAAM_CMD_SZ *
> > DESC_AEAD_SHARED_TEXT_LEN) shy of what is needed to
> > store the shared descriptor, resulting in memory
> > corruption.  Fix this.
> > 
> > Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> 
> Applied to cryptodev.  Thanks Kim!

Herbert, this patch fixes a memory corruption bug introduced in
commit 4427b1b - "crypto: caam - add support for sha512 variants of
existing AEAD algorithms", which is currently the last commit for
caam in Linus' tree. Can you please push this commit (c5bf900 in
cryptodev) to Linus before he releases 3.0?

btw, it would be good if commit af56dea "crypto: caam - fix build
warning when DEBUG_FS not configured" were also pushed to avoid the
build-bot messages, but it's not nearly as important as this one.

Thanks,

Kim
