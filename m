Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2FB2288D5;
	Sat, 16 Aug 2025 09:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755335832; cv=none; b=p3MnnrU5rAaypQhf2pUbfd0avomuQWdbK6HJVg4IJe5K3erftA30r1DRoMXmreUtcHYbhZAeMsZBB+NthWu4thZqVJJcqiVEp+3gL8vvrUXHZYcqua6tvAB/I6yJv/Xjd6J5Apb9zhnaHxUFBxjKWyRzVNf8fNFFJj13179AWVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755335832; c=relaxed/simple;
	bh=9T61HD81tV08LClECOQ+Zr3l0he20nyaxDuXwlAodWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nabhVgDpQrIs2xgSSxpixXoOXvSQOW2YlS+yD0d18txq4Qpu6xjmz0SjKoTDVQFkVVPT0p2xsG6garG4eVMilk1isQzGuYvZpApQtEkNL02PVsp6S68LOPcJWsj+5/9QTEgbsRE6kR6UrtgdmbwURA4YdGeyunMar127pG5snN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QVy9MP8f; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QVy9MP8f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Mek6N/9hY+b6eNY2t+YRBKtIz4cC7SJ2HElflbJFTp0=; b=QVy9MP8fqYmBl26R7PxAVp8pkl
	/eXdqeUK9wKsLKwMaP2x6K/WTpcsZWDRia3/kz29nlBSSJ+c/ubN1WyceyrWOXjYIE0Uu90xfdu/p
	0N9XYHsKSjrMY2twVWmwpJuUlVyw2llPqiy5VZYiQ4AWif+0lEIdPiDD10ZPoeJBBtyWqBPZr1D1p
	O2oLQissGvwQU2NJC2oi2S0o6AheQe4JqrqpBsxeLokUakqhcGg0TyxDJCagEDhCKLcALA7RBOQHm
	a9sUYk7N/uO4Z8/llUgauTOhjSLnzVxX56inxxtBIniQhBRZYu/Pa5fOuRAxOnsD/VKT3u2Tzqu3I
	F5Ujmaow==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unCme-00EmCs-2a;
	Sat, 16 Aug 2025 17:17:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Aug 2025 17:17:01 +0800
Date: Sat, 16 Aug 2025 17:17:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] crypto: Prevent kernel-infoleak in rng_recvmsg
Message-ID: <aKBMjQpA9P70EA0z@gondor.apana.org.au>
References: <6895b041.050a0220.7f033.0058.GAE@google.com>
 <tencent_B406618996EEF22ED6CC8EA7DF46FD92D206@qq.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_B406618996EEF22ED6CC8EA7DF46FD92D206@qq.com>

On Sat, Aug 09, 2025 at 05:59:43PM +0800, Edward Adam Davis wrote:
> Initialize the intermediary array member to 0 to prevent the kernel from
> leaking uninitialized data to user space.
> 
> Reported-by: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e8bcd7ee3db6cb5cb875
> Tested-by: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>  crypto/jitterentropy-kcapi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> index c24d4ff2b4a8..9e9e069f55af 100644
> --- a/crypto/jitterentropy-kcapi.c
> +++ b/crypto/jitterentropy-kcapi.c
> @@ -107,7 +107,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
>  {
>  	struct shash_desc *hash_state_desc = (struct shash_desc *)hash_state;
>  	SHASH_DESC_ON_STACK(desc, hash_state_desc->tfm);
> -	u8 intermediary[SHA3_256_DIGEST_SIZE];
> +	u8 intermediary[SHA3_256_DIGEST_SIZE] = { 0 };

This is not a leak! The stack memroy is hashed and fed into the
entropy pool.  If you can recover the original kernel memory from
the result, then we have much bigger problems :)

Please find a way to mark this as a false positive.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
