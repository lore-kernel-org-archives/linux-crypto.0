Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E1B34D4D2;
	Fri, 21 Nov 2025 11:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763723517; cv=none; b=LNCZwaadjZoH+6CMkFR0rrMG35itQex/1qTVdWjZsmvUYA3M9SfY03CgQBTTkPsze0oRT07KlmO/r0LzSkrCh1RVS4iPU8/2/kw9KyvGFXW0kQ56Q9+T0c+3E+otM8AN0yXCsUJe2VNYI5ZMMZRu+IEdbqscoYNPcj1PJVI3YYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763723517; c=relaxed/simple;
	bh=gWxAYhDmk41PHhTypPTXfd1MsXomDn33hIh6jBxUjgo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YFIgIUhZXLpQXgi1VD7Vt7xljde6CJYm7lDJ1sHkPgxuI//0UY3615375SLA24tDRUVzyQj2mSW6LJl4ao0JAP1joXPY4OhDuJZf/I2Mvurj7da7IFbHlU7Hl9CdUsno6SVOYfAAuGkpbzl0bjNrx6xqwo68xHfml5oUsbG25F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnHtHc4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnHtHc4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1FEC4CEF1;
	Fri, 21 Nov 2025 11:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763723516;
	bh=gWxAYhDmk41PHhTypPTXfd1MsXomDn33hIh6jBxUjgo=;
	h=From:To:Cc:Subject:Date:From;
	b=lnHtHc4OMM/UnmrDGuJaiScF4nZfLCqMiCTfJ+qPGeN7dXpWXPmuWlG85E5cARTPO
	 gKUzEmp7XLzjsytGT7JnC2xeJEIbTxou1/EDhMUu70ptOYaU2HOC4yKY+UrwyhfiX3
	 qSgNRiCTC1X04Ixq7Kd8UfsmOThPHiU4xvHEzfWKkaNSyte+Dn/kNXNQVPUwK9tTS7
	 utMefSUGqlt+6azzPpHWMGMfi9cj0OfOJ4wNo2U8rKo8zNDfWcPsddGuCM0aYusCh8
	 pv6YaxzA9L/nGjywUhkUB1JZoZsjcqigZ18fdxAHEdKxkGG122F11j04qNdzGGHM9Y
	 DoTxinZ+eJ1XQ==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vMP3V-000000006W8-0Xly;
	Fri, 21 Nov 2025 12:11:57 +0100
From: Johan Hovold <johan@kernel.org>
To: Weili Qian <qianweili@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: Kai Ye <yekai13@huawei.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: hisilicon/qm - fix device leak on QoS updates
Date: Fri, 21 Nov 2025 12:11:30 +0100
Message-ID: <20251121111130.25025-1-johan@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure to drop the reference taken when looking up the PCI device on
QoS updates.

Fixes: 22d7a6c39cab ("crypto: hisilicon/qm - add pci bdf number check")
Cc: stable@vger.kernel.org	# 6.2
Cc: Kai Ye <yekai13@huawei.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a5b96adf2d1e..ef6fdcc3dbcb 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3871,11 +3871,14 @@ static ssize_t qm_get_qos_value(struct hisi_qm *qm, const char *buf,
 	pdev = container_of(dev, struct pci_dev, dev);
 	if (pci_physfn(pdev) != qm->pdev) {
 		pci_err(qm->pdev, "the pdev input does not match the pf!\n");
+		put_device(dev);
 		return -EINVAL;
 	}
 
 	*fun_index = pdev->devfn;
 
+	put_device(dev);
+
 	return 0;
 }
 
-- 
2.51.2

