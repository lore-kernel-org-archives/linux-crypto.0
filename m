Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553C8341AC1;
	Tue, 21 Oct 2025 15:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761061751; cv=none; b=Xz+v555hHELwDQ/n/gyEnxWQO3wYfwLAVHk+ocmLQShIw+0+ZGftieBkkTnvGoOGTpBKq820jYO845SildZWhb099EhWeoeBYKnTAFHA2T5YioAY7TK1Xaz0P/AidJuKniS/MMTef21eWdbnI4RwDJdKK+Vr2RIYZnMQvDW6puY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761061751; c=relaxed/simple;
	bh=OXTAf2vBKvRueTPuVWkRspJ60c2GrNw29sEA1D0jzFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eve9YK0ebmcWvJVPjqc/cS/zkJS3z03JpiLHUSXb7iHwoJklapJQnZBLliG7JDnRUDDgOoih8gfoQLEy6lIX1nJqy1W/Kon+OGIfJZ+Z9SO104Rka44GeXHViPTBBCNwjcfL1S188voXPygBtyJ6uEd2mhI+xfjvxuZPbe/B3Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l6ZGKHQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6ZGKHQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742C7C4CEF1;
	Tue, 21 Oct 2025 15:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761061748;
	bh=OXTAf2vBKvRueTPuVWkRspJ60c2GrNw29sEA1D0jzFA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l6ZGKHQ6L8Im05FB+cDihH7NFZlsTQicV4UGwn8Imqxk7IiFyNBjRzw826sEI7+Y8
	 pCZRF+q1by0a+vbrJH9pbWZlou32hv6rX5iO7GmWQWU3br7ZRBeyN/S513d0fN11pU
	 QhIE3U6+IjVDcQpkkHcKQcL6wnpM+1rQJVgniuKcrckkuFlONKu9BDXBEnHxN+9aK6
	 Up/QozBsJE0ZdUF2vhZMVCefUw13O2Kaw44hRW6ZRq+NRc1R9jqaUely9y6rvlPbc7
	 L1BEA8+DDiWCsd5VYe/WzrdNqEEB2ZapqLk4AQ5rpQknltDN3oBgM6s6YwpTgCz6bY
	 BSDlps4L5HedQ==
Date: Tue, 21 Oct 2025 15:49:06 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 15/17] lib/crypto: s390/sha3: Migrate optimized code into
 library
Message-ID: <20251021154906.GB83624@google.com>
References: <20251020005038.661542-1-ebiggers@kernel.org>
 <20251020005038.661542-16-ebiggers@kernel.org>
 <51fc91b6-3a6e-44f7-ae93-aef0bcb48964@linux.ibm.com>
 <20251020175736.GC1644@sol>
 <29e766ca-54e4-453d-9dfc-ea47e2a1f860@linux.ibm.com>
 <5895ed68-dd6e-4f3d-9e6f-c27459556ff7@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5895ed68-dd6e-4f3d-9e6f-c27459556ff7@linux.ibm.com>

On Tue, Oct 21, 2025 at 10:43:00AM +0200, Holger Dengler wrote:
> Hi Eric,
> 
> On 21/10/2025 09:24, Holger Dengler wrote:
> > On 20/10/2025 19:57, Eric Biggers wrote:
> [...]>> - Risk of bugs.  QEMU doesn't support the s390 SHA-3 instructions, so no
> >>   one except the s390 folks can test the code.  I can try to write code
> >>   for you, but I can't test it.  And the s390 SHA-3 code has had bugs;
> >>   see commits 992b7066800f, 68279380266a5, 73c2437109c3.
> >>
> >>   The first priority should be correctness.
> > 
> > Let me figure out, if me and my colleagues can do the testing for you.
> > Unfortunately, I'll be unavailable for the next two weeks. But I'll come back
> > with a solution for the testing.
> 
> I talked to Harald: we can do the testing for you on our development machines.
> Please send new series to us or provide them in your git repo.

Thanks!  I'll Cc both of you on v2 when I send it later.  For now, this
series (v1) can be found in lore at
https://lore.kernel.org/linux-crypto/20251020005038.661542-1-ebiggers@kernel.org/T/#u
And as mentioned in the cover letter it's also retrievable from git:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git sha3-lib-v1

v1 already has the s390 optimized implementations of
sha3_absorb_blocks() and sha3_keccakf().  If you could enable the
following:

    CONFIG_CRYPTO_LIB_SHA3_KUNIT_TEST=y
    CONFIG_CRYPTO_LIB_BENCHMARK=y

... and then show the results for sha3_kunit before and after the commit
"lib/crypto: s390/sha3: Migrate optimized code into library", that would
be helpful.

In v2, I'll look into providing overrides for the one-shot functions
sha3_{224,256,384,512}() too.  If it works out, I'll ask you to re-test
with that additional change as well.

- Eric

