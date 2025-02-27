Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FB2156230
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 03:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740626174; cv=none; b=hqOnWTNd5huHXCzFusJezHI5mcoWyjm2ZIL/yQ82tvYPvCSa7i/ox6ktP2MTP8PS4KffqBAjw01LTUWW/hRIwNEeIpcz0S5nb8MElxKR0kdKpgi9flL44pdjAOA5th1DDwPAyrmgpAiGU0l4BWrTizb1QKahvQaR7zh5eKiMZGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740626174; c=relaxed/simple;
	bh=OUUTBlLgs8hhDhpQbI48kwB0jsY/hV5TLtbolSdDQu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZi6k7DgRkQDgai4Zf2LFcwHKDKxLEbP/QK9WpYDaUxPZx5KvyOJ7iOIt1dS0DRDKYzea9+Z/XQK1h5wwnLqKC77PlCy0MQgQrXR+osEWKto/GKxa+xsQ7949hBrmCoJcUB3fQg2FwdFKwmY1esa+a8HdTv4bmemG9azzSL6VQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gvrtNv6q; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6rKRC4O/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tqVz8+PW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=u8SGqIMM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gvrtNv6q";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6rKRC4O/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tqVz8+PW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="u8SGqIMM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 954381F455;
	Thu, 27 Feb 2025 03:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1740626170;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+wUah66yWGlGNYhoY5BIf5XArhw0tYdOj4NduOe8c5A=;
	b=gvrtNv6qiUy7AadtKgoaq6AYD95qDW19nn4pLDbHObVaqgcBVxaZen34PkL1TCENKlXPbY
	WgpVBu2v4JjG2/yB1CFvWxPzpRze8Ngn18UUiaODO2Vo4KzyVgewLIfYT+jjsDVFRaMQOZ
	4DpwI9ekElaY8QKE79yB6VVzS4Tw5Qg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1740626170;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+wUah66yWGlGNYhoY5BIf5XArhw0tYdOj4NduOe8c5A=;
	b=6rKRC4O//ouIx1MvZ7JnhCkzZtMIpyz4I5hRj0JEF9ULuaCS8TKnEUlVv76aa1FIef+Gbd
	P+k/3GTusb/aANCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1740626168;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+wUah66yWGlGNYhoY5BIf5XArhw0tYdOj4NduOe8c5A=;
	b=tqVz8+PW0b1B3e1Qgvge1SGwB4cuy0iiclLNTh42GTDEukdKjHErvsMFP9wk8hYR+LMtOp
	zgCz0R6RkWzvq6tPCNmVp1RlF6rznAEsDp+rVihQ099zb3w01rP6e/UU9Xz7RZG47DbB6s
	KzuOfGXuGxXTp8ZLxN+kYQ9CTr27NAs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1740626168;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+wUah66yWGlGNYhoY5BIf5XArhw0tYdOj4NduOe8c5A=;
	b=u8SGqIMMryBCTEb7GqrMWiwcy30moNJ1cV2OKX/uSKhwy/ee4po50mB8HkFOkmoGjUhDEE
	64uoVykEE5v/7uCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6F4E313888;
	Thu, 27 Feb 2025 03:16:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id M5voGvjYv2e5KgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 27 Feb 2025 03:16:08 +0000
Date: Thu, 27 Feb 2025 04:16:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Nitin Gupta <nitingupta910@gmail.com>,
	Richard Purdie <rpurdie@openedhand.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
	Dave Rodgman <dave.rodgman@arm.com>
Subject: Re: [PATCH] lib/lzo: Avoid output overruns when compressing
Message-ID: <20250227031607.GY5777@suse.cz>
Reply-To: dsterba@suse.cz
References: <Z7rGXJSX57gEfXPw@gondor.apana.org.au>
 <20250226130037.GS5777@twin.jikos.cz>
 <Z7_D4i5yifwdXjwZ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7_D4i5yifwdXjwZ@gondor.apana.org.au>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,openedhand.com,linux-foundation.org,chromium.org,oberhumer.com,arm.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:mid];
	TO_DN_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Score: -4.00
X-Spam-Flag: NO

On Thu, Feb 27, 2025 at 09:46:10AM +0800, Herbert Xu wrote:
> On Wed, Feb 26, 2025 at 02:00:37PM +0100, David Sterba wrote:
> >
> > Does it have to check for the overruns? The worst case compression
> > result size is known and can be calculated by the formula. Using big
> 
> If the caller is using different algorithms, then yes the checks
> are essential.  Otherwise the caller would have to allocate enough
> memory not just for LZO, but for the worst-case compression length
> for *any* algorithm.  Adding a single algorithm would have the
> potential of breaking all users.
>  
> > What strikes me as alarming that you insert about 20 branches into a
> > realtime compression algorithm, where everything is basically a hot
> > path.  Branches that almost never happen, and never if the output buffer
> > is big enough.
> 
> OK, if that is a real concern then I will add a _safe version of
> LZO compression alongside the existing code.

Makes sense, thanks. The in-kernel users are OK, but the crypto API also
exports the compression so there's no guarantee it's used correctly. As
it needs changes to the LZO code itself I don't see a better way than to
have 2 versions, conveniently done by the macros as yo did.
