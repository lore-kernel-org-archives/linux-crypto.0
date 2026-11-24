Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541737;
	b=V4AiuxQAK9IBERAmlrR04Td1bQBZp8OBTtelUjQpWZoLK/VjAjBGhFoeBR3gcw78swTr
	 ktFv+OL2ya4/IGciOQTjMC54lX3X5p9uynw1ewLn58mjVImaZLfFqwTAgmtCjc0RsH/Do
	 6zfBpPU5+PzsPAb9n/r3U0U1mXEDYalmV33dG0Wzo0sPJGcjJQUIrrRTpVGd/QYSZkcmV
	 ca2eTq5V3BVFlnnWM6YtB9V68HHgAbagL60OEGH2LKV5o95lOa9pB4WqrATs3dPwounBg
	 KfDipf+yZ31IHcZ2yxTyWYhvmavdlRCeUE/8nQKNbJ15Ul8ZjULp6V4LhrccUPhiVoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541737;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=cWqL6q32i2ja46RHuRrMa8Y59cNELun9rcT6OJr7BfE=;
	b=qZxtoW/8MqWqgzFXxG7EHaviOCjMLMm+2gUBVbEslNakpXLIjrIPmaAGNsZz8EhjoUUj
	 tHjzpgQfzNUlReOM1Ry0XrA5+X24IL16NoVCL65VdGYyAYE4R8CXFsVdxEPvv0H74EmXB
	 ZgZm0rFydICYvC/jrGRkFSoarNCMoxIiboIYnVYGFKLW+Th0jNLz2j4dyppN5gyScs97M
	 tMuXPj1mW8o04sueu0E/EeT0yG88KozDVBCpmZmmN5qfjvOKCgHZibtIoWK5InOCiKTuL
	 m0b03nVd6w4yEnoWUSja6vrxObQvRV0Wfvr/lNevDe8Hyc3u1aJMJHnGlYozEMvEd5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GeIPhm2b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 14265606A33B;
	Tue, 24 Nov 2026 17:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GeIPhm2b
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F18111F000CA;
	Tue, 24 Nov 2026 17:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795541736;
	bh=cWqL6q32i2ja46RHuRrMa8Y59cNELun9rcT6OJr7BfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GeIPhm2bJlCmLIB2Uhp4YL9t1l7plYTcOJFMFBCjGAlQmjVZiRMwlkSYEO6Y+sjAx
	 7VEOhgtmQfXP4HQtnMhNEC7fym2O5gK1LuFAiN/hzTGfmBAMePgGKfQYJW1eb+Ja/r
	 wuIKJLAOs0WgMd7k3b1yVyOQtpvWDV2KYuxC+OhfZSvP/I3fAVnDKFf8Zlc/9nJpvZ
	 87EgXxCP9rl1lPOSmt8Gm1N+kDYHIZ/phMeH2ymC14TG3TQpK737O1UBFF55oeSYRE
	 yemyQu1anWZ4TVlunkbQEgVN1kqzrOmcB9MLf4KA6lSJFQt/HTEE1PI9/Y1UIEGG+E
	 zcmOnsKZX8Xag==
Date: Tue, 24 Nov 2026 19:35:32 +0200
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
Message-ID: <awXK5NCHf82v7yaj@kernel.org>
References: <20261119-keyctl-pkey-fixes-v2-0-9e2d1c7db7ec@cispa.de>
 <20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de>
 <80ded1ae-51a7-46d1-bb67-02b4b06de71b@enneenne.com>
 <av7x53CigERu-cf2@kernel.org>
 <5d833d4c-bf8b-4ffb-a214-126de4403d4e@cispa.de>
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
In-Reply-To: <5d833d4c-bf8b-4ffb-a214-126de4403d4e@cispa.de>

On Tue, Nov 24, 2026 at 04:54:15PM +0100, Florian Bauckholt wrote:
> On 11/19/26 13:56, Jarkko Sakkinen wrote:
> > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Hi,
> 
> I saw that for-next-keys now has 94cd21592349 ("KEYS: Fix asym key
> overflow in keyctl_pkey_verify()") with the same (trivial) patch.
> I'm not sure how this goes, but if you'd like to add some context, a
> link to this thread and these tags can probably be moved over:
> 
> https://lore.kernel.org/all/20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de/
> 
>   Tested-by: Stefan Berger <stefanb@linux.ibm.com>
>   Reviewed-by: Guicai Ma <maguicai@kylinos.cn>
>   Tested-by: Guicai Ma <maguicai@kylinos.cn>
>   Tested-by: Rodolfo Giometti <giometti@enneenne.com>
> 
> Thanks,
> Florian

OK, so I pulled that by mistake as I was picking patch for keys 
1/2; not asymmetric keys.

I'll drop it.

Br, Jarkko
