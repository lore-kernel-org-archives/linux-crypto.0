Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328EC3BB44;
	Sun,  8 Feb 2026 13:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770558102; cv=none; b=F7ovGm/ndocLeaTJxJVOc2rUG91XDl6UKcYDlC+RtnzzcR5GruC56kPp9gPaCFi6dr9L/A6aPHyL+ZO3/NU1WdvhzYC81vPGjWM5dhyxtU+1+Y1N+fahcACawW5/T+dFZVyHbqxtcH12twMoWte5UCURJt2SE3Khrye0qfhkcWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770558102; c=relaxed/simple;
	bh=ti2HHlDkYkoqcOXYBYZAbQ0uCHRQUrB0P4f6dSI4DGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lq1+hKesbzXD7KKhgeYiV9VdVkjCYwDTxw904oClqLbwPPqbu4fPuTX+as7xa2qGZRkzXA0yWkhIvxyF/95fiprKICE4QFRm3eglf5I4DtKyUr5VMsYK5i7RejSSzAVIr4Qnh1TY+JbOYmVDJ39BsafuJ6LjjEueUih1PtV4qJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FaxVKW9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FaxVKW9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20385C4CEF7;
	Sun,  8 Feb 2026 13:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770558101;
	bh=ti2HHlDkYkoqcOXYBYZAbQ0uCHRQUrB0P4f6dSI4DGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FaxVKW9XildzEYhzXO4yso/ukdgofIpSW35hErjupkJVFoqCSiZAstO08jo9rqzIJ
	 zgHuep0wgr0K3yrpVbIA9mgu94N9RBYeGLNzG9I0ygCtwmWmZG90TH3Fah3/Hl7h9w
	 b9jTflHL/+aJHgZ5ARU1lLujhvwNB/7x5ACid88KeJFQOFwjIVibvl8MisMw72rlyN
	 FCeGru/94Emr4ICvVe0j9gLUKbB7Dqb4IGQf6aOW05GDftXW/hfurmqDGnOICuSUrn
	 iZ40yqkNDOFVCpJ/ZSYuy6BX0ifVjg4z/pCoAlJjVz2wwYKabaE3KzIATtkkbmkfhq
	 cRI4wrSLeBH1w==
Date: Sun, 8 Feb 2026 15:41:37 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@cloudflare.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	keyrings@vger.kernel.org, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v16 8/7] pkcs7: Change a pr_warn() to pr_warn_once()
Message-ID: <aYiSkRHz0iCiwaW4@kernel.org>
References: <20260202170216.2467036-1-dhowells@redhat.com>
 <2892236.1770306426@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2892236.1770306426@warthog.procyon.org.uk>

On Thu, Feb 05, 2026 at 03:47:06PM +0000, David Howells wrote:
> Only display the "PKCS7: Waived invalid module sig (has authattrs)" once.
> 
> Suggested-by: Lenny Szubowicz <lszubowi@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Tested-by: Lenny Szubowicz <lszubowi@redhat.com>
> cc: Lukas Wunner <lukas@wunner.de>
> cc: Ignat Korchagin <ignat@cloudflare.com>
> cc: Jarkko Sakkinen <jarkko@kernel.org>
> cc: Stephan Mueller <smueller@chronox.de>
> cc: Eric Biggers <ebiggers@kernel.org>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: keyrings@vger.kernel.org
> cc: linux-crypto@vger.kernel.org
> ---
>  crypto/asymmetric_keys/pkcs7_verify.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
> index 519eecfe6778..474e2c1ae21b 100644
> --- a/crypto/asymmetric_keys/pkcs7_verify.c
> +++ b/crypto/asymmetric_keys/pkcs7_verify.c
> @@ -427,7 +427,7 @@ int pkcs7_verify(struct pkcs7_message *pkcs7,
>  		if (pkcs7->have_authattrs) {
>  #ifdef CONFIG_PKCS7_WAIVE_AUTHATTRS_REJECTION_FOR_MLDSA
>  			if (pkcs7->authattrs_rej_waivable) {
> -				pr_warn("Waived invalid module sig (has authattrs)\n");
> +				pr_warn_once("Waived invalid module sig (has authattrs)\n");
>  				break;
>  			}
>  #endif
> 

Could be also ratelimited but I guess here once is the right call:

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
