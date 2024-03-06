Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA3614280
	for <linux-crypto@vger.kernel.org>; Wed,  6 Mar 2024 04:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709697654; cv=none; b=JydPQPm2DpgcsWGhIuC6/IIYUAbJ4YGzTBVBf2ypRRZnnSUIfvNh0jF+PuCSRvM9gP0MhaZw8kRV9ijK477DcJsWTLe3c7fOU6m3XGGTG+V7fPlRv75H0LNVce4FwKB9oWiZ2orYaIw0Qbf+dgjM5lBGtB3e1sJuoRSExkZtv9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709697654; c=relaxed/simple;
	bh=rAa1uyLPHnRWBSj1ygLVRIEJ8L0RTjmTZsGPcSt8KOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iGNU5eu0ihcGxvOmcnTmEbT3ANDA0Ku/b+wLhREKdmu6z0vp+ofIgjhZa3VZs2sRCkd5ka5AWIRjh0cyF5ny3InL6iQGvzFt+VjaNhcI1PGDBpO9RTc7Qd64tb+DmEK4YEn4ddulJ9xDpCD2ezLwAjBNbvRFsZQLm7kHh1fB0HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pRNWAPyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pRNWAPyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C80FC433F1;
	Wed,  6 Mar 2024 04:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709697653;
	bh=rAa1uyLPHnRWBSj1ygLVRIEJ8L0RTjmTZsGPcSt8KOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pRNWAPyFrX4HLNODQWWNQiWoxtkc7xOu8oPyrifPrDffo4C06fqWLjmrKI9YDv8lE
	 tRKkL16+uW8bJd7i2iVrcFBGNPxxXyWQZFCb7OHt2KPKEgL0J7P1WgSF11kI1PeJGb
	 +7Twu4fjeXLOyRyQhCtt+C6YiRSNm06B0oWfFmQg1cB+8BlCI+Xvb6P9cXDf+GsQLP
	 CD6Kw4wAQ2h603xhuaEthSfEavoe9MqK/wcYgp6M3X2T5VbdCrvMrGZ6PvKK0XVUAK
	 dLByIB8aP1uQsugzG2Nbit3XgfPNAy/iPFhgmIicR+BEi36c5oJoT1NO4jrxZW+v53
	 tbtPaVgVH11UA==
Date: Tue, 5 Mar 2024 20:00:52 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com
Subject: Re: [PATCH 0/4] Add spacc crypto driver support
Message-ID: <20240306040052.GB68962@sol.localdomain>
References: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>
 <20240305211318.GA1202@sol.localdomain>
 <CALxtO0kp+vDstePYkq3AYSD-h6LRt1HvRm4HdW-OtTQm5ipqkw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALxtO0kp+vDstePYkq3AYSD-h6LRt1HvRm4HdW-OtTQm5ipqkw@mail.gmail.com>

On Wed, Mar 06, 2024 at 09:16:31AM +0530, Pavitrakumar Managutte wrote:
> > Algorithms that don't have a generic implementation shouldn't be included.
> >
> Hi Eric,
>   Yes we have tested this with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
> 
>   Also is it fine if those additional algos stay inside that disabled
> CONFIG. SPAcc hardware
>   does support those algos.
> 
> - PK
> 

If you provide an option to build them into the driver, that still counts as
them being there.  I think they should just be left out entirely for now.

- Eric
