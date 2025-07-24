Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077AE61FFE;
	Thu, 24 Jul 2025 16:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753374425; cv=none; b=M3HE+D640g0435a26iOFUEV+qg6MZo3VtWGCfawT26sf8hxJ2z1KXw47JL/yeIC89YYZz62XQ+4q8+kDJYodA6tt5y2cX1qNcQHkgs6+LfbuHu0fWSF8K3uk5Ktwhg0v74MYBj5x2p4qF/CToMvjTWnzRVUUlBuJFrhBah9TAGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753374425; c=relaxed/simple;
	bh=ZLtKDlw4HklFwl3H1eJr2MOPUF9UxNKbvY/yxo23DK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yv0a/UeUIp+RYikEPHk9cjgsKH7+W4sQKEHi3p9OViIRhQ748As3vCVTg4O5Bm3sqjjyzD0oqrgFUxw04wFEOwFXNPVq63boANZvqdzR3DDXnKAKwY347m8yhrvTHPXtWeKkzbLtKpbDNmhLNUPYsLJPTfJiFh/d3ZCwRxLdtc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dYr1vird; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dYr1vird"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E02C4CEED;
	Thu, 24 Jul 2025 16:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753374424;
	bh=ZLtKDlw4HklFwl3H1eJr2MOPUF9UxNKbvY/yxo23DK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dYr1virdGmGHb3VJfXGh/qNDIRcEeJU+lYxFQ6pMvqTyAXSTGns2W8AidS4uXBcad
	 aDoQTrdZmHcs0xyBI0+AgOXQNORicLLceT9AvMwpHZUvAb1xNNfz9Hk2stp4FZxbLE
	 3q/Hr4a2V7UV84CWfHGgVvUbB8BZvH51Tp7j/fSvc/rQx/Aqe3tW4fXocIAk+AN+3T
	 Nm5e4qE/1pVUIyPARN69yTH7k+yZXeQac5sLAu8ziGADAamsHPSBJIqYeO4+6hppJh
	 +LeDEboVWT9ALCd1RRiUctiWrfsoVC3lm5rEgEFcdeMy0c05tAc1T+CO68/Bs4OohR
	 DBw3LUofwjmVQ==
Date: Thu, 24 Jul 2025 09:26:15 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: tests: Annotate worker to be on stack
Message-ID: <20250724162615.GA26800@sol>
References: <20250721231917.3182029-1-linux@roeck-us.net>
 <20250722031603.GA1298@sol>
 <a534e0ad-35db-45f5-a1c9-9bd34cd3dafd@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a534e0ad-35db-45f5-a1c9-9bd34cd3dafd@roeck-us.net>

On Thu, Jul 24, 2025 at 07:19:00AM -0700, Guenter Roeck wrote:
> On Mon, Jul 21, 2025 at 08:16:03PM -0700, Eric Biggers wrote:
> > On Mon, Jul 21, 2025 at 04:19:17PM -0700, Guenter Roeck wrote:
> > > The following warning traceback is seen if object debugging is enabled
> > > with the new crypto test code.
> > > 
> > > ODEBUG: object 9000000106237c50 is on stack 9000000106234000, but NOT annotated.
> > > ------------[ cut here ]------------
> > > WARNING: lib/debugobjects.c:655 at lookup_object_or_alloc.part.0+0x19c/0x1f4, CPU#0: kunit_try_catch/468
> > > ...
> > > 
> > > This also results in a boot stall when running the code in qemu:loongarch.
> > > 
> > > Initializing the worker with INIT_WORK_ONSTACK() fixes the problem.
> > > 
> > > Cc: Eric Biggers <ebiggers@kernel.org>
> > > Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > ---
> > >  lib/crypto/tests/hash-test-template.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next
> > 
> 
> Unfortunately it turns out that this is insufficient and/or that there
> are more problems. With this patch applied and the ext4 unit test crash
> fixed in next-20250724, I now see the following crash. I'll try to bisect.
> 
> Guenter
> 
> ---
> [    9.683061]     KTAP version 1
> [    9.683116]     # Subtest: poly1305
> [    9.683160]     # module: poly1305_kunit
> [    9.683391]     1..12
> [    9.686210] BUG: unable to handle page fault for address: ffff923a00a09000
> [    9.686349] #PF: supervisor read access in kernel mode
> [    9.686399] #PF: error_code(0x0000) - not-present page
> [    9.686517] PGD 1000067 P4D 1000067 PUD 1291067 PMD 3248067 PTE 0
> [    9.686694] Oops: Oops: 0000 [#1] SMP PTI
> [    9.686957] CPU: 0 UID: 0 PID: 565 Comm: kunit_try_catch Tainted: G                 N  6.16.0-rc7-next-20250724-00001-ga9d31cee9308 #1 PREEMPT(voluntary) 
> [    9.687093] Tainted: [N]=TEST
> [    9.687126] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [    9.687264] RIP: 0010:poly1305_blocks_avx2+0x47c/0x780
> [    9.687352] Code: bd f4 f3 c5 bd f4 d4 c5 7a 6f 46 10 c5 25 d4 de c5 1d d4 e2 c5 fd 6f 50 10 c5 b5 f4 f1 c5 35 f4 c8 c5 0d d4 f6 c4 41 15 d4 e9 <c4> 63 3d 38 46 30 01 48 8d 76 40 c5 ed f4 f1 c5 ed f4 d0 c5 b5 73
> [    9.687509] RSP: 0000:ffff923a009fba00 EFLAGS: 00010202
> [    9.687565] RAX: ffff923a009fba90 RBX: 0000000000001000 RCX: ffffffffb36df180
> [    9.687624] RDX: 0000000000000040 RSI: ffff923a00a08fc0 RDI: ffff923a009fbd18
> [    9.687686] RBP: 0000000000001000 R08: 0000000000000001 R09: 0000000000000000
> [    9.687744] R10: ffff923a009fbc08 R11: 0ed99de400a62f9c R12: ffff923a00a08000
> [    9.687801] R13: ffff923a009fbca8 R14: 0000000000000001 R15: 0000000000001000
> [    9.687881] FS:  0000000000000000(0000) GS:ffff8ad208a1a000(0000) knlGS:0000000000000000
> [    9.687948] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    9.687998] CR2: ffff923a00a09000 CR3: 000000001e09c000 CR4: 00000000001506f0
> [    9.688097] Call Trace:
> [    9.688183]  <TASK>
> [    9.688331]  ? __poly1305_init_avx+0x172/0x1f0
> [    9.688394]  ? kernel_fpu_begin_mask+0xa1/0xf0
> [    9.688442]  poly1305_blocks_arch+0x95/0x190
> [    9.688493]  poly1305_update+0x6e/0x150
> [    9.688534]  poly1305+0x5b/0x90
> [    9.688592]  test_hash_test_vectors+0xd1/0x1c0

That's weird.  This crash suggests that the Poly1305 assembly code read
past the end of the input data buffer, which is a type of bug the test
is designed to detect.  However, I've never gotten this crash when
running the test, even on next-20250724 and even on a CPU that uses the
poly1305_blocks_avx2() code path.

Could you provide your kconfig, in case this is kconfig dependent
somehow?

- Eric
