Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EC23161A1;
	Mon, 23 Feb 2026 16:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864284; cv=none; b=VatSqgZfUmeaJJgpqNBdWODaCWA5TcbOYfrxXqqGV7dKDQZZaEXbv1vB/cF/gtJmk7Nb8zGMX7IRXanQmB54kcmYZraFo6KSSMljaa1pAlgdIwfNbB9McxbD61vGoaSTq9PwnOuFJ+f5Cx9A65rmgUb+cgr9WP0//RIqmmywjfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864284; c=relaxed/simple;
	bh=z0+k2/vsL3nwF+DeqeI8DQy/GT6X1KPt1rxrFs1rkXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTq33sn84SviThgTw3AweaLIkt3utFpt9yaSaxzp2daIeWiNUOZkzNDVr8MITwyvb088fpf/NLd2OiYaBTEcGtIQ07ahy9/mtTqEFZiUunEgLNtYsc+6fPyQSjND13cUbpfJGQRv2BPOW9wMEYfUu0rnvLI1lCGWS5QYdvyn+CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjlhTPfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjlhTPfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECB6C2BCAF;
	Mon, 23 Feb 2026 16:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771864284;
	bh=z0+k2/vsL3nwF+DeqeI8DQy/GT6X1KPt1rxrFs1rkXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjlhTPfrVN5DVJWrNv5hq1GjuhRYaxOeL4pgKhzQF5uQJQ6HbJKQwd2tygXyj5sCe
	 8oG7puqb15MJ/F99OPVxRywJ+LzvOZ4xkRUMzMjkfDMKpNhqUdpKhnNom+5Hmp6aOq
	 Ri83bj7rD9rwKxYUirpItvQIoTUB8I8d5DM63kE5gSr9sjkFLW8VUu69Ps6g5oXnqI
	 N7TAzQkAAWlPh6NQ7l2ytCwjBlsyLg5cEQaKgkqOk6Is29jSiZvfUJlaTbIczWbWEP
	 3eLLDCD5WgeHj34oR7iLUl/L9BQaYstG1BGmFQb08MrmQi4Cd6Qan7kqib4MlBRqlc
	 ipLwxzhmZrL2A==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 3/4] crypto/ccp: support setting RAPL_DIS in SNP_INIT_EX
Date: Mon, 23 Feb 2026 09:28:59 -0700
Message-ID: <20260223162900.772669-4-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260223162900.772669-1-tycho@kernel.org>
References: <20260223162900.772669-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

The kernel allows setting the RAPL_DIS policy bit, but had no way to set
the RAPL_DIS bit during SNP_INIT_EX. Setting the policy bit would always
result in:

    [  898.840286] ccp 0000:a9:00.5: sev command 0xa0 failed (0x00000007)

Allow setting the RAPL_DIS bit during SNP_INIT_EX via a module parameter.
If the hardware does not support RAPL_DIS, log and disable the module
parameter.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 096f993974d1..362126453ef0 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -75,6 +75,10 @@ static bool psp_init_on_probe = true;
 module_param(psp_init_on_probe, bool, 0444);
 MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
 
+static bool rapl_disable;
+module_param(rapl_disable, bool, 0444);
+MODULE_PARM_DESC(rapl_disable, "  if true, the RAPL_DIS bit will be set during INIT_EX if supported");
+
 #if IS_ENABLED(CONFIG_PCI_TSM)
 static bool sev_tio_enabled = true;
 module_param_named(tio, sev_tio_enabled, bool, 0444);
@@ -1428,6 +1432,16 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 			data.max_snp_asid = max_snp_asid;
 		}
 
+		if (rapl_disable) {
+			if (sev->snp_feat_info_0.ecx & SNP_RAPL_DISABLE_SUPPORTED) {
+				data.rapl_dis = 1;
+			} else {
+				dev_info(sev->dev,
+					"SEV: RAPL_DIS requested, but not supported");
+				rapl_disable = false;
+			}
+		}
+
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
 		data.list_paddr = __psp_pa(snp_range_list);
-- 
2.53.0

