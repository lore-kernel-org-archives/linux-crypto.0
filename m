Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E0B44471C
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 06:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791528881; cv=none; b=trhjnkVK4mjPi3GYX2bJ2ICf8uvtdDWfpP1vkIS7HdxkwATl7Svx2vlKjQNYL2XYKEqiuJfpOxC2zLr0kjK4KAKBRUk6dz9LngS+j73fvGD/PU34aYwG+KxnNbI7v0laHCcJiTpjjtJLzINOc2bqWUMaXYGD6euAHKY1dOcXuU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791528881; c=relaxed/simple;
	bh=wu+uBrjlvRD2ITE4XBNGOFu01cCzqEw5y8dP/zxWqpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAEzalfVr1peO4nRS1W4+dQtlhTO/8hlWOmmIafP46JXFZOFgjhFn0WVsELlk9hxQ0CFssqb5Ch2sCHlw5UjXi5BC/oQmNWkBC3t+kUNv/XSsq/ADrsDT2v3B+gc3dtPxq0/ZWa/VVcKMJrfPoxByYMba4fsmgiwkN537qGMBiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OGmcVRXR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OGmcVRXR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791528877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S3+4R+QpyK4HOxxP6qoWhYfhHc4hscg5LMjpnbpjS08=;
	b=OGmcVRXRc9Dhe8aATL9k4Ck+RKB8gDYhdp363NFnvSo7DK2ROF5C5EK9V/3gT1ciIFyQZz
	Mn0Z8Tq0qAnYEu1zYzIIczkzNnJN4zTDpX87gbateNuUlNaQDSAUzEfhTlRIF832XN/dFY
	AKmBIjiQN19DvHYpBPW9RgIcozT71xg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-OxYrb-qoOie7b1HofEXdiA-1; Fri,
 09 Oct 2026 02:54:33 -0400
X-MC-Unique: OxYrb-qoOie7b1HofEXdiA-1
X-Mimecast-MFC-AGG-ID: OxYrb-qoOie7b1HofEXdiA_1791528872
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E40419560A7;
	Fri,  9 Oct 2026 06:54:32 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 943031956095;
	Fri,  9 Oct 2026 06:54:29 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	johannes@sipsolutions.net,
	miriam.rachel.korenblit@intel.com
Cc: ilan.peer@intel.com,
	emmanuel.grumbach@intel.com,
	linux-crypto@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v3 2/4] wifi: iwlwifi: enable MFP_CAPABLE in FIPS mode
Date: Fri,  9 Oct 2026 08:54:11 +0200
Message-ID: <20261009065413.53403-3-jtornosm@redhat.com>
In-Reply-To: <20261009065413.53403-1-jtornosm@redhat.com>
References: <20261009065413.53403-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Re-enable MFP_CAPABLE flag in FIPS mode for iwlwifi to allow Management
Frame Protection (802.11w) to work with mac80211 software crypto.

Commit 0636800c8ee1f ("wifi: iwlwifi: disable certain features for
fips_enabled") disabled MFP_CAPABLE when fips_enabled=1.
The original concern about "some frames need to be handled in
firmware" applies to firmware-offloaded features like WoWLAN and beacon
protection, which remain correctly disabled by the commented commit.
For normal STA mode operation, management frames are processed in
software. And MFP can function in FIPS mode for normal STA operation
when mac80211 software crypto handles IGTK encryption/decryption using
FIPS-approved AES-CMAC/GMAC algorithms.

Other major WiFi drivers (ath11k, rtlwifi, mt76, ...) set MFP_CAPABLE
unconditionally, suggesting this approach is viable for FIPS mode
operation with software crypto.

When FIPS_EXCEPTION_WIFI_MFP is set via the fips_exception boot
parameter, use fips_allows_exception() to restore MFP_CAPABLE.
Without fips_exception set, the behavior remains exactly as commit
0636800c8ee1 implemented.

Testing on Intel WiFi 6E AX210 with fips=1 fips_exception=1 shows:
- IGTK ciphers (CMAC, GMAC-128, GMAC-256) are properly advertised
- WPA3-SAE connections with MFP required succeed
- iw station dump confirms "MFP: yes"

Firmware logs "Unhandled alg: 0x707" (SEC_ENC_ERR) during operation,
confirming that firmware does not have the keys and frames are being
handled by software crypto as expected.

Fixes: 0636800c8ee1f ("wifi: iwlwifi: disable certain features for fips_enabled")
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v3: reuse v1 1/2 idea plus fips_allows_exception() helper from patch 1/4
v2: https://lore.kernel.org/all/20260930120829.383408-1-jtornosm@redhat.com/
v1: https://lore.kernel.org/all/20260629121213.597038-2-jtornosm@redhat.com/

 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5bd246e37943..144a19a4015c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -462,7 +462,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		IWL_ERR(mvm,
 			"iwlmvm doesn't allow to disable BT Coex, check bt_coex_active module parameter\n");

-	if (!fips_enabled)
+	if (!fips_enabled || fips_allows_exception(FIPS_EXCEPTION_WIFI_MFP))
 		ieee80211_hw_set(hw, MFP_CAPABLE);

 	mvm->ciphers[hw->wiphy->n_cipher_suites] = WLAN_CIPHER_SUITE_AES_CMAC;
--
2.49.0

