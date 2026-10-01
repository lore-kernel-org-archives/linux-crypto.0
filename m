Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511D04570E4
	for <linux-crypto@vger.kernel.org>; Thu,  1 Oct 2026 18:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790880751; cv=none; b=AzX4j8L3+4a16kMYh7mnGJhnBFHDkPPN2yvSBWHjeVYq2vPInlLWcL5vcHVP9RcvMKpyLhxCr6/3Ywvx6EQ9BZ/OJNDz8w9gdLSKQzAAiY/RHhBnfoAnwMVQ28FUIDXMfIOK1j7vCXIki8rElMj8T/XvLiaq1UZrFzPbSm3Y/eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790880751; c=relaxed/simple;
	bh=NzLZKjU8ptejrY+87RgUK703ZHzae+j0fTkW4FgVOn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfoOF0X8gJKSy83FtxfmXxLMnqL3SuYgQK8AJXLjGrA5ttnRsIip2mliFbiEUv6dC2HDiVG/ca1aYzJqs2zPtk6UYimY4C/c3LJme7ohooVuTbdwd1M/aGgigWY0Zfg1YNkUG6OLsxIzhIsWQ2gQMquwASJC70JqVJBmtxYnRMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cUUhOzS+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cUUhOzS+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790880749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NzLZKjU8ptejrY+87RgUK703ZHzae+j0fTkW4FgVOn8=;
	b=cUUhOzS++81QMiTBW25N4lOPOKNdldXmA26uLfOvMOqJA+yLJKmnrQow1vKmrX0hAaMbcx
	lWnbKRyMm/B+d6GMJe8W1qj1WkbsQX7IpqXkhaA+80IXhF51Ve8xTuWW84Ri+KprBf3tqu
	URMLTBpDnf86g3ffVneec3x49RuRiwI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-hxfPdkq5MC2aPInYBxrjgw-1; Thu,
 01 Oct 2026 14:52:25 -0400
X-MC-Unique: hxfPdkq5MC2aPInYBxrjgw-1
X-Mimecast-MFC-AGG-ID: hxfPdkq5MC2aPInYBxrjgw_1790880744
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 23D531905692;
	Thu,  1 Oct 2026 18:52:23 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9106D1956089;
	Thu,  1 Oct 2026 18:52:20 +0000 (UTC)
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
Date: Thu,  1 Oct 2026 20:52:18 +0200
Message-ID: <20261001185218.189030-1-jtornosm@redhat.com>
In-Reply-To: <eac35c39724254fe0b208d50130cd6a6737ee407.camel@sipsolutions.net>
References: <eac35c39724254fe0b208d50130cd6a6737ee407.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Johannes,

> I don't _think_ it does that. It does behave a bit differently for MFP,
> but that's wrt. management frames.

Good to know. I will re-test with just MFP re-enabled and no data
keys to hardware, adding more debug logging to understand where
data gets stuck. Something else must have been wrong in my v1 test.

> Fundamentally, in this case the driver (even mac80211) shouldn't install
> (data) keys to hardware.

Ok

> I'd need to sit down and (re-)derive that, but I don't recall it being
> particularly tricky - just boils down to the various dependencies
> between features.

Ok, I can assume there are no other dependencies to start with.

> Presumably that would mean IGTK/BIGTK can be offloaded and remain
> working, but TK/GTK can't be known to the firmware since it's not FIPS
> certified.

Ok, I will take this approach for v3: IGTK/BIGTK offloaded to
firmware, PTK/GTK software-only.

> I mean, you _could_ push this further and keep almost all features: you
> still give PTK/GTK to firmware but don't use the offload mechanisms for
> data frames; though presumably then you'd not consider the result "good
> enough" since then a non-certified component (the firmware/hardware)
> holds the keys...?

Ok, for our customers having the keys in a non-certified component
would not be acceptable. The simpler approach is better for this case.

> I have no opinion on that, I guess the crypto folks should chime in
> about that. Having something very obvious makes sense to me, vs. having
> it at wifi or even driver level.

Then I will keep the boot parameter approach and make sure to Cc the
crypto maintainers for their input.

I will work on the feature dependencies myself and come back with
a cleaner v3. Thanks for the guidance, very helpful.

Best regards
Jose Ignacio

