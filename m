Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316B7500975;
	Sun, 18 Jan 2026 00:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768694996; cv=none; b=EKyAtRWS7bbhA/1xIIL7MQIfK+jrHAt+YXy1TP91Il5Vf9enIY4hdMMP2nqe3DYSXNZWcAMlPfGOxEcufwbNNvyX6GyXRK+mxYnP7+aNR+D8zICzog41v51zGbnNiBBZ0C0bfTve3atpdGPQGlWMvyaVlmDSKBwNMM7dX+6V3Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768694996; c=relaxed/simple;
	bh=lgzADPJ5CYeQw0YxwMb3aP5aMRt5Doo5y9XyqUq7CUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aUu8d9wSy1fQxYf97hBsh6KVBcqKZmw0iMIHAoowqVOVS4BYIlbHUY96O+W52Evc1b2NbKZ5hU6sQ5yM6bNTGRpCtmSK6ekawUVsK7EPSdQkRnOBWH+YgZCHSHCL4kUJ/W3Rn63dv3pPI1/UADwUeqoSjQxpJ1v6Gs3JL/27APk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FWi+KZ6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FWi+KZ6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F91AC4CEF7;
	Sun, 18 Jan 2026 00:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768694995;
	bh=lgzADPJ5CYeQw0YxwMb3aP5aMRt5Doo5y9XyqUq7CUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FWi+KZ6M4YVXcPLfdFC8G7PMTA+7hIM+2lpKOyffImBgrfzbeBbMvjPFitYP7nDu5
	 GUDLV/h0/p74k5plRM7l5u2tJYLZgmFrGquDdtIokHAPbUyh/jWQpizR7SU1Im9Ocj
	 loHgCHAFYgXhWCzvPCtAFgvNM7XZSKYqlL9QW3pcKibT3sgtxqI2mGqPJmDZakGXUa
	 ooRNApZyZneXbJPdzAeHvWIxjsnJgVs87jjBhty8Bctd58BXwb/mVEDQTxKjeotcz/
	 NqtAZGZtuUKB8mHPPzPXIcq+h+sOBS/qSlxl4Fuktie2QvzRMipQHhNW2iHP4SxyH1
	 79nNzQW4nHB/g==
Date: Sat, 17 Jan 2026 16:09:47 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, Jason@zx2c4.com,
	ardb@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, CobeChen@zhaoxin.com,
	TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com,
	GeorgeXue@zhaoxin.com, LeoLiu-oc@zhaoxin.com, HansHu@zhaoxin.com
Subject: Re: [PATCH v3 1/3] crypto: padlock-sha - Disable for Zhaoxin
 processor
Message-ID: <20260118000947.GE74518@quark>
References: <20260116071513.12134-1-AlanSong-oc@zhaoxin.com>
 <20260116071513.12134-2-AlanSong-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116071513.12134-2-AlanSong-oc@zhaoxin.com>

On Fri, Jan 16, 2026 at 03:15:11PM +0800, AlanSong-oc wrote:
> 
> Signed-off-by: AlanSong-oc <AlanSong-oc@zhaoxin.com>

Since this is a bug fix, please add Fixes and Cc stable tags.

- Eric
