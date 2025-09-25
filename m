Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA4F1114;
	Thu, 25 Sep 2025 12:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758801646; cv=none; b=YGwdgbNqxLVWPrW5+9RQbjq0tjNUM9Zunw3gGSADvMjBn7xpQf9enfbBcY80D1RwCZ4kgxhx48TlNtaN2wXgNFc5b9leYDxLN2Ie13DlR4DNFicwQGSTWibZ4g+IvIT1vauuzZ6HhFgtAMzLD/BXa2oZZiCgWT2qP0Zu6faIPLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758801646; c=relaxed/simple;
	bh=+YAB5I/onFJFzUFrF0bfZccZfgP5koeJO9saION6R6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYSXLDpx/8MfSEbrmSXRDFVPJn86lk1fSLRcvP2yGK5sTfayhRJmnTxpN8GjCyH7zOMKHQNQ2ZkZmcVuUrF0bgsk7+56Bx1ELdi94cXYE65Q3gyUHPqfSj8McdZ7rBJTYXgj8Bg4YFP9EQBBjOhyZQRcTRvHHHArGcj+ep+TVJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iXSTIoOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iXSTIoOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE25C4CEF0;
	Thu, 25 Sep 2025 12:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758801645;
	bh=+YAB5I/onFJFzUFrF0bfZccZfgP5koeJO9saION6R6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iXSTIoOFGhJWqlDKp/2cXjv/b6GXJ07IYgwYeHWSyhZZgI1Y2TwzisczlhvtRvPB2
	 Fj2s4lN1QuUpvaCh62L/hCXrr265mGZsiYa6m9yhWKbKbyqAIWVlriUQVdcXAr8Qr9
	 ErI2oie40wlw564bhE/U83HpteZSmxV/qeFtSeJfyitzJkEpQ62Ir8HYAS3og/KxGp
	 eo5RLRwkn+hH8ZxbY93r2uhBcZfmgGcshezWy4hRCU5Hui/Fhc4nxU9QG23bdhjwzx
	 weqdST9J6KvxkBLd+lHIZowLygEy+yESOTKGyjaRvRa5ehFakrjkhPPkDWVgAJ3O1z
	 zTX+gos6CUPBQ==
Date: Thu, 25 Sep 2025 13:00:41 +0100
From: Lee Jones <lee@kernel.org>
To: Lukas Bulwahn <lbulwahn@redhat.com>
Cc: Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>, linux-crypto@vger.kernel.org,
	loongarch@lists.linux.dev, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: Re: [PATCH] MAINTAINERS: adjust file entry in LOONGSON SECURITY
 ENGINE DRIVERS
Message-ID: <20250925120041.GJ8757@google.com>
References: <20250912074638.109070-1-lukas.bulwahn@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250912074638.109070-1-lukas.bulwahn@redhat.com>

On Fri, 12 Sep 2025, Lukas Bulwahn wrote:

> From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
> 
> Commit 5c83b07df9c5 ("tpm: Add a driver for Loongson TPM device") adds a
> driver at drivers/char/tpm/tpm_loongson.c, and commit 74fddd5fbab8
> ("MAINTAINERS: Add entry for Loongson Security Engine drivers") adds a new
> section LOONGSON SECURITY ENGINE DRIVERS intending to refer to that driver.
> It however adds the entry drivers/char/tpm_loongson.c; note that it misses
> the tpm subdirectory.
> 
> Adjust the entry to refer to the intended file.
> 
> Fixes: 74fddd5fbab8 ("MAINTAINERS: Add entry for Loongson Security Engine drivers")
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks

-- 
Lee Jones [李琼斯]
