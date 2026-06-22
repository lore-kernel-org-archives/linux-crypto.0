Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3991A36D9EB;
	Mon, 22 Jun 2026 07:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782113881; cv=none; b=K6CZWrYAdf0MzdXc0Xp7/LeL5YcR3m0cXTd/J8n1bx7Fl7FYn7i/+mmiuEEO4dm0ao8ctztLNRyzFniMYaYqiaO1S3SCforqJM+SV2RXo0La9mqJ9m8yxIWRWSP3bzylqCDGvInfm4F5CcLIORKWMPwHWWT5RnuIqkRmySjrqFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782113881; c=relaxed/simple;
	bh=2JnZp7M49poI/fSZ0yf26kQj+a0PRFmsz1BVhRR/bks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tNZdQMMhYLG2AGmSLwyRb6UvMF6bwWsuQQu8O9M3mh83q3+NigmKiZL+YLTyMOQqi1uWW+yb2kXkEC5RqHMuOZpVfhLv3mRR16Sq7kHFweOWJXw4RJ04EYXxMlB23glHv1ZxtW0x1xx2MgiR7e2zM/RQaEkS/7XGwAiQET04iTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyuWmIlz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyuWmIlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F221F000E9;
	Mon, 22 Jun 2026 07:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782113879;
	bh=moTbx0RFo+uvT+Pxb32XDw9nJ+Mu1YWJBEYCVjzKA+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gyuWmIlzux+LBkkR4jhe2TAl1Hs2vJWj4OJdIJ3+TcUw0MFBJX5fc2iZobWTqYi+T
	 D8VhnGvQTp9tk+Nl55mE0e60KT+Ph+JO5NOluxLJ84I3tCtFPZCykz9mMqiiZT28pq
	 ziR+ABsRpqibaA8KgpwgzF9r31Fov1L206e4RA0lFkE9LXJVvkyXSrr5O/i57fhtnu
	 GdEWIdVhX8ICzRiM1uA37DW9La0xdpu1LSx8hqxRIHbNL343H6VUdW5rrNVNmVqlVL
	 XR0lZ7M0DLP01Uzvhly5ZeSiYOksBxY3vGELdOc1Cunxdhmg/R5WkHzfDUWo15o/+d
	 gAZQ+/GJ3GwSQ==
Date: Mon, 22 Jun 2026 09:37:55 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Jad Keskes <inasj268@gmail.com>
Cc: Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Alexander Clouter <alex@digriz.org.uk>, devicetree@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] hw_random: timeriomem-rng: add configurable read
 width and data mask
Message-ID: <20260622-exotic-seagull-from-neptune-bb5f97@quoll>
References: <20260618120110.36439-1-inasj268@gmail.com>
 <20260618120110.36439-2-inasj268@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260618120110.36439-2-inasj268@gmail.com>

On Thu, Jun 18, 2026 at 01:01:10PM +0100, Jad Keskes wrote:
> The TODO for supporting read sizes other than 32 bits and masking has
> been sitting in this driver since 2009.  Implement it.

And who - which driver/platform - uses or needs that? We are not really
doing things because someone wrote TODO in 2009. Quite likely notes
from 2009 are way outdated...

> 
> Add reg-io-width (1, 2, or 4 bytes) and mask support.  The read loop
> dispatches on width using readb/readw/readl so a configured 1-byte
> access does not trigger a bus error on hardware that rejects 32-bit
> reads to that address.  The mask is ANDed with the value before storing.
> 
> These are platform properties, not runtime policy -- width depends on
> SoC integration, mask reflects which output bits carry entropy.
> 
> The alignment check in probe is updated to verify the resource is
> aligned to the configured width instead of hardcoding 4-byte alignment.

Best regards,
Krzysztof

