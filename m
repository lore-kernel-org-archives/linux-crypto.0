Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EB73BED74;
	Thu, 11 Jun 2026 11:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781179011; cv=none; b=UEjWb6HoL1aq+GNEx1tHIzRye9HSWuEWYoJK91bAZXxbPeJsHzSBdK+0/OJdMSXfyPXQf4goUtY8S2Cgobz0/mImzMMX0vxb5Mwb5cLDlJ+mxKZbKRoWk1bDC6/4yfYJgcp4DPGCM8UU89cc7COPFIDdUU5tlGviFdHFXMw5KUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781179011; c=relaxed/simple;
	bh=p+z2Cb+IYqw0oF+ulEcKkpYQyMc55w2fHKqiVKP4B0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BAaA1wgayXlsUzQXYhc+15A/fT2Mx1AbK1W5Hdviv4EBwHvp17gvDDotBXOY55dthSzNGb96zL6QPSq95uGo9oNZU7a6mlqXjZUweSUBI+AnXeXv9P0uqqzHAtczmDkXfIw4AwjDmqjDxPsLLDN2MWOiT56TcAmF6OVAQXBG18U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MtrwLgQ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MtrwLgQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1721F00893;
	Thu, 11 Jun 2026 11:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781179010;
	bh=p+z2Cb+IYqw0oF+ulEcKkpYQyMc55w2fHKqiVKP4B0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MtrwLgQ6J4LUv5hkXoos/e/FjkDLL6BZyozh+84eapQ9D2wJMrgbqwkUAv3fsfz+F
	 idy+h06nwp0JIQwxvFRUpDpanrKXiQnK9Z3ahs4nk00LPBCBa3hChS5q03HlshSwoD
	 SsNJU+UMmmYmNeibXZbIDEsM1ALvmER06/OnYwj+q39Cye+d9ueGQ2TqlYxq/XW8jt
	 zljVjt+lRe+VZyoL77vWTvnZDLWu2k8D9eWTRR/gpsTWdCYXVH2YXGOoYM28LpTAp/
	 NzTRFnrisXo/0b7wFjeXpvZIhlJDR8EcZ61tDzi1rbDz0pz5AILFzPdApUPBhj7zCA
	 uL5qKlJMzsFrA==
Date: Thu, 11 Jun 2026 14:56:46 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jihong Min <hurryman2212@gmail.com>
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] xfrm: extend ESP offload infrastructure for packet
 engines
Message-ID: <20260611115646.GN327369@unreal>
References: <20260523121522.3023992-1-hurryman2212@gmail.com>
 <20260523121522.3023992-2-hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260523121522.3023992-2-hurryman2212@gmail.com>

On Sat, May 23, 2026 at 09:15:20PM +0900, Jihong Min wrote:
> Some ESP offload engines operate on whole ESP packets rather than the
> generic software trailer layout. They can generate outbound ESP padding,
> next-header and ICV bytes in hardware, and inbound decapsulation can
> return an already-trimmed packet with the recovered next-header value.

How does this differ from the existing IPsec packet‑offload support in the
Linux kernel?

Thanks
