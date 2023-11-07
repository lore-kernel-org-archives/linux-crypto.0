Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E375A315AB
	for <linux-crypto@vger.kernel.org>; Tue,  7 Nov 2023 15:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XczKj+Xo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B72C433C8;
	Tue,  7 Nov 2023 15:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699372473;
	bh=2WdsVUiAfYxrVcPeYECimo+kHKgZIJKwzaynU8H25qc=;
	h=From:To:Cc:Subject:Date:From;
	b=XczKj+XoqEJ3o8tWljioNqDxgFHV7oSjGWRKJ1r48CqWZE8IpEODRK97tYEVi/ODz
	 i2Gudo0kaZ0y1yGp0yYonpShUPbRp6pw4Mkd8vJZOKn9TUsCV6pSnpxsv+CIVvN3i7
	 2L57aw3rrAqVKJyA7a33dYzrtW7uL0kx18zcW1G0NkZT3Kexoiezw8lYK+BN3WWGD6
	 JLfjOQiN3s+wxKUxGogkb/tJAjDTWch03SjMSPLqvev9oHa2ZKm17iGSH/bh7MvR0y
	 BbT59QVAUQXY3XRDLFzyWZGkMyxij4bhzlcv4sYp7B9XXXXra6p8dSlpkkjtSYJ8cD
	 7R0pWPwd3144g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Lu Jialin <lujialin4@huawei.com>,
	Guo Zihua <guozihua@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	steffen.klassert@secunet.com,
	davem@davemloft.net,
	daniel.m.jordan@oracle.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/11] crypto: pcrypt - Fix hungtask for PADATA_RESET
Date: Tue,  7 Nov 2023 10:54:09 -0500
Message-ID: <20231107155430.3768779-1-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 4.19.297
Content-Transfer-Encoding: 8bit

From: Lu Jialin <lujialin4@huawei.com>

[ Upstream commit 8f4f68e788c3a7a696546291258bfa5fdb215523 ]

We found a hungtask bug in test_aead_vec_cfg as follows:

INFO: task cryptomgr_test:391009 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Call trace:
 __switch_to+0x98/0xe0
 __schedule+0x6c4/0xf40
 schedule+0xd8/0x1b4
 schedule_timeout+0x474/0x560
 wait_for_common+0x368/0x4e0
 wait_for_completion+0x20/0x30
 wait_for_completion+0x20/0x30
 test_aead_vec_cfg+0xab4/0xd50
 test_aead+0x144/0x1f0
 alg_test_aead+0xd8/0x1e0
 alg_test+0x634/0x890
 cryptomgr_test+0x40/0x70
 kthread+0x1e0/0x220
 ret_from_fork+0x10/0x18
 Kernel panic - not syncing: hung_task: blocked tasks

For padata_do_parallel, when the return err is 0 or -EBUSY, it will call
wait_for_completion(&wait->completion) in test_aead_vec_cfg. In normal
case, aead_request_complete() will be called in pcrypt_aead_serial and the
return err is 0 for padata_do_parallel. But, when pinst->flags is
PADATA_RESET, the return err is -EBUSY for padata_do_parallel, and it
won't call aead_request_complete(). Therefore, test_aead_vec_cfg will
hung at wait_for_completion(&wait->completion), which will cause
hungtask.

The problem comes as following:
(padata_do_parallel)                 |
    rcu_read_lock_bh();              |
    err = -EINVAL;                   |   (padata_replace)
                                     |     pinst->flags |= PADATA_RESET;
    err = -EBUSY                     |
    if (pinst->flags & PADATA_RESET) |
        rcu_read_unlock_bh()         |
        return err

In order to resolve the problem, we replace the return err -EBUSY with
-EAGAIN, which means parallel_data is changing, and the caller should call
it again.

v3:
remove retry and just change the return err.
v2:
introduce padata_try_do_parallel() in pcrypt_aead_encrypt and
pcrypt_aead_decrypt to solve the hungtask.

Signed-off-by: Lu Jialin <lujialin4@huawei.com>
Signed-off-by: Guo Zihua <guozihua@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/pcrypt.c | 4 ++++
 kernel/padata.c | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 62e11835f220e..1e9de81ef84fa 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -174,6 +174,8 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, &pencrypt);
 	if (!err)
 		return -EINPROGRESS;
+	if (err == -EBUSY)
+		return -EAGAIN;
 
 	return err;
 }
@@ -218,6 +220,8 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, &pdecrypt);
 	if (!err)
 		return -EINPROGRESS;
+	if (err == -EBUSY)
+		return -EAGAIN;
 
 	return err;
 }
diff --git a/kernel/padata.c b/kernel/padata.c
index 7f2b6d369fd47..a9e14183e1884 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -121,7 +121,7 @@ int padata_do_parallel(struct padata_instance *pinst,
 	if (!cpumask_test_cpu(cb_cpu, pd->cpumask.cbcpu))
 		goto out;
 
-	err =  -EBUSY;
+	err = -EBUSY;
 	if ((pinst->flags & PADATA_RESET))
 		goto out;
 
-- 
2.42.0

