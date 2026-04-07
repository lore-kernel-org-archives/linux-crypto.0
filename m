Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB05738C41A;
	Tue,  7 Apr 2026 17:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775584150; cv=none; b=piCQl8fG1vOeoAL+edUjwszQ4xcZyE1ljBIXsPa5X9pSSc2+Hy0fW3t5Lh72VAX5WM19ekY0Dyc2IP5tYvTd/wSTlTzk4MlDn6MGGRiAjOIIAR6LcSieJqw7O5QES3W0lpv+gTUHyF/i+V1GvaDg/A6VWlwsN6pWwc7v8/cLGQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775584150; c=relaxed/simple;
	bh=J3ccJ20YEcKVvAC8qpCT4CXnRnkkZO8YTXGG4okMx4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5EOQGoQRnUEeWWrw70+LIJ9VbOFZUgeT8Z5c8tSldk6BUuJMNd4luSZ539wdaF9JNbfFrQJ5PaeIE6zHDsoFH8blDoV6z5QfRCqoKnlgfDgGR/Naoe9Pranue+Ggj0fulZA5zhse8rqHl43kfiHBQyGw3StMcERAi8ouCl1Xq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r9iED0vH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r9iED0vH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3A2C116C6;
	Tue,  7 Apr 2026 17:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775584150;
	bh=J3ccJ20YEcKVvAC8qpCT4CXnRnkkZO8YTXGG4okMx4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9iED0vHb8jSfdQ1ic8E2nkBc3Qu/JwSghQSkwXfoN3ZOHvrUMlRL5yH5H+R4FBy1
	 k8bYWAX2YNSixSm2ml53GHFbn6EeAGXd9Y0oLMDo5Qj6+FjN5GdAC98+eC0A0fP/aC
	 uBfXMW/W+6OtGtGkpmCzMRbSli+k1Qhox6W5pEObZ+e2AmnzJ3gU612hb6fQh6A7nQ
	 amVdr4xEGCQjjraU9C78CpTPcbPjeVlGvsyM8P+tFhEu9FrS4ibE29fShXTNiixcz5
	 BkuMCJu05lQkSBkgL2SYJ4sFgmj0mANUUvV21xQHVEGGeJa9r7pmsYGh6uJ2HmrzDJ
	 Nr3SaWTZnNN8A==
From: Tycho Andersen <tycho@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	"Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: [PATCH v2 2/2] crypto/ccp: Skip SNP_INIT if preparation fails
Date: Tue,  7 Apr 2026 11:47:13 -0600
Message-ID: <20260407174713.439474-3-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260407174713.439474-1-tycho@kernel.org>
References: <20260407174713.439474-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

During SNP_INIT, the firmware checks to see that the SNP enable bit is set
on all CPUs. If snp_prepare() failed because not all CPUs were online,
SNP_INIT will fail, so skip it.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 939fa8aa155c..854263cbb256 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1374,7 +1374,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		return -EOPNOTSUPP;
 	}
 
-	snp_prepare();
+	rc = snp_prepare();
+	if (rc < 0)
+		return rc;
 
 	/*
 	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list
-- 
2.53.0

