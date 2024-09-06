Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855BC139D03;
	Fri,  6 Sep 2024 07:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725606459; cv=none; b=nSMhytovIwj59SsNlf4XqlYfnYoSIZVQQgJDt9HeptRZdLL/WabPPfaOvoPdjxv9RE6AN/YdAalCSw3Lq7EcWXh7tygG9UalOadOzHrgUq1vg5m/c7zmSyggK7YC9JHXP5JJDBO/Mbd03hcQTtgTaIfN//3kziyiNMNFg6ixgF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725606459; c=relaxed/simple;
	bh=/AeH+2h6DGdC5mAVhh8fKp4h265aWOMF9j0clSotbiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=trEh4kmQrl794VJI3sxXNQ6g7uEV1a/3HwKTNq0uYw746GIgcqaoU28sO6HWG7MqynAIIGiqyMYyEU6qRAdSWAjUtqE1tvCsG19RkPu6oTJqu9CQeoFriQGqlfz+rjKIXX+M4Vf1UsGEjNgOALDzxUq2s1PGA9WrM0wp1HSxHvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fEJ7ERbI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fEJ7ERbI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=P16dne/Mcc4NZ5OYXUWn3vwk1ZjN/yArpaZkdtXKUAE=; b=fEJ7ERbI0XSEouQb1vYiHlJm5M
	VzXLfXUALbZs85TXvC7Ul0p32bKOj++oQOujmkSyMftsgezHdfTfFw679kHI43vL9dLcusKlsLlLj
	Om0D7zyGzza+/BPBYJ2f7mbToec4m1Uc5teN565gGJPEQka2tCSBL6FzVmdXhlwaqDnnOF3gmFYrI
	Q4wgZo+TxgSWyq+NCShJYmkyx+a4AmuRmoCeKN8IonZqjNbMsuWcbfY5iJsQWlxpcElgyYpRT8ZMt
	hvIJeEr3FwXMovUTaT0gUWdROgbwkqYhHbC+x09S6IXf5JY/gGPoDxA43FMAUQ1uVibZIuOyxrPBR
	ud8bHNfg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1smSu7-000WVU-2z;
	Fri, 06 Sep 2024 15:07:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Sep 2024 15:07:25 +0800
Date: Fri, 6 Sep 2024 15:07:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Amit Shah <amit@kernel.org>
Cc: ashish.kalra@amd.com, thomas.lendacky@amd.com, bp@alien8.de,
	john.allen@amd.com, davem@davemloft.net, michael.roth@amd.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	amit.shah@amd.com
Subject: Re: [PATCH] crypto: ccp: do not request interrupt on cmd completion
 when irqs disabled
Message-ID: <ZtqqLSNSYpsD5Cgy@gondor.apana.org.au>
References: <20240829102007.34355-1-amit@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829102007.34355-1-amit@kernel.org>

On Thu, Aug 29, 2024 at 12:20:07PM +0200, Amit Shah wrote:
> From: Amit Shah <amit.shah@amd.com>
> 
> While sending a command to the PSP, we always requested an interrupt
> from the PSP after command completion.  This worked for most cases.  For
> the special case of irqs being disabled -- e.g. when running within
> crashdump or kexec contexts, we should not set the SEV_CMDRESP_IOC flag,
> so the PSP knows to not attempt interrupt delivery.
> 
> Fixes: 8ef979584ea8 ("crypto: ccp: Add panic notifier for SEV/SNP firmware shutdown on kdump")
> 
> Based-on-patch-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Amit Shah <amit.shah@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
