Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14847483;
	Tue, 22 Oct 2024 17:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729616475; cv=none; b=ncBWldkGp+OYO7EalIc/gIJtE+tUZyVcDoK2Jl+BnEePE9CwkFUu4vzVyQU1l1sYZ8Opo4ImQLt/F++dOfRtVC0d2qBPuCCilK+JGFeXzLESthA/YAlRmUP5netaIOy30xGtWP5bKHzMTNxH+o6BdxfOL7NmEN3Fsl1gb6VA+dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729616475; c=relaxed/simple;
	bh=SkxruN3qyASLBSy7ziFG5BSa8nKG0zYL2UVq2sfpF60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gXj5s7XqsbJ1gp6eBizMzbaNahu8GfENlBnkuf2jgTh6l8EkL305tbSJZRpv4YW8TN8WyJl3aiCsPc9oj5Tvz1dfxCwnznwIdI+CRg2Qu+ge5bu+IzD+hheH24IKbFG60mhfsKB9zOy2WF6KGqKYEP69bJL8IgCIG89PlmWOlIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qrApnhmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrApnhmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1A4C4CEC7;
	Tue, 22 Oct 2024 17:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729616474;
	bh=SkxruN3qyASLBSy7ziFG5BSa8nKG0zYL2UVq2sfpF60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qrApnhmZAXDdZ4SSpggax2im4eSKHuqpnqC9KwoGZB/aRpyGHLEjvH+EmdQypkKux
	 7PI5+FW3O0VLQVJxBsYG8W4p6lheqxCoB8WnZzxtV9bFCEB2Dr6NElYULTkFDqVL3+
	 prxeH2uePahI5PJi1yKoAU1pQusy3/BZuOPcKf2+GtbKmYT8xFlSf/vJUFN2WPvF35
	 xtNWGPIJoRF+phpOkrSsDLkJT4yqQ7RM/cNBJHK/V8kWKHVSwkYDMc+cRBGUsh995z
	 BoHAyxw/C3LovbDIOeEpsEBXylrsyskt3Ma8lKBpFbDLnxSHrlq223m1U1gRBl8DWN
	 6dV7HTrtJiXwA==
Date: Tue, 22 Oct 2024 18:01:08 +0100
From: Conor Dooley <conor@kernel.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [RFC PATCH v3 2/3] dt-bindings: crypto: Add Inside Secure
 SafeXcel EIP-93 crypto engine
Message-ID: <20241022-frozen-dinginess-c9b71213e11a@spud>
References: <20241021145642.16368-1-ansuelsmth@gmail.com>
 <20241021145642.16368-2-ansuelsmth@gmail.com>
 <20241021-extenuate-glue-fa98a4c7f695@spud>
 <6716883e.050a0220.3afab9.2304@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WarKaUJK5icuKqW0"
Content-Disposition: inline
In-Reply-To: <6716883e.050a0220.3afab9.2304@mx.google.com>


--WarKaUJK5icuKqW0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024 at 06:58:35PM +0200, Christian Marangi wrote:
> On Mon, Oct 21, 2024 at 05:50:25PM +0100, Conor Dooley wrote:
> > On Mon, Oct 21, 2024 at 04:56:38PM +0200, Christian Marangi wrote:
> > > Add bindings for the Inside Secure SafeXcel EIP-93 crypto engine.
> > >=20
> > > The IP is present on Airoha SoC and on various Mediatek devices and
> > > other SoC under different names like mtk-eip93 or PKTE.
> > >=20
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > ---
> > > Changes v3:
> > > - Add SoC compatible with generic one
> > > Changes v2:
> > > - Change to better compatible
> > > - Add description for EIP93 models
> >=20
> > RFC v3, but I don't see any comments explaining what you're seeking
> > comments on.
>=20
> I feel comments for the DT part are finished, if Rob is ok with the
> following compatibles.
>=20
> The RFC is more for the driver part and this is patch part of the series.

I didn't see anything there either, that pointed out what made it an
RFC. Please be more explicit in the future - possibly in your cover
letter.

--WarKaUJK5icuKqW0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZxfaVAAKCRB4tDGHoIJi
0j2oAQCPnM+xlAU21uykbD2R+qVH/1NCqFKMuxtkcErWXY+k6AEA9XEkpZ423S/Y
8/3Yk49clCSUaEY9pZS4S0HEdrSKqQ0=
=1OeI
-----END PGP SIGNATURE-----

--WarKaUJK5icuKqW0--
