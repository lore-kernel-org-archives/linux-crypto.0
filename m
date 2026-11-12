Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794468524;
	b=f6sK3s/QMkmstoACWVrUgB21MUZCm71+bBHao1yWND4BtFykDIT335ZZz5HCke8N2eM4
	 e94NNOwqQG5MtKNFfIkJyPd94uOQhhschc4YgILOsdQykilkIE4MHUNjnN6Fm52FImDX0
	 a2tmewudCRiWM20Soj1KB8teBVwVpduG3wpaFsQkpN29zeJDQNtIqUE0e2mEV8LDG79o3
	 WTeAhwggoIek8fI/pR62fQOqAsj2+vspFHO60WzPFT7PJh7At1OyTRnM6gWmMFXwt+J8v
	 mG7BHns0i47TpD2ZfE7ADzbbLFdp2Z9HsozhmX9+p9BDfCSTZpereK5uhvHrUYNfmsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794468524;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=aNozQA4o1upURYxWaEXrzavAa/kCiQMOzOAXy/eko8A=;
	b=2wGeRJMbNQTjvc8eLTcVUxMcfxdezPg/Zw5/9gUR7qInujfQ6pW/7VXQAxw5fBXL7T00
	 b45hn+BpRzIP+KifsRg0onb94eBF2E3Ypi8qHk0INlF9Ss+eL8h2HoTVpIQWpgm7/Taqb
	 xFroUI2BHeAoL8u3z7XZyMLO/CrNs09CYlZBcGov+ccrWOoJVrBeNFmCwq7j74BTlwc52
	 WfSY5fy7TDnSdDs+lzZMHKG+kw3kvSCvgn7TnxOTLt3NsDzt7oiAdpU4chGhw3Nzlmlfh
	 d+bsH3RgIA6PBFO7bhQsRMWbUjHBj9OIz11Xb+2RQ00GGXB86MOWuqJz9GjHhaxigzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Oqjr6+xz;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35E2606A336;
	Thu, 12 Nov 2026 07:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Oqjr6+xz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=aNozQA4o1upURYxWaEXrzavAa/kCiQMOzOAXy/eko8A=;
	t=1794468523; x=1795678123; b=Oqjr6+xzgIK88nyls6QxiexpXaBHprrWMoZjJCFpkpJLzZe
	NSHzEX24e8fPksYTuGtHEiqVJK1LKICx0MELP8YZZrNOI6I3ms9Ts8OTy95gz8Lk32RMG9i2RVHuo
	NiZhZ47UsJsOwe0IXDLbXAh2HcL2YE9y5dYykbx20Bt/sWzej3pmX1jQzrKahnlpxS4Tj3nwJIoQ9
	rLe5iOWQ2ulYtuP9cd6FbEFKYMB8LCPnP4SLDsdBV+oM06oK8r2yfDt+MTVbcMI4doivwe5C1807a
	l4sfSV9kkhfIeQHlOZiooY/QBvcKXk/fzUG5+FgmiLR/hC9GxSqm2EEYM7Sd4yEw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xRPEd-0000000691I-39rv;
	Thu, 12 Nov 2026 08:28:39 +0100
Message-ID: <199b6e10af2267bb60e7e73fda243f73b1b818ad.camel@sipsolutions.net>
Subject: Re: [PATCH 1/3] um: Define kernel_fpu_begin_mask()
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Biggers <ebiggers@kernel.org>, akpm@linux-foundation.org, 
	linux-raid@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, x86@kernel.org, Christoph Hellwig
 <hch@lst.de>,  Richard Weinberger	 <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, 	linux-um@lists.infradead.org
Date: Thu, 12 Nov 2026 08:28:38 +0100
In-Reply-To: <20261111205604.47547-2-ebiggers@kernel.org>
References: <20261111205604.47547-1-ebiggers@kernel.org>
	 <20261111205604.47547-2-ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2026-11-11 at 12:56 -0800, Eric Biggers wrote:
> Define a stub for kernel_fpu_begin_mask() on user-mode Linux so that
> lib/raid/ can switch from kernel_fpu_begin() to kernel_fpu_begin_mask().
>=20
> Note: this causes a checkpatch error due to the macro's value not having
> outer parentheses, but it's left as-is for consistency with the existing
> kernel_fpu_begin() and kernel_fpu_end() definitions right next to it.
>=20

Probably should've CCed linux-um (done now), but the change seems fine.
There's no FPU handling needed in UM since the host kernel deals with
it.

johannes
