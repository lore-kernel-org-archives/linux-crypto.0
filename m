Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D33D35C6AF
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 10:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784714406; cv=none; b=oApuwhSxFluRucKGor5TE4090Qc5u1w6wCgvB23p7lYTtDyEVz/VUqXXBPU1y/kw5IT/ENkiKAJ35z00J3teOA7mJ+T2vbPmeZRn6UH61A3vMAE7ZKV7GbMIkbb/OWy1/8ioXL/fySS/JKdpcBigxTlVmCV4YoyRea65JTmJ5kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784714406; c=relaxed/simple;
	bh=XkLh3Y+yDcVXLHR0EH1gna2qCg+qF/uDwe5Ga4HX/T0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=ID0e+Vm1aeprILSpH2d9H2QqiwGRgpj6UhyrqUleNFGXVzartNgMyYHmagj76Vl1xqt4oIsK1tnGfBhA2ctYqOT4U8GXKSzvk2nQ6SBskQkHML2OX5FJIfvgUZJbumCH2p8Bj39Qh0r3K2rRqyg5YZYV5MKSk0A9Rg5LLOLPtlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QvHpPaYK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QvHpPaYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6471F000E9
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 10:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784714404;
	bh=zJi8nJTPOQLto8PzeQsebnb2PMHHs2KS0DmG0HTrM24=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=QvHpPaYKsz0dbwhiIKQ80EEoRd/S/SBjrjSd6B5jY2pb+xOD0DWgFk9b8tBaGU2eR
	 6MZUP+bUiNpwLmVsN0y3lPRkmU4PeiTrEMVZL/Toa7YkL+KA2hxecWGOqDHgFjni3I
	 n4lXUO1BIiqKBPl+ir2vGSE8BJ36CvChsV+akpfyLxivP3dJWcEsJK5v+1WnA/sMgV
	 smVUi9qNOTIItqxKx+mndOVESFiuPg5fzNt6F/dp8gjV8GXpZZdEZFd9zPXVgyihve
	 dY8/zbn63fIGM3svfalXiw1k3Ee0ubqJbfjCGeGxQ66pwui3rAXa6XKaL0BDc8ysOu
	 qti+VxFXOu/YQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0906AF40067;
	Wed, 22 Jul 2026 06:00:02 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Wed, 22 Jul 2026 06:00:03 -0400
X-ME-Sender: <xms:opRgagg_qIhc0Z4LG625qdmyAtPEF5s6-muVaQ_RWNk0PjLxFSYVfQ>
    <xme:opRgaj3aMj-9bFl1gp55b0Gc4SN_3164dGjmfc3dCkZON9mkmM0duPugCPCLEe1FB
    sD47YdFoJUrvPj5qjBn86E5RRQTdxddC7AwG0h5ZJvwNfTtUabB0Q>
X-ME-Proxy-Cause: dmFkZTGJ1FH34GKdr7h/zxn+t/uNPIoANAGnGv/KJz9ew4UUm7Q9UqmiZEjekBw2ji4n1y
    T8ZLRe0l/8daHQaITyNUhec5/vwSFonsAtaDhI8V/ADFQevcfWy8cwuIpnEs2MPC0TWt7I
    jPB19VCpxvybGB2qZi236nV/1v/jCI4YKFPU2GbcxwpzLV6JKr0LzsoPDF/QzeTe7qOeBK
    oa2TsM0AbXU666WZXVbDKMR9v442z885Vn5BOG2ZvGy2O4n2ipXS48WDjeecuxAzfqKUdJ
    JiSOB0wOc3NAd+u+dKdmDzUfVn0QQ1px9DBPhraB/OacRUFgRXNF93XN+Un1/HGFRPjiDY
    xY4/xKVJC16FrEEjuGcpwvsjsD+p+y5G5VkEYCzuCtIf439C5+7X4GWvxZ2cW4i8F4OhgA
    r6wK2RJE0hAKcq+LfsTfLnhVYTjS8b6U3q37FQldBFR+A4mqfVnoYIFPbQXaZQeSUF9V6x
    HujG2sSQztRXwPfwthA8I133U2fJNk+BZZ9PlX6JzHHCDNd/azIP2royFqj6JmIHFu63et
    l6a95qXYvccz46Oikwt6wCo6daC+oiV0i8OPBc+U5yNPCLsj/susM6W5BsyOcoYUugDyvJ
    q2FikRtxxawCs5yR0HfqkunLUhwZqSBs87VRGV8VqMDrfNgyxEsDkG3DC2Ag
X-ME-Proxy: <xmx:opRgasCq2BVJszorEco6Y_se7l5ByVAbdnPNdXsRBe4YSh8ef-JHYA>
    <xmx:opRgahk1HhBebe6YAD1XHwDxhkBe2IZBAw8ScqUgSEpacpugdV65Mw>
    <xmx:opRgaqPpuv1a1KL14Kwqta-ESl-wBoYyuM19OBdnjSiQstMrGth4OQ>
    <xmx:opRgau9jxIvq1YWLUdU0irGPx6mvt4EtHrGJ1hFSwdNPedrV4g8GKQ>
    <xmx:opRgasGve-qYQ_HM41gN7M4e2eUxVFbkvJYfi6Lvg2uPozrvQktsndzQ>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id BDEF91820082; Wed, 22 Jul 2026 06:00:02 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 22 Jul 2026 11:59:40 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, x86@kernel.org,
 "Borislav Petkov" <bp@alien8.de>,
 =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>,
 "Alexey Kardashevskiy" <aik@amd.com>
Message-Id: <294ca2d9-2552-44c5-9c9c-df44692ce145@app.fastmail.com>
In-Reply-To: <20260722025338.33354-1-ebiggers@kernel.org>
References: <20260722025338.33354-1-ebiggers@kernel.org>
Subject: Re: [PATCH 0/3] Remove old AES-GCM library
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 22 Jul 2026, at 04:53, Eric Biggers wrote:
> The old AES-GCM library code is being replaced as part of an overhaul
> that is adding support for all the common AES encryption modes with
> consistent conventions
> (https://lore.kernel.org/linux-crypto/20260715221153.246410-1-ebiggers@kernel.org/).
>
> The SEV code is the only user of the old API.  Update it to use the new
> API instead.  Then remove the old API.
>
> This applies to libcrypto-next.  If possible I'd like to take this
> through libcrypto-next for 7.3.  Acks are appreciated.
>
> Eric Biggers (3):
>   x86/sev: Use new AES-GCM library
>   x86/sev: Remove obsolete virtual address check
>   lib/crypto: aesgcm: Remove old AES-GCM library
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

>  arch/x86/Kconfig                        |   2 +-
>  arch/x86/coco/sev/core.c                |  53 +-
>  arch/x86/include/asm/sev.h              |   2 +-
>  drivers/virt/coco/sev-guest/sev-guest.c |   7 +-
>  include/crypto/gcm.h                    |  21 -
>  lib/crypto/Kconfig                      |   6 -
>  lib/crypto/Makefile                     |   3 -
>  lib/crypto/aesgcm.c                     | 721 ------------------------
>  8 files changed, 26 insertions(+), 789 deletions(-)
>  delete mode 100644 lib/crypto/aesgcm.c
>
>
> base-commit: e4f23159c8d09b6b15d47f2c95e0a3e7c62f52a2
> -- 
> 2.55.0
