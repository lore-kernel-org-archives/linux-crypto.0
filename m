Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92FA19F12A;
	Tue, 21 Oct 2025 03:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761016392; cv=none; b=k72zd/GUyARPv9qszu0+pYbt9yFhFpi58QnaEffwFLsSW90JPVRIKFRDX2p4nO2Z42BTPT5mkEfy/j/EUXS/r/qntqdbk2o1KNGRKfYfFmiLw+lD172CPpi0LGbyBWTKCwcR8rzfN5FX25BALsgoEkBEJ/gLe0Fbi1ok3C2TZpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761016392; c=relaxed/simple;
	bh=S5AtrKXvJA/5Da2Iz8tuG0yMOFMS9Zrhpy81mF6Y4Sg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ht+ZHBOOziyTEE1TUXE5Cu38RWhhkuj2MVSiNH5X8ObMCh7BW8X1ZMOK/y2leiFW1EfCVAIJ849el3OR2mEcrMN0dvOnHMLC9ziM9KDLHQw/xzkniZl2equx3mkkZob3ofi43sYLIGWkrRBRLeVptdy6/kyJAdhNszrpQuRrwQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=GKkcSI68; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="GKkcSI68"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=wfGA3DegtlrVHUVrxkczFnxqgIZ1YYjT0aDZlqryxF4=; 
	b=GKkcSI68jTW6NzwQ8/dJbCu4358dmhJsvX4cyggSIkawhMqjSkONVSPw/24oE+GfAs6PjmoA+fE
	yHlgaUFJX7fO2x3Tki4PUmOkzliPexCO05bVExtO9m3xT9zCLeo9rFxOb0tSdaA7r4QQJ1kmlfJIG
	RrChuUF1WgrvX3cI8jDOgJBPcWaAcRZ9WgNHOlJznKx++N3bcfIJgVwNdWKBJHl3/KQ1uOy9I331v
	3rMWoa7K1AKBo9Hwv4reLoxFoeS9/XTUK1f7bjdDouH16hwBuo90BGTUqnwnLdG2hLeoYfPZ/RHCa
	LN5VAK6QIbiVkkcbCdtnShj/cQP3CGQuuXNA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vB2nv-00EEB8-2y;
	Tue, 21 Oct 2025 11:12:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 Oct 2025 11:12:55 +0800
Date: Tue, 21 Oct 2025 11:12:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pei Xiao <xiaopei01@kylinos.cn>
Cc: syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] [patch] syz test
Message-ID: <aPb6NzJovIM6CFud@gondor.apana.org.au>
References: <68f6f516.050a0220.346f24.0002.GAE@google.com>
 <6556ef55c42ea17d82561b8182d9453b19d66a62.1761016077.git.xiaopei01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6556ef55c42ea17d82561b8182d9453b19d66a62.1761016077.git.xiaopei01@kylinos.cn>

On Tue, Oct 21, 2025 at 11:08:54AM +0800, Pei Xiao wrote:
> #syz test
> ---
>  lib/crypto/x86/poly1305.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/lib/crypto/x86/poly1305.h b/lib/crypto/x86/poly1305.h
> index ee92e3740a78..3b9f1024a18d 100644
> --- a/lib/crypto/x86/poly1305.h
> +++ b/lib/crypto/x86/poly1305.h
> @@ -8,6 +8,7 @@
>  #include <linux/jump_label.h>
>  #include <linux/kernel.h>
>  #include <linux/sizes.h>
> +#include <linux/string.h>
>  
>  struct poly1305_arch_internal {
>  	union {
> @@ -86,6 +87,7 @@ static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx512);
>  static void poly1305_block_init(struct poly1305_block_state *state,
>  				const u8 raw_key[POLY1305_BLOCK_SIZE])
>  {
> +	memset(state, 0, sizeof(struct poly1305_block_state));
>  	poly1305_init_x86_64(state, raw_key);
>  }

Please stop sending random patches to me.  If you want to test
random patches, send it to syzbot only and not anyone else.

When you hit an uninitialised access in crypto code, it's usually
the caller at fault.  So I suggest that you focus your energies
further up the stack.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
