Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DBD4949E0;
	Thu,  1 Oct 2026 16:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790873692; cv=none; b=RPCFYgQWgM5TEYYToLR8aLAyCrzSDkBAD96SXbyvER3B0EJ2We6bgllLAXX1gXVNC0Z3fLP+GLDOI86LLwZpO3GFdeEEAi/FFkqX9j2keZDO4Zc0LIUJs0JMzTTisOaEdgJ1ijo/hAzKj5n5j3zob3o8B38m4q4ATOS9SdJHoA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790873692; c=relaxed/simple;
	bh=yXq+gcSfkIaoIKjLI8CEojYIwNl8HUAmTygaWX14pa4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=knsbZEWOAkgaU1pM8Wqf55JG5M4E1W+rVtPmcSyaQqgVMUDzQ4bWfpWJEDBeRgVCT9PyKCTj5xszh7KWQctPnS91ifatWByLCheU8IV4SBuwlJZKpMVVfNKIg9pQPM+YPcOfmDKNMq+YFdOhbd+jc0NaHP2GvEjLR/j1ZwWHNvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vM/EbmY7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vM/EbmY7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=yXq+gcSfkIaoIKjLI8CEojYIwNl8HUAmTygaWX14pa4=;
	t=1790873689; x=1792083289; b=vM/EbmY7xD+ZfcgQXTRpEx+8EZMOPNA0HFlKleGEMlgavWL
	qc8Incr7UzxjwA197Z9Y19pLS2d8nCS8vuX+83IW/t/1QCbtLXUtkaDbvQ4A8C2sadQoqOLA+1SHO
	qUiuv0omUL4pP+mCWqJCFrjFkGaKpxjB4sWLy5ylvTRUdGuechBfRcHBf2xiocaIdTOOK4RFQi2Y9
	rPEvhz52SRyQnf4YZ2NitS6dePHxHl7MJrbQ56DpYXNL6GsI2+REL3uCsgRi0hqCYFqeotcnTNRNk
	/tC+R8cS5hOBB/U5wVgJv/h4cq7C4syz0A9jJ6ffs+Djci/sx3vPC4k1cIjPTFww==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCJVS-00000000Fda-431u;
	Thu, 01 Oct 2026 18:19:39 +0200
Message-ID: <eac35c39724254fe0b208d50130cd6a6737ee407.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/5] wifi: add opt-in FIPS exception for iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: davem@davemloft.net, emmanuel.grumbach@intel.com, 
	herbert@gondor.apana.org.au, ilan.peer@intel.com,
 linux-crypto@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org, 	miriam.rachel.korenblit@intel.com
Date: Thu, 01 Oct 2026 18:19:38 +0200
In-Reply-To: <20261001155924.168311-1-jtornosm@redhat.com>
References: 
	<5cb9e89db758fd3af22d3a168a93406fef82c5c2.camel@sipsolutions.net>
	 <20261001155924.168311-1-jtornosm@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi,

> What I would like and what we need is: data encryption stays in
> software (FIPS-compliant), WiFi connectivity works, and we accept
> that some management frame protection is not fully FIPS-validated.

Fair.

> > Well, it does work without MFP, so fundamentally the firmware can pass
> > data without having keys?
>=20
> That is what I would expect, but in v1 I only re-enabled MFP_CAPABLE
> without passing any keys to firmware and got connection but no data
> traffic. Looking at the code, mac80211 SW crypto plumbing works
> correctly when drv_set_key() does not install keys in hardware,
> and the TX path sets IWL_TX_FLAGS_ENCRYPT_DIS for pre-encrypted
> frames. So the host side should handle it. My suspicion is that
> firmware changes its behavior when MFP is negotiated, expecting
> keys to be installed, and drops encrypted data frames it cannot
> decrypt instead of forwarding them to the host. The SEC_ENC_ERR
> messages I saw in v1 were likely from management frames, not data.
> Any guidance on this would help me take the right approach for v3.

I don't _think_ it does that. It does behave a bit differently for MFP,
but that's wrt. management frames.

Fundamentally, in this case the driver (even mac80211) shouldn't install
(data) keys to hardware.

> > That's not the point - the point is that there are different
> > dependencies and you didn't think about _why_ something is disabled.
> > Not all of this is all related to MFP.
>=20
> Fair point. These dependencies were not documented in the original
> disabling commits, so I treated everything as a single block to
> revert. Could you clarify which features depend on MFP, which on
> HW crypto, and which on other reasons? That would help me get
> the separation right.

I'd need to sit down and (re-)derive that, but I don't recall it being
particularly tricky - just boils down to the various dependencies
between features.

> Spelled out: data encryption (PTK/GTK) must stay in software
> (FIPS-compliant). We accept that firmware-autonomous management
> frames (like AddBA) are not FIPS-protected. We accept reduced
> uplink throughput from missing TX aggregation. We do not need
> big A-MSDUs or WoWLAN. The goal is a working WPA3-SAE connection
> with FIPS-compliant data path.

Presumably that would mean IGTK/BIGTK can be offloaded and remain
working, but TK/GTK can't be known to the firmware since it's not FIPS
certified.

I mean, you _could_ push this further and keep almost all features: you
still give PTK/GTK to firmware but don't use the offload mechanisms for
data frames; though presumably then you'd not consider the result "good
enough" since then a non-certified component (the firmware/hardware)
holds the keys...?

> Also, is the general approach of an opt-in boot parameter
> (fips_exception) to keep the default behavior unchanged
> acceptable, or would you prefer a different mechanism?

I have no opinion on that, I guess the crypto folks should chime in
about that. Having something very obvious makes sense to me, vs. having
it at wifi or even driver level.

johannes
