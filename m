Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01AA3D955D
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 06:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791528891; cv=none; b=lHMe+RfvmQmVncxpHZdTLkNLgd41MLffV7wStuhqTJ+P81CDImKIyUhGpYVBjwU+X6R6TVutK/w/UOQlSsUYqLssFr0O2Ra8ibL28UA2DSGil8i2Vk2kjjnNVKOAI9nCuvmh20F0iyagFRdxBulHh27EVg9MBxxaPPYMbdqDS9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791528891; c=relaxed/simple;
	bh=TJlsYDnFC8zISOZyBmJoUdPTLU20R4ymlqE0MW5+eVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adja78nXcMvm7H30Zjv6r9r/7bh9fDdRNxhzKL4v64sulmt9O05NpLarHRdxT8wI6fu5wrdbt4o6Ctz3Dt9x4LVjFixeusxTPymUYmVLBJcQ3JC9b3UUWoUyXu5S2nJnur5zhAoVUCkkQjowwuJyGo4RYPN4YDL6IaVINPApi/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nn6PF40L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nn6PF40L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791528889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mGtogbUw0+ydyvkT1lLcqH/0z21aOLmaGzw5Bo0Tx8E=;
	b=Nn6PF40Lq+UXpZ7gz9NlNQr1/0ccrRE2KKXBmDWucX6ChyDZmr+k6Kp58npIjdPUnh7wDY
	Yeql6Wd+0XoFf/k6mYlXYl9y8wSw+h2uDvpe+PIg33JZBoTBNxSRssSqrY8ekyocvJGRgM
	wLJY1u5Aw4xQw59Q4osKkKxFZztAelM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-173-WjyuIJHYNqyTNhaxkGxXrw-1; Fri,
 9 Oct 2026 06:54:44 +0000
X-MC-Unique: WjyuIJHYNqyTNhaxkGxXrw-1
X-Mimecast-MFC-AGG-ID: WjyuIJHYNqyTNhaxkGxXrw_1791528883
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 966FD18000A2;
	Fri,  9 Oct 2026 06:54:42 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DF56F1956095;
	Fri,  9 Oct 2026 06:54:39 +0000 (UTC)
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
Subject: [PATCH v3 4/4] wifi: iwlwifi: reduce encryption error message to debug level in FIPS mode
Date: Fri,  9 Oct 2026 08:54:13 +0200
Message-ID: <20261009065413.53403-5-jtornosm@redhat.com>
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

In FIPS mode, the firmware may report
RX_MPDU_RES_STATUS_SEC_ENC_ERR (0x707) for frames received
before keys are installed. This triggers the warning:
  "iwlwifi: Unhandled alg: 0x707"

This is expected behavior -- mac80211 software crypto handles
decryption on the host CPU. Reduce the message from IWL_WARN to
IWL_DEBUG_RX in FIPS mode to avoid false-positive warnings
during normal operation, while preserving warnings for actual
unexpected conditions.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v3: No modification
v2: https://lore.kernel.org/all/20260930120829.383408-6-jtornosm@redhat.com/

 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 1ebca0323a89..e59876b7a1fa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -496,6 +496,14 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
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

