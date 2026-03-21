Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086DE21E087;
	Sat, 21 Mar 2026 06:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774072822; cv=none; b=pJx1Vpd8RXEsK+VcFpqrSmcE2X3SZErk/GJJpOqIBq5wJcWUsHZJRxN6F5H6/yfFx0DeQNtR7b/dzdyQNR+ZRP3dP9mjd3oFJ3m2iFku83Dy5fzdVrdUMfjn0zP9bFrEFU0YyYOVJT8nOASWltYwg6zyjf2XJogdDoe6tXtE0DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774072822; c=relaxed/simple;
	bh=21V6TWpo4y4SXceWpzfArOakhMQOtwcHthaE43SB59Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DtcCEhGzdqgNirQ26fZtDDNUzusWnUNMG0dyjcK8Drk6IaofLNM8cVcNeqpLB+L2xQGRpD5y9y1aR0WCpjb/lqVEq/+U/gTsUDW5D8SsyzAtuSbVDLtUcb5vtyw7E1vkWlbFQYCgxWoYHBVUSj0HV0wDTZbtUUp9uWMIEtDx7mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YEGguSrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YEGguSrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69199C19421;
	Sat, 21 Mar 2026 06:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774072821;
	bh=21V6TWpo4y4SXceWpzfArOakhMQOtwcHthaE43SB59Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YEGguSrp8SnQ0ENcj57IFd905OoMpA4h/Tv1g6D607oz7IO/jabb2b/Otvj3/xz+a
	 t5fsR0YvzbdjC6a6NFxZscLgvbTtTPDTeN3DTJGujCD1wAr4sci5nZSuyQrEF0BeQc
	 YjRi9CXXRJHV/xHuyKw28ta1PczQ9IStATeYMt43Za8dfUohOBTpZP9vbSlweeTNuU
	 ubf0GDgwVS56zC0UNJlowrSGpUjLnfqxYMI5I3K77qgBFkQkNIx6bieDL2g5JDOENT
	 IsUBqNQW1ZjkK48/AtKNXKpze4O1IPyngb7OU7oZzt79DnHe3VgU6nr7GmVZtunt7m
	 /lzy+77q0E0zQ==
Date: Fri, 20 Mar 2026 22:59:17 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: sha1: Explicitly specify alignment of
 sha1_ctx::buf
Message-ID: <20260321055917.GA2346@sol>
References: <20260320231403.47323-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320231403.47323-1-ebiggers@kernel.org>

On Fri, Mar 20, 2026 at 04:14:03PM -0700, Eric Biggers wrote:
> __sha1_final() writes a __be64 to &ctx->buf[56] using a plain write.
> That assumes that the alignment of buf is at least that of __be64.  It
> is, since it immediately follows a u64 field.  However, to make this
> assumption explicit it's best to specify the field alignment explicitly
> too, like what is done in the corresponding SHA-2 and MD5 structs.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  include/crypto/sha1.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/crypto/sha1.h b/include/crypto/sha1.h
> index 4d973e016cd6..560ed4fd1703 100644
> --- a/include/crypto/sha1.h
> +++ b/include/crypto/sha1.h
> @@ -38,11 +38,11 @@ struct sha1_block_state {
>   * @buf: partial block buffer; bytecount % SHA1_BLOCK_SIZE bytes are valid
>   */
>  struct sha1_ctx {
>  	struct sha1_block_state state;
>  	u64 bytecount;
> -	u8 buf[SHA1_BLOCK_SIZE];
> +	u8 buf[SHA1_BLOCK_SIZE] __aligned(__alignof__(__be64));
>  };

Surprisingly, this patch actually breaks the build on 32-bit x86.  The
static assertions in crypto/sha1.c that verify the consistency of
'struct sha1_ctx' and 'struct sha1_state' start failing.  gcc puts
bytecount and buf at offsets 20 and 28 in the struct.  I.e., it puts the
u64 field on only a 4-byte boundary.  However, __alignof__(__be64)
actually returns 8, causing the offset of buf to change from 28 to 32.
(The result is the same if __alignof__(u64) is used instead.)

Apparently __alignof__ returns the "preferred alignment".  But what we
want is "minimum alignment".  Which is C11's _Alignof, which was
deprecated in C23 and replaced with "alignof".  Sigh.

Probably best to just keep this as-is until we can get drivers/crypto/
migrated off of 'struct sha1_state' and remove that.

- Eric
