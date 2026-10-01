Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDB54E4C30
	for <linux-crypto@vger.kernel.org>; Thu,  1 Oct 2026 15:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790870379; cv=none; b=JIJzBqgYLmY0YZPHAttmlLlv5IOLfPxf2gcT2TLcVV5TCs2gY+DYqwgjr1PX/NtPl9n/QqdrS1XKfTJ0jgh6fcLIhrrAF46YDhFBn3YxqPRubE5pYnzuYho494AF8RUQ+2WNgXIft02S/JMUmUQYyDbW/pKj7qZ3ahUn9W/uc6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790870379; c=relaxed/simple;
	bh=VSOQRqkRi9QhMTkEEnVtkYBylSOIqf7jD4LzCWJyB1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVn+R2QZUEEG3hIe8BOoE4DxZlOL136LQXx15gTqRacYfpqjGjqOiG/0AWui2qslOm5hetBihX7069qOB6x0wylw9pYlq0ohqH5QBrZ6wknqqBaNjKjn0Aa3Bl1IdZjBR/Owp+ddbCRNDeeZXx/uYYPt14slRcW+jPgFt0MHfzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gcxb1NY8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gcxb1NY8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790870375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VSOQRqkRi9QhMTkEEnVtkYBylSOIqf7jD4LzCWJyB1U=;
	b=gcxb1NY8bWuoyx+Z2L28+EoDaJPLogX0L3tGIJEyF5h7k3fK0WLT7M+bcs6uZkfvIPVaUn
	39pFm+2ytvdDD9Ki0XWIvEUNzSDsVuWqQEwuHSq3TRaSmzMjzCooGMOpEYnnfNYR/xqjA4
	uuD6benqrUBC78o56UawZi2N1pD48UE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-73-0C8GnYawMNOvZcs4wuQPzg-1; Thu,
 01 Oct 2026 11:59:31 -0400
X-MC-Unique: 0C8GnYawMNOvZcs4wuQPzg-1
X-Mimecast-MFC-AGG-ID: 0C8GnYawMNOvZcs4wuQPzg_1790870370
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20CA618005B4;
	Thu,  1 Oct 2026 15:59:29 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E611E1956089;
	Thu,  1 Oct 2026 15:59:25 +0000 (UTC)
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
Date: Thu,  1 Oct 2026 17:59:24 +0200
Message-ID: <20261001155924.168311-1-jtornosm@redhat.com>
In-Reply-To: <5cb9e89db758fd3af22d3a168a93406fef82c5c2.camel@sipsolutions.net>
References: <5cb9e89db758fd3af22d3a168a93406fef82c5c2.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Johannes,

> Yes, it does remain disabled, but then (for example) why allow
> set_rekey_offload() to go through - it's clearly not necessary.

Ok, understood, set_rekey_offload() is not needed with WoWLAN
disabled, that was an oversight.

> But again, what are you actually trying to achieve?

What I would like and what we need is: data encryption stays in
software (FIPS-compliant), WiFi connectivity works, and we accept
that some management frame protection is not fully FIPS-validated.

> If you want big A-MSDUs, then you need hardware crypto, which you allow
> now, which would seem to _completely_ defeat the purpose of FIPS here
> (to protect data, if you read it charitably vs. just saying it's for
> paper-pushing).

Analyzing it again with your comment, you are right about A-MSDUs,
if there is no HW crypto then big A-MSDUs are not possible anyway,
so restoring A-MSDU sizes was wrong.

> OTOH, why does IGTK matter so much to you? That particular key has no
> relation to data protection, so arguably *that* could still be
> offloaded. But you're doing it all precisely the other way around.

And you are right about IGTK, it has no relation to data protection
so it could be offloaded, and I should not have kept it in software
while sending PTK/GTK to firmware. That was indeed the opposite.

> Well, it does work without MFP, so fundamentally the firmware can pass
> data without having keys?

That is what I would expect, but in v1 I only re-enabled MFP_CAPABLE
without passing any keys to firmware and got connection but no data
traffic. Looking at the code, mac80211 SW crypto plumbing works
correctly when drv_set_key() does not install keys in hardware,
and the TX path sets IWL_TX_FLAGS_ENCRYPT_DIS for pre-encrypted
frames. So the host side should handle it. My suspicion is that
firmware changes its behavior when MFP is negotiated, expecting
keys to be installed, and drops encrypted data frames it cannot
decrypt instead of forwarding them to the host. The SEC_ENC_ERR
messages I saw in v1 were likely from management frames, not data.
Any guidance on this would help me take the right approach for v3.

> That's not the point - the point is that there are different
> dependencies and you didn't think about _why_ something is disabled.
> Not all of this is all related to MFP.

Fair point. These dependencies were not documented in the original
disabling commits, so I treated everything as a single block to
revert. Could you clarify which features depend on MFP, which on
HW crypto, and which on other reasons? That would help me get
the separation right.

> But again, the way you did that doesn't make any sense.

I just reverted the necessary parts (to me) to the previous working
state. I can narrow it once I understand the correct separation.

> Which is the opposite of what you actually did.

Understood. The patches gave data keys to firmware (defeating FIPS
for data) while keeping management keys in software. The correct
approach should be the reverse: keep PTK/GTK in software for
FIPS-compliant data encryption, and offload IGTK if needed since
it has no data relation. Happy to rework this properly for v3.

> I really do think it starts with spelling out what you (or your
> customers) actually want, and what trade-offs wrt. FIPS you're
> willing to accept.

Spelled out: data encryption (PTK/GTK) must stay in software
(FIPS-compliant). We accept that firmware-autonomous management
frames (like AddBA) are not FIPS-protected. We accept reduced
uplink throughput from missing TX aggregation. We do not need
big A-MSDUs or WoWLAN. The goal is a working WPA3-SAE connection
with FIPS-compliant data path.

Also, is the general approach of an opt-in boot parameter
(fips_exception) to keep the default behavior unchanged
acceptable, or would you prefer a different mechanism?

Thanks

Best regards
Jose Ignacio

