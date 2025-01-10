Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D745B2063C3;
	Fri, 10 Jan 2025 06:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736490444; cv=none; b=IpKi8MPkXZTDSYMeXB7hymz7VcpEOiRyx7VnVyx7vFkCpxRRqiYnxdxzwxgVOpRPwXGJU0e//egDmMXlD+nmeOM3Z1t4sApBH63rWRH7RuB7g23b6rM256pZQyQE0zcVE0DDm6BUeJBpleHTxS3ubJTOZM9Q8bwjIdZAK0XGYkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736490444; c=relaxed/simple;
	bh=g3puWqYUf9MNfZTwYufdnbwTa7VGbmrMWvrHteTQlSQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KqDXYj8ZwixYJKLDgGaJeo9Bgvl7T916rP7ch8a/PsDFrc2HomhnD00ykLUIDtHNPJtUG7wiEuljfpYnPFfqi7jM0SMa1ArNuIU48CmysfQ/47QJr9Xjgm6UYtLZjjQtzJleVmbwZWuqJw71LKMgN4pQv0rCGAd31Hpm+GDPzMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YTsBT3QYkz4f3jqw;
	Fri, 10 Jan 2025 14:26:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 85A9B1A0845;
	Fri, 10 Jan 2025 14:27:12 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgCXoGOzvYBnLbQtAg--.33415S2;
	Fri, 10 Jan 2025 14:27:12 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com,
	herbert@gondor.apana.org.au,
	nstange@suse.de
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenridong@huawei.com,
	wangweiyang2@huawei.com
Subject: [PATCH v2 0/3] padata: fix UAF issues
Date: Fri, 10 Jan 2025 06:16:36 +0000
Message-Id: <20250110061639.1280907-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCXoGOzvYBnLbQtAg--.33415S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUY17kC6x804xWl14x267AKxVW8JVW5JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7
	xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
	FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr
	0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48J
	MxAqzxv26xkF7I0En4kS14v26r126r1DMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUrR
	6zUUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/

From: Chen Ridong <chenridong@huawei.com>

Fix UAF issues for padata.

---
v1->v2:
 - use synchronize_rcu to fix UAF for padata_reorder.
 - add patch to avoid UAF for 'reorder_work'

Chen Ridong (3):
  padata: add pd get/put refcnt helper
  padata: fix UAF in padata_reorder
  padata: avoid UAF for reorder_work

 kernel/padata.c | 43 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

-- 
2.34.1

