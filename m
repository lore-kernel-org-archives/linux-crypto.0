Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD9B60BB6;
	Sun, 26 May 2024 09:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716580; cv=none; b=al26I7QJKnJR9dj0y6M/56ESQ4Su4hjFXy4urEydPgk3VEL1TipghzZ2TAxyaiIHNBwju/jrrHOwOj4fw78k0vd8XylGhzyk9aHUzOsA588CQff8S7wrBpsUaKVraeqbQJabrxKc/40QdfRy/0XIPtwVfk/eCWqGzzguT73XowI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716580; c=relaxed/simple;
	bh=HWS2+qYcEoeuDPE6pRQlBEzqh5TUaWJ7g9eGRb9l3t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSxv54YCOz6OC+7RUS1t0645ZVY9NsCNtPmiIg6xqnG7rAFzDVMtIf2I6Wb3vwGORdD+lGgtcfumXm0umHT2b2KR72wbvB76nN2pF89TMSlr30YxyAxI5nlmyjSq1waJ6MZ3fAmnJUjQFw+CXi1su2lyiCeLkgptPVtSz4P74Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FdlhjK5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FdlhjK5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6224C32781;
	Sun, 26 May 2024 09:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716579;
	bh=HWS2+qYcEoeuDPE6pRQlBEzqh5TUaWJ7g9eGRb9l3t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdlhjK5ZDMykPkodpWyPQFQsKzKHZhv2uNrOROB3SzJ5TIpcbU8G4/7yDKl1edm7V
	 AFRkvouGRiZgafnWFx/83tqAOZC+3N6dowOBZfJulq9KkY5YoB44BIqELBVvhZRk0j
	 Hby2RCl6oEoUTHasuIW6GNYoL5cCHD1pdYDm0e0ZIWfBPnBAIdsqgnW4jt1F3YIJK4
	 5usY7co9kpZB0Vs7l10Irc+jmxbsi0E+RjJCXmfniC8Ia8QKuv2JlheSTrXGymj3sT
	 Jm/jByWYmQGx2t0KdjcDzT2swfb+0SV/fa9MaWbgBsYBRnOBPNS2dyoM7NZqeSac89
	 GfSQA3q3VN8gQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	qianweili@huawei.com,
	wangzhou1@hisilicon.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 05/11] crypto: hisilicon/qm - Add the err memory release process to qm uninit
Date: Sun, 26 May 2024 05:42:43 -0400
Message-ID: <20240526094251.3413178-5-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240526094251.3413178-1-sashal@kernel.org>
References: <20240526094251.3413178-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.31
Content-Transfer-Encoding: 8bit

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit c9ccfd5e0ff0dd929ce86d1b5f3c6a414110947a ]

When the qm uninit command is executed, the err data needs to
be released to prevent memory leakage. The error information
release operation and uacce_remove are integrated in
qm_remove_uacce.

So add the qm_remove_uacce to qm uninit to avoid err memory
leakage.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index e889363ed978e..562df5c77c636 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2952,12 +2952,9 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 	hisi_qm_set_state(qm, QM_NOT_READY);
 	up_write(&qm->qps_lock);
 
+	qm_remove_uacce(qm);
 	qm_irqs_unregister(qm);
 	hisi_qm_pci_uninit(qm);
-	if (qm->use_sva) {
-		uacce_remove(qm->uacce);
-		qm->uacce = NULL;
-	}
 }
 EXPORT_SYMBOL_GPL(hisi_qm_uninit);
 
-- 
2.43.0

