Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794437815;
	b=FbouBtjZ8NxbFO0QgeslZsLhe0iC3ZxjXE03XSRL4NdVzeOHJqftqb4FZAcgCkElat1B
	 O6Kqoxxo/34t1qHNMMDb/yUpOibfLaR1aW+cuhzDjPXT1kmwKdZnc1vGuBYPwGcinD3MU
	 0G4vFAHOIPQtHHvmHijCo6mMZltETbiUH9r+wR7yD5UpQ4MiWyt/DoqbxQNcwL7L3Q6gc
	 1gu/xLP/l62FIujM4KDJqSXl9oTiC57pRQ8uc05kJ+o8Fj1t4vmdme6cO8b1TUqqsDijO
	 fUp+zSTilPZ9dFOZBV7HqBBjdp+pO6gsZPnWi8dx4chqDtIi7Vh6RBsVZRurj6z/lEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794437815;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=x8KIMploAwbb4Mczfw+P/Ziz4NnA8K/xtCPVdcSXKs0=;
	b=uZv0l7DshCJWMVdpa1kXt0nlWloH7o2pBtvrJ6KkLIpXT4hIWr9deUgapo4ToSVPN+CV
	 N5Nk86PQ7pT99CvmdZDEhaUQM+ZlUNgjy4mG6vAm5iod4swFkIW6slMI0gCp0mDl4gjj/
	 yRI6zGw8++2HSerE1Ia3Psk+U1g+BY9spPAKScU3MrykTCKqCEHmJfqW041fYSSYW+MwR
	 iiD6xg9Xm2eHtBWX3Vl4R40h2Uqc53UEhgEE6TV+Sb6IrJy1Q9YhsJzVJtoMm6/dJK/tm
	 pMxWlLMAI2Gtk/K0WldARYuijg1+6E1XazUMQ4XIV8c7wrhskb4SvQA4dbhRjVKqJKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OGJj+p87;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EEAAC606A31C;
	Wed, 11 Nov 2026 22:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OGJj+p87
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0BCF81F00A05;
	Wed, 11 Nov 2026 22:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794437814;
	bh=x8KIMploAwbb4Mczfw+P/Ziz4NnA8K/xtCPVdcSXKs0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OGJj+p87ocnVwHaY2calrJ2foED/sPQjz42IiLpu4tPdczIy7sQ62wR9uBkKkxJ4o
	 WIIHZvwMx9GLjyPviougxn4Ut3D1tRaU5j7kSk/E4qa2T/uXYA93CAigHwzPOoTJF6
	 fScr8sRACHs13cl0yW2oQIsp2SRVrFP+i6/9LR/dkiOxPJs3OtBDz4TMqtHN6yGimi
	 rx71gHNUxwWiEqjJv2oSPM95MRNFulDsgorjRL2fhnkPzGd5sVdWqGnDcb9Wr82OA1
	 kE02tyedIOW+OgEdSDAO0Qm00MpzYu/V5rezbLujIt+Xk4jb/qF/xn9D3ko8/iOt2C
	 AUO4tFjpI2++Q==
Date: Thu, 12 Nov 2026 00:56:51 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: florian.bauckholt@cispa.de
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Hui Peng <benquike@gmail.com>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KEYS: fix signature length passed to
 KEYCTL_PKEY_VERIFY
Message-ID: <avTysxDOQ11nKR4r@kernel.org>
References: <20261111-keyctl-pkey-fixes-v1-0-934ebaa267a7@cispa.de>
 <20261111-keyctl-pkey-fixes-v1-1-934ebaa267a7@cispa.de>
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
In-Reply-To: <20261111-keyctl-pkey-fixes-v1-1-934ebaa267a7@cispa.de>

On Wed, Nov 11, 2026 at 04:56:07PM +0100, Florian Bauckholt via B4 Relay wrote:
> From: Florian Bauckholt <florian.bauckholt@cispa.de>
> 
> Commit cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
> made keyctl_pkey_params_get_2() set params->out_len to the maximum
> output size of the operation instead of the size provided by the caller.
> It does so for KEYCTL_PKEY_VERIFY as well, but verify has no output
> buffer: out_len shares a union with in2_len, the length of the
> signature.
> 
> As a result keyctl_pkey_verify() ignores the signature length passed by
> the caller. It copies max_sig_size bytes from the signature pointer and
> passes max_sig_size as the signature size to the verification.
> 
> This makes no difference for signatures that are always max_sig_size
> bytes long, such as RSA. A shorter signature, e.g. a DER-encoded ECDSA
> signature, is followed by whatever is behind it in the caller's memory,
> or the call fails with -EFAULT if that memory is not readable. The
> x962 ECDSA template currently ignores data following the signature,
> which hides the problem.
> 
> Use the length provided by the caller, which has already been checked
> against max_sig_size.
> 
> Fixes: cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/20260919221742.3709658-1-benquike@gmail.com/
> Signed-off-by: Florian Bauckholt <florian.bauckholt@cispa.de>
> ---
>  security/keys/keyctl_pkey.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/security/keys/keyctl_pkey.c b/security/keys/keyctl_pkey.c
> index 15b6bf6399b5..794fa3d01911 100644
> --- a/security/keys/keyctl_pkey.c
> +++ b/security/keys/keyctl_pkey.c
> @@ -160,7 +160,7 @@ static int keyctl_pkey_params_get_2(const struct keyctl_pkey_params __user *_par
>  		    uparams.in2_len > info.max_sig_size)
>  			return -EINVAL;
>  
> -		params->out_len = info.max_sig_size;
> +		params->in2_len = uparams.in2_len;
>  		break;
>  	default:
>  		return -EOPNOTSUPP;
> 
> -- 
> 2.56.0
> 
> 

Thanks, good catch, and apologies for causing this bug.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

Br, Jarkko
