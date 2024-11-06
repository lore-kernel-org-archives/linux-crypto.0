Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D9F1FBCBC;
	Wed,  6 Nov 2024 12:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897703; cv=none; b=P/rrY8kBLwKX9PO0QP+9mLgqC/2yppO5L2j2iWe1bV0cuo2lRZ8VYywM6Iv5BiU9AxWKmjDLRMM9P20IDkrjjRA8NsWEFB341YtOyXOVOYfqEzTzdO/CY+yHnZkCU0xLNVwnjqaoLQSCIhtW+xnsh6pMltbxVeI9zU9zZxGmRwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897703; c=relaxed/simple;
	bh=C/YyHTsrUA5cNUrNatbZfGIhA6FzfOxnYY7jmTSTWoY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qsmNgvfqfwGZhcW/K/q+AqGmlkehSb6r/+P0q2eBC79eF4HFtsdxKVGWOvVrfFp35CKZegpqF86GfGs+xsSFEoxn+esFiU3uhmAhA6J/zpoH7Rzam9rMNCNCUddTZ4FDfV0MfvuJhMl7NGlOv33Vm3Odgm3LmtW6kQSQU+VG+9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=r3i4JO0l; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="r3i4JO0l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1730897696;
	bh=iRLJUrrpvdggs7VLYItdrnY/LsBZ/gUpUlld7wSgZg8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=r3i4JO0l9iQ/cxv6XhZ8DpOqJ1j7acgckLxkKMl4bVwXA5RGLe7UDkjwHhojgmrwP
	 DyZG+tZetPViar+nig97Y1e3NAu0EwOv/NjD9YIC4KKcMvbLrMVIXzuPzcjqLgDovE
	 XiM9FezvsiY0J/Ty+HMvlufgk1ad3WTlsGYrCIU1Yk/BKEnYjRiJrAmKlkNvcY8j5l
	 H/+YXKVDwa2XdpIquKUVEghyDfsQ/Y8j7LN3e7GemCZO/Zyj9gas7PIGXGgqu5XD8P
	 bdqWjxJ8RU72jLFr1PjZPKGKDaQlHM90aHVh9ukfSU1Vu1MCf0lC3u8psiNAsEg0yW
	 Wh9EveL3Kt/Fw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Xk4t25VRLz4wyh;
	Wed,  6 Nov 2024 23:54:50 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Lukas Bulwahn <lbulwahn@redhat.com>, Olivia Mackall
 <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Lukas
 Bulwahn <lukas.bulwahn@redhat.com>
Subject: Re: [PATCH] hwrng: amd - remove reference to removed PPC_MAPLE config
In-Reply-To: <20241106081343.66479-1-lukas.bulwahn@redhat.com>
References: <20241106081343.66479-1-lukas.bulwahn@redhat.com>
Date: Wed, 06 Nov 2024 23:54:52 +1100
Message-ID: <871pzoldyb.fsf@mpe.ellerman.id.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Lukas Bulwahn <lbulwahn@redhat.com> writes:
> From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
>
> Commit 62f8f307c80e ("powerpc/64: Remove maple platform") removes the
> PPC_MAPLE config as a consequence of the platform=E2=80=99s removal.
>
> The config definition of HW_RANDOM_AMD refers to this removed config opti=
on
> in its dependencies.
>
> Remove the reference to the removed config option.
>
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
> ---
>  drivers/char/hw_random/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

Thanks for cleaning it up.

There's also an EDAC and cpufreq driver that need to be removed. I
posted the patches before [1] but need to resend them to the relevant
maintainers and with updated change logs.

[1]: https://lore.kernel.org/linuxppc-dev/20240823112134.1314561-2-mpe@elle=
rman.id.au/

cheers
