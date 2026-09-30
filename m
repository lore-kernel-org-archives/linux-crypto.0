Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810463C8728
	for <linux-crypto@vger.kernel.org>; Wed, 30 Sep 2026 12:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790770143; cv=none; b=OhCsYHrMjlVSKMYYGEJTnlBUduCQY4V/siGzniO+4BmW44A3i+yuD5wZq18DOSiEGlYNe5n1Azg2NOv7pFKsZaoVOogjn++mqJloeWSmFI9Kdwo24P8nlBCruoXAN4kFEJtiD4cCnJGOzTCIWzrllAzINXbEOkRqv1iuSCUlKz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790770143; c=relaxed/simple;
	bh=hy1Cd4aNAiVuuZX+JOuupFMRwiCbwo50mLlOzLatxyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=af/1Z+clsaYETXYGMrEIVZzFdUgfJcGZ0KpamQUwqImqCQTKMpPiuuRQPjH5NsbS7YgEYMT56jReIf5Wshyu2b65w+Kb3BXu5VfoYQgZsoVhpxFh5rbvd50AOtf26qPNdCwpeBRPefzzuaxmglJM0fLey+jCOY93APuWyE8gaF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WNw1PPKV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WNw1PPKV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790770138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DA4JZTLcL9MFExPRBc/IxF4Lq5xcWqz46K78L1WGHIM=;
	b=WNw1PPKVtneBIFG4Q/WC1n+F5NtWztPMt7H/jb2fcEy/7pw8EkVxM0L+srQWVCYQorGR9W
	LPf44Kk1zzeH8Ri6t7fFbDoIpYPHLwgaj/k2VwdUFst5mSnCUvCZ8V0yPpUgILM7SSSZdQ
	am9YWAlgkVUM8XsKU6TNqOlU9QtwzRA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-339-481YEIgGPSC0Vi6_lEz6xw-1; Wed,
 30 Sep 2026 08:08:57 -0400
X-MC-Unique: 481YEIgGPSC0Vi6_lEz6xw-1
X-Mimecast-MFC-AGG-ID: 481YEIgGPSC0Vi6_lEz6xw_1790770135
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44B36180B5D6;
	Wed, 30 Sep 2026 12:08:55 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E2F1B180035F;
	Wed, 30 Sep 2026 12:08:52 +0000 (UTC)
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
Subject: [PATCH v2 3/5] wifi: iwlwifi: restore FIPS-disabled features with fips_exception
Date: Wed, 30 Sep 2026 14:08:26 +0200
Message-ID: <20260930120829.383408-4-jtornosm@redhat.com>
In-Reply-To: <20260930120829.383408-1-jtornosm@redhat.com>
References: <20260930120829.383408-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Commit 0636800c8ee1 ("wifi: iwlwifi: disable certain features
for fips_enabled") disabled multiple WiFi features under FIPS
mode because Intel firmware autonomously sends some management
frames without FIPS-validated integrity protection. This is
correct from a compliance standpoint but breaks WiFi connectivity
entirely on WPA3-SAE networks which mandate MFP.

When FIPS_EXCEPTION_WIFI_MFP is set via fips_exception boot
parameter, use fips_allows() to restore the following features
disabled by that commit:

In the mvm driver path (mvm/mac80211.c):
  - MFP_CAPABLE: required for WPA3-SAE association
  - Beacon Protection (full and client-only): integrity
    protection for beacons, handled by firmware

In the mld driver path (mld/mac80211.c):
  - Cipher suites and MFP_CAPABLE: required for WPA3-SAE
  - Beacon Protection: same as mvm path
  - MLO (Multi-Link Operation): disabled because it requires MFP

In iwl-nvm-parse.c (shared by both paths):
  - A-MSDU max sizes: reduced under FIPS, restored with exception
  - EHT/WiFi7 capabilities: disabled because EHT requires MFP
  - 6GHz channels: disabled because 6GHz requires WPA3/MFP

A warning is logged for both mvm and mld drivers when the
exception is active to ensure the known firmware limitation
is visible:
  "FIPS: MFP enabled with known firmware limitation"

WoWLAN remains disabled under FIPS regardless of the exception
flag in both mvm and mld paths. Unlike MFP where only some
management frames bypass host crypto, WoWLAN requires all
traffic to be handled by firmware crypto during suspend, as
the host CPU is not available for mac80211 software crypto.

Without fips_exception set, the behavior remains exactly as
commit 0636800c8ee1 implemented.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v2: complete the conditional FIPS disabling revert
v1: https://lore.kernel.org/all/20260629121213.597038-2-jtornosm@redhat.com/

 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 11 +++++++----
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c  |  7 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  9 ++++++---
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 863d5e358152..ca565b4311bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -502,14 +502,16 @@ static void iwl_init_vht_hw_capab(struct iwl_trans *trans,
 	 */
 	switch (iwlwifi_mod_params.amsdu_size) {
 	case IWL_AMSDU_DEF:
-		if (trans->mac_cfg->mq_rx_supported && !fips_enabled)
+		if (trans->mac_cfg->mq_rx_supported &&
+		    fips_allows(FIPS_EXCEPTION_WIFI_MFP))
 			vht_cap->cap |=
 				IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454;
 		else
 			vht_cap->cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895;
 		break;
 	case IWL_AMSDU_2K:
-		if (trans->mac_cfg->mq_rx_supported && !fips_enabled)
+		if (trans->mac_cfg->mq_rx_supported &&
+		    fips_allows(FIPS_EXCEPTION_WIFI_MFP))
 			vht_cap->cap |=
 				IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454;
 		else
@@ -886,7 +888,7 @@ iwl_nvm_fixup_sband_iftd(struct iwl_trans *trans,
 
 	/* EHT needs WPA3/MFP so cannot do it for fips_enabled */
 	if (!data->sku_cap_11be_enable || iwlwifi_mod_params.disable_11be ||
-	    fips_enabled)
+	    !fips_allows(FIPS_EXCEPTION_WIFI_MFP))
 		iftype_data->eht_cap.has_eht = false;
 
 	if (!data->sku_cap_11bn_enable || !iftype_data->eht_cap.has_eht)
@@ -1221,7 +1223,8 @@ static void iwl_init_sbands(struct iwl_trans *trans,
 	 * avoid spending time on scanning those channels and perhaps
 	 * even finding APs there that cannot be used.
 	 */
-	if (!fips_enabled && data->sku_cap_11ax_enable &&
+	if (fips_allows(FIPS_EXCEPTION_WIFI_MFP) &&
+	    data->sku_cap_11ax_enable &&
 	    !iwlwifi_mod_params.disable_11ax)
 		iwl_init_he_hw_capab(trans, data, sband, tx_chains, rx_chains,
 				     fw);
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 3a4c8fda68d0..3ccbf1033160 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -167,7 +167,7 @@ static void iwl_mld_hw_set_security(struct iwl_mld *mld)
 		WLAN_CIPHER_SUITE_BIP_GMAC_256
 	};
 
-	if (fips_enabled)
+	if (!fips_allows(FIPS_EXCEPTION_WIFI_MFP))
 		return;
 
 	hw->wiphy->n_cipher_suites = ARRAY_SIZE(mld_ciphers);
@@ -176,6 +176,9 @@ static void iwl_mld_hw_set_security(struct iwl_mld *mld)
 	ieee80211_hw_set(hw, MFP_CAPABLE);
 	wiphy_ext_feature_set(hw->wiphy,
 			      NL80211_EXT_FEATURE_BEACON_PROTECTION);
+
+	if (fips_enabled)
+		IWL_WARN(mld, "FIPS: MFP enabled with known firmware limitation\n");
 }
 
 static void iwl_mld_hw_set_antennas(struct iwl_mld *mld)
@@ -344,7 +347,7 @@ static void iwl_mac_hw_set_wiphy(struct iwl_mld *mld)
 	if (mld->nvm_data->sku_cap_11be_enable &&
 	    !iwlwifi_mod_params.disable_11ax &&
 	    !iwlwifi_mod_params.disable_11be &&
-	    !fips_enabled)
+	    fips_allows(FIPS_EXCEPTION_WIFI_MFP))
 		wiphy->flags |= WIPHY_FLAG_SUPPORTS_MLO;
 
 	/* the firmware uses u8 for num of iterations, but 0xff is saved for
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5bd246e37943..f6e20a07e329 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -462,8 +462,11 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		IWL_ERR(mvm,
 			"iwlmvm doesn't allow to disable BT Coex, check bt_coex_active module parameter\n");
 
-	if (!fips_enabled)
+	if (fips_allows(FIPS_EXCEPTION_WIFI_MFP)) {
 		ieee80211_hw_set(hw, MFP_CAPABLE);
+		if (fips_enabled)
+			IWL_WARN(mvm, "FIPS: MFP enabled with known firmware limitation\n");
+	}
 
 	mvm->ciphers[hw->wiphy->n_cipher_suites] = WLAN_CIPHER_SUITE_AES_CMAC;
 	hw->wiphy->n_cipher_suites++;
@@ -492,12 +495,12 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	 * beacon protection must be handled by firmware,
 	 * so cannot be done with fips_enabled
 	 */
-	if (!fips_enabled && sec_key_ver &&
+	if (fips_allows(FIPS_EXCEPTION_WIFI_MFP) && sec_key_ver &&
 	    fw_has_capa(&mvm->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_BIGTK_TX_SUPPORT))
 		wiphy_ext_feature_set(hw->wiphy,
 				      NL80211_EXT_FEATURE_BEACON_PROTECTION);
-	else if (!fips_enabled &&
+	else if (fips_allows(FIPS_EXCEPTION_WIFI_MFP) &&
 		 fw_has_capa(&mvm->fw->ucode_capa,
 			     IWL_UCODE_TLV_CAPA_BIGTK_SUPPORT))
 		wiphy_ext_feature_set(hw->wiphy,
-- 
2.55.0

