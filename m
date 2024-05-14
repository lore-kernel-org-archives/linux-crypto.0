Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE737AD31;
	Tue, 14 May 2024 06:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.242.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715669704; cv=none; b=J+IB6TRIaxzfjMEJkUZw0FvIvs69lY6fVtQMzsIFz/t7k+8XG+KvKwo81x2UbUKvzjhEkcwdfN2Ey4M5hVZ0ww3sNNuYY1tVRcN+779KzSd1kxHYlxih/vzLJx87qLnfUZOrcv/Obgi8W0Nrl+CY8/QTRme7NZxIwCzckbxTl4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715669704; c=relaxed/simple;
	bh=dnr1nGL3WqI6iGgA/+7AS53QJ5C6Oo8Pvkj89qA/GZA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=U8Rfos/kmUwgN4J5E09iyKJ3daCNCzbhRiWBYeQ3x2/DN0BDdSeBg4Nuqa9RrLNoWQxUx4QiwTz7g8md5dln0IsTrzd7svRfoY2VM4DO1kAdM5SCIwDUIKMqiNQGjCCnF5x+lbgfzuvBqjbRVQWkKVvWMhM/LL02l4idx8sBnSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=176.9.242.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout3.hostsharing.net (Postfix) with ESMTPS id 74E4410195696;
	Tue, 14 May 2024 08:54:52 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 3D8A96FAE9C; Tue, 14 May 2024 08:54:52 +0200 (CEST)
Date: Tue, 14 May 2024 08:54:52 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Julia Lawall <julia.lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>, cocci@inria.fr
Subject: Re: [GIT PULL] Crypto Update for 6.10
Message-ID: <ZkMKvAnyOR3_cJnS@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi1T6wq1USBfU=NjdpSaTiKzV4H2gnUQfKa_mcXqOSk_w@mail.gmail.com>
 <CAHk-=wjmwmWv3sDCNq8c4VHWZUtZH72tDqR=TcgfpxTegL=aZw@mail.gmail.com>

On Mon, May 13, 2024 at 03:12:53PM -0700, Linus Torvalds wrote:
> On Sun, 12 May 2024 at 20:50, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > Lukas Wunner (1):
> >       X.509: Introduce scope-based x509_certificate allocation
[...]
> Having random kernel code add random "assume()" lines is absolutely
> not what we should do. Particularly not in some random code sequence
> where it absolutely does not matter ONE WHIT.
> 
> Now, I've pulled this, but I killed that  "assume()" hackery in my merge.

Thanks, appreciated.  This way of handling it spares me from having
to resubmit the patch without assume().  (The patch is prep work
for upcoming PCI device authentication.)


> > However, this patch still has two outstanding build defects which
> > have not been addressed:
> >
> > https://lore.kernel.org/all/202404240904.Qi3nM37B-lkp@intel.com/
> 
> This one just seems to be a sanity check for "you shouldn't check
> kmalloc() for ERR_PTR", so it's a validation test that then doesn't
> like the new test in that 'assume()'.

I've been in touch with Julia (+cc) to silence this coccinelle
false-positive.  But now that the assume() is gone, the coccinelle
warning won't appear anyway:

https://lore.kernel.org/all/alpine.DEB.2.22.394.2405062136410.3284@hadrien/


> And the second one:
> 
> > https://lore.kernel.org/all/202404252210.KJE6Uw1h-lkp@intel.com/
> 
> looks *very* much like the cases we've seen with clang in particular
> where clang goes "this code isn't reachable, so I'll just drop
> everything on the floor", and then it just becomes a fallthrough to
> whatever else code happens to come next. Most of the time that's just
> more (unrelated) code in the same function, but sometimes it causes
> that "falls through to next function" instead, entirely randomly
> depending on how the code was laid out.

Curiously, this particular 0-day report is for gcc 13.2.0 though,
not clang.

The assume() macro had no effect with clang when I tested it.
So the unnecessary IS_ERR() check persisted despite the macro when
compiling with clang.  Only gcc honors it.  Probably another reason
why you would hate the macro. :)

clang supports __builtin_assume().  In theory that should have the
same effect as __builtin_unreachable() on gcc (albeit with inverse
boolean semantics).  In practice it had no effect.  (Tested with
clang 15.0.6.)

https://clang.llvm.org/docs/LanguageExtensions.html#builtin-assume

So with clang there doesn't seem to be a working way to tell the
compiler about assumptions it can make.  And with gcc it's apparently
"hit and miss" depending on the exact gcc version and code. :(


> I suspect that because I removed the whole 'assume()' hackery, neither
> of the above issues will now happen, and the code nwo works.

Yes.

I guess this effort was over the top, so apologies for the noise!

Thanks,

Lukas
