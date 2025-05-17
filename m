Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87461D5CC7
	for <linux-crypto@vger.kernel.org>; Sat, 17 May 2025 20:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747513626; cv=none; b=SGW+LQYxdX0SXc8fihRmammu7hnVt0GmZOiojvVApJDE1AV3elU6BMXgg3WHARHZDTdZe1KPQ1W0ZKJaG3WyokNiyTKQ8kf/Ek7ySPyu4to7BU/SxgmsiYiGdxT+OvJPJleQryGa+sQA7lPSRvBDZNg2CK9cbJXNvR4Ih4fnKO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747513626; c=relaxed/simple;
	bh=xqx8xv7ZKRjgqPjbeyNs3/axOGgrsM3g9FyrkJ1Z27s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F82C72q7lgvfKT3c0SR512NnMbhnFvXJNKjSe6tYqrMTKLP/99h8tKdVFF0CQTJXeZ5FxxZxBAoVwJRuMLGb7nEb8f2TzuA6mrVPi30gCa89U968e42THdN9N8gE83h7keKH4KlTNO72ls5tldD77cG2Jarjqn4NOfkp1IWiULI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sa0in1+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sa0in1+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C10C4CEE3;
	Sat, 17 May 2025 20:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747513626;
	bh=xqx8xv7ZKRjgqPjbeyNs3/axOGgrsM3g9FyrkJ1Z27s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sa0in1+beRcI9vsg/MLVSXgtMlNWn6jmitoxDznzKbUa/FDiB+Sbaia8FlJU2tfLu
	 H8FM2JUvc67l6JQx9TYXAMHVjJnRcN9P1xo9G4aLwVJLuBOTi1iKT91sgbqxy/DHqJ
	 L/b9/f8k9BLSNM4y0/hnpSV5IiUfr5B9beR6Ei1y9Ird+C1kh7OWYZhvBEgjtlceFZ
	 ZqzXEmTNlQpnk8ZbcTqKeiSDxFVpCYO+zFmfm/2CPWPEt+6lVYrZD45kRnpsJT/OOZ
	 hmuY9cu2ygV9iPbylV2L4Kui9gYe54VXspGWbZh2YU6SLlJ7EPUOgPOOfDWqHFAnrw
	 wCIKJRSVJEJ6Q==
From: Mario Limonciello <superm1@kernel.org>
To: mario.limonciello@amd.com,
	thomas.lendacky@amd.com,
	john.allen@amd.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH 2/2] crypto: ccp - Add missing tee info reg for teev2
Date: Sat, 17 May 2025 15:26:30 -0500
Message-ID: <20250517202657.2044530-3-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250517202657.2044530-1-superm1@kernel.org>
References: <20250517202657.2044530-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

The tee info reg for teev2 is the same as teev1.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/crypto/ccp/sp-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index e8d2bb646f3f4..fa5283b05323c 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -375,6 +375,7 @@ static const struct tee_vdata teev1 = {
 static const struct tee_vdata teev2 = {
 	.ring_wptr_reg		= 0x10950,	/* C2PMSG_20 */
 	.ring_rptr_reg		= 0x10954,	/* C2PMSG_21 */
+	.info_reg		= 0x109e8,	/* C2PMSG_58 */
 };
 
 static const struct platform_access_vdata pa_v1 = {
-- 
2.43.0

