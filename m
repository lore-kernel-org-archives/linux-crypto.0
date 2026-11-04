Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793799103;
	b=K5a1pc6cNG86Vwh9CrE7Go/NlCk8RhR0l7kfqJAPrsy3891VhKpzOrcgkoruMf7HtbA2
	 O48Lxvrn76qVdm1FTgq0GAcqKVqyhNFXKicQ94tqIt0n2SnxPJ0emUI3CC364soyHP9aw
	 4kF2CsuUDogDuVPMcAxpL68JI+fh1yF+NR7Hab3BEllQBNLj9fA8a0vWBMLou8oppdRtN
	 6JBEf/COMRSkqgcL/OFH96v72EInmTesshkNB5pZHU+WAnx39zU0BVehqdCoWajw9sDmH
	 O3ONgeauFhdffWHLV9lfiudMNqaiJnwcZP6IYLjMJyfOH96xjZkt0jF+3D5si6eRM0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793799103;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZFpULgh/2Py9g9R1tDcInwYAR5BepHxp04BQ0WGbqvY=;
	b=Z91DaO1qVXJoax2oOPaPdmu0681sEPWKWJjQqJ3bUqNGbCQ3KaH+vHnfZlPgkEzhDfz3
	 3vvUubZlStM3wLR8hks9tWu5BiooKYSNpY2EvxSuOisU6NBK5mYIbBxwyGS3Gp+fhXTGW
	 jYtq//82zrDic2mAiCTW0Lv1jwsyQ+z4ckkP7687Ud17RyLnGWBKLUmIAz9TmJ8bEM6t8
	 uSdWmWb3q5Dtko+sdrWW3UmfVquEUE7w1e/VWsBsfSw9Lp5eIGfe9OTR6KEhqGsLbKHco
	 4SM8ma8+T2IihX+Dz7jVLbVPOhNZrLQYvKF6Q/iSN7NyK002I/csZ3lTBRRR14XlVtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rj7+x9S0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E786606A31B;
	Wed,  4 Nov 2026 13:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rj7+x9S0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7851A1F000C1;
	Wed,  4 Nov 2026 13:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793799102;
	bh=ZFpULgh/2Py9g9R1tDcInwYAR5BepHxp04BQ0WGbqvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rj7+x9S0abM0/dp+PucNKWJyGLObTVn+lErpoqoyfCMFXU1zLBfI8BDWPMad2LLJa
	 e0Yc6vmrblq/0yMnc5+e2K3ha1jyU3h7nyiCkuU4D+JzmeTakH+3SPDAQYnB/QwFS7
	 zHb5+Jou3DZeQD6opKxuxw7bUpalozNM7w/rcWk4djPT8mCmn2kPojiEOf9dYMLGW0
	 XgXTBsfYtlKjpdsQ4d9cJYn+y8v1ypauk1pEeOHQX4QLEHwaVZiOlvxupy4eGvX1d8
	 OrqqwsWO1VNAhzhqwYvQiHlu7HXjTGkmEWF4OVYok0G30Vkm7Vqzvsmm7AsV72ohIs
	 U6tDhZ6rnuD1g==
Date: Wed, 4 Nov 2026 14:31:37 +0100
From: Thorsten Blum <blum@kernel.org>
To: Manorit Chawdhry <m-chawdhry@ti.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
	Colin Ian King <colin.i.king@gmail.com>, Andrew Davis <afd@ti.com>,
	Pratham T <t-pratham@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Udit Kumar <u-kumar1@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 21/30] crypto: sa2ul - reject exhausted context IDs
Message-ID: <auszufOgf4FyKOu0@kernel.org>
References: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
 <20261104-b4-upstream-sa2ul-cleanup-v2-21-15ab90b3f9c2@ti.com>
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
In-Reply-To: <20261104-b4-upstream-sa2ul-cleanup-v2-21-15ab90b3f9c2@ti.com>

On Wed, Nov 04, 2026 at 11:14:31AM +0530, Manorit Chawdhry wrote:
> When every security-context ID is allocated, the bitmap search returns
> SA_MAX_NUM_CTX. Setting that out-of-range bit can corrupt adjacent state
> in the device structure. Reject allocation while still holding the lock
> so no bitmap or context count is changed.
> 
> Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
> Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
> ---
>  drivers/crypto/sa2ul.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
> index ead12f77ff67..2964aa44d50e 100644
> --- a/drivers/crypto/sa2ul.c
> +++ b/drivers/crypto/sa2ul.c
> @@ -717,6 +717,10 @@ static int sa_init_ctx_info(struct sa_ctx_info *ctx,
>  
>  	spin_lock(&data->scid_lock);
>  	bn = find_first_zero_bit(data->ctx_bm, SA_MAX_NUM_CTX);
> +	if (bn >= SA_MAX_NUM_CTX) {
> +		spin_unlock(&data->scid_lock);
> +		return -ENOSPC;
> +	}
>  	__set_bit(bn, data->ctx_bm);
>  	data->sc_id++;
>  	spin_unlock(&data->scid_lock);

Reviewed-by: Thorsten Blum <blum@kernel.org>
