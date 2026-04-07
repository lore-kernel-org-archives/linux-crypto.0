Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBD2382389;
	Tue,  7 Apr 2026 06:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775542586; cv=none; b=Pktxof4aVZnNaquJuPa9FWAy5PQm3z8LNdMgxN9/Jf0041OsAHPIPD1SS1YOjhGLxbdf+VB52pnXtPL/N9tk2qYtaeictg2wnHH5a0kUnfFljQ7KJa5ewKz+kxExunuoQhTDx7MQCscX05nJgMb44TBRkwbZAEVY7iOkuA6K2cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775542586; c=relaxed/simple;
	bh=KdmcKd6KCmY2Qqa0++TFhwFGz5elB5zo+eecO5yvJKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nLc/f1Glp/YDof1Iqc+Big1WMg900b/SCxbMux9wBaHUDegV+Ilxcx6mrL0wK2Q4UcxUbGjGXbG1K/t3znnMS77CKWjxa4abEl2x6anPdO3AFSqsQIroCpzdf6L5J2IPt1nurQimEPO9Cc0ghGq8jX0Hx2RBcMwk9LN50WCVBsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E9hiS/a9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E9hiS/a9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B46DC116C6;
	Tue,  7 Apr 2026 06:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775542585;
	bh=KdmcKd6KCmY2Qqa0++TFhwFGz5elB5zo+eecO5yvJKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E9hiS/a9f4bh91vr60DuDJJQNykYlnpkF1yErXbEMO9iTEHceZe2rbNhLf+CyDnoh
	 M5Vplblxc4ePoGMdaRhMFKy5RzYHwVuaFDTWS7z/19k7Uu2HLBqt+bP5MBKYdYXOHs
	 jDwXJXK6v35ScRqjgk++az6ToFIckbYuDyPioSpGoFDDHh1/56oEI7abgS5PFmnXYg
	 502BDnvE7jBvbQReUi9TqnAwqUj5PcTBGJzGAzF+M0dBswewIy1lnV+kuzpuTKzF6O
	 MS2RASTj7Gf1DvKxeiLdHgwAmfybPs7/2t1BAXJQJn9Ewh5OPN0GMCX1i+FPHhBxmu
	 6y0Mq1YLDiEPw==
Date: Mon, 6 Apr 2026 23:15:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH wireless-next 0/6] Consolidate Michael MIC code into
 mac80211
Message-ID: <20260407061508.GA7934@sol>
References: <20260405052734.130368-1-ebiggers@kernel.org>
 <7f69d6e6c2057858eda5c65ec77be44d72c6ac78.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f69d6e6c2057858eda5c65ec77be44d72c6ac78.camel@sipsolutions.net>

On Tue, Apr 07, 2026 at 08:00:53AM +0200, Johannes Berg wrote:
> The one thing that feels odd to me in this is moving it to *mac80211*
> specifically, and then using that in the ancient drivers. Not only is
> that a big module those don't (otherwise) need, but also it makes it
> look like you need the softmac stack for those drivers, but they're
> really hardmac so that's a bit confusing.
> 
> I wouldn't want to have a separate module just for this, but I think
> since it's going to be exported anyway, we could move the whole
> michael.c file to net/wireless/ and make it part of cfg80211. All
> wireless drivers ought to depend on that anyway.

Just to clarify, mac80211 already contains the michael_mic() function.
And every driver that needs Michael MIC already depends on mac80211
except for ipw2x00.  So bloat-wise I assumed it's probably better to
make that one driver depend on mac80211, rather than make every driver
pull in the Michael MIC code (by moving it from mac80211 to cfg80211).
But if you prefer that the code be in cfg80211 we can do it that way.

- Eric
