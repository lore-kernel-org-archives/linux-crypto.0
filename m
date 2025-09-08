Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A9031D753;
	Mon,  8 Sep 2025 18:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757357241; cv=none; b=sJ4kz21tWaU63a1ZZ8dG5IMCt6F69YZojWrZKGGCVowgkA+0VWxMkKg6tPRRwW48rx26Lzvhuoe3cWEzwSoIzSFpROIuNBEGRVB+l+2huvMuJgjP6omswO51R6DWzBAPv/ymShx9DAibFFYlGJV8lc3MJfqVU/jOwF7leat+oo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757357241; c=relaxed/simple;
	bh=AfprIgiDfWjO7Sx268c7GufyvueqCiN6g2qWiUmUJJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G23Cd1UklFM8bxQUI+3mOYXNL5DL8qyvf8c7JPmP61YwHBO5FWCJqcnGCNjTGg+QLFENwXQwqoEtKYq97v9c/oyvMQC4pAYm3NJQbqEK8sZLufMcVhIoqwEcyJ7LKOm5iE+Q5N51S15WJR1ZqLp4Wdvq/7whaxHGV0anzHBN/qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BuipKt60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BuipKt60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023AEC4CEF1;
	Mon,  8 Sep 2025 18:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757357241;
	bh=AfprIgiDfWjO7Sx268c7GufyvueqCiN6g2qWiUmUJJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BuipKt609RmQwSuA29Q/0jCMc0rhxRjDxNW1vh+KfXemm54Se8aZRGpJYguH0OAPd
	 b7VVcX7QTUNqzLrX3mB6vUOhiEaeNzxfmtbmCPPEBCvSXOe3cCge8a51GUb3JUFdbf
	 NCu6BdYq85vtUBF2CQL5TYVUpRLzPzm83ePDV2y4cbeukgNN0Gztipdy2bwKUnpGLN
	 zFZfcv/j9IUumP65wCTwXa+2YubdEGgCna/E5otvJqTWQz5V8jaZ4f54ooa4qVRSj7
	 DF8uzK06XvE808cX0ou55hSo7gKlJUPwIJmqYxS1+R0OAsgEhp434PzQDvW5L/j7xn
	 kGWDXC+ZTKp2Q==
Date: Mon, 8 Sep 2025 18:47:19 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: syzbot <syzbot+14c6a89d5f47cd26ea7a@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] general protection fault in xxh64_update
Message-ID: <20250908184719.GB189309@google.com>
References: <68bebd63.050a0220.192772.086e.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68bebd63.050a0220.192772.086e.GAE@google.com>

On Mon, Sep 08, 2025 at 04:26:27AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4ac65880ebca Add linux-next specific files for 20250904
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=12951312580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fbc16d9faf3a88a4
> dashboard link: https://syzkaller.appspot.com/bug?extid=14c6a89d5f47cd26ea7a
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16951312580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b8e962580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/36645a51612c/disk-4ac65880.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/bba80d634bef/vmlinux-4ac65880.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e58dd70dfd0f/bzImage-4ac65880.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+14c6a89d5f47cd26ea7a@syzkaller.appspotmail.com
> 
> Oops: general protection fault, probably for non-canonical address 0xe0009d1000000000: 0000 [#1] SMP KASAN PTI
> KASAN: maybe wild-memory-access in range [0x0005088000000000-0x0005088000000007]
> CPU: 0 UID: 0 PID: 6069 Comm: syz.0.32 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
> RIP: 0010:get_unaligned_le64 include/linux/unaligned.h:28 [inline]
> RIP: 0010:xxh64_update+0x55b/0xcf0 lib/xxhash.c:312

Bug in mm/gup.c that reached linux-next but has already been fixed.

#syz dup: KASAN: null-ptr-deref Read in io_sqe_buffer_register

- Eric
