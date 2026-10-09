Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5F23537D2
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 06:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791528868; cv=none; b=nS8X8RnLXl7K0wCSJHXsTj5bvMU6f014iTEppm+wIEzX4unNd3CEbjUCLlgMDMRmEw2Ap+L6Zcyq9xyyI1V6NTC+9K9qX+TjaNtkr/uliAtqrL6FhxWW/6LNPIkfK4sy6wTZqQ7LLxrawLvSAzLUmLlEtjWc6tjZPif3B6hKsQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791528868; c=relaxed/simple;
	bh=m2zQVkcbcbSAMrYr2LYxACrbU+VgKN2r9zn0rSs0pnI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cgQVlgGVn3XfFJ8Xrg4JlzoJL52Wno1Y5uxVjVOQPbog3qJUKP1Vn3qHt54lvjmXCGUy3Qr7ofZMgQwWznLMuL7AI6S+9PqTQLadzx9Rgeh0A3D47wULdCsjtpZpFf4Efd5VOTjWRw+y3uHEjt/URvp6mppeuDTiva3+uUUvay4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QafL9pcE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QafL9pcE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791528865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MYSDTGTi24omrQKQQ1wJaO1ftwe6RCJQ1+775Gx5ePY=;
	b=QafL9pcE1pGZM2Kh23LHOA10FiLGHILx71Ogz5EBD/WQJFi8Q8+KIo2VmRXc1OK/IgzWSD
	9HCfKCEvxk+neipECo+2PN8v1j8Tt2lksMvh3BeEAfpjVIWUEE64N2GPXk9QrCmswHpU/L
	n4noYXLewG4+E2D5W5CEWVodiJJCv9Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-218-Ycci_0HhP92L0o9xHKUPOA-1; Fri,
 9 Oct 2026 06:54:19 +0000
X-MC-Unique: Ycci_0HhP92L0o9xHKUPOA-1
X-Mimecast-MFC-AGG-ID: Ycci_0HhP92L0o9xHKUPOA_1791528858
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 752201955F6D;
	Fri,  9 Oct 2026 06:54:17 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CAF941956095;
	Fri,  9 Oct 2026 06:54:14 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	johannes@sipsolutions.net,
	miriam.rachel.korenblit@intel.com
Cc: ilan.peer@intel.com,
	emmanuel.grumbach@intel.com,
	linux-crypto@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] wifi: add opt-in FIPS exception for iwlwifi
Date: Fri,  9 Oct 2026 08:54:09 +0200
Message-ID: <20261009065413.53403-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Commits 5241526dede9 ("wifi: mac80211: don't send keys
to driver when fips_enabled") and 0636800c8ee1 ("wifi:
iwlwifi: disable certain features for fips_enabled")
disabled WiFi functionality under FIPS mode because
Intel firmware autonomously sends some management
frames without FIPS-validated integrity protection.

While this is technically correct, it leaves
FIPS-required environments with no WiFi connectivity
at all, since WPA3-SAE mandates MFP and without
MFP_CAPABLE the client cannot even associate.

This series introduces an opt-in fips_exception=<bitmap>
kernel boot parameter that allows administrators who
understand the firmware limitation to explicitly choose
connectivity over strict compliance. No keys are
installed in firmware; mac80211 handles all data
encryption/decryption in software using FIPS-approved
algorithms. The default behavior remains exactly as the
original commits implemented.

This is a provisional v3 to show the current working
state and continue the conversation from [1]. Changes
and pending items are based on Johannes's very helpful
guidance.

With fips=1 fips_exception=1 on Intel AX211, this
series enables:
- MFP (802.11w) with software crypto in mac80211
- RX AMPDU aggregation
- Bidirectional data with no keys in firmware

Known limitation:
- No TX A-MPDU aggregation. Firmware sends ADDBA
  unprotected, AP drops it (MFP). Host-driven ADDBA
  from mac80211 can work at the protocol level but
  TLC does not aggregate. Details in [1].

Pending for later versions:
- IGTK/BIGTK offload to firmware
- 6 GHz / EHT dependencies
- TX aggregation (if possible)

Test setup:
  AP: WPA2-PSK ieee80211w=2, channel 52 80MHz HE
  STA: Intel AX211, fips=1 fips_exception=1
  RX: ~450 Mbps (iperf3)
  TX: ~26 Mbps (iperf3, no A-MPDU)

[1] https://lore.kernel.org/all/20261009064326.43891-1-jtornosm@redhat.com/

v3: Address comments from Johannes:
    - Drop PTK/GTK offload to firmware, software-only
      crypto
    - Drop A-MSDU size restoration
    - Drop set_rekey_offload
    Per patch:
    - 1/4: same as v2 1/5 but fips_allows() renamed to
      fips_allows_exception() with more suitable semantics
    - 2/4: v2 2/5 (key gate), v2 3/5 (feature restore)
      and v2 4/5 (SW_MGMT_TX) dropped, replaced by only
      enabling MFP_CAPABLE
    - 3/4: new, RX AMPDU and A-MSDU fixes for SW crypto
      path
    - 4/4: same as v2 5/5
v2: https://lore.kernel.org/all/20260930120829.383408-1-jtornosm@redhat.com/

Jose Ignacio Tornos Martinez (4):
  crypto: fips: add fips_exception kernel boot parameter
    and fips_allows_exception() helper
  wifi: iwlwifi: enable MFP_CAPABLE in FIPS mode
  wifi: iwlwifi: fix RX AMPDU and A-MSDU in FIPS mode
  wifi: iwlwifi: reduce encryption error message to
    debug level in FIPS mode

