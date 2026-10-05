Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B072FD665
	for <linux-crypto@vger.kernel.org>; Mon,  5 Oct 2026 16:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791218735; cv=none; b=jQrqoqYxOWBLwT0loQCvfo5K5+KFhjtECRmfXEAN0mJLJYf4OjaPI6CO/exbZDrmvFW4+Iqnhv3FlXHgpkeKBKRAPpGnSrB+DSusC5woBgxornLWeO5ILnkyp/h1f4WAr7IuriTFWCgwa7Ld+A5fiMQ9i5MrXYadT43pzBV2S/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791218735; c=relaxed/simple;
	bh=7D6Gl2egxCSHnlxTzxwYRhz1lqivuXqCWdEjUWKxNjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tarNMRxPiRRTZyCJHPtDX9kV9AN07mSBnSQ7KkcfMw4pg/0/Lhw7KPleT8V90vKOJRDusYl5pGTczV/ksF4HFUTU4v9ZnfcGHZMB/vU6IDD+1tBvjVUhVzPBedx3215iwHZ+uiPhgOTjd81n7vVMrrpon04AJaj06VTqIMcvqqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DvPoSiyU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DvPoSiyU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791218731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CpyQBAbjoL+kog2eecxlfPx2SlC8rsPqvGk/Sf5CfWA=;
	b=DvPoSiyUKFlChaI+KRupChPKf6J6LUu0+A8RAEL13GK4xFNoWd8ImY/gkK9pf5duQzCQOZ
	p8k+bS7O67hfwHYT6uS4ne6SFvnKdJ7E97dA5ZENzMtGGir5y4Ei7QaVrKlADgsdx8TbJ/
	nqa7DC0LW4kG3zO4Voh/EHqLt1F11Bs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-155-abrwgGzRO3Ck7eDIxy74tA-1; Mon,
 05 Oct 2026 12:45:28 -0400
X-MC-Unique: abrwgGzRO3Ck7eDIxy74tA-1
X-Mimecast-MFC-AGG-ID: abrwgGzRO3Ck7eDIxy74tA_1791218727
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 34E021953956;
	Mon,  5 Oct 2026 16:45:26 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0FFC71800446;
	Mon,  5 Oct 2026 16:45:22 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: johannes@sipsolutions.net
Cc: davem@davemloft.net,
	emmanuel.grumbach@intel.com,
	herbert@gondor.apana.org.au,
	ilan.peer@intel.com,
	jtornosm@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	miriam.rachel.korenblit@intel.com
Subject: Re: [PATCH v2 0/5] wifi: add opt-in FIPS exception for iwlwifi
Date: Mon,  5 Oct 2026 18:45:21 +0200
Message-ID: <20261005164521.1037345-1-jtornosm@redhat.com>
In-Reply-To: <4ede9873924541b7bed3fc09f5b8c8eb0415ea40.camel@sipsolutions.net>
References: <4ede9873924541b7bed3fc09f5b8c8eb0415ea40.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi Johannes,

Following your guidance, I have been working on the v3 approach:
PTK/GTK software-only. Let me share my results, although spoiler,
I think I need a bit more of guidance.

With the minimum changes on top of the fips_allows() infrastructure
(patch below), I have bidirectional data working with SW crypto.
mac80211 handles CCMP encryption/decryption on the host, firmware
has no data keys.

However, I had to disable RX AMPDU aggregation to make RX work.
Without PTK in firmware, firmware does not set the correct bits
in the Block Ack bitmap, since it cannot validate the received
frames. The AP assumes frames were not received, retransmits,
and eventually gives up. TX AMPDU works fine because the AP has
the keys and sends correct BA back to the STA.

Disabling RX AMPDU forces individual frame ACKs, which work at
the PHY level without keys. The throughput cost is significant:
~12-30 Mbps instead of ~500 Mbps with HW crypto.

Analyzing the Block Ack protocol, I think the BA bitmap only
requires the Sequence Number (from the unencrypted MAC header) and
CRC validation (PHY-level). So neither could require decryption keys.
Could we allow this behavior?
Is there a firmware mode where firmware acknowledges all CRC-valid
frames in the BA regardless of decryption status?
That would allow RX aggregation with SW-only crypto and recover most of
the throughput.

The minimal diff on top of the fips_allows() infrastructure:
(only applying 1/5 and 5/5 patches)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -462,7 +462,7 @@
-	if (!fips_enabled)
+	if (fips_allows(FIPS_EXCEPTION_WIFI_MFP))
 		ieee80211_hw_set(hw, MFP_CAPABLE);

@@ -1041,7 +1041,8 @@
-		if (!iwl_enable_rx_ampdu()) {
+		if (!iwl_enable_rx_ampdu() ||
+		    (fips_enabled && fips_allows(FIPS_EXCEPTION_WIFI_MFP))) {
 			ret = -EINVAL;

The first change restores MFP_CAPABLE when the FIPS exception is
set, so WPA3-SAE association works. The second change rejects
AddBA RX requests in FIPS mode, forcing individual PHY-level ACKs.

Thank you for your help

Best regards
Jose Ignacio

