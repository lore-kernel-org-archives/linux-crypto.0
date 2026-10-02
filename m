Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A5A4825AF
	for <linux-crypto@vger.kernel.org>; Fri,  2 Oct 2026 10:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790937927; cv=none; b=T3/FBF5k+MWtyt2bEzFPztYGsn5AJmfa5qOFVgptEIZcX4lYVZcnfbySYBnacL0+hiwWjSXg441epE6foTcUQIaygI2WuMmDvSu6/mhEtwveGsKdgE1M3ngc5JSPueZULgJ+9YCI5ym3gMJ55yGl7CHNuBnUipJxWBgTAzv1noA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790937927; c=relaxed/simple;
	bh=dGR1f+GNVEfMS1LNIZ6/CtLwpdK6ROJnEqnttlfsMtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srEkYHpOWo+rpFl44y4ClozDvc1FCPQYsCEICND/8+m+HBGL4AQa8MQaF2j7Nq2c1jSz7sfcWXy5PktvrQEiCc6fbNEIdkThEvuaJFIq/U0VyrQrbpILJeTRdgm5m16kpFspmy/2Lx2qE5x55GUR+mDZ8d+oEdHz+rd4J15MJfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vl+s958A; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vl+s958A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790937924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dGR1f+GNVEfMS1LNIZ6/CtLwpdK6ROJnEqnttlfsMtE=;
	b=Vl+s958ApZFFm2o5HXwScTRl485MjrK86qgupwBHGifcL8Cs06mgSO9Kqd11TPvDoUU0M4
	/iaUBNsZgIdvUEUCF13c9pZC00Vt0qkTKLBlV4thaIOG6T2SVo2rRvTpXxh/qT+a1PtsB+
	qlWGXAIJynSlUpnp7SqH3b2BKdwumk4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-674-oaTCLrNKO5yEw7dtjdHaQA-1; Fri,
 02 Oct 2026 06:45:19 -0400
X-MC-Unique: oaTCLrNKO5yEw7dtjdHaQA-1
X-Mimecast-MFC-AGG-ID: oaTCLrNKO5yEw7dtjdHaQA_1790937917
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E2E241935333;
	Fri,  2 Oct 2026 10:45:16 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AAE491956095;
	Fri,  2 Oct 2026 10:45:13 +0000 (UTC)
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
Date: Fri,  2 Oct 2026 12:45:12 +0200
Message-ID: <20261002104512.307060-1-jtornosm@redhat.com>
In-Reply-To: <4ede9873924541b7bed3fc09f5b8c8eb0415ea40.camel@sipsolutions.net>
References: <4ede9873924541b7bed3fc09f5b8c8eb0415ea40.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Johannes,

> A-MSDU size is definitely dependent on PTK since A-MSDU splitting
> requires hardware crypto, and otherwise the RX buffers aren't big
> enough (by default, but it's not worth the complexity, and people won't
> want to do big allocations anyway).

Ok, A-MSDU stays out.

> EHT requires MFP and beacon protection, beacon protection requires
> checking in firmware since firmware reacts to beacon frames.

Understood, so Beacon Protection needs BIGTK offloaded to firmware.
With the approach of IGTK/BIGTK to firmware, this should be
possible, and then EHT can be re-enabled.

> 6 GHz was documented in the code.

Ok, I will check the code comments for that dependency.

> MLO needs EHT and then transitively that was disabled.

Clear, the chain is MLO -> EHT -> MFP + Beacon Protection.

> The biggest question then remains what MFP gaps you create with this. I
> _think_ you might even have to install random keys to the firmware, but
> ... then maybe it wouldn't even pass certain frames to the driver? I'm
> not sure you want to accept a loss of MFP security.

This is the part I am investigating now. Without PTK in firmware,
firmware-autonomous TX management frames (like AddBA) would be
unprotected, that is the accepted trade-off. For RX, the question
is whether firmware forwards protected unicast management frames
to mac80211 for SW decryption or drops them. I am testing this.

About random keys, I think that would cause firmware to attempt
decryption with wrong keys and corrupt or drop the frames, so
probably not a viable path, but needs to be tested.

Regarding MFP security, the intention is not to lose it but to
handle it in software where possible. I think the only gap would be
firmware-autonomous frames that bypass mac80211, but of course I
need to confirm it.

Thank you for your help again

Best regards
Jose Ignacio

