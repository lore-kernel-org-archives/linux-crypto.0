Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814E9156236;
	Mon,  6 Oct 2025 19:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759778785; cv=none; b=fueeTB5svoQKgtfXdUeW2ZtaT+wZwODkGJuFnMUvNFnjFvbx0i//3H2dvFzdqcppLEoQnWp//eDl68PMhPy1Nyfccb0NrsM0OxP1tUgOxPcq2tm7a9LjxilEE8Cf5PVc4Iy/N4Bl9lWvxH/+hpbMkex1qQd1rPhk37ujGgKGigc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759778785; c=relaxed/simple;
	bh=quimo5ouivxUpUMJUfFCgFEDlaRUcgwrcu89Pfdan7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=idezrbI7SVEJSIdPVfuB4+LbQOg4QntXOAhNCiL8LDV9msphM7jRL2UlMo6pnjykZ1BCincd3GrjavSAXpPnxzkfdy15leZqIfHeMiPwcLtkzXER7ESsebC3Dgnoz+XZSEuQQkwYBq8oFik9cjB6TzIOH5hDue9Gdt+m/uqh9wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KWf2ZncX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KWf2ZncX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C443C4CEF5;
	Mon,  6 Oct 2025 19:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759778785;
	bh=quimo5ouivxUpUMJUfFCgFEDlaRUcgwrcu89Pfdan7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KWf2ZncXZChMgbnKxJSXynd4mKkYgjUYsT7AQ59e+vv7FarO2F2HoZ+KPxmclQw2m
	 W8+kBn/cVr6MdtvFQ7qwLqpjaXEOPvnV4LgwWF1RfPxTGrExbvdmeJk0FJpGJ+yY/8
	 Vgz3U/sbvIGgvLgbiJk6i6ymWyMwIJ2HXT7AneWRxoSrm+r2K76paPIM6Efz/I8MEV
	 mtQ43iQtPNpFRerys4FCKO+GkF9gBoZ0CorxAnK3Bn0vJQETusdWeWoV/HSDMHwkbe
	 49sOvnX5V4f6MVPTpfwqWmEMJ4/SuHXWjWPPX/OoDN9NGmdaimJ1Lh0YHg9xfjDv9d
	 UxJCXWmzsuHUA==
Date: Mon, 6 Oct 2025 19:26:22 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, "nstange@suse.de" <nstange@suse.de>,
	"Wang, Jay" <wanjay@amazon.com>
Subject: Re: 6.17 crashes in ipv6 code when booted fips=1 [was: [GIT PULL]
 Crypto Update for 6.17]
Message-ID: <20251006192622.GA1546808@google.com>
References: <562363e8-ea90-4458-9f97-1b1cb433c863@kernel.org>
 <8bb5a196-7d55-4bdb-b890-709f918abad0@kernel.org>
 <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>
 <f31dbb22-0add-481c-aee0-e337a7731f8e@oracle.com>
 <20251002172310.GC1697@sol>
 <2981dc1d-287f-44fc-9f6f-a9357fb62dbf@oracle.com>
 <CAHk-=wjcXn+uPu8h554YFyZqfkoF=K4+tFFtXHsWNzqftShdbQ@mail.gmail.com>
 <3b1ff093-2578-4186-969a-3c70530e57b7@oracle.com>
 <CAHk-=whzJ1Bcx5Yi5JC57pLsJYuApTwpC=WjNi28GLUv7HPCOQ@mail.gmail.com>
 <e1dc974a-eb36-4090-8d5f-debcb546ccb7@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1dc974a-eb36-4090-8d5f-debcb546ccb7@oracle.com>

On Mon, Oct 06, 2025 at 09:11:41PM +0200, Vegard Nossum wrote:
> The fact is that fips=1 is not useful if it doesn't actually result
> something that complies with the standard; the only purpose of fips=1 is
> to allow the kernel to be used and certified as a FIPS module.

Don't all the distros doing this actually carry out-of-tree patches to
fix up some things required for certification that upstream has never
done?  So that puts the upstream fips=1 support in an awkward place,
where it's always been an unfinished (and undocumented) feature.

- Eric
