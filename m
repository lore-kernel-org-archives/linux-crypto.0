Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D0B3F58CA;
	Wed, 22 Jul 2026 16:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784738014; cv=none; b=SOqelScaaVLypvW/2vpUkWn/DfTaXzanzEQ7E5WgOnHk4vQLYNsWC/q0JJCN7vLvYRBMhmViEAXy1jYViA4IawACME/3oJMzBoxzswGdsmDUwsnaZPznBBqVegmGmdUoFGxXXmDsKRVNmFt2jP0pk6md4ZNoRQSbEXufrd+k+es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784738014; c=relaxed/simple;
	bh=WdYQjHqz0WxK/3wW+np6k2Dth2qI3mgTky+yhMAGq9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qY5pKhD/mVZC8/UPXGJml1ksywe9uTg7z6qOGns5XSw4LuYuYH1JwqrU+W/wVKyH6y47hk08C761NmKf5vNKfEUik2EzVJHzjW1aC/F27DThRK5F8j+L6eLsWYxFuzSSUX5qXFOmCjb9g5lhQuWBkxEOaCgyD9Emp8QbCHdy8Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUgoIFtI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUgoIFtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1EB1F00A3A;
	Wed, 22 Jul 2026 16:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784738012;
	bh=U26BwfjGu0ZDjt757734uba9SAS16WYrs7B3QfwHKTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SUgoIFtIjw9t9w+5MgYFRZc9WdrCBEgfU6t5R+bd2mkxS1b24Vis5wQ3T2Czl8pmD
	 x+7tIlmI8dQjFb4nA9BuqskcoRGdeirD6HxOGRASksHhDrSJQ23n2Xx/5yntyQ0h9q
	 OP6m4xFgLkbHADZ1pD2sIKg5TLH9013S0x6YTMQ201gEBRFQx43RFFmV/+pI1X6tlj
	 HYwrMl+UbmTiVOVBEpoFXIoKiCFQyV/g+/G4ecUzWGsxn6ezQo7DLqjCayYhRmpAHw
	 tcfpJVatXDSSE5cu7EPot8Jgf1T+63Y+QrsDY9hqg/bze/IfHQqf3PbVeYWDR+sfly
	 zLkFrZu0R+Lxg==
Date: Wed, 22 Jul 2026 16:33:31 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
Message-ID: <20260722163331.GA2865613@google.com>
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <alnlaCXmoLRAlr96@gondor.apana.org.au>
 <20260721082501.6128-1-bartosz.golaszewski@oss.qualcomm.com>
 <c826b73d-6307-4237-a065-b7a8487350ce@gmail.com>
 <CAMRc=Me55rUmjjR+ZzdWd2ss9JJMZzJch0zKd4GqONBjCzFMYQ@mail.gmail.com>
 <8e9101ce-e9ec-4111-a1a6-7a9a07788818@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e9101ce-e9ec-4111-a1a6-7a9a07788818@gmail.com>

On Wed, Jul 22, 2026 at 11:46:16AM -0400, Demi Marie Obenour wrote:
> With your patch, does the driver also pass stress tests, such as
> multiple threads using it in parallel with varying algorithms and
> message sizes?

As I've mentioned before, the self-tests (crypto/testmgr.c) don't issue
more than one request concurrently.  They are really designed for
testing the software implementations, not the hardware drivers.  None of
the hardware driver authors has ever caused enough about quality to make
any significant improvements to the tests.  Inevitably it's just push
the driver in, *maybe* run the existing incomplete tests once (for QCE
it's finally getting done just now), and job done I guess.

- Eric
