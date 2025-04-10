Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D6046B5;
	Thu, 10 Apr 2025 02:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744250617; cv=none; b=FBgjuq/9RJDKOmHVPhoQ3V5frSMDHwoOg9P+kHAh7wznBphengbg+/tC+0uRI1m4kbM7IZRNKVvDX2ek+jYBwvLVgau3ADH4W7HkUcysWcrIw213/lUnSsHIW+L+CjWCxm8ajIPHv/fyM5n9r7nRTFqLZK8OLNmdwrNB/ejx2OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744250617; c=relaxed/simple;
	bh=OEDqPPoOblcvee0nJKQCF23/R5drdrG9tTPR7H+DeL4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FA9WmENZH7EZgSBmOEkLpfOYjAWN4ES+QOqHiw7F7Y4Aqt7CQHXYWUwmKRrvaQH21DPNXa0U8VWsM+oh+nja5CXHOxEKcNHnf9m1D7ROf7z71Xp2FNk2J34O72OSaWrUCQT+9odwH7/PZsoZU8PDwJDvn11GGwQBF9P0aHBzF6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0u/jJCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0u/jJCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52211C4CEE2;
	Thu, 10 Apr 2025 02:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744250616;
	bh=OEDqPPoOblcvee0nJKQCF23/R5drdrG9tTPR7H+DeL4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=J0u/jJCMcmkOebnxyvxd2rQVXMK48DrA1e6H7WD1opvoQAJdHNt0WyI+HqmuGjBTK
	 FE4xeMghbRB08FLk7NC+YsVQxfn1YgWBuFTayml1dsffu9cfQh2AiGZafJIAPP77nc
	 hu5WN684pUQLAuPVZWLP1fH8wLILqppqrOKZropv6xqb7M+plurui1/o16gRCC7Q4Z
	 9LDNnZmgndM1poT7aacROK7aWV8opEWt8q/S8aH14nfBe6tsgMAUoCWXKIq1FB+ANL
	 fDit7ve9z9HhEF7YnEoTmiGCFmjN2vxMajQQb8kGi4JJ8pJXtiO/iyRPqAZTuMEUBq
	 ABzUCsQpSVaMQ==
Date: Wed, 9 Apr 2025 19:03:35 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Christian
 Brauner <brauner@kernel.org>, Chuck Lever <chuck.lever@oracle.com>,
 linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, Herbert Xu
 <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH net-next v2 06/13] rxrpc: rxgk: Provide infrastructure
 and key derivation
Message-ID: <20250409190335.3858426f@kernel.org>
In-Reply-To: <20250407161130.1349147-7-dhowells@redhat.com>
References: <20250407161130.1349147-1-dhowells@redhat.com>
	<20250407161130.1349147-7-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  7 Apr 2025 17:11:19 +0100 David Howells wrote:
> +	aead = crypto_krb5_prepare_encryption(krb5, &TK, RXGK_CLIENT_ENC_RESPONSE, gfp);
> +	if (IS_ERR(aead))
> +		goto aead_error;
> +	gk->resp_enc = aead;
> +
> +	if (crypto_aead_blocksize(gk->resp_enc) != krb5->block_len ||
> +	    crypto_aead_authsize(gk->resp_enc) != krb5->cksum_len) {
> +		pr_notice("algo inconsistent with krb5 table %u!=%u or %u!=%u\n",
> +			  crypto_aead_blocksize(gk->resp_enc), krb5->block_len,
> +			  crypto_aead_authsize(gk->resp_enc), krb5->cksum_len);
> +		return -EINVAL;

kfree_sensitive(buffer); missing?

> +	}
> +
> +	if (service) {
> +		switch (conn->security_level) {
> +		case RXRPC_SECURITY_AUTH:
> +			shash = crypto_krb5_prepare_checksum(
> +				krb5, &TK, RXGK_SERVER_MIC_PACKET, gfp);
> +			if (IS_ERR(shash))
> +				goto hash_error;
-- 
pw-bot: cr
