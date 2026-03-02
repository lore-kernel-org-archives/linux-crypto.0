Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31622395D97;
	Mon,  2 Mar 2026 08:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438487; cv=none; b=ACUhYACS7fyoD0kA7fHhAULAMv2b4KoAvnO7HDuhbsYISCCN+S/T2lvMLu566iDYNWzhV+EzpV31fhl9tZiNSla0pyuEhebnaEjN8aDPEOSdaGakFY3WMuYC72DE2/Bhv0TsSRBpcpRrnBDs+M5QE/IIV0t8TrNNZTWMcD32WNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438487; c=relaxed/simple;
	bh=CY5S+8Xe7LGX85M7lE2YZMKcd7EzAIMtR79Jhigxnp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMrnhkrsKZaYzRd5ZMtDeLBhP1PIAcXL4QDZ3HvwYd5Q0nvsPZGJuyc6ef3Iaujxnsb7v+NewuHsLDYMveKHAb6vWSu7xoLecsrS+LFm9l9nP3FkRDn6mUNFulcZ1kVnN4QieNRAWEXa7ucOaj1cCfxT0OZO5tpT2cEaFtfZEQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ORYfLTF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ORYfLTF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE82C2BC87;
	Mon,  2 Mar 2026 08:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438486;
	bh=CY5S+8Xe7LGX85M7lE2YZMKcd7EzAIMtR79Jhigxnp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORYfLTF719UTIp1G3cyD39g/CaEAT66LC7vKpnjJiFKVJmdTVc5ebgSVgFFYTTYED
	 LYyywuH955n5rnJAqjhbdz92VHuyFFxGuZ9Ny2HA5UBifnQ+i84cFEu8LZFbLh1WlK
	 6ppUXi2xTpCfRKhJADa/5LDNi5GsR7xGjyWO/LsPyvVyhycBWaWqtfXRt6dv2/OUG6
	 CG3e1HA+JDY2g2iCaQd26eghO8M7tiaI01DLJwISYqBmXwMyz3tTvQZl9m6cerOi/m
	 r5BwA1fznJkWFrHLJJ761CgUsD6PR5BmTgMIVNXXPVEUSDoEwc5hLutozP6KxahDMc
	 OLKKwO7PHgCkA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-nvme@lists.infradead.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 16/21] nvme-auth: target: remove obsolete crypto_has_shash() checks
Date: Sun,  1 Mar 2026 23:59:54 -0800
Message-ID: <20260302075959.338638-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302075959.338638-1-ebiggers@kernel.org>
References: <20260302075959.338638-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since nvme-auth is now doing its HMAC computations using the crypto
library, it's guaranteed that all the algorithms actually work.
Therefore, remove the crypto_has_shash() checks which are now obsolete.

However, the caller in nvmet_auth_negotiate() seems to have also been
relying on crypto_has_shash(nvme_auth_hmac_name(host_hmac_id)) to
validate the host_hmac_id.  Therefore, make it validate the ID more
directly by checking whether nvme_auth_hmac_hash_len() returns 0 or not.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nvme/target/auth.c             | 9 ---------
 drivers/nvme/target/configfs.c         | 3 ---
 drivers/nvme/target/fabrics-cmd-auth.c | 4 +---
 3 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index f483e1fd48acc..08c1783d70fc4 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -43,19 +43,10 @@ int nvmet_auth_set_key(struct nvmet_host *host, const char *secret,
 	if (key_hash > 3) {
 		pr_warn("Invalid DH-HMAC-CHAP hash id %d\n",
 			 key_hash);
 		return -EINVAL;
 	}
-	if (key_hash > 0) {
-		/* Validate selected hash algorithm */
-		const char *hmac = nvme_auth_hmac_name(key_hash);
-
-		if (!crypto_has_shash(hmac, 0, 0)) {
-			pr_err("DH-HMAC-CHAP hash %s unsupported\n", hmac);
-			return -ENOTSUPP;
-		}
-	}
 	dhchap_secret = kstrdup(secret, GFP_KERNEL);
 	if (!dhchap_secret)
 		return -ENOMEM;
 	down_write(&nvmet_config_sem);
 	if (set_ctrl) {
diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 3088e044dbcbb..463348c7f097b 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -15,11 +15,10 @@
 #include <linux/pci-p2pdma.h>
 #ifdef CONFIG_NVME_TARGET_AUTH
 #include <linux/nvme-auth.h>
 #endif
 #include <linux/nvme-keyring.h>
-#include <crypto/hash.h>
 #include <crypto/kpp.h>
 #include <linux/nospec.h>
 
 #include "nvmet.h"
 
@@ -2179,12 +2178,10 @@ static ssize_t nvmet_host_dhchap_hash_store(struct config_item *item,
 	u8 hmac_id;
 
 	hmac_id = nvme_auth_hmac_id(page);
 	if (hmac_id == NVME_AUTH_HASH_INVALID)
 		return -EINVAL;
-	if (!crypto_has_shash(nvme_auth_hmac_name(hmac_id), 0, 0))
-		return -ENOTSUPP;
 	host->dhchap_hash_id = hmac_id;
 	return count;
 }
 
 CONFIGFS_ATTR(nvmet_host_, dhchap_hash);
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 5946681cb0e32..b703e3bebae4e 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -6,11 +6,10 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/blkdev.h>
 #include <linux/random.h>
 #include <linux/nvme-auth.h>
-#include <crypto/hash.h>
 #include <crypto/kpp.h>
 #include "nvmet.h"
 
 static void nvmet_auth_expired_work(struct work_struct *work)
 {
@@ -73,12 +72,11 @@ static u8 nvmet_auth_negotiate(struct nvmet_req *req, void *d)
 		return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
 
 	for (i = 0; i < data->auth_protocol[0].dhchap.halen; i++) {
 		u8 host_hmac_id = data->auth_protocol[0].dhchap.idlist[i];
 
-		if (!fallback_hash_id &&
-		    crypto_has_shash(nvme_auth_hmac_name(host_hmac_id), 0, 0))
+		if (!fallback_hash_id && nvme_auth_hmac_hash_len(host_hmac_id))
 			fallback_hash_id = host_hmac_id;
 		if (ctrl->shash_id != host_hmac_id)
 			continue;
 		hash_id = ctrl->shash_id;
 		break;
-- 
2.53.0

