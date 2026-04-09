Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDCF63E2773;
	Thu,  9 Apr 2026 17:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775755084; cv=none; b=XaP8H0VNv9xvdmZClO07kIdrZ0+6hFSNbwlqeK2gD6fayEJd8EnP3pAm7OCytj/f2By8gi3ce6rIQQTGKe24ySndd5JFrnhUYGEAUIzw6eUezbJr266yZNTzEVLDuXfSyqloaN/VknLuUycxO6ny+tuFV2C4EnZB0u6xLVgMb2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775755084; c=relaxed/simple;
	bh=Y+eoGKYTeWqG4D6rKvEPW3T2VA9uJVyrFqI6sZjn8vY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwl3D8Q2EBLWVAbyRyYJy0l4w6HXt+wqpRffavLVoqJrJ9OXZWc+7DPI1bQPj3/SM4vmjGqE5pbgmjBKriZpI3LPeFMLXSOJ5F32giwLIj0BmtfcsKNjZOBKi2z+cbfPrPSQZd2KIHy+2JulC2AdWyKy0rDRMgSLQPDG+ZH8da4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=FyTJ0T0F; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="FyTJ0T0F"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 937EC20B710C; Thu,  9 Apr 2026 10:18:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 937EC20B710C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1775755081;
	bh=uMAf/aAFn2cF17U/6EJfT5ll571ILEGPz4I3Tb9MzL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FyTJ0T0F6U8+kQZOAwLlJOpHbvHmcTLv1ZKXZ3WoGBXtCTdMmwn+K46HIl8/76vJM
	 bUHquLGXpUfuDi70JCvo3WyEHZQKdvU4Nx/BznJwKLCVcXU+h8GeU5FEcSg17CQqy8
	 rm1/wEAVFn6WefNv0YAR3dz+M/HmOhPX5GcTRQBE=
Date: Thu, 9 Apr 2026 10:18:01 -0700
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jeff Barnes <jeffbarnes@linux.microsoft.com>,
	Paul Monson <paul.monson@capgemini.com>
Subject: Re: [PATCH] crypto: tstmgr - guard xxhash tests
Message-ID: <adffSYxKIuaDLZit@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260407192859.270745-1-hamzamahfooz@linux.microsoft.com>
 <adYNClYB6RY820Xl@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <adYNClYB6RY820Xl@gondor.apana.org.au>

On Wed, Apr 08, 2026 at 04:08:42PM +0800, Herbert Xu wrote:
> Please show me the panic.  Normally it's not an issue if an algorithm
> is not present while the test vectors are.
> 

alg: hash: failed to allocate transform for xxhash64: -2
Kernel panic - not syncing: alg: self-tests for xxhash64 (xxhash64) failed in fips mode!
CPU: 0 PID: 425 Comm: modprobe Not tainted 6.6.130.2-2.azl3 #1
Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 01/08/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0x4c/0x70
 dump_stack+0x14/0x20
 panic+0x179/0x330
 alg_test+0x678/0x680
 ? __alloc_pages+0x1e2/0x340
 do_test+0x26f8/0x7670 [tcrypt]
 do_test+0x72c5/0x7670 [tcrypt]
 tcrypt_mod_init+0x65/0xff0 [tcrypt]
 ? __pfx_tcrypt_mod_init+0x10/0x10 [tcrypt]
 do_one_initcall+0x4e/0x330
 ? kmalloc_trace+0x2e/0xa0
 do_init_module+0x68/0x250
 load_module+0x1f2e/0x2150
 ? __do_sys_init_module+0xe6/0x1d0
 __do_sys_init_module+0x19c/0x1d0
 ? __do_sys_init_module+0x19c/0x1d0
 __x64_sys_init_module+0x1e/0x30
 x64_sys_call+0x11b3/0x1c90
 do_syscall_64+0x5a/0x80
 ? irqentry_exit_to_user_mode+0x29/0x50
 ? irqentry_exit+0x3f/0x50
 ? exc_page_fault+0x87/0x160
 entry_SYSCALL_64_after_hwframe+0x78/0xe2
RIP: 0033:0x7715f70fab9e
Code: 48 8b 0d 85 32 12 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 af 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 52 32 12 00 f7 d8 64 89 01 48
RSP: 002b:00007ffde8fef6c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000af
RAX: ffffffffffffffda RBX: 00005d0b39626af0 RCX: 00007715f70fab9e
RDX: 00005d0b1710197a RSI: 0000000000028c39 RDI: 00005d0b39635310
RBP: 00005d0b1710197a R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000071 R11: 0000000000000246 R12: 00005d0b39635310
R13: 0000000000000000 R14: 00005d0b39626c20 R15: 00005d0b39626da0
 </TASK>

Seems like crypto_alg_mod_lookup() [1] fails and that triggers the panic() at [2].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/crypto/api.c?h=v7.0-rc7#n338
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/crypto/testmgr.c?h=v7.0-rc7#n5760

BR,
Hamza
