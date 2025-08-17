Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC11E3176FD;
	Sun, 17 Aug 2025 11:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755430866; cv=none; b=QNhQ1rJmUZKFpMPwdoaDhw5E52U9gExrVHaqVkIrbQiF+gmwzyrWSBa6gsZMGABM48/iKS4QqtlR3dX8NbKjUIK9N66N9rB7oOdgIidXtig9NAurQ0zPL3QV1zLLgDRSSSuDpPhAzlsdMK6JyeT/JgJcO9+qeY5R6R/4rSQL3J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755430866; c=relaxed/simple;
	bh=869c7gcPaIYl+h4mKgJ6Ss13sUo0NWqQFv5exvTjHMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrMuEjSwUtxRqysBu5S6XTodyjeEY3oJMvmHh86ZPEJFAOW7eZxZlxUdHDsKRziuo2Kdyg33jl0C9B3rLZTYJlfMc6Ll2/8WflvmnCrbQcxGbQr1DqmmrFrhlGyJC/FERNU2f24gMePxAjG6+XhF7WvwDHBgXYDw7e8BRJ585QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=R1bJPsL0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="R1bJPsL0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NXJYL/vOt42RWZZh2Kt3o1FAhTT8s2pj2ozGihGmzPg=; b=R1bJPsL0ucWKskUIdD8xvuEHR6
	mm/9aAj3gTqsSGNty4OvPdnqm+52hucSvkjRVO5fb2FbRDsrS2ZN5xbqUi9V5fwuzlkUGf0S28jh8
	90NfeqYXEbigRfhTxvlavwiF+bEZTk3RjUgx1moYkSl5Gj4imSeNxnPteEXUMMJcnQKP3NP00f7q8
	4OLD/vV8ZnhRn1fCeeYOzj5uO3UZ+9w+kJQ/ImPrmnv7WdgGsORoPld5bc5Q14U48G60XmLUniLrx
	MC5Y56aRdS419VqlMERmMi4je2EanwzGitSjU5hiGpOI0SsHG4FxZSOFwkqjM7kujRmPF3iNA45RX
	iU8PQ0kQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unbVT-00Ez69-39;
	Sun, 17 Aug 2025 19:40:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 17 Aug 2025 19:40:56 +0800
Date: Sun, 17 Aug 2025 19:40:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Edward Adam Davis <eadavis@qq.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V2] crypto: Mark intermediary memory as clean
Message-ID: <aKG_yEuG6F4cqFjf@gondor.apana.org.au>
References: <aKGYHwT31OaGzc5Z@gondor.apana.org.au>
 <tencent_73E16EBC9654E89EECD6CEC4786A6C4C2D0A@qq.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_73E16EBC9654E89EECD6CEC4786A6C4C2D0A@qq.com>

On Sun, Aug 17, 2025 at 06:59:15PM +0800, Edward Adam Davis wrote:
> This is not a leak! The stack memroy is hashed and fed into the
> entropy pool. We can't recover the original kernel memory from it.
> 
> Reported-by: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e8bcd7ee3db6cb5cb875
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
> V1 -> V2: mark it as unpoison
> 
>  crypto/jitterentropy-kcapi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> index 1266eb790708..4020a6e41b0e 100644
> --- a/crypto/jitterentropy-kcapi.c
> +++ b/crypto/jitterentropy-kcapi.c
> @@ -117,6 +117,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
>  		pr_warn_ratelimited("Unexpected digest size\n");
>  		return -EINVAL;
>  	}
> +	kmsan_unpoison_memory(intermediary, SHA3_256_DIGEST_SIZE);

Please change SHA3_256_DIGEST_SIZE to sizeof(intermediary).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
