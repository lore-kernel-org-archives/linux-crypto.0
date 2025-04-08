Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96531288CC
	for <linux-crypto@vger.kernel.org>; Tue,  8 Apr 2025 15:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744127076; cv=none; b=J9z382vFWmZFcJinuOd3Kd/+PCI0Tc02eHRAq93D99xzSQBTw8/i7VUZnmPU/gxLkKxshKdPKTs/JeiLuVz2f0iyDtESajiit1S6+u0kBCOdIbIYQrtN7abEkZcBS7Xl0hKT8bWzMNfQCcXPvaitZ53urdIiiZuGLxChZImO/AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744127076; c=relaxed/simple;
	bh=QfGk+St/BZffAHCW4HDfe5HEDvaTBOAzxOV4lsHRr0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rN7yJmgGERmHUrEQmPOsIAybWkWhShpaHXU4HF3oa7b4RX7sfentEEsFopeHNXGTPVwkKVIdhs/kPM9bBu5Axfd46iiL2Z0N7ofE0ZNMStCzFDXqkzbvvq31lji4BP8a8NeLj6A3DQ7x2oYV110eUZOjM6E+V97AK0OwO/zI56I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hzOZ+kir; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hzOZ+kir"
Message-ID: <e3dd2f83-8451-47b0-a774-a697b861ceb3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744127071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CXIB70x15AbBHta+hdOaQKeCOzWFxSv/4pSccU8QyVI=;
	b=hzOZ+kirYJdW7t5lmthYieBgPmWxykReVBb9M2SclS56LGDgRzbEdXLEtM19BNKqvdoXK6
	5nJCh1NEmw4j17SDwUS6PU34cMtZgpeHaSStE9cceXlkMcPSUaLTI6tptkWNnWFf+S3Nd6
	iuHS4bF47J4lVDGiHWuidOFaL2HWpxs=
Date: Tue, 8 Apr 2025 11:44:27 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] crypto: caam/qi - Fix drv_ctx refcount bug
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
 Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>,
 linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 linux-kernel@vger.kernel.org,
 Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>
References: <17f9af67-de10-4b96-99ef-3c5cd78124c0@linux.dev>
 <Z_SxYFdyBJTYe_7G@gondor.apana.org.au>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Sean Anderson <sean.anderson@linux.dev>
In-Reply-To: <Z_SxYFdyBJTYe_7G@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 4/8/25 01:17, Herbert Xu wrote:
> On Mon, Apr 07, 2025 at 07:16:38PM -0400, Sean Anderson wrote:
>>
>> [    2.731344] refcount_t: decrement hit 0; leaking memory.
> 
> ...
> 
>> [    2.731496] caam_rsp_fq_dqrr_cb (include/linux/refcount.h:336 include/linux/refcount.h:351 drivers/crypto/caam/qi.c:593) 
>> [    2.731502] qman_p_poll_dqrr (drivers/soc/fsl/qbman/qman.c:1652 drivers/soc/fsl/qbman/qman.c:1759) 
>> [    2.731510] caam_qi_poll (drivers/crypto/caam/qi.c:491) 
>> [    2.731514] __napi_poll (net/core/dev.c:7328) 
>> [    2.731520] net_rx_action (net/core/dev.c:7394 net/core/dev.c:7514) 
>> [    2.731524] handle_softirqs (arch/arm64/include/asm/jump_label.h:36 include/trace/events/irq.h:142 kernel/softirq.c:562) 
>> [    2.731530] __do_softirq (kernel/softirq.c:596) 
>> [    2.731533] ____do_softirq (arch/arm64/kernel/irq.c:82) 
>> [    2.731538] call_on_irq_stack (arch/arm64/kernel/entry.S:897) 
>> [    2.731542] do_softirq_own_stack (arch/arm64/kernel/irq.c:87) 
>> [    2.731547] __irq_exit_rcu (kernel/softirq.c:442 kernel/softirq.c:662) 
>> [    2.731550] irq_exit_rcu (kernel/softirq.c:681) 
>> [    2.731554] el1_interrupt (arch/arm64/kernel/entry-common.c:565 arch/arm64/kernel/entry-common.c:575) 
>> [    2.731561] el1h_64_irq_handler (arch/arm64/kernel/entry-common.c:581) 
>> [    2.731567] el1h_64_irq (arch/arm64/kernel/entry.S:596) 
>> [    2.731570] qman_enqueue (drivers/soc/fsl/qbman/qman.c:2354) (P)
>> [    2.731576] caam_qi_enqueue (drivers/crypto/caam/qi.c:125) 
> 
> So caam_qi_enqueue hasn't had a chance to increment the refcount
> and the IRQ already came in to decrement it.  Lesson is that you
> should always increment your refcount before you give it away.
> 
> ---8<---
> Ensure refcount is raised before request is enqueued since it could
> be dequeued before the call returns.
> 
> Reported-by: Sean Anderson <sean.anderson@linux.dev>
> Cc: <stable@vger.kernel.org>
> Fixes: 11144416a755 ("crypto: caam/qi - optimize frame queue cleanup")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
> index 7701d00bcb3a..b6e7c0b29d4e 100644
> --- a/drivers/crypto/caam/qi.c
> +++ b/drivers/crypto/caam/qi.c
> @@ -122,12 +122,12 @@ int caam_qi_enqueue(struct device *qidev, struct caam_drv_req *req)
>  	qm_fd_addr_set64(&fd, addr);
>  
>  	do {
> +		refcount_inc(&req->drv_ctx->refcnt);
>  		ret = qman_enqueue(req->drv_ctx->req_fq, &fd);
> -		if (likely(!ret)) {
> -			refcount_inc(&req->drv_ctx->refcnt);
> +		if (likely(!ret))
>  			return 0;
> -		}
>  
> +		refcount_dec(&req->drv_ctx->refcnt);
>  		if (ret != -EBUSY)
>  			break;
>  		num_retries++;

Tested-by: Sean Anderson <sean.anderson@linux.dev>

However, note that the following error is still present:

[    3.294978] alg: sig: sign test failed: invalid output
[    3.300128] 00000000: 68 e4 b7 d5 2e 12 d4 9b ca a5 a7 fc 50 2f d2 f6
[    3.306573] 00000010: 6b 01 58 1e b7 72 2c 0f 66 a4 c9 1e b9 49 21 a7
[    3.313016] 00000020: 53 62 26 6d bb 69 62 a2 7e 3b 8d 80 6f 2d 21 9d
[    3.319458] 00000030: cd 6f 92 e5 a9 03 e4 b3 b0 fc e7 4f ec a7 23 5c
[    3.325902] 00000040: 1d dc 08 13 c3 2e 8b d9 fa ab e0 6f 2b a0 9d 2b
[    3.332345] 00000050: 32 47 d5 ad ec 65 5a ce b3 13 35 95 37 0e f1 b0
[    3.338788] 00000060: c3 8e 22 0d c9 a2 b3 31 58 ea 74 18 18 d2 9f 7e
[    3.345230] 00000070: 04 fe 3b f1 5e 40 6c 39 3f 38 a2 71 58 fa da 1a
[    3.351672] 00000080: ed 02 70 7c 9e 72 93 a3 66 25 f2 35 e9 82 00 49
[    3.358114] 00000090: 8e 09 b9 f0 52 76 b2 9e b4 06 b0 60 f2 15 a1 78
[    3.364556] 000000a0: 74 3c 9b 87 17 f6 e8 ff ca fe 41 ed 73 c8 28 70
[    3.370999] 000000b0: 33 cc a2 de d6 04 7a b5 85 81 a3 46 16 46 66 af
[    3.377442] 000000c0: 26 84 bc 9e 70 68 7c b3 68 44 73 4c c2 a4 70 45
[    3.383887] 000000d0: a5 af a3 b3 9c cb b5 c8 bf 7d 8a 17 97 f6 33 0c
[    3.390329] 000000e0: 94 cc d3 fd ee e7 ba 8b dc 6f c7 3b 3b 67 14 ae
[    3.396771] 000000f0: 6a 00 33 90 df c5 f9 a2 6c b8 93 f7 cf 6b 0d 0d
[    3.403214] alg: sig: test 1 failed for pkcs1(rsa-caam,sha256): err -22
[    3.409833] alg: self-tests for pkcs1(rsa,sha256) using pkcs1(rsa-caam,sha256) failed (rc=-22)
[    3.409836] ------------[ cut here ]------------
[    3.423067] alg: self-tests for pkcs1(rsa,sha256) using pkcs1(rsa-caam,sha256) failed (rc=-22)
[    3.423094] WARNING: CPU: 3 PID: 337 at crypto/testmgr.c:6012 alg_test (crypto/testmgr.c:6012 (discriminator 1)) 
[    3.439282] Modules linked in:
[    3.442334] CPU: 3 UID: 0 PID: 337 Comm: cryptomgr_test Not tainted 6.14.0-seco+ #163 NONE
[    3.450687] Hardware name: LS1046A RDB Board (DT)
[    3.455387] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    3.462349] pc : alg_test (crypto/testmgr.c:6012 (discriminator 1)) 
[    3.466008] lr : alg_test (crypto/testmgr.c:6012 (discriminator 1)) 
[    3.469667] sp : ffffffc086ebbd40
[    3.472974] x29: ffffffc086ebbd40 x28: 0000000000000000 x27: 0000000000000000
[    3.480114] x26: 00000000ffffffea x25: 00000000ffffffff x24: ffffffc082066470
[    3.487253] x23: 0000000000000159 x22: 0000000000000807 x21: ffffff8801ce2a80
[    3.494392] x20: ffffff8801ce2a00 x19: ffffffc081290df0 x18: 0000000000000000
[    3.501531] x17: 35326168732c6d61 x16: 61632d6173722831 x15: 000000000000002d
[    3.508670] x14: 0000000000000000 x13: 00000000fffffffe x12: 65742d666c657320
[    3.515808] x11: 656820747563205b x10: ffffffc081dc0640 x9 : ffffffc081d91ef8
[    3.522946] x8 : ffffffc086ebbb28 x7 : ffffffc081d91ef8 x6 : 00000000fffff7ff
[    3.530085] x5 : 00000000000001a4 x4 : 0000000000000000 x3 : 0000000000000000
[    3.537224] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffffff88023fc200
[    3.544362] Call trace:
[    3.546801] alg_test (crypto/testmgr.c:6012 (discriminator 1)) (P)
[    3.550461] cryptomgr_test (crypto/algboss.c:181) 
[    3.554122] kthread (kernel/kthread.c:464) 
[    3.557261] ret_from_fork (arch/arm64/kernel/entry.S:863) 
[    3.560833] ---[ end trace 0000000000000000 ]---

as well as another error on reboot (present before but I forgot to post it):

[   98.514208] ------------[ cut here ]------------
[   98.518823] WARNING: CPU: 3 PID: 1 at crypto/algapi.c:464 crypto_unregister_alg (crypto/algapi.c:464 (discriminator 1)) 
[   98.527100] Modules linked in:
[   98.530153] CPU: 3 UID: 0 PID: 1 Comm: systemd-shutdow Tainted: G        W          6.14.0-seco+ #163 NONE
[   98.539899] Tainted: [W]=WARN
[   98.542859] Hardware name: LS1046A RDB Board (DT)
[   98.547559] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   98.554520] pc : crypto_unregister_alg (crypto/algapi.c:464 (discriminator 1)) 
[   98.559224] lr : crypto_unregister_alg (include/linux/atomic/atomic-arch-fallback.h:457 include/linux/atomic/atomic-instrumented.h:33 include/linux/refcount.h:136 crypto/algapi.c:464) 
[   98.563926] sp : ffffffc0820dbb80
[   98.567234] x29: ffffffc0820dbb80 x28: ffffff8800160000 x27: ffffff8801787090
[   98.574374] x26: 0000000000000000 x25: ffffffc082022030 x24: 0000000000000000
[   98.581513] x23: 0000000000000001 x22: ffffffc081efa4e0 x21: ffffffc0820dbbb8
[   98.588652] x20: ffffffc081e80cc8 x19: ffffffc081f095c0 x18: 0000000000000000
[   98.595791] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000001
[   98.602929] x14: ffffff8800160080 x13: 00000000000001b6 x12: 0000000000000001
[   98.610069] x11: 0000000000000000 x10: 000000000000042c x9 : 0000000000000001
[   98.617207] x8 : ffffffc0820dbb68 x7 : ffffffc081f095d0 x6 : ffffffc0820dbb58
[   98.624346] x5 : ffffffc081f095c0 x4 : 0000000000000000 x3 : 0000000000000000
[   98.631484] x2 : ffffffffffffffff x1 : 0000000000000001 x0 : 0000000000000002
[   98.638623] Call trace:
[   98.641062] crypto_unregister_alg (crypto/algapi.c:464 (discriminator 1)) (P)
[   98.645765] crypto_unregister_rng (crypto/rng.c:188) 
[   98.650035] caam_prng_unregister (drivers/crypto/caam/caamprng.c:207) 
[   98.654216] caam_jr_remove (drivers/crypto/caam/jr.c:59 drivers/crypto/caam/jr.c:207) 
[   98.657963] platform_shutdown (drivers/base/platform.c:1439) 
[   98.661883] device_shutdown (include/linux/device.h:937 drivers/base/core.c:4823) 
[   98.665804] kernel_restart (kernel/reboot.c:271 kernel/reboot.c:285) 
[   98.669465] __do_sys_reboot (kernel/reboot.c:725) 
[   98.673384] __arm64_sys_reboot (kernel/reboot.c:723) 
[   98.677390] invoke_syscall (arch/arm64/include/asm/current.h:19 arch/arm64/kernel/syscall.c:54) 
[   98.681137] el0_svc_common.constprop.0 (include/linux/thread_info.h:135 (discriminator 2) arch/arm64/kernel/syscall.c:140 (discriminator 2)) 
[   98.685841] do_el0_svc (arch/arm64/kernel/syscall.c:152) 
[   98.689152] el0_svc (arch/arm64/include/asm/irqflags.h:55 arch/arm64/include/asm/irqflags.h:76 arch/arm64/kernel/entry-common.c:165 arch/arm64/kernel/entry-common.c:178 arch/arm64/kernel/entry-common.c:745) 
[   98.692204] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:763) 
[   98.696559] el0t_64_sync (arch/arm64/kernel/entry.S:600) 
[   98.700217] ---[ end trace 0000000000000000 ]---

--Sean

