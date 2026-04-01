Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB5C44D688;
	Wed,  1 Apr 2026 14:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775054293; cv=none; b=HZ0sLYch2bkQjedzxEeGwiyH3E89Rh2Vzs4bEcaCQbKVeu+pwkbWOC52pEOwBUmk6BShbvhearLp5+2zkgO1uenjx3md2HzEh/nBAbtBQJseCVe7UYippjijkPI58LUCYJNqo2wt1dLfChciTsmiGy4AVlHr4IGWqs9FnvNXEJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775054293; c=relaxed/simple;
	bh=/CV9TD4ima1utichAPZ1WHSsiCussnChxVXmIIQzfqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3zhQC9HQXlJ27fjWHA9wd55FU3BL7Qj8nRN2FTr6LceLn2AmZDWo/i3KSDf/D2VclOAalK0JZm/IZS9kERXsPqDDUkpwfQ5dKBa7NEXSWxq20YmJLi4CWIWvANbDzUq4rOoaTsuUO/07ya9PMaLn0qI55s8xNwrhr5VKZIONjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEPkudBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEPkudBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB54C2BCB2;
	Wed,  1 Apr 2026 14:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775054293;
	bh=/CV9TD4ima1utichAPZ1WHSsiCussnChxVXmIIQzfqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEPkudBo2Y0ZQBERqgT0kFzNLVoZ77JImYP/hzBPzqLmPyXlOvdbo2UWstepkjs3J
	 WjR8dcuJELaGb2iEZm4umps9QM6q3BFtEeDP562uu5iSwaiVhd1GPDcf+w4Edc4e1x
	 ew3VOUqC5jABlSth0FRkvNLJOZ6ap+SCPq1XaR6C+N9IS1SOv30pXChKYIBrtABO2h
	 CZOJRmAAJa8xlaUSLUud2G/I0xvu+swv4GctT9EdSztp9mwQrqDhcNj77kBX4/9IZ9
	 SI3upUllpujiJKwmFk5wGNXDSyVyV0dHdMYGeNuDXL5rH7DHOvyjEpjpOefCbOzK7k
	 Se2v+ULHKMV+A==
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
Subject: [PATCH v1 2/2] crypto/ccp: skip SNP_INIT if preparation fails
Date: Wed,  1 Apr 2026 08:35:51 -0600
Message-ID: <20260401143552.3038979-2-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260401143552.3038979-1-tycho@kernel.org>
References: <20260401143552.3038979-1-tycho@kernel.org>
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
 drivers/crypto/ccp/sev-dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 939fa8aa155c..1fc7ee432e28 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1374,7 +1374,10 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		return -EOPNOTSUPP;
 	}
 
-	snp_prepare();
+	if (snp_prepare() < 0) {
+		dev_dbg(sev->dev, "SNP preparation failed, are all CPUs online?\n");
+		return -EOPNOTSUPP;
+	}
 
 	/*
 	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list
-- 
2.53.0

