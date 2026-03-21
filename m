Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6228A282F00;
	Sat, 21 Mar 2026 08:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774083110; cv=none; b=mAKGie4ZtIp9rsXrMquogyxhhCeEB0waDmf8/MqylTbYVhHihndmZIQYmE4pukYL458hPYXylrOofBgpFuDzyJtYYsC0D2cC5OgIbFYcj+5SZ1qx0EM9h6LNl0Q3DyaOo3WwuuBV7M8wk9BxgszOGAdKy/awY80lnjyOz4oArRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774083110; c=relaxed/simple;
	bh=PXFpYd2pOTik78VZe6EY9r+UBL4TQd0Fgbl32CURf5w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=AzIzuaWX0Ujm6TSKg+8Bmc8WahhwQs9MHB+ME5X9ceF5BoS2Z1LbGUapqBr/G4RyDsnL86+U+av/0nXvCcHhUrKg5X3GcL4dxss5Ico22ziH6AAva1vCKuMrhpL1yDNkC8Q38ep4epE6dsV34G1W2Z98K5G91npXTkAsZIxRhbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=UTr4SYfo; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="UTr4SYfo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=FXu9guMMjMgom50Su5r/X8HM7wApelPbyGk8nQBGrnA=; b=UTr4SYfoVTg2/B+dPjiw0B/uqO
	hxICvow/VeMHVZD20JIa1IZkD1WxsLnPuBJ3m+lJvdDj4nW82F16mp6wgfUmJSB8JmA81qgledFNv
	nka2AikkYNKj+0eatDHflwnYQh5KSmRoveKej4ACj7u9f9P51cdBpFUP2FiLqzXnBKaQBEe/Cy8ck
	caeoz/vvoBitm8tQImnO4oiCr0N6tLlTPmpedg9DPI2ZcNlZwD8WYcPRptKUViGAAOaWmCRrcxLz5
	ryr7H7CuuNz4kQYOXq/PS+tSIIl0QuemfQvdl70GisPQahzJoZ5UF3jc3unxlkn3lax9uD8Ed7Ek8
	jfbo+5CQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w3s3c-00GJEp-1J;
	Sat, 21 Mar 2026 16:51:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Mar 2026 17:51:44 +0900
Date: Sat, 21 Mar 2026 17:51:44 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	tglx@kernel.org
Subject: Re: [PATCH v2] padata: Put CPU offline callback in ONLINE section to
 allow failure
Message-ID: <ab5cIEp526X-1PgT@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313152433.504992-1-daniel.m.jordan@oracle.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
> syzbot reported the following warning:
> 
>    DEAD callback error for CPU1
>    WARNING: kernel/cpu.c:1463 at _cpu_down+0x759/0x1020 kernel/cpu.c:1463, CPU#0: syz.0.1960/14614
> 
> at commit 4ae12d8bd9a8 ("Merge tag 'kbuild-fixes-7.0-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kbuild/linux")
> which tglx traced to padata_cpu_dead() given it's the only
> sub-CPUHP_TEARDOWN_CPU callback that returns an error.
> 
> Failure isn't allowed in hotplug states before CPUHP_TEARDOWN_CPU
> so move the CPU offline callback to the ONLINE section where failure is
> possible.
> 
> Fixes: 894c9ef9780c ("padata: validate cpumask without removed CPU during offline")
> Reported-by: syzbot+123e1b70473ce213f3af@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/69af0a05.050a0220.310d8.002f.GAE@google.com/
> Debugged-by: Thomas Gleixner <tglx@kernel.org>
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
> 
> v2
> - Use non-atomic __cpumask_clear_cpu
> 
> Applies to cryptodev-2.6 but not mainline since it requires
>    https://lore.kernel.org/all/20260226080703.3157990-1-zhouchuyi@bytedance.com/
> 
> include/linux/cpuhotplug.h |   1 -
> include/linux/padata.h     |   8 +--
> kernel/padata.c            | 120 +++++++++++++++++++------------------
> 3 files changed, 65 insertions(+), 64 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
