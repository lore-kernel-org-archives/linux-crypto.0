Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B946913792B
	for <linux-crypto@vger.kernel.org>; Sat, 26 Oct 2024 06:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729925624; cv=none; b=pnvo8OphnKR9RBzmT9Ji6QbtHT8T/QepKVVQEfr5cIcW6j2sYcKzLlJTjUHR69D+oTKG3NER6pb7+PxMFZ32TUPsKi5r1jvv0Ww/c4zYFXXUW6tg0iw95PW6Da+EVcUtIff1m7xVseNlSyi7gvhFGv+3I1XI/Hz7f59U88hWtl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729925624; c=relaxed/simple;
	bh=8sprvOdY8ecDQuYGTmZyo5kYQH6JxayvNZ0LmDuWQBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qx1zBgJiEKzbjAOejqguRnZTCw/T+0JJXMmQ+dHn8TvlwsIDgTavEDFl2caGuJDlMRj1I1YyxwdG5RUcFAYcRq+Bgr2aDOC5TQJz4cml77tjPdY6BUKsxLh0w75lBMzEZFuGWpqd/fnkhrzTx/yiEIdVuVaY9xJQsastF17S8q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qKtTVFhj; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qKtTVFhj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Uu2ysrDh5aycUV+KUoszZU/8Y6r8pscm1D+IOKwwD48=; b=qKtTVFhj583Ti2DrGJE3S4ernL
	qh9Z8omN54TxfkhQeqNG7txgLoDfYLpbiBGQpqQaStOuS3WLgnWIgwwRdVachyYYVuIuPPTfTkgYY
	9PIjK8/sw+7bZCbHPw3xu6MYd8PtavG1CK6xziBSgXs2d/hqDc1EqB5xgW+0ODgPcXHS2eoJ24IYl
	MkyeCBnDDDpuWVqjS2+XwpkBJ0wgxOfJkxT/MbmvldK3FCSnVvGhT3b90DtqjJ/DnsUxIRMnp9Tu0
	EktpDMUCJfpfQ55e5R6ycm0DfyRPYm/fkftq87/Jv/NyKeKAiRAGDlw0CbdnMPIdLt63gaI0pZ1gW
	CdvHA+ew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4afx-00CFsA-1J;
	Sat, 26 Oct 2024 14:53:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 14:53:29 +0800
Date: Sat, 26 Oct 2024 14:53:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH cryptodev-2.6] crypto: sig - Fix oops on
 KEYCTL_PKEY_QUERY for RSA keys
Message-ID: <ZxyR6UBAjXEpkYOI@gondor.apana.org.au>
References: <ff7a28cddfc28e7a3fb8292c680510f35ec54391.1728898147.git.lukas@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff7a28cddfc28e7a3fb8292c680510f35ec54391.1728898147.git.lukas@wunner.de>

On Mon, Oct 14, 2024 at 11:43:01AM +0200, Lukas Wunner wrote:
> Commit a2471684dae2 ("crypto: ecdsa - Move X9.62 signature size
> calculation into template") introduced ->max_size() and ->digest_size()
> callbacks to struct sig_alg.  They return an algorithm's maximum
> signature size and digest size, respectively.
> 
> For algorithms which lack these callbacks, crypto_register_sig() was
> amended to use the ->key_size() callback instead.
> 
> However the commit neglected to also amend sig_register_instance().
> As a result, the ->max_size() and ->digest_size() callbacks remain NULL
> pointers if instances do not define them.  A KEYCTL_PKEY_QUERY system
> call results in an oops for such instances:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   Call Trace:
>   software_key_query+0x169/0x370
>   query_asymmetric_key+0x67/0x90
>   keyctl_pkey_query+0x86/0x120
>   __do_sys_keyctl+0x428/0x480
>   do_syscall_64+0x4b/0x110
> 
> The only instances affected by this are "pkcs1(rsa, ...)".
> 
> Fix by moving the callback checks from crypto_register_sig() to
> sig_prepare_alg(), which is also invoked by sig_register_instance().
> Change the return type of sig_prepare_alg() from void to int to be able
> to return errors.  This matches other algorithm types, see e.g.
> aead_prepare_alg() or ahash_prepare_alg().
> 
> Fixes: a2471684dae2 ("crypto: ecdsa - Move X9.62 signature size calculation into template")
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  crypto/sig.c | 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
