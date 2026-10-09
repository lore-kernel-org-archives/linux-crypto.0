Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9033AD506
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 06:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791528220; cv=none; b=COY0sUZaeJ9oTg+XJsjYF6VUTs9unicv4NjQ4nYLAKvX+ZzGoogOentxIQgpYMoepbWeqINzd/GBV1NrcJP8910Xk6t2YgEzsxE2sAk36paDolgGOXEQ7T8UYkhs24mEMlhxl1E+38V0MUt5Xnn3brdlgbBvNjpWa3JAXqMAikk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791528220; c=relaxed/simple;
	bh=yyn6D6bfKGOTe3fsah1GxOz9P5nLVgArvK/aI+vZ/3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDo6cDq+VSIp+eSyD9yDPE8ESJqWYvHEtF9KuVRav7JkbFP/iT/meuoSx7DfNqLlMvYIAJjHMdFlBubnPYIDFrEyxNOQ9vPFx9Ctsspl1oWc8pPA0GQQ4LqHYdyyUc7dE7BgIn5fQGXAVVUJ+lMm7+KfXN8AdV/gfQA68ylafFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B337RckO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B337RckO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791528218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yyn6D6bfKGOTe3fsah1GxOz9P5nLVgArvK/aI+vZ/3Y=;
	b=B337RckOzsbUEbcBHALJg90BjIrOXXuhi7KiW9Y+KuFZCokirrhUiVgtyYeqsTAALLY/D5
	jJmFmpg2pemK88YlRLiNil6N6JQR8n98KcPOd1c6Q676wpayo4JIluiHFixLGoUYgQ4Zfm
	F8qc2g4p7lkBK6lR9p6IsmVz1XcLDB8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-T48WVRNDM12Nt61gUSa81w-1; Fri,
 09 Oct 2026 02:43:34 -0400
X-MC-Unique: T48WVRNDM12Nt61gUSa81w-1
X-Mimecast-MFC-AGG-ID: T48WVRNDM12Nt61gUSa81w_1791528212
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 612831954B08;
	Fri,  9 Oct 2026 06:43:31 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8121C1800446;
	Fri,  9 Oct 2026 06:43:28 +0000 (UTC)
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
Date: Fri,  9 Oct 2026 08:43:26 +0200
Message-ID: <20261009064326.43891-1-jtornosm@redhat.com>
In-Reply-To: <289161e6ddaf18fa63a55623c75d700850fd57b6.camel@sipsolutions.net>
References: <289161e6ddaf18fa63a55623c75d700850fd57b6.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi Johannes,

Sorry for the delay. I wanted to have concrete results
before continuing the conversation.

> No keys at all, but yeah.

Right, no keys at all in firmware.

> What are you testing with now? Still MFP?

Yes, MFP enabled. WPA2-PSK with ieee80211w=2 on the AP,
AX211 as STA, channel 52 80MHz HE.

> That doesn't really make sense. How can TX A-MPDU work
> when you have MFP, this was the bit you disabled earlier
> even with all the other work? And the firmware has to
> send the AddBA request, so that can't make it through??

You are right, it does not work. I was wrong in my
previous mail, sorry about that. Monitoring the frames
with a separate station in monitor mode (mt76) I can
see that firmware sends ADDBA Request unprotected, AP
drops it (MFP), firmware retries every ~2 seconds
followed by DELBA, all dropped. TX throughput is ~26
Mbps (individual MPDUs, no aggregation).

Following the pattern of mt76, I tested triggering
ieee80211_start_tx_ba_session() from the driver so
mac80211 sends an encrypted ADDBA through the normal
TX path. The AP accepts, the BA session is fully
established and persists, no DELBA is sent by the AP.
But TLC does not know about this host-established
session so it still does not aggregate.

Is there a way to allow TX aggregation from mac80211
in this scenario, similar to how the RX path can be
managed from the host? Or any other mechanism to let
TLC know that a BA session has been established for a
TID so it can aggregate? I could not find a TX
equivalent of STA_MODIFY_ADD_BA_TID in the firmware
API, but maybe there is another way I am missing.

> That almost seems low (11g maxed out at ~24 Mbps with
> 54 Mbps PHY rate), but depends on the channel width
> and MCS.

The same setup without fips=1 gives ~500 Mbps, so
the individual MPDU overhead explains the gap.

> I'd have said it should already work that way.

You were right. After debugging I found the places in
the RX path where frames were being dropped without
keys and fixed them (see v3 3/4).

I am sending a v3 (4 patches) with the current working
state as a provisional version to show you the status
and continue with your guidance. The series covers:
fips_allows_exception() infrastructure, MFP re-enabled,
RX AMPDU and A-MSDU fixes, and debug message reduction.
RX throughput is back to ~450 Mbps with these fixes.
TX throughput is the remaining limitation.

I plan to address IGTK/BIGTK offload and 6 GHz
dependencies in later versions of this series once we
settle the aggregation question.

Thank you for the guidance

Best regards
Jose Ignacio

