Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF694908D5;
	Sat, 25 Jul 2026 22:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785017087; cv=none; b=fW/o1wllasYZJRVmA0rr2CQpYvzh8EKWpE75zEEpm75dTf6zXZQI4/HRfFA9s3RV3BAFxAoZSd71VAD3Z3xNjTZAgzd2GF4TnsO0XoWHXWIAo0GMBV+Xx75oafhFHOWX8CvNSyFgJN+fAnVoEwSL8smLAnwnQw7JtGBquomPBkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785017087; c=relaxed/simple;
	bh=mGIg3K+K1wSQWhAGMAHMSPBP/6DPPvgRMdjQJJlEuFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VecM6GAR2Th4PtuUpv7pJjrYvG2bkn1XvYFKzuVRttzIGGT6QMqk4L824qeyxqC92KpticKl0E8cwXo2eA4Po8avJXhdjKU5FoH7iHczIaNFcdXW82X1McyNqgV/nWI1IQkSoeOvRRrjCr1ld7gDQDSLQkQbXdF9nK6DZTnJ/uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JavIgWGE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JavIgWGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338791F000E9;
	Sat, 25 Jul 2026 22:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785017086;
	bh=IOGIkoaj/GiqcjfHmsSE2D+sdz6y+uP9toBV9inklFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JavIgWGEHKCAdZDmmddz9VRnfX3zC3zMpsAzu8RJWBBJAfaauExwiGOGRfYepaITR
	 hoGA4NpLO8mv71kditTBpUGRJyeLaT+BGYc0G6nb9tyo6kZtbO/QHnlJDe4RDc6PO6
	 2rIgb2gWXp63XOEMXsCEV4Ev/t+Od7Xh2hDbMSt0vMq39KUCkLrZ/3cuReq2Nj73as
	 6VQbHMuvRewCCNs/hc7ijU1WcYt2b0iWYG68uQdYCTHVJumo9e42D8hPc3Pw3rbyOM
	 v9peETkO/kBDT1YSEsSs5loezkix9nPPfnxPZBu3F4DLYG22nAvr1+2ckpFLrx/cNx
	 2NTIpywthduYA==
Date: Sat, 25 Jul 2026 15:04:43 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Dominique Martinet <asmadeus@codewreck.org>, demiobenour@gmail.com,
	Harald Freudenberger <freude@linux.ibm.com>, acme@kernel.org,
	adrian.hunter@intel.com, alexander.shishkin@linux.intel.com,
	ardb@kernel.org, axboe@kernel.dk, corbet@lwn.net,
	davem@davemloft.net, edumazet@google.com,
	herbert@gondor.apana.org.au, horms@kernel.org,
	io-uring@vger.kernel.org, irogers@google.com,
	james.clark@linaro.org, jolsa@kernel.org, kuba@kernel.org,
	kuniyu@google.com, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, mark.rutland@arm.com,
	mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, peterz@infradead.org, skhan@linuxfoundation.org,
	willemb@google.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
Message-ID: <20260725220443.GA41199@quark>
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
 <20260603133312.12848-1-freude@linux.ibm.com>
 <amOGWwdjnJqyxH5L@codewreck.org>
 <20260724160034.GB2032@sol>
 <amOTjPW__CNZui3_@codewreck.org>
 <CAFLxGvy+ec3nQLrQtwFZgGELhT2pKBDnHdD0pMvEGh-Mf3rjgQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvy+ec3nQLrQtwFZgGELhT2pKBDnHdD0pMvEGh-Mf3rjgQ@mail.gmail.com>

On Sat, Jul 25, 2026 at 10:55:03PM +0200, Richard Weinberger wrote:
> Speaking of CAAM, there is a legit usecase which exists mainline. No
> vendor patches needed.
> 
> You can create a CAAM BLOB (a generated and sealed key) using the
> trusted keys subsystem and use this BLOB
> later in AF_ALG to perform AES with a key invisible to userspace.
> 
> e.g.
> kid=$(keyctl add trusted mykey "new 32 pk" @s)
> keyctl print $kid | xxd -r -p > blob.bin
> Then just create a caam_pkey_info in userspace and feed it into AF_ALG
> and perform AES with it.

Well, specifically AES-CBC.  That's the only one that is in the driver.

> So, pretty please,  if you kill AF_ALG and all this, offer some way to
> achieve the same in userspace.

If needed, "cbc(paes)" and/or "cbc-paes-caam" (whichever name it is
being accessed as) can be allowed as a special case, as a stop-gap.

This would need confirmed use of that specific algorithm with upstream,
which we don't quite have yet.  Dominique had a confirmed use of
"tk(cbc(aes))", but that has never existed upstream in the first place,
so it's not something that could be allowlisted upstream.

You've only mentioned that it "can" be used in this way in upstream.
Can you confirm that it *is* used, and with an actual upstream algorithm
name, and if so which one(s)?  And if so, would you also be able to
share whether this is for dm-crypt or not?  We should remember that
dm-crypt accepts keys directly and AF_ALG is not needed to use it.

- Eric
