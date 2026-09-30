Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5348D4CEE64
	for <linux-crypto@vger.kernel.org>; Wed, 30 Sep 2026 12:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790770170; cv=none; b=bPMKWyo5/c09zw/mCpVsLa5fIGMWzO7zboS/WwLqadB8bdjnGn9impOA6HQLpb8OCWhMQDkL4Rm9+p905YCMy1NoJ5bhoDBBI/LFyvlHntW2pZV+YTfAC4yzAptjYsX1EZF0JUAmnQ7QDUa5kRYqAipKITDQKz+R7ZIw9O1gEZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790770170; c=relaxed/simple;
	bh=m9DXyAV2T1PBYUAoEe2imt3tO09tXB6zdVxsrArYk40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oe804ZD+iC1Z2VtnBJeJeSdSlsaa+DyLflbH8Yl+MGUz9pPdmuZtSApIPPOxv28qhnBWemPd0R2+ApXlsw74lqn2E0bDgGEHpxljsWfuVWkA2pcZSNJhPoOKItYd/SQJbc/BBlNi69IdlJRi6AdGJlYaDCC48kOCPCtk+b9dC/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X9dKVYCd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X9dKVYCd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790770168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vjcf7hIfj9XS3LK0g8mrm5vFSLMh8C4+ka79NqwVkOU=;
	b=X9dKVYCdtLCpi9ZeZyU2qKfdIKMzD4X/ZEHJMnyreclFuvJXMnnOC6igP3Zh1SA8F4OR+M
	Pm4Ey9Tze0DzqdNLdw5SBKwaPe9MdbtJEc9+ii1ix+yfaoTtmDuyAh1GBa/dbQnOA5qDTY
	74/wimMLnH6Sb4VSVgNqhHXZ9LABC5Q=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-149-SwMAQ0_CPk6ADd-iQQCgng-1; Wed,
 30 Sep 2026 08:09:25 -0400
X-MC-Unique: SwMAQ0_CPk6ADd-iQQCgng-1
X-Mimecast-MFC-AGG-ID: SwMAQ0_CPk6ADd-iQQCgng_1790770163
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D1E1195C279;
	Wed, 30 Sep 2026 12:09:23 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EBD021800345;
	Wed, 30 Sep 2026 12:09:20 +0000 (UTC)
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
Subject: [PATCH v2 5/5] wifi: iwlwifi: reduce encryption error message to debug level in FIPS mode
Date: Wed, 30 Sep 2026 14:08:28 +0200
Message-ID: <20260930120829.383408-6-jtornosm@redhat.com>
In-Reply-To: <20260930120829.383408-1-jtornosm@redhat.com>
References: <20260930120829.383408-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

In FIPS mode, the firmware may report
RX_MPDU_RES_STATUS_SEC_ENC_ERR (0x707) for frames received
before keys are installed. This triggers the warning:
  "iwlwifi: Unhandled alg: 0x707"

This is expected behavior — mac80211 software crypto handles
decryption on the host CPU. Reduce the message from IWL_WARN to
IWL_DEBUG_RX in FIPS mode to avoid false-positive warnings
during normal operation, while preserving warnings for actual
unexpected conditions.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v2: No modification
v1: https://lore.kernel.org/all/20260629121213.597038-3-jtornosm@redhat.com/ 

 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 7f0b4f5daa21..6d223ef75bb4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -6,6 +6,7 @@
  */
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
+#include <linux/fips.h>
 #include "iwl-trans.h"
 #include "mvm.h"
 #include "fw-api.h"
@@ -494,6 +495,14 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		return 0;
 	case RX_MPDU_RES_STATUS_SEC_CMAC_GMAC_ENC:
 		break;
+	case RX_MPDU_RES_STATUS_SEC_ENC_ERR:
+		if (fips_enabled) {
+			IWL_DEBUG_RX(mvm,
+				     "FIPS mode: firmware cannot decrypt, status: 0x%x\n",
+				     status);
+			break;
+		}
+		fallthrough;
 	default:
 		/*
 		 * Sometimes we can get frames that were not decrypted
-- 
2.55.0

