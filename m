Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71934CDDD4
	for <linux-crypto@vger.kernel.org>; Wed, 30 Sep 2026 12:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790770127; cv=none; b=Kikj1hw3OQtTmPOeptrxkokTCYyvRFhV+nyLg//nouGDIU6MQD/e3P8daZC/XDL+g94HgApDZUGkoCgzw+V0nlxeMHbNrE5x+OBdLA96V31YsDs8oDiKgb5RY1jxRXQNVCZppMzC9ho/F4Gi7gJFqAlUjAe6YqLmzAho8d3iI+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790770127; c=relaxed/simple;
	bh=PUZyVtL/WwsyN3mMHzNBsiMogc4tTnXgQ0B4qRVLOkI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oFDdynVAP/Y94AN9M8WdJAXnnuVWSY9LFTta1HdyO0REWNFP2y9t7+tcFGB8vSJ22eGP1zyFSvM1ioQQZCcXlWzjjsJG3/2IvTDRclHJGJcePgVJlLM1Nvi+xr79Sf1knwLbIOOPHN9JU8ZG2DeemHDCcBct4y3Zv3M+q6FlA7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F0aeyv6B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F0aeyv6B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790770124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9rhp3IqEZms1d4OK2w2EJagR67qK0XPrx1WrGr8q7e8=;
	b=F0aeyv6B9JrBhk/ug/68jzqI6iZA0zMUVj3mCeeHK7M7wcmZ0JVIMKjISp4NtR0iSwZ922
	AVSCf2yQ9WEaCKFyxyK7O0dqYaoND91c4Y6fR7Yv1ILBijNRme/bi2JJCmZcWQKrZh/XpG
	1Hty1xH/32SPcB61aRLvHLNXrwopgkg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-532-c5OWs_w9Meq6ozMcBP6Q5A-1; Wed,
 30 Sep 2026 08:08:41 -0400
X-MC-Unique: c5OWs_w9Meq6ozMcBP6Q5A-1
X-Mimecast-MFC-AGG-ID: c5OWs_w9Meq6ozMcBP6Q5A_1790770120
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76044190F9D3;
	Wed, 30 Sep 2026 12:08:37 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 68B701800612;
	Wed, 30 Sep 2026 12:08:34 +0000 (UTC)
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
Subject: [PATCH v2 0/5] wifi: add opt-in FIPS exception for iwlwifi
Date: Wed, 30 Sep 2026 14:08:23 +0200
Message-ID: <20260930120829.383408-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Commits 5241526dede9 ("wifi: mac80211: don't send keys to driver when
fips_enabled") and 0636800c8ee1 ("wifi: iwlwifi: disable certain features
for fips_enabled") disabled WiFi functionality under FIPS mode because
Intel firmware autonomously sends some management frames without
FIPS-validated integrity protection.

While this is technically correct, it leaves FIPS-required environments
with no WiFi connectivity at all, since WPA3-SAE mandates MFP and without
MFP_CAPABLE the client cannot even associate.

The data encryption paths (CCMP/GCMP via PTK/GTK) are handled by mac80211
software crypto using FIPS-approved algorithms on the host CPU. The known
gap was management frame integrity protection on the TX side, where
firmware bypasses the host crypto stack.

This series introduces an opt-in fips_exception=<bitmap> kernel boot
parameter and an exported fips_allows() helper function that allows
administrators who understand the firmware limitation to explicitly
choose connectivity over strict compliance. The FIPS_EXCEPTION flag uses
generic WIFI_MFP naming (not iwlwifi-specific) since the mac80211 key
blocking affects all drivers. The default behavior remains exactly as the
original commits implemented.

v1 (2 patches) unconditionally re-enabled MFP without addressing
the firmware limitation for robust action frames and was rejected.
v2 replaces this with an opt-in exception, extends coverage to all
disabled features (key delivery, Beacon Protection, EHT, 6GHz,
A-MSDU, MLO) and both driver paths (mvm + mld), and adds SW_MGMT_TX
for host-side management frame protection.

AddBA (TX aggregation setup) cannot be fixed this way because firmware
creates these frames autonomously (TX_AMPDU_SETUP_IN_HW), bypassing
mac80211's TX path. The only observed degradation with the exception
active is reduced uplink throughput: firmware-created AddBA requests
are silently discarded by the AP, so TX aggregation is not established.
Downlink aggregation (AP to STA) works normally. No other functionality
is observed to be affected. Since the AP drops unprotected
firmware-autonomous frames rather than accepting them, the system
remains secure — those frames are simply not considered.

Multicast robust management frames (e.g. group-addressed deauth in AP
mode) are protected by IGTK via AES-CMAC/GMAC, which mac80211 handles in
software. Firmware-generated multicast management frames may lack
integrity protection, but a STA does not generate these normally.

Spectrum Management / CSA: a STA does not send CSA (AP-only).
On the RX/STA side, re-enabling MFP and Beacon Protection
(patches 2/3) restores the existing mac80211 protection layers:
1. MFP (patch 3) drops unprotected Spectrum Management action
   frames — these are robust action frames (category 0)
2. Beacon Protection (patch 3) validates beacon CSA IEs via BIGTK
3. Unprotectable Extended CSA (Public action, category 4) only
   blocks TX queues and requires beacon confirmation before channel
   switch (ieee80211_sta_process_chanswitch)
Spectrum Management responses from the STA (e.g. Measurement
Report) are built by mac80211, not firmware, so they go through
the normal TX path and are protected by SW_MGMT_TX (patch 4).
On the TX/AP side, beacons are built from mac80211 template and
protected by Beacon Protection (BIGTK) when re-enabled.

WoWLAN remains disabled under FIPS regardless of the exception flag,
as it requires all traffic to be handled by firmware crypto during
suspend (the host CPU is not available for mac80211 software crypto).

Patch details:
Patch 1: Adds the fips_exception infrastructure (boot parameter,
         read-only sysctl, fips_allows() helper)
Patch 2: Gates the mac80211 key blocking with fips_allows() so keys
         can reach the firmware for data traffic
Patch 3: Gates the iwlwifi feature disabling with fips_allows(),
         restoring MFP, Beacon Protection, EHT, 6GHz, A-MSDU sizes
         and MLO support
Patch 4: Best effort to force software encryption for unicast
         management frames (CCMP/GCMP). It sets
         IEEE80211_KEY_FLAG_SW_MGMT_TX on pairwise CCMP/GCMP keys when the
         exception is active, forcing mac80211 to encrypt unicast robust
         management frames (SA Query, deauth, disassoc) in software using
         FIPS-approved CCMP/GCMP, the same mechanism used by ath9k, ath5k,
         carl9170, mt76x02, rtw88, rtw89, rtlwifi, ... and other drivers.
Patch 5: Reduces firmware decryption error message to debug level in
         FIPS mode. Same as v1 patch 2/2, accepted upstream but not
         yet landed.

Tested on Intel WiFi 6E AX210 with fips=1 fips_exception=0x1:
- WPA3-SAE connection with MFP required succeeds
- iw station dump confirms "MFP: yes"
- Data traffic (TX/RX) works normally

v2: complete, improve and justify
    consider and analyze the feedback from Johannes Berg
v1: https://lore.kernel.org/all/20260629121213.597038-1-jtornosm@redhat.com/

Jose Ignacio Tornos Martinez (5):
  crypto: fips: add fips_exception kernel boot parameter and
    fips_allows() helper
  wifi: mac80211: allow keys to driver with fips_exception
  wifi: iwlwifi: restore FIPS-disabled features with fips_exception
  wifi: iwlwifi: use software crypto for management frames in FIPS
    exception mode
  wifi: iwlwifi: reduce encryption error message to debug level in FIPS
    mode

-- 
2.55.0

