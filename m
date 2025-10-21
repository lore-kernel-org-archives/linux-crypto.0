Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE97524678F;
	Tue, 21 Oct 2025 07:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032051; cv=none; b=n0/X8rS5zhHmVPhh8pKwK2fCG17W56ZX19Pe0EFgb/muETq2djPg1NLE7TH4X94ERqnStRobxJyRJQV/clNQ0SFJyxs4McT8V1G1Tmnvyd7uz7qvrSvXRBAhvmeZipw6S4UqoUtYtuVhvO7cG1okJ5jVi7Dt74wpdUcu/sKYboc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032051; c=relaxed/simple;
	bh=7Wa28TlMvvSz0WtFrF634en46SUmD/vMXOOAEphY/e0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bI/4caVjIHndA8oYETLioTwpb3/aEeeTc4yF0YnR6mlmbb88avKPOeTgqkG9TlPUU9OwQllN7Vtsiyiu1iu+gDhNhssI+6ozVcjx5fwv2by/Dkfk+nJaQeF+4QB5XUeyyEL7sykOf9avVJrgJp0Cf39kU0LEY4B9zFyH+b52+pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 4da09824ae5011f0a38c85956e01ac42-20251021
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:e5b7ec79-23f7-4beb-8f9d-b617b2f56104,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:41a275d11e71e244c82dd71ca429188e,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4da09824ae5011f0a38c85956e01ac42-20251021
X-User: xiaopei01@kylinos.cn
Received: from [10.42.12.251] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1792766674; Tue, 21 Oct 2025 15:33:57 +0800
Message-ID: <37764538-c4c9-482b-9cd0-8895fb973325@kylinos.cn>
Date: Tue, 21 Oct 2025 15:33:54 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/crypto: poly1305: fix uninit-value in poly1305_blocks
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jason@zx2c4.com, ardb@kernel.org, ubizjak@gmail.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
References: <751b3d80293a6f599bb07770afcef24f623c7da0.1761026343.git.xiaopei01@kylinos.cn>
 <20251021061511.GA2385@sol>
From: Pei Xiao <xiaopei01@kylinos.cn>
In-Reply-To: <20251021061511.GA2385@sol>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


在 2025/10/21 14:15, Eric Biggers 写道:
> On Tue, Oct 21, 2025 at 02:01:20PM +0800, Pei Xiao wrote:
>> syzbot reports uninit-value in poly1305_blocks:
>>
>> BUG: KMSAN: uninit-value in poly1305_blocks+0x1a9/0x5f0 lib/crypto/x86/poly1305.h:110
>>  poly1305_blocks+0x1a9/0x5f0 lib/crypto/x86/poly1305.h:110
>>  poly1305_update+0x169/0x400 lib/crypto/poly1305.c:50
>>  poly_hash+0x9f3/0x1a00 crypto/chacha20poly1305.c:168
>>  poly_genkey+0x3b6/0x450 crypto/chacha20poly1305.c:233
>>  chacha_encrypt crypto/chacha20poly1305.c:269 [inline]
>>  chachapoly_encrypt+0x48a/0x5c0 crypto/chacha20poly1305.c:284
>>  crypto_aead_encrypt+0xe2/0x160 crypto/aead.c:91
>>  tls_do_encryption net/tls/tls_sw.c:582 [inline]
>>  tls_push_record+0x38c7/0x5810 net/tls/tls_sw.c:819
>>  bpf_exec_tx_verdict+0x1a0c/0x26a0 net/tls/tls_sw.c:859
>>  tls_sw_sendmsg_locked net/tls/tls_sw.c:1138 [inline]
>>  tls_sw_sendmsg+0x3401/0x4560 net/tls/tls_sw.c:1281
>>  inet6_sendmsg+0x26c/0x2a0 net/ipv6/af_inet6.c:659
>>  sock_sendmsg_nosec net/socket.c:727 [inline]
>>  __sock_sendmsg+0x145/0x3d0 net/socket.c:742
>>  sock_write_iter+0x3a6/0x420 net/socket.c:1195
>>  do_iter_readv_writev+0x9e1/0xc20 fs/read_write.c:-1
>>  vfs_writev+0x52a/0x1500 fs/read_write.c:1057
>>  do_writev+0x1b5/0x580 fs/read_write.c:1103
>>  __do_sys_writev fs/read_write.c:1171 [inline]
>>  __se_sys_writev fs/read_write.c:1168 [inline]
>>  __x64_sys_writev+0x99/0xf0 fs/read_write.c:1168
>>  x64_sys_call+0x24b1/0x3e30 arch/x86/include/generated/asm/syscalls_64.h:21
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0xd9/0xfa0 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> in poly1305_blocks, ctx->is_base2_26 is uninit-value, ctx init in：
>> poly1305_init ->
>>      poly1305_block_init
>>
>> so add memset in poly1305_block_init, then use poly1305_init_x86_64 to init
>> by asm.
>>
>> Reported-by: syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
>> Tested-by: syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
>> Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
>> ---
> Thanks for the bug report.  It will first need to be confirmed that this
> is actually an issue in lib/crypto/ rather than the calling code, and if
> so, why poly1305_kunit doesn't catch it (even when run on an KMSAN
> enabled kernel, which I've done).  
Is this related to the compiler type? I see it was compiled with

Debian clang version 20.1.8

> And which commit it fixes.  I'm
> guessing it's most likely a KMSAN false positive that was exposed by
> commit b646b782e522 dropping the dependency of the
> architecture-optimized Poly1305 code on !KMSAN.  KMSAN doesn't know
> about memory initialization done by assembly code.  But I'll double
> check this, if you don't get around to it first.
>
> The hash algorithms generally don't need a dependency on !KMSAN, as
> their assembly code doesn't initialize memory.  It looks like the
> Poly1305 code is an exception to that though, and I missed it.  If so,
> the proper solution (IMO) is to use kmsan_unpoison_memory() right after
> the assembly function that initializes the memory is called.  See
> sha256_finup_2x_arch() for an example of that.  Note that more than one
> architecture may need this. 
So may  I send a patch by use 

kmsan_unpoison_memory(out1, SHA256_DIGEST_SIZE); ?


>  If it ends up being too inconvenient, we
> can make the architecture-optimized Poly1305 code depend on !KMSAN
> again.  But preserving KMSAN coverage is preferable.
>
> - Eric

thanks！

Pei.

