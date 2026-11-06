Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964629;
	b=hf8fSn1ML4uVpYyFfOLPhiXie5WhC0Og3HzMSRQlrhXT34gy5cNQmb3xRxshevBFPjil
	 qgZAferKPm/LKBCI51Ho2SgTptV5QkcoW7MLg+CJSVTTL+5NQYY/+i5Tg6Fz0ozownW8V
	 +dWmuuUqVz7ISUZcYsXdOtDFZnQA8AsmsNCvWVOBC3B0KKgBzTBA+I4swtSsprCeC8QUz
	 SOtPII4HIwMbEouZ9M5Fy4LTNm8TSr8kxK24ZslxnfuvZf8P/+TCuoIZnsYjmhSwLC1rK
	 buz9A+qi07Ag+Nbq7iMqSHiplyo6i6tH+joUnOwZQocdM4EiXuU5ItyzdTN808CfVCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964629;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=m9WRGg7uv4AersWeud7SoY+SXQFUs0fujKXYHljLyqQ=;
	b=En5LXkxI0/IEX6evjO/EitABfb4GKNB6phk3+OwRRsTStIPBV7qr22Is+YKPAnS5D7Y0
	 fTBw6xQJ+vMu7Qb8333xC+EdOvFSp1AKAhnbHeRBRc6McaACEOIO4zn0IlLr7FG6vR/x/
	 ppjUOAwuJUPVh6IaahATWfvfQZuM5ZB1DaEdBAc1NTjj9SA8ClUjR+kSD7nZL4dmjgfm8
	 m0bFdqKiB1urAjTjPWmiB99PJG7t3NeVxb2/UkPmFvRGKrkM03IkpqbEV7ZfKoE9tMpb7
	 LFQQxev2LOIZagaFjV00A812JZQ8Xj5v4WA8GEuMV9XGNRW1VXF9mgaHBdVGryleMdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GdDZQn8Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E685E606EEBA;
	Fri,  6 Nov 2026 11:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GdDZQn8Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FC21F008A1;
	Fri,  6 Nov 2026 11:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793964628;
	bh=m9WRGg7uv4AersWeud7SoY+SXQFUs0fujKXYHljLyqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GdDZQn8Ykl1TppbRA05wdf6ZG/Ay/vL6GEnVHghCS/Q6PkjbeEMIitnGBO0FUf7UJ
	 2YGNjIsoO+8yZ4AWUlW0s7PkwwmxAYARTnbBTLHMzIZ4c9UB4cO+N2TNOTqM8hv18C
	 bGX4bYh7Ei1SqX7F5yqGynVZOQRNNpIS4IqjYL9M0AexBeHSIHxn7w1oahQF2qOWW0
	 FCTL9hiJzKFfLqMjhe6ggejEp+KusZSdAeJdANwZcRayWf7eIIgPi87ihVCkePGI/L
	 S/Yr0DmWk3gK7ojk3i+UrWaBTgMIkaOeYk2NiKbtmtbP7eWQO9HxfkyltASCLG95T4
	 UaMuVHGSFemHA==
Date: Fri, 6 Nov 2026 12:30:23 +0100
From: Thorsten Blum <blum@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Laurent Vivier <lvivier@redhat.com>,
	Olivia Mackall <olivia@selenic.com>,
	Rusty Russell <rusty@rustcorp.com.au>, Amos Kong <akong@redhat.com>,
	virtualization@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: virtio - prevent use-after-free after a failed
 restore
Message-ID: <au26T4dmLXWFkxPv@kernel.org>
References: <20261016103640.4989-2-blum@kernel.org>
 <au219vQfcYE0maYw@gondor.apana.org.au>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au219vQfcYE0maYw@gondor.apana.org.au>

Hi Herbert,

On Fri, Nov 06, 2026 at 07:11:50PM +0800, Herbert Xu wrote:
> On Fri, Oct 16, 2026 at 12:36:40PM +0200, Thorsten Blum wrote:
> > remove_common() frees the driver data during freeze, but does not clear
> > vdev->priv, which points to freed memory. If probe_common() then fails
> > during restore, a later remove or freeze can dereference the dangling
> > pointer.
> > 
> > Clear vdev->priv on the probe_common() error cleanup path and before
> > freeing the driver data in remove_common(). Also reset the device and
> > return early from remove_common() if vdev->priv is already NULL for a
> > safe teardown after a failed restore.
> > 
> > Fixes: 08e53fbdb85c ("virtio-rng: support multiple virtio-rng devices")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Thorsten Blum <blum@kernel.org>
> > ---
> >  drivers/char/hw_random/virtio-rng.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> 
> Please respond to this comment:
> 
> https://sashiko.dev/#/patchset/20261016103640.4989-2-blum%40kernel.org

I think the issue raised by Sashiko is valid, but also pre-existing and
could therefore be fixed in a separate follow-up patch.

Thanks,
Thorsten
