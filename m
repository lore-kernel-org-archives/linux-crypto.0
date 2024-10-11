Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420352141A6;
	Fri, 11 Oct 2024 10:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728643053; cv=none; b=iztNM3uhDmuoF8kmfdgX2q0FVidUZKPl+bnDnIZeegoKAlNwyeYSr/vQhGntJzsTQTpZKuS3lYGfNXr5XcWMeYJ9o/KIsJAhxteaxdQ7OH1DSfND66hOi0w6g3hsunkzrFQOAFQAbihA/+m+A3hyLRo56+KbQFYiM8dBTvVygwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728643053; c=relaxed/simple;
	bh=TNWBq93GF4E1/XgY52ihtX4etSNNjRQUHT+/2cQ6Lsc=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=m98TMUb2Bl/82vVANtXOmCzNW0wqURMwmxDslViutfFRpabyTs+PRjbTZBx741wYd0hrSEs6wLTh+BpI/xADU7ktgt8mnhOWl/aJnIELk2ejedWepEaHL0IR/OeRX+ibvMsNPAlUSdepuIenid0tlwuwnmsO43Vp3re7yKTl9rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=WUgf2/bb; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="WUgf2/bb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1728643048;
	bh=eOi3s+J0p0Rr7NAS8srzm60cAmwu+YPFf/AT7DlY+X8=;
	h=From:To:Subject:In-Reply-To:References:Date:From;
	b=WUgf2/bb4LJatYWiCY0XLpmV+rffzesMAMwfAp+YUuDAt+gw8tmvFrHHligqdjw+P
	 1y6Ojs9+pdHT4uZkufk1le3fg1mT7JbaNGFbHUeyO4yAAKUcnNoJMPw3Rv/+R1Lhit
	 EuyLZ030ahnxk2KmT0gobRrhlZfulQpeknqSX6Kgksztt6dVQuH041aS6/lqN7B9Aw
	 Kl8bv+fmXaiKhELzxjBrbqNFuYazHeuvGSdcvEy8+B4d3PKudLDy/V8rG79rwHvA8M
	 bOPe4KnsdWkJ5xS1/Aiwci1Kg3ermDpe0crFL/nuJXEOWZkZUwpDubni3AuBmYHsxs
	 V9tVmx9/1XSsA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XQ33V63y8z4xN6;
	Fri, 11 Oct 2024 21:37:26 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Vishal Chourasia <vishalc@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, Nicholas Piggin <npiggin@gmail.com>, Christophe
 Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: drivers/nx: Invalid wait context issue when rebooting
In-Reply-To: <ZwjjXJ5UtZ28FH6s@linux.ibm.com>
References: <ZwjjXJ5UtZ28FH6s@linux.ibm.com>
Date: Fri, 11 Oct 2024 21:37:27 +1100
Message-ID: <87wmif53iw.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Vishal Chourasia <vishalc@linux.ibm.com> writes:
> Hi,
> I am getting Invalid wait context warning printed when rebooting lpar
>
> kexec/61926 is trying to acquire `of_reconfig_chain.rwsem` while holding
> spinlock `devdata_mutex`
>
> Note: Name of the spinlock is misleading.

Oof, yeah let's rename that to devdata_spinlock at least.

> In my case, I compiled a new vmlinux file and loaded it into the running
> kernel using `kexec -l` and then hit `reboot`
>
> dmesg:
> ------
>
> [ BUG: Invalid wait context ]
> 6.11.0-test2-10547-g684a64bf32b6-dirty #79 Not tainted

Is that v6.11 plus ~10,000 patches? O_o

Ah no, 684a64bf32b6 is roughly v6.12-rc1. Maybe if you fetch tags into
your tree you will get a more sensible version string?

Could also be good to try v6.12-rc2.

> -----------------------------
> kexec/61926 is trying to lock:
> c000000002d8b590 ((of_reconfig_chain).rwsem){++++}-{4:4}, at: blocking_notifier_chain_unregister+0x44/0xa0
> other info that might help us debug this:
> context-{5:5}
> 4 locks held by kexec/61926:
>  #0: c000000002926c70 (system_transition_mutex){+.+.}-{4:4}, at: __do_sys_reboot+0xf8/0x2e0
>  #1: c00000000291af30 (&dev->mutex){....}-{4:4}, at: device_shutdown+0x160/0x310
>  #2: c000000051011938 (&dev->mutex){....}-{4:4}, at: device_shutdown+0x174/0x310
>  #3: c000000002d88070 (devdata_mutex){....}-{3:3}, at: nx842_remove+0xac/0x1bc
  
That's pretty conclusive.

I don't understand why you're the first person to see this. I can't see
that any of the relevant code has changed recently. Unless something in
lockdep itself changed?

Did you just start seeing this on recent kernels? Can you bisect?

> stack backtrace:
> CPU: 2 UID: 0 PID: 61926 Comm: kexec Not tainted 6.11.0-test2-10547-g684a64bf32b6-dirty #79
> Hardware name: IBM,9080-HEX POWER10 (architected) 0x800200 0xf000006 of:IBM,FW1060.00 (NH1060_012) hv:phyp pSeries
> Call Trace:
> [c0000000bb577400] [c000000001239704] dump_stack_lvl+0xc8/0x130 (unreliable)
> [c0000000bb577440] [c000000000248398] __lock_acquire+0xb68/0xf00
> [c0000000bb577550] [c000000000248820] lock_acquire.part.0+0xf0/0x2a0
> [c0000000bb577670] [c00000000127faa0] down_write+0x70/0x1e0
> [c0000000bb5776b0] [c0000000001acea4] blocking_notifier_chain_unregister+0x44/0xa0
> [c0000000bb5776e0] [c000000000e2312c] of_reconfig_notifier_unregister+0x2c/0x40
> [c0000000bb577700] [c000000000ded24c] nx842_remove+0x148/0x1bc
> [c0000000bb577790] [c00000000011a114] vio_bus_remove+0x54/0xc0
> [c0000000bb5777c0] [c000000000c1a44c] device_shutdown+0x20c/0x310
> [c0000000bb577850] [c0000000001b0ab4] kernel_restart_prepare+0x54/0x70
> [c0000000bb577870] [c000000000308718] kernel_kexec+0xa8/0x110
> [c0000000bb5778e0] [c0000000001b1144] __do_sys_reboot+0x214/0x2e0
> [c0000000bb577a40] [c000000000032f98] system_call_exception+0x148/0x310
> [c0000000bb577e50] [c00000000000cedc] system_call_vectored_common+0x15c/0x2ec

I don't see why of_reconfig_notifier_unregister() needs to be called
with the devdata_mutext held, but I haven't looked that closely at it.

So the change below might work.

cheers

diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index 35f2d0d8507e..a2050c5fb11d 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -1122,10 +1122,11 @@ static void nx842_remove(struct vio_dev *viodev)
 
 	crypto_unregister_alg(&nx842_pseries_alg);
 
+	of_reconfig_notifier_unregister(&nx842_of_nb);
+
 	spin_lock_irqsave(&devdata_mutex, flags);
 	old_devdata = rcu_dereference_check(devdata,
 			lockdep_is_held(&devdata_mutex));
-	of_reconfig_notifier_unregister(&nx842_of_nb);
 	RCU_INIT_POINTER(devdata, NULL);
 	spin_unlock_irqrestore(&devdata_mutex, flags);
 	synchronize_rcu();

