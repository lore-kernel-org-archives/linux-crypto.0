Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C6B3845B2;
	Tue,  7 Apr 2026 06:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775543134; cv=none; b=RJTYLYle9l5xByWartgFXjz7Q+ds9hix/GeRBaA2g+tyF9gPLUyeE7Lg5zrpRkI2SUKBDHRAiSp3T9ZIsxFGQWsX4Sj7+nlMfwBuM6l8+/BfmknwC7Std+nXvKdZU3TprI8m/HYjXtlGRcpADDjicmH1bq1Z4/ZD5EyC7/kYLZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775543134; c=relaxed/simple;
	bh=7myyrQLyPFYxdKfnkSXwkzBuz3EJBZB6Q5+S3A0CE+Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WYNSXea5XSg0kvXar4b5L/J9hIkNcj7tbPNBed4CoLI7buGmk/nVbQ+4WghTQqw5j7miD89z/E2Mmc+XcOICWanEW9jVTsJSIIS9ZeUR/7tfz+e3tpdk83SFxOqNelUUjycLNOYv+QI6HQgimhe57ekHVh5e2fasFhJyPhh4AZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=IVery5rZ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="IVery5rZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=f34iJLD9ZZePI8PF+bqyMD2gigAtlHfku0r+4VhOe40=;
	t=1775543132; x=1776752732; b=IVery5rZ3BU4vpMv+3oWBYQy7Bd3rV0amTl2oK7WCzPD8U/
	KI3bIRp3N+ueIaBYrBE2L9wrvtQfup306oLiyW2aKGVcyy3O08OcMw4p40obMO4RNLHNjGR/vtAGJ
	cdE5p2vco/cIOF5dnhCMPvDbS2fax/QiNxMJBygb2EaHGPsqzOOI7G4Ccqnl7j+22XgnP9xbHEIoj
	GnS/Im8IP7l8Av7FU0mpXj1dKK3473qdtrusgykKgPQ5/CFpwpYU1sUPxcxcDfo4iY9bkUpQKoBNO
	W0LP7rvqurqiCDSAr9PhjEWSiYeJADiVTCP3il2nccFBlVDfPYHLVwDlB+fTL/LQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1w9zUc-0000000C2JF-2VsW;
	Tue, 07 Apr 2026 08:00:54 +0200
Message-ID: <7f69d6e6c2057858eda5c65ec77be44d72c6ac78.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 0/6] Consolidate Michael MIC code into
 mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Biggers <ebiggers@kernel.org>, linux-wireless@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Herbert Xu
	 <herbert@gondor.apana.org.au>
Date: Tue, 07 Apr 2026 08:00:53 +0200
In-Reply-To: <20260405052734.130368-1-ebiggers@kernel.org>
References: <20260405052734.130368-1-ebiggers@kernel.org>
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

Hi,

On Sat, 2026-04-04 at 22:27 -0700, Eric Biggers wrote:
> Michael MIC is an inherently weak algorithm that is specific to WPA
> TKIP, which itself was an interim security solution to replace the
> broken WEP standard.

Heh, yeah, we keep thinking about whether or not we can remove either of
them completely, but ... backward compatibility is messy.

> Seeing as Michael MIC is specific to WPA TKIP and should never be used
> elsewhere, this series migrates those few drivers to the mac80211
> implementation of Michael MIC, then removes the crypto implementation of
> Michael MIC.  This consolidates duplicate code and prevents other kernel
> subsystems from accidentally using this insecure algorithm.

Makes sense, mostly.

The one thing that feels odd to me in this is moving it to *mac80211*
specifically, and then using that in the ancient drivers. Not only is
that a big module those don't (otherwise) need, but also it makes it
look like you need the softmac stack for those drivers, but they're
really hardmac so that's a bit confusing.

I wouldn't want to have a separate module just for this, but I think
since it's going to be exported anyway, we could move the whole
michael.c file to net/wireless/ and make it part of cfg80211. All
wireless drivers ought to depend on that anyway.

johannes
