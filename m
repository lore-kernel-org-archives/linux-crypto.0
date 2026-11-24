Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795542659;
	b=nf7JIYk8pjfpVeuR+uspsBVgZSg/O43coAf56VFyaGeCjjqFWJSLuhc8XQ9DknlH323F
	 1evg5miVuZLxhsQOBokNjwTLY9Gde7EhPb43ude/ZDCx84k/gJRcieHTPkZMbkSPtmbNV
	 Ke+iChIWEvo4DYv1WV/6n7IRddsVCSK8tZP1tvoUPawAi2e/ouMglLFzDfy5BlVHFfMCZ
	 /NQ84GV0sZUaZRNoIog43Srr7qvTzKydcWjYAgDg+uP7NkW/QhHgwztGfeIqeTSyNnc9C
	 KKudIe4e03G5bDPfRsgTRFwtf/1LxdNV1AU1fVYMbZJlOO3xB6q9ct7ZFq7D5wmNsZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795542659;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=0umf8O3DjQrzppFewFNsXqOGF86wKTW4LdEpoqux2L0=;
	b=iGopnjG6M2zj5s1nJu1Meh7BgYYKfGSW5dRfIysehDgQxlBM5ueS/Mhq4lW4FG47J9J2
	 PwwzhHozOiFuLJFMywbUzZER87sCaMpEoieRcfrnGr77zD0O49JbLBie0zFUaIofJDO0F
	 gYSdUglin24SbwfMTuEsTj1nh5JvvaoTMFkWNuzklyHp4XPBNyPBeXdU6zj9HYre7Vxus
	 QTrImAy/c1TTUAgu6V4r/lAm3TYEqB80lSLvuT+b+4JXr4FL83aLO2o9AiCnu5odLtmS5
	 VuP+DCLbqJuO1CR01fIK2oOmu0UJIww7qongh71cP1MoNwIg6ZeKy4eZXFkhaGkMJBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qj0FY0HE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6D2E1606A31E;
	Tue, 24 Nov 2026 17:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qj0FY0HE
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 21CCD1F000CA;
	Tue, 24 Nov 2026 17:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795542658;
	bh=0umf8O3DjQrzppFewFNsXqOGF86wKTW4LdEpoqux2L0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qj0FY0HElTl2tk/8v876CoTCb1kQjrWkDGpktqCeRe4TbMjgF/AbkO4AkV8bo0DBI
	 FAXjEU7y99mfursvL3TaWNnHALnVHnmV74+LT3kJA6zbEdWMkAAiYSROU+BD5rJnQW
	 9/5VvcDf8MtA/9WMJaveUnu8WUXJoSit6QkGl+8GOM3fCSIJhFmacpT/mLx0ebNWQy
	 x4wJ8TOMuB8CPs0YTyDC8/vrMhbXnUYVfRvDbWA2BtEf1yPjqUFlqGSc+wnee9tAS1
	 oZxjxtFMAr46OB0/bFedKd6CEczT7Vi0zBEzpMPO7GPnRkTxMPCHhvv5LlhXycjlcm
	 lcppO/hoPbmrA==
Date: Tue, 24 Nov 2026 19:50:55 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Florian Bauckholt <florian.bauckholt@cispa.de>
Cc: Rodolfo Giometti <giometti@enneenne.com>,
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Hui Peng <benquike@gmail.com>,
	Stefan Berger <stefanb@linux.ibm.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Guicai Ma <maguicai@kylinos.cn>
Subject: Re: [PATCH v2 1/2] KEYS: fix signature length passed to
 KEYCTL_PKEY_VERIFY
Message-ID: <awXOfwPQUxO2L1M2@kernel.org>
References: <20261119-keyctl-pkey-fixes-v2-0-9e2d1c7db7ec@cispa.de>
 <20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de>
 <80ded1ae-51a7-46d1-bb67-02b4b06de71b@enneenne.com>
 <av7x53CigERu-cf2@kernel.org>
 <5d833d4c-bf8b-4ffb-a214-126de4403d4e@cispa.de>
 <awXK5NCHf82v7yaj@kernel.org>
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
In-Reply-To: <awXK5NCHf82v7yaj@kernel.org>

On Tue, Nov 24, 2026 at 07:35:37PM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 24, 2026 at 04:54:15PM +0100, Florian Bauckholt wrote:
> > On 11/19/26 13:56, Jarkko Sakkinen wrote:
> > > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > Hi,
> > 
> > I saw that for-next-keys now has 94cd21592349 ("KEYS: Fix asym key
> > overflow in keyctl_pkey_verify()") with the same (trivial) patch.
> > I'm not sure how this goes, but if you'd like to add some context, a
> > link to this thread and these tags can probably be moved over:
> > 
> > https://lore.kernel.org/all/20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de/
> > 
> >   Tested-by: Stefan Berger <stefanb@linux.ibm.com>
> >   Reviewed-by: Guicai Ma <maguicai@kylinos.cn>
> >   Tested-by: Guicai Ma <maguicai@kylinos.cn>
> >   Tested-by: Rodolfo Giometti <giometti@enneenne.com>
> > 
> > Thanks,
> > Florian
> 
> OK, so I pulled that by mistake as I was picking patch for keys 
> 1/2; not asymmetric keys.
> 
> I'll drop it.

I'm confused. The patch set had fixes for to separate subsystems
so I picked the one that I should.

I assume it will be picked by someone. If not send a new patch.

Br, Jarkko
