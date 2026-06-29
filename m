Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F8613D0C18;
	Mon, 29 Jun 2026 07:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782717895; cv=none; b=pLCjPjIe90vDYqMteLh26QUTPVcG8hPXtH5ho+3dCTr2GBKF42y+sqlNmiQsjTeFrjAbOkGrbCYNhGsqzEWoH7gKaaRq4nfipRPnVte2RqOMBpHXnDFXQ3V/zCkzLMB2+iBRm2Qzp06I5LrcNfc3xMyA+WIPBc+d7FATJm5idU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782717895; c=relaxed/simple;
	bh=8KDyBRVIEpQomG4KojVPk5YEjDwmARSS/fg3zqyuV38=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dNeb7I187qSiR1KFPBa/DB/utp27AJPKUCVvsITxboRFNZcrskOJEc83zgAxuoJEMPgtPxJYsf9iHiJi+jWg0NgA4zOyocftZADJjQHTXEv2CITLFBqpkt4+oqtja3ciXowX9SNfiJ0coLLFmkNWkJjfj0wzafTlsb3Zv03Ldpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.40.54.123])
	by gateway (Coremail) with SMTP id _____8DxsOq3HUJqkxMZAA--.64351S3;
	Mon, 29 Jun 2026 15:24:39 +0800 (CST)
Received: from localhost.localdomain (unknown [10.40.54.123])
	by front1 (Coremail) with SMTP id qMiowJDxhcCxHUJqJl63AA--.61324S2;
	Mon, 29 Jun 2026 15:24:33 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
To: lee@kernel.org
Cc: chenhuacai@kernel.org,
	xry111@xry111.site,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>
Subject: [PATCH v4 0/2] mfd: loongson-se: Fix miscellaneous issues and add multi-node support
Date: Mon, 29 Jun 2026 15:11:07 +0800
Message-ID: <20260629071109.7341-1-zhaoqunqin@loongson.cn>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxhcCxHUJqJl63AA--.61324S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj9xXoWrZFWfKw4rJr4UXrWUtryrAFc_yoW3KrbE93
	40v3s7Grn7GF92qa43Cws7WFyruFW8JF1YkFyqqF15Xasrtw13Gry2vryfua48GFZrJr15
	ur1v9r1fAr17KosvyTuYvTs0mTUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUb7AYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8j-e5UUUUU==

- Patch 1 focuses entirely on structural and error-path hardening for the
  pre-existing baseline code. This includes resolving critical issues such as
  uninitialized stack memory writes, engines array out-of-bounds writes.

  v4: new patch

- Patch 2 introduces the multi-node platform support.

  v4: Safely handling shared interrupt handler returns.
  v3: Using shared interrupts (IRQF_SHARED) instead of manually
      iterating through all devices to check for interrupts.


Qunqin Zhao (2):
  mfd: loongson-se: Fix miscellaneous issues
  mfd: loongson-se: Add multi-node support

 drivers/mfd/loongson-se.c       | 32 ++++++++++++++++++++++++++------
 include/linux/mfd/loongson-se.h |  1 +
 2 files changed, 27 insertions(+), 6 deletions(-)


base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.47.2

