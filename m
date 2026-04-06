Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063D938759D;
	Mon,  6 Apr 2026 16:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775494508; cv=none; b=EHM4UIWclohcYnwBJ9icPmjQl3CCAJzjCKQLEKVkaK97aRmEJClbtbx4rDMh6CcbFGleq2Hy5ia1P2l7rf9blmhTvwA5+khEsYIY95OfLdx00Sma+9U5Fd2hY73FLArqiq8FPOv1p8cdJf89Ku6cLKZnw+5Hu0lvVaiLmK9HgVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775494508; c=relaxed/simple;
	bh=YPa/uyVI/zqPFLBKVoFkDJwBwijtEHRHs03s3tfOZ/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j6W92YKfkwNoOr/kNCfh1P1pQDwSYwx8Wxjg+dUUFRHnFlvmAyXtv2wjCp6TmhCYzzShbZPuIpd+QJVQxzmZ1tCdwz+xk4yDQjwTkBjkcRnm8wZtIWrepBUtL4tB4QhE8OXQtNBPfCyn63hg5jA6MDNbSUUsl+qd6euoR30E0DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RPSu1G8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RPSu1G8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4343BC4CEF7;
	Mon,  6 Apr 2026 16:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775494507;
	bh=YPa/uyVI/zqPFLBKVoFkDJwBwijtEHRHs03s3tfOZ/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RPSu1G8yBRgJShEMiu/+j9upL2j+a0NY3G8eULqcdFSnVU+teFCtNYnqjbCFLkUj2
	 eMRppvBNylHBFD+njmyliTADdLua7U7arTjjkYbfU5TQW7Mivuv1/2ExjlAh/PcXnS
	 IZpfs1K7j+enuMZ8dsjdg3XlSa5ci/cbq+biGIiHagNSLKjOjq1TUzkfkYc4Uduqkz
	 fzgqWC69jt8FIqUNX6fqQcCcYKUdEu1K8Hrjux3iTMXDW/Y/MsmDvz1vSfaTdBlsp3
	 Bly1FwKmjXyKXPYDXGj4I7vNjBvQCNlzk0Da+qPhwU9ytoBLDupG4J0bwENGxvpBdI
	 /qHBboGghIp3g==
Date: Mon, 6 Apr 2026 09:53:50 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Stefan Berger <stefanb@linux.ibm.com>
Cc: linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, zohar@linux.ibm.com,
	roberto.sassu@huawei.com, David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/3] crypto: public_key: Remove check for valid hash_algo
 for ML-DSA keys
Message-ID: <20260406165350.GD2971@sol>
References: <20260405231224.4008298-1-stefanb@linux.ibm.com>
 <20260405231224.4008298-2-stefanb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405231224.4008298-2-stefanb@linux.ibm.com>

On Sun, Apr 05, 2026 at 07:12:22PM -0400, Stefan Berger wrote:
> Remove the check for the hash_algo since ML-DSA is only used in pure mode
> and there is no relevance of a hash_algo for the input data.
> 
> Cc: David Howells <dhowells@redhat.com>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Ignat Korchagin <ignat@linux.win>
> Cc: keyrings@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
> ---
>  crypto/asymmetric_keys/public_key.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index 09a0b83d5d77..df6918a77ab8 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -147,11 +147,6 @@ software_key_determine_akcipher(const struct public_key *pkey,
>  		   strcmp(pkey->pkey_algo, "mldsa87") == 0) {
>  		if (strcmp(encoding, "raw") != 0)
>  			return -EINVAL;
> -		if (!hash_algo)
> -			return -EINVAL;
> -		if (strcmp(hash_algo, "none") != 0 &&
> -		    strcmp(hash_algo, "sha512") != 0)
> -			return -EINVAL;

Does this broaden which hash algorithms are accepted for CMS signatures
that use ML-DSA and contain signed attributes?

- Eric
