Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D203A17B402
	for <linux-crypto@vger.kernel.org>; Tue,  8 Jul 2025 14:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751984062; cv=none; b=e5Xg2e8NFDjI3UIqdoheX/ruGHARuCamhsO4K/RbBqagd0LNxcioWhyKNEAsCH0v4QPDDEgFU0b8LaYJkZgvN52KLty38GyqJv2oLhqzDM8CVnmBT632nODNX4IdapLUjCRwHfSUu2H5rLJf8nvJ28xxfGkp/pOK2Ykvh0RKxGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751984062; c=relaxed/simple;
	bh=cnWaXa74/QbfnSb2LTs5sZmQXHNxB435+m+y24Jr8gI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jpuwqpEh9HG2ve3u91VDXE7VCk4cuJ9UR+vMYktQPZep3AwhtL6pVvxUwFUjcjgwgNRsnDzcseUcwzYN8yXy4eDY3XErQrvZ749E2CsIWwOe82SufNeX/CBKZfgYWnu6aqwzCpJYSI9v4gtl54L92I7lVqyBh3Q4Z4TwxwaQajM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UF5z2Khn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fI5fTs/Q; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2pzrGVc4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4DpvvbG2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UF5z2Khn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fI5fTs/Q";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2pzrGVc4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4DpvvbG2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F135F2111F;
	Tue,  8 Jul 2025 14:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1751984058;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jy7+FymTvjDCy1JGk/8xikVi4a2BjKPwW51tOqW3Ebs=;
	b=UF5z2Khnttq1mw3Na6MdfoOFwxNq8t6qeI2mNA1fKrnBrWSLTj31b2ufiPfYWe3FUxTvNx
	khngmhWAdgbx8lgLOyYzL49n/8UNcHhCUNsXw/8tSIjQMgE9WHBPYAC9mGD+1vR5pcn3GW
	NipdN2gnTWHujDbtsGOIdNyuJ77oqBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1751984058;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jy7+FymTvjDCy1JGk/8xikVi4a2BjKPwW51tOqW3Ebs=;
	b=fI5fTs/Q415OWmKm2xciqk1eDdKCZqaDg5lUn1fCv89Qb6rwvGWGjk7PlC/STdGEmgAr5h
	/4wR/zJlT6zMAMDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2pzrGVc4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4DpvvbG2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1751984057;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jy7+FymTvjDCy1JGk/8xikVi4a2BjKPwW51tOqW3Ebs=;
	b=2pzrGVc4KJ33UUEttCriZCxABDkgLaW64trvzx+p+esR/BBzOlQ/oJq+JSFhJUZNZPl6M9
	hflkIEhS4SXNrUIAx1TznWSYmJqymukP54/D71IPw9SQ1MpbVM9bMjM0Vwfn3vmM+ao7DX
	t92FF+bFKzzYKz32tCDAYuRnfngDBMw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1751984057;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jy7+FymTvjDCy1JGk/8xikVi4a2BjKPwW51tOqW3Ebs=;
	b=4DpvvbG2ZkS55xtJDFB3XSSTfyWfIBGCE+5gfFdTUy+Krjfj4cCE5TTlTm99ncmBPPpdCq
	rcE7oI+XPJD3qBDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D121E13A54;
	Tue,  8 Jul 2025 14:14:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZSLHMrknbWgDRQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 08 Jul 2025 14:14:17 +0000
Date: Tue, 8 Jul 2025 16:14:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
	linux-hardening@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: zstd - replace zero-length array with flexible
 array member
Message-ID: <20250708141412.GL4453@suse.cz>
Reply-To: dsterba@suse.cz
References: <20250703171933.253654-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703171933.253654-2-thorsten.blum@linux.dev>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: F135F2111F
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.21

On Thu, Jul 03, 2025 at 07:19:34PM +0200, Thorsten Blum wrote:
> Replace the deprecated zero-length array with a modern flexible array
> member in the struct zstd_ctx.
> 
> No functional changes intended.
> 
> Link: https://github.com/KSPP/linux/issues/78
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/zstd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/zstd.c b/crypto/zstd.c
> index 657e0cf7b952..c489976c3e8b 100644
> --- a/crypto/zstd.c
> +++ b/crypto/zstd.c
> @@ -25,7 +25,7 @@ struct zstd_ctx {
>  	zstd_dctx *dctx;
>  	size_t wksp_size;
>  	zstd_parameters params;
> -	u8 wksp[0] __aligned(8);
> +	u8 wksp[] __aligned(8);

This is from patch "crypto: zstd - convert to acomp" currently as commit
f5ad93ffb54119a8dc in linux-next. Should it rather be folded there? It's
part of the crypto queue.
