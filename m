Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A57951D51E;
	Thu,  1 Oct 2026 20:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790886188; cv=none; b=Eh/rXkv7KiuCxr5ON0VJ3I8Em/bSZ+hDfABIpMMqZekmHE4F3ENZ3DwZv9wT/Jpx5LRGseT+zTZTzQFbLzVNwISl9DgJUebXvhAqkCKiGd5A+nikQG4kcA0y9DtlGpJ6GqdljDrj+7DAzYOY5KhTBo80jCR8XxH0RcfV0N4SuSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790886188; c=relaxed/simple;
	bh=QH0Ond0pO0Z/CebP1SXSVOfeQ2bDj0kyIRwKTBh+YNw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bN6wDZidp1HsbGzzERo+MxdJltqvcGbxMxwl3hlSym3CZg1fikbldQ6eHFSJOHAhB8LVGVJCFIHwGYRUsPTjxqgSVb4Ak+ekNc1+1zQxvVbyY9Bx6n69P0ZoWIxpcMvHv8vObGruXdFFtLUzGIEBl70Ai+gOGZEobhUWsAxxvT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Hp6E7lO+; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Hp6E7lO+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=QH0Ond0pO0Z/CebP1SXSVOfeQ2bDj0kyIRwKTBh+YNw=;
	t=1790886186; x=1792095786; b=Hp6E7lO+FE7A4yIxfFK628HFs/kkgSp0H1YSok8BoFjs28V
	t4FkcRUhMMVdHWAHSPNciSPvaT12mpRF8p32cZEgG+mPKLJ18w37bffofwBfjfGqLYzBWmirjcjY1
	0AFvFcOe+4Nj3dRgcb9iuR6Wg1YkECqPqrzZON4vlmicYaL6F1zmdAY2qlTpXpjunKpjBSIYyPGw+
	1XHiJcnJsCKjHEJd6JWJq7sKA3YQzDC0jEZKX1dgh/eeThO6hCuwtu9MZYzKXPKygAFWQhCopwHRy
	6ELlL8scWU4laYEatZUBoS5XyEl/1s2uwwnQocoQP3kElhYVAz7OZXDg5/qT7g0A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCNIv-00000000R4f-1i7Y;
	Thu, 01 Oct 2026 22:22:57 +0200
Message-ID: <4ede9873924541b7bed3fc09f5b8c8eb0415ea40.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/5] wifi: add opt-in FIPS exception for iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: davem@davemloft.net, emmanuel.grumbach@intel.com, 
	herbert@gondor.apana.org.au, ilan.peer@intel.com,
 linux-crypto@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org, 	miriam.rachel.korenblit@intel.com
Date: Thu, 01 Oct 2026 22:22:56 +0200
In-Reply-To: <20261001185218.189030-1-jtornosm@redhat.com>
References: 
	<eac35c39724254fe0b208d50130cd6a6737ee407.camel@sipsolutions.net>
	 <20261001185218.189030-1-jtornosm@redhat.com>
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

On Thu, 2026-10-01 at 20:52 +0200, Jose Ignacio Tornos Martinez wrote:
> Hi Johannes,
>=20
> > I don't _think_ it does that. It does behave a bit differently for MFP,
> > but that's wrt. management frames.
>=20
> Good to know. I will re-test with just MFP re-enabled and no data
> keys to hardware, adding more debug logging to understand where
> data gets stuck. Something else must have been wrong in my v1 test.
>=20
> > Fundamentally, in this case the driver (even mac80211) shouldn't instal=
l
> > (data) keys to hardware.
>=20
> Ok
>=20
> > I'd need to sit down and (re-)derive that, but I don't recall it being
> > particularly tricky - just boils down to the various dependencies
> > between features.
>=20
> Ok, I can assume there are no other dependencies to start with.

A-MSDU size is definitely dependent on PTK since A-MSDU splitting
requires hardware crypto, and otherwise the RX buffers aren't big
enough=C2=A0(by default, but it's not worth the complexity, and people won'=
t
want to do big allocations anyway). There may eventually be a way out
with split RBs but we don't (yet) implement that in the driver.

EHT requires MFP and beacon protection, beacon protection requires
checking in firmware since firmware reacts to beacon frames.

6 GHz was documented in the code.

MLO needs EHT and then transitively that was disabled.

The biggest question then remains what MFP gaps you create with this. I
_think_ you might even have to install random keys to the firmware, but
... then maybe it wouldn't even pass certain frames to the driver? I'm
not sure you want to accept a loss of MFP security.

johannes
