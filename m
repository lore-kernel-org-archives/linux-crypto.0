Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AB840F731
	for <linux-crypto@vger.kernel.org>; Thu,  1 Oct 2026 13:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860147; cv=none; b=oghSkSXjnrmmO/BMTQ5/H72p6qbxG6jLR5Ti625OLwX4TNGUI7sDRbVVprbw8fwlGukOKOuic8kMxGAlcJ0/Kxyz8nsXVFL4vHV9HhIXoivDCkK8NLhbuM0qLd2SC7X1i5+lU3SIArhJee9qIc3kBflrJs3d07+/5quuuw9gXUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860147; c=relaxed/simple;
	bh=P0m7BTgPA3NFnKogK6RGHVIwvl83jT0YfIAkvm6FzKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRtOryYnMC3O4/cXDDFrM220vvADmY3D3mrTWRFfoSFIfGy72JUMgBnqlxoTmqawCsklUU0KS2KnJzxyXn8p1arf4Rux8UONM184iLl7uJxMyzGHNL9O4X4fkUBT08FOEAw4G6NaCcd+XahR/Q9wS8QnGYK7H2Af87Erk9XUlto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bYfi2KsA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bYfi2KsA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790860144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P0m7BTgPA3NFnKogK6RGHVIwvl83jT0YfIAkvm6FzKk=;
	b=bYfi2KsAlHQdEuZh2x0/b1zbcyYFR4SuT0kmlULS9MA53S/d7xfMUctps8gzF3tEf+O4oO
	XXLYGQwuqdv+YsFh9e0fii1YvXH0UYWvSvSmfHoZB2cHTY2k4W52rme5K+pxPsUlXXVrql
	9rX3d8k1kuHOyhoNS9MnhFPS5KF7TMk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-z74um1bVNIKbgOTd5p3ZSA-1; Thu,
 01 Oct 2026 09:09:00 -0400
X-MC-Unique: z74um1bVNIKbgOTd5p3ZSA-1
X-Mimecast-MFC-AGG-ID: z74um1bVNIKbgOTd5p3ZSA_1790860139
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DF531955DA6;
	Thu,  1 Oct 2026 13:08:58 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DDE9930000E4;
	Thu,  1 Oct 2026 13:08:54 +0000 (UTC)
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
Date: Thu,  1 Oct 2026 15:08:53 +0200
Message-ID: <20261001130853.137567-1-jtornosm@redhat.com>
In-Reply-To: <47ebbd91b4bdb57723be40608349eff9ced1f34b.camel@sipsolutions.net>
References: <47ebbd91b4bdb57723be40608349eff9ced1f34b.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Johannes,

Based on the discussion around v1, I tried to prepare a more complete
proposal addressing the concerns raised there (AddBA, CSA, robust
action frames). I understand I may have gone too broad and missed
some aspects of how encryption offload works internally, without
access to firmware documentation it is difficult to get everything
right.

Just to clarify a few points, WoWLAN was intentionally kept disabled
in the patches (both mvm and mld paths), precisely because it requires
all traffic via firmware crypto during suspend. IGTK handling was not
changed either, as mac80211 already handles it in software. A-MSDUs
are not directly MFP-related, fair point, but they were part of the
same commit being reverted, because patch 2 and patch 3 are just
reverting some parts of the FIPS disabling to try to get it working
again under the exception.

On the specific patches:

Patch 2: In v1, I only re-enabled MFP_CAPABLE without passing keys
to firmware, the result was connection but no data traffic. That is
why I added key delivery in v2. Is it possible to keep software
crypto for data while having a functional connection, or does the
firmware require keys installed to pass frames? This would help me
understand the correct approach.

Patch 3: I can narrow this to the minimum needed. Some features
(EHT, 6GHz) depend on MFP so I included them, but I agree it
could be more selective.

Patch 4: The intent was host-side crypto for management frames via
SW_MGMT_TX (same mechanism as ath9k, rtw89, etc.), but I understand
this depends on how patch 2 is resolved.

Ultimately, I just want to fix a problem affecting our customers who
are interested in keeping WiFi working, accepting that some lower-level
management frames are not FIPS-compliant while the important part for
them, data encryption, is. The default behavior is maintained, this
is only allowed if the exception is explicitly configured. This was
working before the commits and our customers already have this
hardware deployed.

I don't want to bother you with more patches without guidance. I can
try to engage Intel on this, but any help, recommendation on the right
approach to try to solve this in some way would be appreciated.

Thanks

Best regards
Jose Ignacio

