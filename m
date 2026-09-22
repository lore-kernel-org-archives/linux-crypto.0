Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EA840B36D;
	Tue, 22 Sep 2026 18:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790100716; cv=none; b=eDKMXYeUSbM1ySgCSY4XP792CXE84dgZcUwaRfwl6SIa1gQtiEIOgYT3dUVq/nPzWtHP8uq1RP07Yss++RjaaNIrWeOn5mU6xOKQ/cqG4TJDvPJ7dGtf61gA32n/Od3/qut5lfHGRMLA1kfvC2ZC6be7vNdsOcdCFJFVPmpfu1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790100716; c=relaxed/simple;
	bh=myufi8EwWAyN9B27OR5T4u0mb036GPQiGxI//ovO+hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRFu+GJaziTXpIDGZZja+jL6R5eYEbtsWqP+3a7KBvLcfwUqNxhhMDMWgtj6tXR8iF6Ew8LxTxgDLVVOj4oh0ED+gDMcYC38xg1ZCS2s9roZzAtr8MJ3MeMUAfMXWDWVcDnGeah22MRzYhTDjzVKCSLRMOjJgUJB8OrerGFe+Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c7rA/AJy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c7rA/AJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D441F000FF;
	Tue, 22 Sep 2026 18:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790100715;
	bh=SqCMu56BMSh7Q37nAtPjblJVasH6TThnAkMFB7AIc5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7rA/AJywyqqfMlWM4AjsDv0klh1Du9Xl55afQzjKLekoRtuCLjISGCb/Oi7rih77
	 oZYO0KBYV1SXrzz/JS+5d4Yc3p+oTMUjF8IGWoiL4YYdaeW4xW9+KwrrCUJZaV6+qR
	 SCNJRg/KbigFLL7X1tzxx6sbn0CZZXa5zPm/7fevOsJLewAUsYUkKPlcrJk/4jl+fB
	 tao6gb/5/ip6iYlxKn+6TF3HtC8KYKwUuYF2CEJlb0jo18IbsFoOfaK7k03ghiIYsS
	 +dMy09dssDuHGV0lIyB4ZW/grwFxhGR8MLH8WGxDp7m4uKGOMLMTWPJOwiBAqdfztf
	 XRp+vyUKqaVFA==
From: Thorsten Blum <blum@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Prarit Bhargava <prarit@redhat.com>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] hwrng: intel - return -ENOMEM when kmalloc_obj() fails
Date: Tue, 22 Sep 2026 20:11:02 +0200
Message-ID: <20260922181102.67309-4-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922181102.67309-3-blum@kernel.org>
References: <20260922181102.67309-3-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=712; i=blum@kernel.org; h=from:subject; bh=myufi8EwWAyN9B27OR5T4u0mb036GPQiGxI//ovO+hk=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmbjuxg67r4KM/AXXTL3E1rv+skPLn6sGRLTtHHnOSV9 dWHt94/11HKwiDGxSArpsjyYNaPGb6lNZWbTCJ2wsxhZQIZwsDFKQATebibkaF9R+UHY6e660+v Chgl7z39P+yGuqbbTpnlcTM0X6wLclRgZHi7SlH3zZbrOZfeMJbNCOi4sOGWV6mY2zqGTyvf5+9 P/MgIAA==
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

intel_rng_mod_init() incorrectly returns -ENODEV when kmalloc_obj()
fails. Return -ENOMEM instead.

Fixes: ee527cd3a20c ("Use stop_machine_run in the Intel RNG driver")
Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/intel-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index a4dd21a9de98..f7f734881c68 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -349,6 +349,7 @@ static int __init intel_rng_mod_init(void)
 	intel_rng_hw = kmalloc_obj(*intel_rng_hw);
 	if (!intel_rng_hw) {
 		pci_dev_put(dev);
+		err = -ENOMEM;
 		goto out;
 	}
 
