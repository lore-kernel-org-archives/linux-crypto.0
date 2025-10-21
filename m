Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958D428314A;
	Tue, 21 Oct 2025 08:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036058; cv=none; b=PHQsVIXeQ+oU3pFraOOjOfipC0sL/QmBfse0EJlBt5ISQSU1b1TNppa3SyN8wEUyMncT+/+HXKwNAHCuAVBvYU+6fd4UjbD9e44pVtivp/3REqa7GjDVJCYWZCocEtDEJFsfio/1v8dyTPObkSOTN+MTDiSNYnWtHhwbFHipw4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036058; c=relaxed/simple;
	bh=hb5VcV0ET3l0QzSsWclmOpjmwF9VwY1uM8U2V3HfyDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sh4u+IanLEeJyGmTmPDDj+6h96ejgVStCSLP2IsYAx8i77ucrNd1NBfNOXyG6KlutVVT1RU2w5O4vavORvIRrOi12Phi4TgQkNVljQM/yQ/W0uwr9Jpp10c2JAS4XjcG27/vg6f8DDFubjIHdvpJ+CpxMo8/Z1Zb1J3bTEUkt4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a59aa16aae5911f0a38c85956e01ac42-20251021
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:5b1bc7ac-4984-447d-92b2-fdfde16de3db,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:847313a20b3d4fb0a5562c6197ee2905,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a59aa16aae5911f0a38c85956e01ac42-20251021
X-User: xiaopei01@kylinos.cn
Received: from [10.42.12.251] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 109458862; Tue, 21 Oct 2025 16:40:50 +0800
Message-ID: <e1b1df10-ce40-4135-93fc-69a1c6d9f32f@kylinos.cn>
Date: Tue, 21 Oct 2025 16:40:47 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/crypto: poly1305: fix uninit-value in poly1305_blocks
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
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

hi Eric,

    thanks for your responce.

> Thanks for the bug report.  It will first need to be confirmed that this
> is actually an issue in lib/crypto/ rather than the calling code, and if
> so, why poly1305_kunit doesn't catch it (even when run on an KMSAN
> enabled kernel, which I've done).  And which commit it fixes.  I'm
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

--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
+#include <linux/kmsan.h>

 #ifdef CONFIG_CRYPTO_LIB_POLY1305_ARCH
 #include "poly1305.h" /* $(SRCARCH)/poly1305.h */
@@ -31,6 +32,7 @@ void poly1305_init(struct poly1305_desc_ctx *desc,
        desc->s[3] = get_unaligned_le32(key + 28);
        desc->buflen = 0;
        poly1305_block_init(&desc->state, key);
+       kmsan_unpoison_memory(desc, sizeof(struct poly1305_desc_ctx));
 }
 EXPORT_SYMBOL(poly1305_init)

how about this ? 

>  If it ends up being too inconvenient, we
> can make the architecture-optimized Poly1305 code depend on !KMSAN
> again.  But preserving KMSAN coverage is preferable.
>
> - Eric
thanks!
