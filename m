Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3203F2C21C7;
	Fri,  1 May 2026 07:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777620111; cv=none; b=bUHFhuTqkU/NM0Fm13U5mYGmbtSH0daR4j3c6hwjjs5WyAqTIknYsJMn55yPIynOrQChzEnV6g1ATgOSUXegL4gBt+y4LsmmgIbN5s5Bo3MGgeNOYvc4u2U9KJ7K7RHdqphTN6fjD7THGCZJEVFsDrQwcP/lYclRZnL4dafVZu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777620111; c=relaxed/simple;
	bh=4nsfTlE0H9cgOBtEYMh2mWEell9rpum5vewrFVLyZuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hqk7k1S60ZTIqVmBAlOtLDAcbuNVUJUIAGOm0aTamQNUNYygntpmwDgOvfr3SMRiW6901Wmu3HTs0k6GInTuxTOWCZniTve3B891IhERBAbETOaCxvdbk5jbD8WvUkqrSmUi9OqB3VOyBJtO8pL/nz5aCst72cEB6wfauL+yXS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqU4Uvi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqU4Uvi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5C6C2BCB7;
	Fri,  1 May 2026 07:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777620111;
	bh=4nsfTlE0H9cgOBtEYMh2mWEell9rpum5vewrFVLyZuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hqU4Uvi3gLDjGq1w3FIesVOPvrT2RNX2VeG2XzfW4noTdGp+HAHJF4i1mlPVMyLEM
	 P6dPfsshP7UDH0UCyBNhmKTSK6QULSX6sGwifynFl6EK/yIvL0P29M/Epmv71G3R4a
	 2JLErsPdO8X+Bgc7r5OGxDSJZYc1QQR7L21Wch1Y=
Date: Fri, 1 May 2026 09:21:48 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: A couple more AF_ALG fixes to cherry-pick
Message-ID: <2026050142-unknown-mushroom-809f@gregkh>
References: <20260430222959.GB2275@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430222959.GB2275@sol>

On Thu, Apr 30, 2026 at 03:29:59PM -0700, Eric Biggers wrote:
> Please cherry-pick 5aa58c3a572b3e3 ("crypto: algif_aead - snapshot IV
> for async AEAD requests") to 6.18.  The earlier branches have this now,
> but it's missing on 6.18.
> 
> Please cherry-pick 915b692e6cb723a ("crypto: pcrypt - Fix handling of
> MAY_BACKLOG requests") to all LTS kernels.
> 
> Note: these bugs seem to be separate from the "copy.fail" bug.

All now queued up, thanks!

greg k-h
