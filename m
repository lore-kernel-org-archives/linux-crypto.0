Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C557382281;
	Fri, 11 Sep 2026 10:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122590; cv=none; b=sT6Vww33Fk1OcTiLMuBk04HtxFnggagxKqTpMt0WzJxPUwgm0EwCAkwK9gfkMrz9F3f0nJ1ZQsz7QU1NecKQdTRPgmEoqiy8wUEe42ik32iKu4JNQ8VPb33wqVY9V1yqOmWkuGbcd2m5LWVIItmJfoRG5vTSQzzNuBkaIJNFUPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122590; c=relaxed/simple;
	bh=hLV7xBANGBQ/DcLKzZk/NdxrWFVmyLTlJGr1J/AI/Fs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NPl0oGxzczsoUF+8wwJo24EJVut10A0f//Tom1iH3JA5ir5XFO9FkLmQMzb9CipDDu3ZCgYSY/hA9YNoqdt0BGFhYesyd6RJVvYylrKSkZpgnwkDHN3bd2T9mPkXnTQX3eOW5iO5ZsN2KjzMOpUIOlL/klaGXExDZSE2k14OFrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=3S1q+UsA; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="3S1q+UsA"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/k4OmrOFXoiWgy/kuZkPHRmLdVosCfYbRhJ8oVYFLic=;
	b=3S1q+UsAC9aO9gQt9G9MINO9Kjqw2piAVYNs+88/zsQJUDkN0EBznThVBXzTZlhv38nDnqHkm
	ocKPI3/4xdw35MpdyQTeAQWWUeuaAVeTCo764NriVdWQarjBxrKpTdaLjqqlkvmUBeaH5LMFytB
	fe0ZLkX2wGmpt07rf6cb7sY=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hh9Vw6qXzz1K96s;
	Fri, 11 Sep 2026 18:18:48 +0800 (CST)
Received: from whupemk200001.china.huawei.com (unknown [7.152.184.93])
	by mail.maildlp.com (Postfix) with ESMTPS id AF21C40563;
	Fri, 11 Sep 2026 18:29:44 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 whupemk200001.china.huawei.com (7.152.184.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 11 Sep 2026 18:29:43 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<linwenkai6@hisilicon.com>
Subject: [PATCH 0/4] crypto: hisilicon - fix several issues in QM and SEC drivers
Date: Fri, 11 Sep 2026 18:29:38 +0800
Message-ID: <20260911102942.387778-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk200001.china.huawei.com (7.152.184.93)

This series fixes several issues in the Hisilicon QM and SEC drivers:

1.fix the devm_kcalloc() argument order in qm_pre_store_caps().
2.fix scheduling while atomic in the SEC AEAD soft fallback, which is
reachable with the backlog spinlock held.
3.fix a memory leak in hisi_qm_sort_devices() on the kzalloc() failure
path.
4.use GFP_KERNEL instead of GFP_ATOMIC in hisi_qm_memory_init(), which
runs in process context.

Wenkai Lin (4):
  crypto: hisilicon/qm - fix devm_kcalloc argument order
  crypto: hisilicon/sec2 - fix scheduling while atomic in aead soft
    fallback
  crypto: hisilicon/qm - fix memory leak in hisi_qm_sort_devices
  crypto: hisilicon/qm - fix GFP flag inconsistency in
    hisi_qm_memory_init

 drivers/crypto/hisilicon/qm.c              | 9 ++++++---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.43.0
