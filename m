Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F15044E041
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 06:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791528884; cv=none; b=RvksgFIS1VPkzTwc3NApqAK3wSQ5yUF8d6jXE0tIR8twzZP3eo3oEFCcu7FXetKjyjxQVCIzKwShYleFy4vRciQxUgDBdaftPU8H0/VCDrmASp4t1rfGgWYcK5SNkPtYeCENn3ImBUZ4jp6m9FfxZ2tlgkrzGV4mburT6YHF2Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791528884; c=relaxed/simple;
	bh=Du8RoSo//t6EueCD537zSTMFOu2ztHb3t0m8MRDMYPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeuxWk+iu6VOQTnI3PQvY2rOQ1lKvRAILaaJnDVvD8zAXnIghvDMkC+HZiuJTOfs5KbY1qOpwLpiX58xk4muNb2Aq/3Mb4xTfZFM3v0XCl6LcJPn2aRsF/hCc4gSYYqMlz9Jt++VzpLUlC9ZzzPRmEsriEO6L34niwwOXVelHyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NR5b0thm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NR5b0thm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791528882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mvugVIrPMk6/lk2Sm5SfI1gqIyZw4M9i2cINErnAU2o=;
	b=NR5b0thm87IFFmYTnKtQsmXlnhKjh9lJ38EtFtaBXG8KLN3MqHyQVbsadAMgbnVhybjuur
	2YKm31ovOh9SFacgUkc9b0pdSRFDdj+sgzGq/gUaxZKgLJ8IVITZM4GBSbG/ORlpREVbJE
	t2n+EiHj0Bio/h7en5FMq/YcPIMK+WA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-s4g5_FV3N8uu8zbt5jHPlw-1; Fri,
 9 Oct 2026 06:54:39 +0000
X-MC-Unique: s4g5_FV3N8uu8zbt5jHPlw-1
X-Mimecast-MFC-AGG-ID: s4g5_FV3N8uu8zbt5jHPlw_1791528877
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 274551955DDE;
	Fri,  9 Oct 2026 06:54:37 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB3411956095;
	Fri,  9 Oct 2026 06:54:34 +0000 (UTC)
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
Subject: [PATCH v3 3/4] wifi: iwlwifi: fix RX AMPDU and A-MSDU in FIPS mode
Date: Fri,  9 Oct 2026 08:54:12 +0200
Message-ID: <20261009065413.53403-4-jtornosm@redhat.com>
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

In FIPS mode with the WiFi MFP exception active, firmware has no
encryption keys installed (mac80211 handles all crypto in software).
This causes two RX-path issues that severely limit downlink
throughput:

1) Firmware reports SEC_UNKNOWN for all received data frames because
   it has no keys to decrypt them. iwl_mvm_rx_crypto() drops these
   frames when they arrive inside an AMPDU, mistaking them for a
   security error. In FIPS SW-crypto mode this is expected -- the
   frames are encrypted and will be decrypted by mac80211. Skip
   the drop when the FIPS exception is active, same as already done
   for monitor mode.

2) Firmware clears the A-MSDU present bit in the QoS header for
   frames it processes. When firmware has no keys, it still strips
   this bit even though it cannot de-aggregate the A-MSDU. mac80211
   then treats the A-MSDU as a regular MSDU, delivering a malformed
   frame. Preserve the A-MSDU bit when the FIPS exception is active
   so mac80211 can properly de-aggregate after SW decryption.

Without these fixes (in my scenario), RX throughput is limited to
non-aggregated rates (~25 Mbps). With both fixes, RX AMPDU works
normally and throughput reaches ~450 Mbps.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v3: new
v2: https://lore.kernel.org/all/20260930120829.383408-1-jtornosm@redhat.com/

 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 7f0b4f5daa21..1ebca0323a89 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
  */
 #include <linux/etherdevice.h>
+#include <linux/fips.h>
 #include <linux/skbuff.h>
 #include "iwl-trans.h"
 #include "mvm.h"
@@ -421,14 +422,15 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	/*
 	 * Drop UNKNOWN frames in aggregation, unless in monitor mode
-	 * (where we don't have the keys).
+	 * (where we don't have the keys) or FIPS SW-crypto mode.
 	 * We limit this to aggregation because in TKIP this is a valid
 	 * scenario, since we may not have the (correct) TTAK (phase 1
 	 * key) in the firmware.
 	 */
 	if (phy_info & IWL_RX_MPDU_PHY_AMPDU &&
 	    (status & IWL_RX_MPDU_STATUS_SEC_MASK) ==
-	    IWL_RX_MPDU_STATUS_SEC_UNKNOWN && !mvm->monitor_on) {
+	    IWL_RX_MPDU_STATUS_SEC_UNKNOWN && !mvm->monitor_on &&
+	    !fips_allows_exception(FIPS_EXCEPTION_WIFI_MFP)) {
 		IWL_DEBUG_DROP(mvm, "Dropping packets, bad enc status\n");
 		return -1;
 	}
@@ -2357,7 +2359,8 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		    !WARN_ON(!ieee80211_is_data_qos(hdr->frame_control))) {
 			u8 *qc = ieee80211_get_qos_ctl(hdr);
 
-			*qc &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+			if (!fips_allows_exception(FIPS_EXCEPTION_WIFI_MFP))
+				*qc &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
 
 			if (mvm->trans->mac_cfg->device_family ==
 			    IWL_DEVICE_FAMILY_9000) {
-- 
2.55.0

