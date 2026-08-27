Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A30485518;
	Thu, 27 Aug 2026 16:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846796; cv=none; b=WV2FJZ8oKZ5geT+Wm0mDZSw4vsBRIZbZD2o0x9vGNT5ufHxBBYgrYYbf/6rq2HKT7gj8quVjcg5cAjXNPqfcC1cWnuDgf2D0jrNDaKevn631hSeNGNLaVmRECu3MNnL9n4vODDmUMXzoop4FXLwwTGpCJp9ZF/So+gPkZ1MUMz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846796; c=relaxed/simple;
	bh=DAHujIzV37ZHDxmmcIBsQ1XmNaztmImRFCcDYEJcmio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VAWOnwxdXuARovRpSazlF1kpOnqvwlnfPRnRSOoUYYzL8EvvcsR8EuzP5V98O7rtnKJME9UdpnOW/z3JVDFpTDhj4dtPc3WkPScLPeU06NmeYdVAxdLiWvI34OEjAdHQcOdqHEjSr0wMinng7dzmahiPAKF0ZQentVkz8JCxJyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WR4YrNU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WR4YrNU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC831F000E9;
	Thu, 27 Aug 2026 16:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787846795;
	bh=DAHujIzV37ZHDxmmcIBsQ1XmNaztmImRFCcDYEJcmio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WR4YrNU60FLWSF2MQXmeYlq7HFScS5YmcJuJYyhl/9rkLZG9MqrKsjcMITzdu+FX3
	 Pp9jp+W5Gvd6hqaoSSP+z+aSWROhwncm7pQewKk26z2I2xaekd6waBdS0pp06GzxbO
	 4PQrecc7B34Juhpf8+54jzeH9rcLQJkozIqESVR+PhSGM+t3Z0cn1jtmHqU8znktHo
	 8sr9M2YnsrsSW2DmbD1zd77ON0CvvAX1yu49HUESBlTee2DPagQxOPimF3f4RlvlDm
	 hc8qOJhJbspKKtWfI7x+BnNj9Fl9yVh+PiDeVwnyHTWSiEKzW3HhzhceYzktMAGHJT
	 6jRBdsXnVxWzw==
Date: Thu, 27 Aug 2026 17:06:26 +0100
From: Conor Dooley <conor@kernel.org>
To: Ayush Singh <ayush@beagleboard.org>
Cc: Jason Kridner <jkridner@beagleboard.org>, robertcnelson@gmail.com,
	Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ayush Singh <ayush@beagleboard.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>, greybus-dev@lists.linaro.org,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 6/7] dt-bindings: beagle: Add BeagleConnect Freedom
Message-ID: <20260827-rash-silly-774a09d80173@spud>
References: <20260827-gb-uart-transport-v2-0-a03bb1f5fbd1@beagleboard.org>
 <20260827-gb-uart-transport-v2-6-a03bb1f5fbd1@beagleboard.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eVfLZDbhjLXC16Fn"
Content-Disposition: inline
In-Reply-To: <20260827-gb-uart-transport-v2-6-a03bb1f5fbd1@beagleboard.org>

--eVfLZDbhjLXC16Fn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Acked-by: Conor Dooley <conor.dooley@microchip.com>
pw-bot: not-applicable

--eVfLZDbhjLXC16Fn
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCapBgggAKCRB4tDGHoIJi
0opuAP95HhqDi7oB+VTtA6pvzXoa9BTm/hQXuDieDgIu6invMQD/fiuPdgWrwMLy
m5xmjxTqXKTSQdT0qLzXZQGKIySFSgM=
=CkDT
-----END PGP SIGNATURE-----

--eVfLZDbhjLXC16Fn--
