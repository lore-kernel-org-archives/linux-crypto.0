Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7169D57333;
	Sun, 28 Jul 2024 16:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722182792; cv=none; b=pzzA6aaU1yxbEQTm6n/3eGoKCVaL5X457/x/qhRcLxfrRICLmAIPudnNaASdWulhQT+6BpwF9KHyI+DmMwXX3uF6cLgw7gvh1T/sLFwc8hFzJxEUR/OtDbg4nZjxY42bMxdqZo+bh8pPDEfyYXRn39e3tqdxSDHwOcsWiQUDiYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722182792; c=relaxed/simple;
	bh=gIToTiYNeW1cGs4mXVB1QJiyt+wWM33pHI3ZXBBaBfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQp06gBC+J8yDR8Fsmw9QaitMIDGmt1BlmEzIm1RyuNHX3MbeUyAtCCphT2MPaPbZiEg6AYnz5uegrdX1Rl4XvMOMefMMle3Gweiwu40IfIMe2j2QOz4eBW7if/8nj7KFRGd3r0HOaD3h9+vxBppxZY3vmrPXeQTnRATm8/H8VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LsD/vWlJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LsD/vWlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE30DC4AF0A;
	Sun, 28 Jul 2024 16:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722182792;
	bh=gIToTiYNeW1cGs4mXVB1QJiyt+wWM33pHI3ZXBBaBfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LsD/vWlJzAiaXvpIBZn0Zslwt5yyowBupstPzDMNINcpHt0BD4adSKKgkkIW4nL+p
	 99Tm07mW/Vz4r9xHuygPzDxYQd2DbRZv2RloijduHo2DpaZ9T+5BCFDOFb4rwkneJK
	 NSQlpU4bY7xXCU2CnWATisBDIkr5p+9+iiL8yTCp1HZL7jESb6rolqZdQdsBQBjRQw
	 CChW0owem/E7kuRkA+0Ku1/XBatmltjUNPqvYtTWofXPCqH/88rePaHy8Cl5qeux6q
	 HsXGD+hcS3cIZy5u/UPGnAk4OHwDqwbXkUAfA+a9e6VHO21Nfz0rmr3oQgcadDAtMh
	 RRlS6x9sSeTFw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jiwei Sun <sunjw10@lenovo.com>,
	Adrian Huang <ahuang12@lenovo.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	damian.muszynski@intel.com,
	tero.kristo@linux.intel.com,
	xin.zeng@intel.com,
	siming.wan@intel.com,
	ciunas.bennett@intel.com,
	adam.guerin@intel.com,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.10 17/23] crypto: qat - initialize user_input.lock for rate_limiting
Date: Sun, 28 Jul 2024 12:04:58 -0400
Message-ID: <20240728160538.2051879-17-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240728160538.2051879-1-sashal@kernel.org>
References: <20240728160538.2051879-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.2
Content-Transfer-Encoding: 8bit

From: Jiwei Sun <sunjw10@lenovo.com>

[ Upstream commit ccacbbc3176277bbfc324f85fa827d1a2656bedf ]

If the following configurations are set,
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_RWSEM_SPIN_ON_OWNER=y

And run the following command,
[root@localhost sys]# cat /sys/devices/pci0000:6b/0000:6b:00.0/qat_rl/pir
The following warning log appears,

------------[ cut here ]------------
DEBUG_RWSEMS_WARN_ON(sem->magic != sem): count = 0x0, magic = 0x0, owner = 0x1, curr 0xff11000119288040, list not empty
WARNING: CPU: 131 PID: 1254984 at kernel/locking/rwsem.c:1280 down_read+0x439/0x7f0
CPU: 131 PID: 1254984 Comm: cat Kdump: loaded Tainted: G        W          6.10.0-rc4+ #86 b2ae60c8ceabed15f4fd2dba03c1c5a5f7f4040c
Hardware name: Lenovo ThinkServer SR660 V3/SR660 V3, BIOS T8E166X-2.54 05/30/2024
RIP: 0010:down_read+0x439/0x7f0
Code: 44 24 10 80 3c 02 00 0f 85 05 03 00 00 48 8b 13 41 54 48 c7 c6 a0 3e 0e b4 48 c7 c7 e0 3e 0e b4 4c 8b 4c 24 08 e8 77 d5 40 fd <0f> 0b 59 e9 bc fc ff ff 0f 1f 44 00 00 e9 e2 fd ff ff 4c 8d 7b 08
RSP: 0018:ffa0000035f67a78 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ff1100012b03a658 RCX: 0000000000000000
RDX: 0000000080000002 RSI: 0000000000000008 RDI: 0000000000000001
RBP: 1ff4000006becf53 R08: fff3fc0006becf17 R09: fff3fc0006becf17
R10: fff3fc0006becf16 R11: ffa0000035f678b7 R12: ffffffffb40e3e60
R13: ffffffffb627d1f4 R14: ff1100012b03a6d0 R15: ff1100012b03a6c8
FS:  00007fa9ff9a6740(0000) GS:ff1100081e600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa9ff984000 CR3: 00000002118ae006 CR4: 0000000000771ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 pir_show+0x5d/0xe0 [intel_qat 9e297e249ab040329cf58b657b06f418fd5c5855]
 dev_attr_show+0x3f/0xc0
 sysfs_kf_seq_show+0x1ce/0x400
 seq_read_iter+0x3fa/0x10b0
 vfs_read+0x6f5/0xb20
 ksys_read+0xe9/0x1d0
 do_syscall_64+0x8a/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7fa9ff6fd9b2
Code: c0 e9 b2 fe ff ff 50 48 8d 3d ea 1d 0c 00 e8 c5 fd 01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
RSP: 002b:00007ffc0616b968 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007fa9ff6fd9b2
RDX: 0000000000020000 RSI: 00007fa9ff985000 RDI: 0000000000000003
RBP: 00007fa9ff985000 R08: 00007fa9ff984010 R09: 0000000000000000
R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000022000
R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000
 </TASK>
irq event stamp: 0
hardirqs last  enabled at (0): [<0000000000000000>] 0x0
hardirqs last disabled at (0): [<ffffffffb102c126>] copy_process+0x21e6/0x6e70
softirqs last  enabled at (0): [<ffffffffb102c176>] copy_process+0x2236/0x6e70
softirqs last disabled at (0): [<0000000000000000>] 0x0
---[ end trace 0000000000000000 ]---

The rate_limiting->user_input.lock rwsem lock is not initialized before
use. Let's initialize it.

Signed-off-by: Jiwei Sun <sunjw10@lenovo.com>
Reviewed-by: Adrian Huang <ahuang12@lenovo.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index 346ef8bee99d9..e782c23fc1bfc 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -1106,6 +1106,7 @@ int adf_rl_init(struct adf_accel_dev *accel_dev)
 	mutex_init(&rl->rl_lock);
 	rl->device_data = &accel_dev->hw_device->rl_data;
 	rl->accel_dev = accel_dev;
+	init_rwsem(&rl->user_input.lock);
 	accel_dev->rate_limiting = rl;
 
 err_ret:
-- 
2.43.0

