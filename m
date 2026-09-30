Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5EE4CE695
	for <linux-crypto@vger.kernel.org>; Wed, 30 Sep 2026 12:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790770140; cv=none; b=t5uokTR2/W0toYq3qDTQZVfS2/lvM5E9JM8yVv7kJm0cPt5wmr+aFEdDMAAnFvNB5htk/GMSsGsPQKClyuZHovZLb1loS8Dy2z5xM46oCc54NP9GFaLD1R+PdpEM28czWlizeM2L6w/JaUfSd3CHCB0b2x8I2vz8Dje197paGuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790770140; c=relaxed/simple;
	bh=nzLmPECupE8+xrUYUyXeGHQ/oWU9iiUuLWY8OBHoVM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBsW+XJ403Xkgjtc7BAw6TQ8BS2wa2YhOahvX57GhWZM4I86VYUPk7xltfHy203WMbX7UzLY/KsI1AZrDb68Vps1ZFfB9DYbKNR6DU3Wj5ijszDMG6Ahz3GODNmRbhNtLIyjDFthsh7M1FFYQi8iK8K5++QHRFGrsdlZMauc+1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J2MPg5ln; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J2MPg5ln"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790770137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aL/5q/FWQKCFAGXSQqcBeSvMvydd/dQdrpGsvg/O698=;
	b=J2MPg5ln3FkQ3/mrnBxOQ28imS2ThKR/fZOmZ7ngvVXvuwXhhLlD6RZy5T1lkxP8yPaqBp
	suj7WPlurFlVwdsDLrZVSyuxlUn1m8ovCVbi8fQsmGpgUOworf4Wb9Lu8zGOvlcJkQN615
	RlP/ufBPQPUKykO3xUrksGwSHvsL0f4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-rJ1EKlqDMYeu6KjHRi_l3w-1; Wed,
 30 Sep 2026 08:08:51 -0400
X-MC-Unique: rJ1EKlqDMYeu6KjHRi_l3w-1
X-Mimecast-MFC-AGG-ID: rJ1EKlqDMYeu6KjHRi_l3w_1790770130
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A514195C279;
	Wed, 30 Sep 2026 12:08:50 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8CC51180035F;
	Wed, 30 Sep 2026 12:08:47 +0000 (UTC)
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
Subject: [PATCH v2 2/5] wifi: mac80211: allow keys to driver with fips_exception
Date: Wed, 30 Sep 2026 14:08:25 +0200
Message-ID: <20260930120829.383408-3-jtornosm@redhat.com>
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

Commit 5241526dede9 ("wifi: mac80211: don't send keys to driver
when fips_enabled") blocks all keys from reaching the firmware
when fips_enabled. While this prevents firmware from using
non-validated crypto, it also means the firmware has no PTK/GTK
installed and blocks all data frames, resulting in a WiFi
connection authorized but with no traffic.

When FIPS_EXCEPTION_WIFI_MFP is set via fips_exception boot
parameter, use fips_allows() to allow keys to reach the firmware
so that data traffic works. The data encryption (CCMP/GCMP) is
still handled by mac80211 software crypto using FIPS-approved
algorithms on the host CPU, but the firmware needs the keys
installed to allow frames through.

Without fips_exception set, the behavior remains exactly as
commit 5241526dede9 implemented.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v2: complete the conditional FIPS disabling revert
v1: https://lore.kernel.org/all/20260629121213.597038-2-jtornosm@redhat.com/

 net/mac80211/driver-ops.c | 2 +-
 net/mac80211/driver-ops.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 49753b73aba2..0a50684d9cf6 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -519,7 +519,7 @@ int drv_set_key(struct ieee80211_local *local,
 		    !(sdata->vif.active_links & BIT(key->link_id))))
 		return -ENOLINK;
 
-	if (fips_enabled)
+	if (!fips_allows(FIPS_EXCEPTION_WIFI_MFP))
 		return -EOPNOTSUPP;
 
 	trace_drv_set_key(local, cmd, sdata, sta, key);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index f1c0b87fddd5..a24230feb864 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -903,7 +903,7 @@ static inline void drv_set_rekey_data(struct ieee80211_local *local,
 	if (!check_sdata_in_driver(sdata))
 		return;
 
-	if (fips_enabled)
+	if (!fips_allows(FIPS_EXCEPTION_WIFI_MFP))
 		return;
 
 	trace_drv_set_rekey_data(local, sdata, data);
-- 
2.55.0

