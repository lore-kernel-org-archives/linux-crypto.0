Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB6629CFE;
	Tue,  1 Oct 2024 06:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727764380; cv=none; b=V+JGO3FuB0Ql+BnhA8VmCgbiaajRUw8Myb6V3TyZrJkBN3+9kSHRxCywOBOf+vO9Xd/UR3Aagj7E+xKpmeDXIa88Oax9oUpz0gAYJ9z4XNYdKFSR4iP9tCYiHyE4u8HnP51li4fyY38qb6cWbwW9i5FdBh1t3MnZoYbEuV64RCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727764380; c=relaxed/simple;
	bh=XSLP4U0q0qoAwVm+UhRDOJEowgMiAvWpAqT9e4Kcl2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nFWR1Ffr+lISbzni7AB45xzb5EuNqNLhwqAdFv2d7N4GRT8LTEkQkFwlSD30Fcx/5oFeOVQiXKQt5qRNnlK0QFjf5PLLWDInAW8ibcvojduMOIce6zYpqUxKcJH5JG5jRmqNJwKnzHFacZbBWcManl8+FcLlmayH5QQq9BG3QwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OxNEwHvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OxNEwHvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3216AC4CEC6;
	Tue,  1 Oct 2024 06:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727764380;
	bh=XSLP4U0q0qoAwVm+UhRDOJEowgMiAvWpAqT9e4Kcl2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OxNEwHvr39xV30aSwN9K2SY7PPbbsrUUmVKIjTzGQmZU4ELXUc1Hnf62szTdMIJ1K
	 v4wYldOh5YizukftbLGG1o+tlfe2NL2DrCFu+HmZGRBOXMpU20vjAI3vckVlboibGG
	 nYTqLLXBU8+s6l8SSftbLsEgrg4HOdT4msXZf1LoGdItcZOqK1gkA3WVSD/2w9j/AS
	 VETIyU7E+9zEv8ElEjiCeiavevdl5cSdddPVoWj3cQ+E1b+2wblAasOt3wHfh/XBED
	 lUI1jITQrNKlcwgYNT3jfXyK6UvdnO1WwzBryps0nNgYqnZk1Hr1o+UsFkT/ogo6tT
	 hz7nxGVgff4WA==
Date: Tue, 1 Oct 2024 08:32:56 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: devicetree@vger.kernel.org, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, robh@kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v9 7/7] dt-bindings: crypto: Document support for SPAcc
Message-ID: <fsp2l2ktvwznm64kwlb23yxlvioi47inzdwcngowbvet43us4k@svi4b7eq7gx7>
References: <20240930093054.215809-1-pavitrakumarm@vayavyalabs.com>
 <20240930093054.215809-8-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240930093054.215809-8-pavitrakumarm@vayavyalabs.com>

On Mon, Sep 30, 2024 at 03:00:54PM +0530, Pavitrakumar M wrote:
> Add DT bindings related to the SPAcc driver for Documentation.
> DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
> Engine is a crypto IP designed by Synopsys.
> 
> Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> Co-developed-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>

Please run scripts/checkpatch.pl and fix reported warnings. Then please
run  and (probably) fix more warnings.
Some warnings can be ignored, especially from --strict run, but the code
here looks like it needs a fix. Feel free to get in touch if the warning
is not clear.

Best regards,
Krzysztof

