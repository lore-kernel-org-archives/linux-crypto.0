Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6292B3F410D;
	Wed, 23 Sep 2026 08:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153238; cv=none; b=phDxTe+np0J9C7/OldGJWLrleZ7gkrrhIe2Xx3QdjiUuQdSZJGYcm77MCmNDO2TG6N8iPbzf+NKmPSCP6FjZGVzYZ96iDcE9OctVfGPR4EaSuo8tAUB+ATyp2bpIHZe5AtdgI1ISXnTlLbyGKq2yqIFM0hHeuOJZ7SbZ3t2vHxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153238; c=relaxed/simple;
	bh=3s/8YWIuPZZVAv66EYuvmzEqcC0JsMgC+mbmF2ahcLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CZ0bkV5yPEIXgXaSBVPu15qHToyh6EAD0oF7FTSLiuxpgMxFTpxx41OINf0dUkvg5AioDlEZ4tqvnTvGNZuUQR5fTxUBeVGbOGbPlBX2s0caoII5gCImIYtFisyxqX3YcOJG/69bEDu9QcQKqqSV3RGjyZgCY7UmnR1jkCSHjFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=sReAEVXv; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="sReAEVXv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=nDKB9shIg39fOmcc3YueSLfTIeDSyLVKCNQEfui/Ees=; 
	b=sReAEVXvTNhTP2EUHbcWqT6VEad2xQ3eXVUoskpjoC8qt1k0Qic9oX9wtdHsjvGpxEPdoMbHx9D
	pW9FzgG1nJUNz3VyDcThAkKH9T/+LqZXBpO3XDOVmlDL51bzojYmKuf2q8UL19pJBjTrFIC+FoD0L
	vk2I0HcFmG+hbQi+AelQ8E69dsQ3TRlvzP4f0+uvkdPIpslQ2tMpw3rvzr/fKX0m+KgtFv1G711id
	mfhgpRFAGIfnvQ1/8eV9y/A6D8/jjfluCAMm47F0FC47pjyKqxY3LrRbi65j8XvACQkdTh0zVEMKF
	XUnORIMCiLf0QUbCoXggV55qmudxeQHuXxoA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9Icv-0000000Gy92-3fQG;
	Wed, 23 Sep 2026 16:46:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:46:53 +1000
Date: Wed, 23 Sep 2026 18:46:53 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: dhowells@redhat.com, lukas@wunner.de, ignat@linux.win,
	davem@davemloft.net, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pkcs7: Check all signers before waiving authattrs
 rejection
Message-ID: <arOR_dQ8QEWbOCDG@gondor.apana.org.au>
References: <20260822212703.1019792-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260822212703.1019792-2-Jeremy.Jean@oss.cyber.gouv.fr>

On Sat, Aug 22, 2026 at 09:27:04PM +0000, Jérémy Jean wrote:
> pkcs7_check_authattrs() only looks at the first SignerInfo when deciding
> whether rejection of authenticated attributes may be waived.  For the
> remaining signers it checks only that authenticated attributes are either
> present on all signers or absent from all of them.
> 
> This means an unmatched ML-DSA signer can be placed first, followed by a
> trusted RSA, ECDSA, or ECRDSA signer.  Verification skips the unmatched
> signature and accepts the later trusted signer.  The first signer still
> leaves the waiver enabled for the whole message, so the non-ML-DSA signer
> can use an exception intended only for ML-DSA.
> 
> Check each SignerInfo's public-key algorithm before leaving the waiver
> enabled.
> 
> Fixes: 91db696adea4 ("pkcs7: Allow authenticatedAttributes for ML-DSA")
> Assisted-by: Codex:gpt-5
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  crypto/asymmetric_keys/pkcs7_parser.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
