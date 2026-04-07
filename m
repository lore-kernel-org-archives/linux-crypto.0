Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E6922D4DC;
	Tue,  7 Apr 2026 06:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775542980; cv=none; b=d7iw1s2/pnz7XMMLUK6JN7wBaS0YZyG2v8P2146Pk6Sapq1eE8DLDQHZW5+gwiEMLPVGsb7GQ6XmnstS6AUIzJT6hzkmTsfm6fr8CO11Qm4KijVwr6a8GSQ5mxX676K7VpiS94zGzw8ObvjrenA58LFs9zUvyhb7qnyRE+mlp/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775542980; c=relaxed/simple;
	bh=Ly0IEUaBYFdrha4UMsI2GK2NmH2PtTt5tL+orjN4f+s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sQVcVRMoYTOa1epg/1q/mFkwKJ2jGDOJOM32RYNOh72RuIQwy7MzpAK59WEvDuBV8ZIrd7PXHbYz3WsXzjRh4jFCjqU/bu3eW8X2UPDH5FPTKEYl9Pg6uGVP6jWpARlRVWeTpW4xh4oGzQDz3tH3fMgOqhtCMq1TsX4JGBTCCCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=AuuFXItq; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="AuuFXItq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Ly0IEUaBYFdrha4UMsI2GK2NmH2PtTt5tL+orjN4f+s=;
	t=1775542979; x=1776752579; b=AuuFXItqeFdsTysS3Wj6c8W/xJe2+GwVubevaWgcTzzSbWf
	eaRcw2eqnsFRbtu1+UIAXjQqzft4o+B+NVSz15/pC92PP+ejzhXvnvhdEu+SMAyUmUWhENpqSAkEP
	zQMsQXCnMILmTyxmRXdkhgXr/sCjLgv1sBQz0NmywDO7scoOe6eLMaYD9YyodJB35/sYBInFc4Ueh
	TvcJOsJPweropswbGmJL00MihTe5p+a114IEOQRIKYw5U0do8MgoY0nL1u4v98jHOfG23tKWbAYnH
	iCNW+VOf7f7cPBw5GC2RAA2SYw/pE96qsbUv6uD+/d/fqv/viIZlvYxhH747iC8A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1w9zpv-0000000C3AZ-0WgB;
	Tue, 07 Apr 2026 08:22:55 +0200
Message-ID: <feabff620b9e82bf7b530660b847ddad4741ece6.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 0/6] Consolidate Michael MIC code into
 mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 07 Apr 2026 08:22:54 +0200
In-Reply-To: <20260407061508.GA7934@sol>
References: <20260405052734.130368-1-ebiggers@kernel.org>
	 <7f69d6e6c2057858eda5c65ec77be44d72c6ac78.camel@sipsolutions.net>
	 <20260407061508.GA7934@sol>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-04-06 at 23:15 -0700, Eric Biggers wrote:
> On Tue, Apr 07, 2026 at 08:00:53AM +0200, Johannes Berg wrote:
> > The one thing that feels odd to me in this is moving it to *mac80211*
> > specifically, and then using that in the ancient drivers. Not only is
> > that a big module those don't (otherwise) need, but also it makes it
> > look like you need the softmac stack for those drivers, but they're
> > really hardmac so that's a bit confusing.
> >=20
> > I wouldn't want to have a separate module just for this, but I think
> > since it's going to be exported anyway, we could move the whole
> > michael.c file to net/wireless/ and make it part of cfg80211. All
> > wireless drivers ought to depend on that anyway.
>=20
> Just to clarify, mac80211 already contains the michael_mic() function.

Yes, for the SW crypto there, which apparently was never ported to the
crypto functions.

> And every driver that needs Michael MIC already depends on mac80211
> except for ipw2x00.

I'm actually surprised it's any of those (actually) mac80211 based
drivers at all, since they ought to just be able to hand the skb to
mac80211 for checking. Not sure what's going on there, but I haven't
looked carefully either.

> So bloat-wise I assumed it's probably better to
> make that one driver depend on mac80211, rather than make every driver
> pull in the Michael MIC code (by moving it from mac80211 to cfg80211).
> But if you prefer that the code be in cfg80211 we can do it that way.

I think you're probably right, but it's a pretty small function and
architecturally, having those drivers depend on mac80211 but not
actually use any of its "real" functionality is IMHO somewhat confusing,
maybe especially from a Kconfig POV.

Also most drivers already use mac80211 so for those it makes no
difference, but of course there are a number of non-mac80211 drivers
that would get this function.

So I think overall, it still makes more sense in cfg80211 - we've been
treating that as not just nl80211 but also "useful things for drivers"
(for obvious reasons, every WiFi driver must use it), so that'd be the
better place I think.

johannes
