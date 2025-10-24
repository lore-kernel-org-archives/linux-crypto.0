Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BC01F03EF;
	Fri, 24 Oct 2025 16:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761322361; cv=none; b=qG6DRfiIwVfAAE3N6n6lwPaUeaLxN+LbPd2tVUDgNLLEau+pAALtk+CW0aBqp5nxavrFuKFsqm2HBsZXn1YpG5MSXliODT9JsEBYFwuzA0EOacGkss2R6o/mRkiA+hAn4hZvfM3QyMasZnwFNFKMDqx8Ab7BOy1H/77d9WM+JE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761322361; c=relaxed/simple;
	bh=AgIAmESWORBI743pPlnGau/twRBNqMq3B6l0KP2QzWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ich09Azhq/lKnCNYgQ4rd3PHbcs69bMdKsgzBvDkd2n6FvUktMCsCd9zz110Uh7JC5etf1SietN5ka93g4ffu5luIw3NnuuSi51wZrnPdUGsk8hAdUND7bRnbnuYiq3gKibbMJKR7ABiT0C80A+YAWJIROhXtuR1FAK/u+J77NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOkBQ5f7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOkBQ5f7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE54C4CEF1;
	Fri, 24 Oct 2025 16:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761322360;
	bh=AgIAmESWORBI743pPlnGau/twRBNqMq3B6l0KP2QzWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YOkBQ5f7Dr/XsiEWN/JkH4z9N7DMbQEbtCibxABl0RTMSqRIQkLrSgcP8q9cLv4bi
	 /TQA8iXjjnmOdbX37TCgeV9iOOPDtFQrcjOkT3H9xX06V47c/vCEt07+14bSQ1Vh4O
	 k0ZzT36OYIZQB7kZIRT47+4RdqovVyYUmszSZOVK3j/zKNEDDjBkJ5R4qeXmtQzxTj
	 nEUJ1elKxEdABRdllOOvHzRUpynm4yLfHcsMXsAMIURaelEF5XT2gHF4jxxGjL7gOY
	 9A8q/9TzjaOEiztTyzx9rpP8x34LDRAJ8hek4YCcY7owg0JzxLNo72NOmluo678Jvw
	 tmjvxMxE3LyKw==
Date: Fri, 24 Oct 2025 09:11:05 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Holger Dengler <dengler@linux.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 15/17] lib/crypto: s390/sha3: Migrate optimized code into
 library
Message-ID: <20251024161105.GA1625@sol>
References: <20251020005038.661542-1-ebiggers@kernel.org>
 <20251020005038.661542-16-ebiggers@kernel.org>
 <51fc91b6-3a6e-44f7-ae93-aef0bcb48964@linux.ibm.com>
 <20251020175736.GC1644@sol>
 <29e766ca-54e4-453d-9dfc-ea47e2a1f860@linux.ibm.com>
 <5895ed68-dd6e-4f3d-9e6f-c27459556ff7@linux.ibm.com>
 <20251021154906.GB83624@google.com>
 <b9094694cb5bc3ec0f479f3c6df909c9@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9094694cb5bc3ec0f479f3c6df909c9@linux.ibm.com>

On Fri, Oct 24, 2025 at 04:24:00PM +0200, Harald Freudenberger wrote:
> On 2025-10-21 17:49, Eric Biggers wrote:
> > On Tue, Oct 21, 2025 at 10:43:00AM +0200, Holger Dengler wrote:
> > > Hi Eric,
> > > 
> > > On 21/10/2025 09:24, Holger Dengler wrote:
> > > > On 20/10/2025 19:57, Eric Biggers wrote:
> > > [...]>> - Risk of bugs.  QEMU doesn't support the s390 SHA-3
> > > instructions, so no
> > > >>   one except the s390 folks can test the code.  I can try to write code
> > > >>   for you, but I can't test it.  And the s390 SHA-3 code has had bugs;
> > > >>   see commits 992b7066800f, 68279380266a5, 73c2437109c3.
> > > >>
> > > >>   The first priority should be correctness.
> > > >
> > > > Let me figure out, if me and my colleagues can do the testing for you.
> > > > Unfortunately, I'll be unavailable for the next two weeks. But I'll come back
> > > > with a solution for the testing.
> > > 
> > > I talked to Harald: we can do the testing for you on our development
> > > machines.
> > > Please send new series to us or provide them in your git repo.
> > 
> > Thanks!  I'll Cc both of you on v2 when I send it later.  For now, this
> > series (v1) can be found in lore at
> > https://lore.kernel.org/linux-crypto/20251020005038.661542-1-ebiggers@kernel.org/T/#u
> > And as mentioned in the cover letter it's also retrievable from git:
> > 
> >     git fetch
> > https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> > sha3-lib-v1
> > 
> > v1 already has the s390 optimized implementations of
> > sha3_absorb_blocks() and sha3_keccakf().  If you could enable the
> > following:
> > 
> >     CONFIG_CRYPTO_LIB_SHA3_KUNIT_TEST=y
> >     CONFIG_CRYPTO_LIB_BENCHMARK=y
> > 
> > ... and then show the results for sha3_kunit before and after the commit
> > "lib/crypto: s390/sha3: Migrate optimized code into library", that would
> > be helpful.
> > 
> > In v2, I'll look into providing overrides for the one-shot functions
> > sha3_{224,256,384,512}() too.  If it works out, I'll ask you to re-test
> > with that additional change as well.
> > 
> > - Eric
> 
> I pulled your repository and checked out the branch sha3-lib-v1 and
> while the kernel build runs I get link errors:
> 
> ld: crypto/sha3.o: in function `crypto_sha3_512_digest':
> /root/ebiggers-linux/crypto/sha3.c:80:(.text+0xaa): undefined reference to
> `sha3_512'
> ld: crypto/sha3.o: in function `crypto_sha3_384_digest':
> /root/ebiggers-linux/crypto/sha3.c:73:(.text+0xea): undefined reference to
> `sha3_384'
> ld: crypto/sha3.o: in function `crypto_sha3_256_digest':
> /root/ebiggers-linux/crypto/sha3.c:66:(.text+0x12a): undefined reference to
> `sha3_256'
> ld: crypto/sha3.o: in function `crypto_sha3_224_digest':
> /root/ebiggers-linux/crypto/sha3.c:59:(.text+0x1aa): undefined reference to
> `sha3_224'
> ld: crypto/sha3.o: in function `sha3_final':
> /root/ebiggers-linux/./include/crypto/sha3.h:188:(.text+0x1f0): undefined
> reference to `__sha3_squeeze'
> ld: crypto/sha3.o: in function `sha3_update':
> /root/ebiggers-linux/./include/crypto/sha3.h:172:(.text+0x232): undefined
> reference to `__sha3_update'
> 
> with a s390 defconfig kernel configuration an a s390 debug_defconfig kernel
> configuration.

Yes, as mentioned elsewhere in the thread the following fixup is needed:

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a04595f9d0ca4..0ff68212cb20a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1005,6 +1005,7 @@ config CRYPTO_SHA512
 config CRYPTO_SHA3
 	tristate "SHA-3"
 	select CRYPTO_HASH
+	select CRYPTO_LIB_SHA3
 	help
 	  SHA-3 secure hash algorithms (FIPS 202, ISO/IEC 10118-3)
 
I'll fix that in v2.

But also note that if you enable the KUnit test as I suggested then this
error gets avoided too, since it selects the library.  (That's why I
didn't notice it before sending -- I always had the KUnit test enabled.)

- Eric
