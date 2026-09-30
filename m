Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EBE3BBFBB
	for <linux-crypto@vger.kernel.org>; Wed, 30 Sep 2026 12:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790770167; cv=none; b=Avw5pRkSU5gvJ5+Usso81YztPxDkPQ9wADaatBnoR+mV5o9Dt7mog+SU+7auGjtAEjliQLLFdZSMI3a+SS4uDhIDFZ1mz6EQsX27KZ5/tYJVLkzKlqA2Oy+EzppSEc9MvhsDpwYvd6AM9FON3dSHRIgSruLpfKkiQH8NePbXHHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790770167; c=relaxed/simple;
	bh=C9TrIIsaL+5A+TFDpbrCcD/1AAMgbE1glqvBJuSQXkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Db9T+RzMLfGQo2BRDpqh9lCbTkDM1M1UpmG3hl4pXL4VR7Ct/uMdm1KkHLt8WJaJTVxF6dv3KvYd9ynBVad+joQffLpfL6VCBZDGOzW0SZE00QIDZRYgZQh6Y5sATBYcdcb9nKFHUpu2j5xreYMhGnJhvRNY+LDPTAyJJqVAJqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hTKbaxVc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hTKbaxVc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790770164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WwhF7io/sxoqE0kISf9Sr5FHDFDQmNz0jfR2kEYin4Q=;
	b=hTKbaxVcB9P6oLvPqoTYYZSv9B73gweu/2z7QyZJ6UFM7HGlOfSK8rCHYhAtm4AOCLlGGu
	iLAaBy2BfqPmgqTMfrfgAEc2zcegaNiED3an+KAQDggE02NCic0z2egs4/P2FF3yoew16X
	JQqVWCfIbQ3rn1wWF6nrDP3JvJ1lQds=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-Ug9qeFB2OwGVW1_xw2UxSw-1; Wed,
 30 Sep 2026 08:09:21 -0400
X-MC-Unique: Ug9qeFB2OwGVW1_xw2UxSw-1
X-Mimecast-MFC-AGG-ID: Ug9qeFB2OwGVW1_xw2UxSw_1790770159
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 110F31800676;
	Wed, 30 Sep 2026 12:09:19 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0E45D18004D2;
	Wed, 30 Sep 2026 12:09:15 +0000 (UTC)
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
Subject: [PATCH v2 4/5] wifi: iwlwifi: use software crypto for management frames in FIPS exception mode
Date: Wed, 30 Sep 2026 14:08:27 +0200
Message-ID: <20260930120829.383408-5-jtornosm@redhat.com>
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

Best effort to protect as many outgoing robust management frames
as possible via host-side software crypto, given the firmware
limitations.

When the FIPS exception is active and keys are delivered to
firmware, mac80211 delegates management frame encryption to
firmware via hw_key. However, Intel firmware does not properly
apply CCMP/GCMP integrity protection to these frames, causing
the AP to drop them when MFP is negotiated.

Set IEEE80211_KEY_FLAG_SW_MGMT_TX on pairwise CCMP/GCMP keys
when fips_enabled, so that mac80211 encrypts unicast management
frames in software using FIPS-approved algorithms on the host
CPU. This is the same mechanism used by ath9k, ath5k, carl9170,
mt76x02, rtw88, rtw89, rtlwifi, ... and other drivers whose
firmware cannot encrypt management frames.

This protects SA Query, deauth, disassoc and other unicast
robust management frames built by mac80211. Multicast robust
management frames (IGTK/AES-CMAC/GMAC) are already handled
in software by mac80211, so no additional flag is needed.

AddBA (TX aggregation setup) cannot be fixed this way because
firmware creates these frames autonomously when
TX_AMPDU_SETUP_IN_HW is set, bypassing mac80211's TX path
entirely. Fixing this would require firmware-side changes.

The only observed degradation with the exception active is
reduced uplink throughput: firmware-created AddBA requests are
sent without integrity protection and silently discarded by
the AP, so TX aggregation is not established. Downlink
aggregation (AP to STA) works normally. No other functionality
is observed to be affected. Since the AP drops unprotected
firmware-autonomous frames rather than accepting them, the
system remains secure — those frames are simply not considered.

When set_key is reached with fips_enabled, the exception must
be active (otherwise drv_set_key blocks keys), so checking
fips_enabled alone is sufficient.

Both mvm and mld driver paths are covered.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v2: new, to improve the behavior
v1: https://lore.kernel.org/all/20260629121213.597038-1-jtornosm@redhat.com/

 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 3ccbf1033160..3fd88420cd17 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -2230,6 +2230,9 @@ static int iwl_mld_set_key_add(struct iwl_mld *mld,
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
+		if (fips_enabled && (key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+			key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
+		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
 	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index f6e20a07e329..38fe710ef414 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4247,6 +4247,8 @@ static int __iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		if (!iwl_mvm_has_new_tx_api(mvm))
 			key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
+		if (fips_enabled && (key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+			key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
-- 
2.55.0

