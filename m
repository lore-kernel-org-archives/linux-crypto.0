From: Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in
	sha1_update()
Date: Thu, 25 Feb 2010 12:32:37 -0500
Message-ID: <73c1f2161002250932j5167e2fan51dc11970df00f7@mail.gmail.com>
References: <4B8692E3.9030509@gmail.com>
	 <19334.40337.651079.440912@pilspetsen.it.uu.se>
	 <73c1f2161002250833n120cda05s9371e5ce13cc0aac@mail.gmail.com>
	 <19334.44752.357207.382349@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Roel Kluin <roel.kluin@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51074 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932947Ab0BYRcl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2010 12:32:41 -0500
In-Reply-To: <19334.44752.357207.382349@pilspetsen.it.uu.se>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 25, 2010 at 12:09 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:
> Brian Gerst wrote:
>> Would barrier() (which is a simple memory clobber) after the memset work?
>
> I don't know. It's implemented as an asm with a "memory" clobber,
> but I wouldn't bet on that forcing previous writes to a dying object
> to actally be performed (it would have to have a data-dependency on
> the dying object, but I don't think there is one).

>From the GCC manual, section 5.37:
If your assembler instructions access memory in an unpredictable
fashion, add `memory' to the list of clobbered registers. This will
cause GCC to not keep memory values cached in registers across the
assembler instruction and not optimize stores or loads to that memory.
You will also want to add the volatile keyword if the memory affected
is not listed in the inputs or outputs of the asm, as the `memory'
clobber does not count as a side-effect of the asm.

--
Brian Gerst
