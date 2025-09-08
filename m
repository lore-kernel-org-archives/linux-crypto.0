Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E6531C57A;
	Mon,  8 Sep 2025 18:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757357216; cv=none; b=qa3i5NNzz4r1auHEz16SMpG7S5WEKdnR0vmnefuxPeVLbjulSPSUirZEGzD3kzHbi8GXJB+brIQxQtuIYd5dX0WmJtP8qVKjjpwxSqLB4qCPX1T1I6BjAxuvPyPNeQJ+Tb23+iehakR7IMx5QklVznI+HitRfhDteUeW9Lgig1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757357216; c=relaxed/simple;
	bh=lWrX8v3qhClvWrF4+LpNXM1Zm/q0IjQqBopenNyN1OA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWBlLcTwQq+uwn9obIJKobu/rD1m2+pE0QfidII/tekhrN8TtofJqIh4wQx8N0P3xzCardliO69eqLRxDCN9mhVjFpffaN/3AeH/ZOnPttm3pdMPrj4a9mCbC64cqslQnzrLSr/DIV0v8neA4RRycUIGwJMXfBrSaGJPo6xezqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hR7awyIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hR7awyIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C74C4CEF1;
	Mon,  8 Sep 2025 18:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757357215;
	bh=lWrX8v3qhClvWrF4+LpNXM1Zm/q0IjQqBopenNyN1OA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hR7awyIR/XImRPw6aYPSI0xEWmj5BVAjHmdnlCkO3YcTfSNgYC+EBdQCWNa29z6qk
	 /D2Q7T2LS5SQ84K6Dc5H2SlC4RorAwu6O7d5jJB3fMfR4+AjUSdQ+zaBESyDDuid4z
	 0Z47/jZOXj6vMbPWqbD7UvM8HYrEArjm327HXOKNwo0GqbcV3RthySUlnH7L0V34bO
	 iMJ8fGye/IF3Lhi4yL84ziPz59J/Gv9hwc1UkbJMbxloNQ4dEGyp8nNEwH3OkxiWpo
	 n947C4jcTKYQlOOUmieqGNniIlU6FPlL8nBlaI7g03Kso8eFB9RhCdtRNyGNfWGfzm
	 +JfZ5gyJgrXiw==
Date: Mon, 8 Sep 2025 18:46:53 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: syzbot <syzbot+e37eedd918576774ec80@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] KASAN: wild-memory-access Read in
 __sha512_update
Message-ID: <20250908184653.GA189309@google.com>
References: <68beb07f.050a0220.192772.086a.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68beb07f.050a0220.192772.086a.GAE@google.com>

On Mon, Sep 08, 2025 at 03:31:27AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4ac65880ebca Add linux-next specific files for 20250904
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=11136312580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1220fefb3f11f346
> dashboard link: https://syzkaller.appspot.com/bug?extid=e37eedd918576774ec80
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15136312580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e23e62580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/17aafe2d8f53/disk-4ac65880.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/09caead80fb0/vmlinux-4ac65880.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b33c041f8dc2/bzImage-4ac65880.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e37eedd918576774ec80@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: wild-memory-access in __sha512_update+0x10d/0x1d0 lib/crypto/sha512.c:175
> Read of size 2 at addr 0005088000000000 by task syz.0.17/6022

Bug in mm/gup.c that reached linux-next but has already been fixed.

#syz dup: KASAN: null-ptr-deref Read in io_sqe_buffer_register

- Eric
