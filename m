Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3273BFE41;
	Fri, 15 May 2026 10:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840084; cv=none; b=Pkn1jaUVyv65rU0Sx57WBBj5rZOV7et6vX2ZiLDUSiDi+5150VIPkVBxikrqWyw46TQT6goxycHehYbPmJhUz4ZxGqsrx/pnQ4XGQVky1znwDKv/EwgZpyD08a9tIunPVbyj5VJPoIj4GPRC2lnKv7fCHnV1PgJbKU6NY7/Oq7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840084; c=relaxed/simple;
	bh=DY9gKKN29EbG47krUzjoFi3mWtNloae+Lm97wR4Sd3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f2hGr0mpOlbHUdTXj4g2kdSWQYD4wxf8TldHpdtcctGMPstc3HXSx1WTBMAqoHoVQPx4j/wJZiBS0E4JLe2BZwsbuRzxMb00ACtVmDM8n8QkCueNuxckdj7k5Sb+eeJ7HfM4vWyUOCbRZrMq3hbvF+BEj16+knf8LDRTpOBi2qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Er2FRt1G; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Er2FRt1G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=HAvF5lerxu88C7QmGx3oLiiL8UrLhhkEzdirT6110bc=; 
	b=Er2FRt1GbnzRl0J+MmkyXtcoFKo8YDOxIkIMRVKi+mXrwpdey5nu8Fft9l8aObFVM7A7MMNIi+u
	xgo5A3MnAtlwaCBE8WH9trDKFklkWXfWqfdl30lQwbXBl62giItGOZQmuZ1pCe7rqCA2uFxuez2Tv
	NkXkriRcF8IKnqpttFHAFunOnu8OWEJxhMHAVFzS0xxjjvd7bj11hNGzGmAcIhI9w/zniGMSyT44Q
	DDPEyb2qWGArnahNDbiXyjXIvF9OXdIc0QxnS2vWsazXtanGlu6Sb+TBzXvXXcWNzqs4x4HuMuqxY
	T3I/4rbB1WjYRYZAT0woFuC1r1SUGwPN++Ww==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpYw-00EOJ5-1u;
	Fri, 15 May 2026 18:14:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:14:34 +0800
Date: Fri, 15 May 2026 18:14:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sean Christopherson <seanjc@google.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: Treat zero-length cert chain as query for
 blob lengths
Message-ID: <agbyCoTIGkx5Lvlc@gondor.apana.org.au>
References: <20260504222812.2339526-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504222812.2339526-1-seanjc@google.com>

On Mon, May 04, 2026 at 03:28:12PM -0700, Sean Christopherson wrote:
> When handling a PDH export, treat a zero-length userspace cert chain buffer
> as a request to query the length of the relevant blobs.  Failure to account
> for the zero-length buffer trips a BUG_ON() when running with
> CONFIG_DEBUG_VIRTUAL=y due to trying to get the physical address of the
> ZERO_SIZE_PTR (returned by kzalloc() on the bogus allocation).
> 
>    kernel BUG at arch/x86/mm/physaddr.c:28 !
>   Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>   CPU: 30 UID: 0 PID: 28580 Comm: syz.2.18 Kdump: loaded
>   Tainted: G        W           6.18.16-smp-DEV #1 NONE
>   Tainted: [W]=WARN
>   Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 12.62.0-0 11/19/2025
>    RIP: 0010:__phys_addr+0x16a/0x180 arch/x86/mm/physaddr.c:28
>   RSP: 0018:ffffc9008329fc80 EFLAGS: 00010293
>   RAX: ffffffff8179110a RBX: 0000778000000010 RCX: ffff8884e6992600
>   RDX: 0000000000000000 RSI: 0000000080000010 RDI: 0000778000000010
>   RBP: ffffc9008329fdf0 R08: 0000000000000dc0 R09: 00000000ffffffff
>   R10: dffffc0000000000 R11: fffffbfff126d297 R12: dffffc0000000000
>   R13: 1ffff92010653fc8 R14: 0000000080000010 R15: dffffc0000000000
>   FS:  0000555556bec9c0(0000) GS:ffff88aa4ce1c000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007fd3159e7000 CR3: 00000004fbc44000 CR4: 0000000000350ef0
>   Call Trace:
>    <TASK>
>     [<ffffffff853d3869>] sev_ioctl_do_pdh_export+0x559/0x7a0 drivers/crypto/ccp/sev-dev.c:2308
>     [<ffffffff853d1fdd>] sev_ioctl+0x2cd/0x480 drivers/crypto/ccp/sev-dev.c:2556
>     [<ffffffff82549ebc>] vfs_ioctl fs/ioctl.c:52 [inline]
>     [<ffffffff82549ebc>] __do_sys_ioctl fs/ioctl.c:598 [inline]
>     [<ffffffff82549ebc>] __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:584
>     [<ffffffff8630115f>] do_syscall_x64 arch/x86/entry/syscall_64.c:64 [inline]
>     [<ffffffff8630115f>] do_syscall_64+0x9f/0xf40 arch/x86/entry/syscall_64.c:98
>    [<ffffffff81000136>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   RIP: 0033:0x7fd3158eac39
>    </TASK>
> 
> Thankfully, the bug is benign outside of CONFIG_DEBUG_VIRTUAL=y as getting
> the physical address is just arithmetic, and the PSP errors out before
> trying to write to the garbage address (which it must, otherwise querying
> the blob lengths would clobber memory at pfn=0).
> 
> Fixes: 76a2b524a4b1 ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
