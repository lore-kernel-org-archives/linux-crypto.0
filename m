Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1BF379EC4;
	Mon,  2 Mar 2026 19:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772478896; cv=none; b=fvXO9B74aHlB3oXEn7TL5SGTPTDbq2cuHCStWw4ED0UWM8w1X2+aFq9turzgywSpS88HNivPz/vO4Cd/XicUJbJlwj5PUiC81KAQvxsOXc7p6BQGMfGYGXtp+5zDVh+zYROP4JNSz53TOveUxiFOTdoTSp4uCOOeZCo2N/mPdw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772478896; c=relaxed/simple;
	bh=kyd4qRfbfq/KxyUYFLuDBOx54KDX2SAP4aqIvXfmEUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYAcwzs+MnAFUzE8ojSNQxxuHNhkm9cFEaFr7IFDCmJaOIWrz33rj7ppPeeZEUtXday+cWioH5szFNpn8JxwsP/aAiqq8g5Q5W3kRIMnNmVgeEj2Ef+6ayySURxRFkZsGazcHkbg0sa9zZxCl1S0l1slC7q9hmAS/kIyVGRqTHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UeAkL8Yf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UeAkL8Yf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F4DC19425;
	Mon,  2 Mar 2026 19:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772478896;
	bh=kyd4qRfbfq/KxyUYFLuDBOx54KDX2SAP4aqIvXfmEUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeAkL8YfJhDOoM7xK5rB1pCAkk+1G1qH0SRWWppQujtbdqT7XuRuECRve+/KasnPo
	 PH9+wB7rNlZ4nkWDtrtL3fZaMP3rrWBZoi9wljowiyJuBAbRNdcCuKujfDeg2HiBor
	 WHPI6XztZdCrRLP37mJMiIPFex1QtgYtzUIMTFllrsP2oTeSKTzJs5A3m1LRn+X5AB
	 hTA8d0dsfMGCC4vVlsnqOZokVHbYffrqP1RsEI1XxlNwdHLDYlMNnOUejkK2ZN3Dm9
	 gzW2pz41mKV+INn4SIjy6oO6IZMiwItAOMymK8TjP1KQM0QlDABAXCPMGJ0vrt5SKK
	 8NJav87WAuZ8A==
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
	linux-crypto@vger.kernel.org
Subject: [PATCH 11/11] crypto: ccp - Update HV_FIXED page states to allow freeing of memory
Date: Mon,  2 Mar 2026 12:13:34 -0700
Message-ID: <20260302191334.937981-12-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302191334.937981-1-tycho@kernel.org>
References: <20260302191334.937981-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tom Lendacky <thomas.lendacky@amd.com>

After SNP is disabled, any pages allocated as HV_FIXED can now be freed.
Update the page state of these pages and the snp_leak_hv_fixed_pages()
function to free pages on SNP_SHUTDOWN.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 665fe0615b06..930fe98993d7 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1221,7 +1221,7 @@ static void snp_add_hv_fixed_pages(struct sev_device *sev, struct sev_data_range
 
 static void snp_leak_hv_fixed_pages(void)
 {
-	struct snp_hv_fixed_pages_entry *entry;
+	struct snp_hv_fixed_pages_entry *entry, *nentry;
 
 	/* List is protected by sev_cmd_mutex */
 	lockdep_assert_held(&sev_cmd_mutex);
@@ -1229,10 +1229,16 @@ static void snp_leak_hv_fixed_pages(void)
 	if (list_empty(&snp_hv_fixed_pages))
 		return;
 
-	list_for_each_entry(entry, &snp_hv_fixed_pages, list)
-		if (entry->page_state == HV_FIXED)
+	list_for_each_entry_safe(entry, nentry, &snp_hv_fixed_pages, list) {
+		if (entry->free && entry->page_state != HV_FIXED)
+			__free_pages(entry->page, entry->order);
+		else
 			__snp_leak_pages(page_to_pfn(entry->page),
 					 1 << entry->order, false);
+
+		list_del(&entry->list);
+		kfree(entry);
+	}
 }
 
 bool sev_is_snp_ciphertext_hiding_supported(void)
@@ -2082,6 +2088,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	    !WARN_ON_ONCE(syscfg & MSR_AMD64_SYSCFG_SNP_EN)) {
 		if (!panic)
 			snp_x86_shutdown();
+		snp_hv_fixed_pages_state_update(sev, ALLOCATED);
 	} else {
 		/*
 		 * SNP_SHUTDOWN_EX with IOMMU_SNP_SHUTDOWN set to 1 disables SNP
-- 
2.53.0

