Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643DF47D95C;
	Fri, 15 May 2026 11:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778845654; cv=none; b=j1PvqMMawSM/AApF+KPuXXgww+DfHke9wFuz0ifQhtYhSVibrF6GQ6/iVzvkF7kCoF6FW8M9YA6vay39J5NZhOye38RTYreDDey48XjBfWeJ8hHjo9DI6un2WaxGHLhDJhuH0kjOnRfUTXHiZRrJ5VBTKArZtCALq8s9SqKQvtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778845654; c=relaxed/simple;
	bh=M6xjZTrvGZyJ27gJgmWGvYtGS17h8GVu6LgrtVBmXgQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NiijZh889mGYhEYTVPwYGCpkF3cwbuk9Zr6O2VeV1nRlR+rxVUr0le6x7g/n+lP1lYNMWClqA+WAKPPrYXvdx7VWzQM1NGlmeilb0BBWvkJN+sNlaEc4Tpj7Od2n+TbvUZTB+Oit4xYYeLg+LOVw/J7adN8yegXqaRBdOt2GriA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=rt2kj0Rx; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="rt2kj0Rx"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uVVeZYKktBUn0kyfdPJ1iLoyXoJIz7xRo8HlOTQ5K+g=;
	b=rt2kj0RxQGKKCGxOJKY1erc7f8F2Q9xhl5d3pKsz+8UTIsW9D0KAg07ZAFOVzLt34JH/l/Bur
	Yl4eXVeFTTJWpXd2pcWRs6kNLTDGoUJ+gdnTmxiUWyC1n1zBhbaHY9F3K0S/FoKB8MIOGpSRKy9
	RBBjVMxTGx/o3vVKGovpLCI=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gH4xG43xzzRhQy;
	Fri, 15 May 2026 19:39:46 +0800 (CST)
Received: from kwepemr100008.china.huawei.com (unknown [7.202.195.119])
	by mail.maildlp.com (Postfix) with ESMTPS id 96FDD40571;
	Fri, 15 May 2026 19:47:24 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemr100008.china.huawei.com (7.202.195.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 15 May 2026 19:47:24 +0800
From: ZongYu Wu <wuzongyu1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH 0/3] crypto: hisilicon - improve backlog handling
Date: Fri, 15 May 2026 19:45:58 +0800
Message-ID: <20260515114601.2492524-1-wuzongyu1@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr100008.china.huawei.com (7.202.195.119)

From: Chenghai Huang <huangchenghai2@huawei.com>

This series improves backlog handling for HiSilicon crypto drivers.
The ZIP and HPRE drivers are extended to support backlog queuing when
the hardware queue is temporarily busy. Instead of failing requests
immediately under hardware congestion, requests can now be queued and
resubmitted when previous requests complete.

The series also fixes a use-after-free issue in the SEC2 backlog path.
The crypto core may release the request and its tfm context immediately
after crypto_request_complete() returns. The SEC2 driver must therefore
avoid accessing context memory that may already have been freed while
processing backlog requests.

Chenghai Huang (1):
  crypto: hisilicon/zip - add backlog support for zip

Wenkai Lin (1):
  crypto: hisilicon/sec2 - fix UAF in sec_alg_send_backlog

lizhi (1):
  crypto: hisilicon/hpre - implement full backlog support for hpre
    driver

 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 223 +++++++++++----
 drivers/crypto/hisilicon/sec2/sec_crypto.c  |  23 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c   | 286 +++++++++++++-------
 3 files changed, 359 insertions(+), 173 deletions(-)

-- 
2.43.0

