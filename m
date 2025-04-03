Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF4A13A244;
	Thu,  3 Apr 2025 03:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743651762; cv=none; b=hVC8Ol8KA20/IsSR1npKQu/BPJQyBAkGVmqo/Tvcxan6x40x0NbgJ5hTeuEdrcW15PMIIulRrvdiBrWMHXFAFP3LITmGxfIL5vNQpHH4tarhKls3Mqdrg//XARHXgIPTEoQiSQVwdrRzY6bZf2M2v4avm4InqDwIJB+O8GDZmus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743651762; c=relaxed/simple;
	bh=nlEfIQXVFSXU2WXk90DKBYPjTtBBUFJlgKi+bnMnsNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L5QO9y6AsKcrP8GySmtk17KrMm+4YzcGQahWFZ1VM5SQDJw/gjl4frer1g67CrSopwmioscUsRhgQtN+V+hGxbklt6RnzcGxb9AJ9txMR2i8i90A/zlYqOH6toqe5FyrAJFWXa2yUYaumFYJSuMVChOMd+omUwI46QS0KT+Mkug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=G6kyT1pn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="G6kyT1pn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vYeenMdn6I2y0o1BiN7xKeWa4HgHTA70mF73ckMYMbw=; b=G6kyT1pnZOdhnSovrf0UM4IfLk
	tjwCogFC1Llkff4olUSBLWbnbyLL01v6OD8vhaA3uuTiNpKD99YEbS/T211vsL7WFwgG6vKpHaatT
	hsfY0r3Cl/xQzcHHDlJRJ1EZjI82SDikhg64FVslk5xqqrGnDUphQ+i52sgAsTPL9J26H9FLnhvWE
	l/iHId/CNmLVv3DJffZ8+ijuZtNgdyDAljNOAnKo1FtSUExiEZDVALERcBrfV8QdhrVo9RITO/kRm
	9b2ElPxvCj8WLBiymk5+cyghFV9uldtMj1ih/L5qZql5VPUt/6gnt4CJKvMj4AluDhjUtAjLkzcop
	W4GvaAOA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u0BTO-00CMAh-1W;
	Thu, 03 Apr 2025 11:42:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 03 Apr 2025 11:42:34 +0800
Date: Thu, 3 Apr 2025 11:42:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Banning crypto in hardirq context (was: [PATCH v2 0/9] crypto: x86 -
 stop using the SIMD helper)
Message-ID: <Z-4DqsRApwQi6Xju@gondor.apana.org.au>
References: <20250402002420.89233-1-ebiggers@kernel.org>
 <Z-yrf_9D2rV1Q136@gondor.apana.org.au>
 <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
 <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>
 <Z-zzvXbjt3xzquXb@gondor.apana.org.au>
 <20250402171930.GD1235@sol.localdomain>
 <Z-3jkYNtZpTDtKGf@gondor.apana.org.au>
 <20250403021453.GA2872965@google.com>
 <Z-344xAsx1uTE9OK@gondor.apana.org.au>
 <20250403032008.GA129577@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403032008.GA129577@sol.localdomain>

On Wed, Apr 02, 2025 at 08:20:08PM -0700, Eric Biggers wrote:
>
> Also, riscv has scalar AES instructions.  (They aren't used by the kernel yet,
> but they could be.  The CRC code already uses scalar carryless multiplication.)

It still doesn't mean that it's a good idea to use AES in a
hard IRQ handler, especially if the code is meant to be portable.

> Also, as I said already, x86 does support SIMD instructions in hardirq context
> in some cases.  Whether anyone actually uses that, I don't know, but it is
> explicitly supported.  Check out irq_fpu_usable().

This is more of an accident than some deliberate strategy of
supporting FPU usage in hard IRQs.  This test was initially
added for aesni:

commit 54b6a1bd5364aca95cd6ffae00f2b64c6511122c
Author: Ying Huang <huang.ying.caritas@gmail.com>
Date:   Sun Jan 18 16:28:34 2009 +1100

    crypto: aes-ni - Add support to Intel AES-NI instructions for x86_64 platform

It was then improved by:

Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Feb 13 13:56:14 2012 -0800

    i387: make irq_fpu_usable() tests more robust
    
    Some code - especially the crypto layer - wants to use the x86
    FP/MMX/AVX register set in what may be interrupt (typically softirq)
    context.

At no point was there any intention of using this in a hardirq
context.

Until such a time when you have a valid application for using
lib/crypto code in a hardirq context, I don't think we should
be supporting that at the expense of real users who are in
process/softirq context only.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
