Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4D61CAA8F;
	Sun,  2 Mar 2025 08:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740903326; cv=none; b=sMYFV8eAYGrjwHCtx9uLMb6QB7tXQDX8nYrZ7JzOkzLstftKYegisnd8Kvo6xuU7ptF3j7YyaoBKmfeUZajj4da4hivDja1QA2geRSbYDQkmICXJA2zkNHT/k6vRsDtejBP6qfGH+RyN8ZsME6/jzY1beZ495YVwmJsRyqOD+Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740903326; c=relaxed/simple;
	bh=s3sRX/Q+mq+nGNcZX7SB86RnDFJteTFeAi7vAm2UNHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TzQQFsYAGr1liXLelgsYHioc5+frKS7qxBLH4pST05/pqL0xKOE3S0HcfKeDOR7paK7N/M4948cjiJuQSYe9VjTLGKr8N3OCVklYZtYOXd9bEByN6Xv4A8TUae0Pa4a5uRmGdt9L2hTOqMwv/GFPQvROAbgLVihG8X7bHLiCTgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZnkD17QL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZnkD17QL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nmIpdUFVtLd3PR1j0aHFNKPvXLHbcD3ARTIfyEVA9h8=; b=ZnkD17QLR/U6D39HzCfs1YkfPY
	KRexbaOEyVp5rMIbw/hZxtyEUJHurVNoDNiiMz67MPm1eTDt7IpfF+dlx9VlGvtW8+EyCrUqR+dkT
	e1IlBJbZBtDhKgv8BWFL5wI64XzIoHpw64+pWW5Sv7uT4RJRFCrt5B1ryrQ65crefJHw+d+1yA9cP
	Q7joKXspzoLtJDlz6VBNJ38aE4rdkxw+l5hmwricb2q/a2pGAThs92gKuW0N0PRie2xU5Qu8zsh9/
	1JEECsRwSvkauugcEcVxvuGASGlulS5j4yuuGeLfYI4PX+ZUf6F7hHUXfztcWxBbSAEtC7mQRVWWV
	SzxS5itQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1toeTd-0030uG-00;
	Sun, 02 Mar 2025 16:15:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 02 Mar 2025 16:15:08 +0800
Date: Sun, 2 Mar 2025 16:15:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: linux@treblig.org
Cc: bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx2 - Remove unused
 otx2_cpt_print_uc_dbg_info
Message-ID: <Z8QTjOmGRAUHbg5d@gondor.apana.org.au>
References: <20250223005354.86234-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250223005354.86234-1-linux@treblig.org>

On Sun, Feb 23, 2025 at 12:53:54AM +0000, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> otx2_cpt_print_uc_dbg_info() has been unused since 2023's
> commit 82f89f1aa6ca ("crypto: octeontx2 - add devlink option to set t106
> mode")
> 
> Remove it and the get_engs_info() helper it's the only user of.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      | 99 -------------------
>  .../marvell/octeontx2/otx2_cptpf_ucode.h      |  1 -
>  2 files changed, 100 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
