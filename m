Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E7418027
	for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2025 13:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740574846; cv=none; b=VYVPtAhyVBBl0CiV7cYVR0dM/TARQsQ/uTat3aj+vXp3Ekb+ziZPjPISUbSGjzz/YWuOLR62LUvLaefufwf3fd2V4gBH1po3C4miW5nrewrAgEe8cdYOmf7QB8sW8XBiD6ba28jPINh711x/sy+Ar1M+ZMmrVxKCA1eVv+WWxP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740574846; c=relaxed/simple;
	bh=cmPP7rNbCximwGs872LU4eZs95Az1ZrkABW5lOKn0Nw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqR/sipA5KVfViRfZBhj1u9yiRDTtXhf0lQqQhEomolc6YWbw1oFzeKEfI48GbzT2JqcF3UPx68d3psOwvRqMgK4zg9WUd5Gmmhyy0VRBZ6HqjJVJ0Dn7x2kpBkoJN1hlAF3X3kgvtovyym31Rq/oOg30FlfTMTgPKF28wGDA0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IBE/FoPc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=TxLBR8Dq; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IBE/FoPc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=TxLBR8Dq; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IBE/FoPc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TxLBR8Dq";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IBE/FoPc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TxLBR8Dq"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4DD251F387;
	Wed, 26 Feb 2025 13:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1740574843;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eV1PgXSxgT3EJSl3MlbGDNhaKizGJ7yoBU7RQU64dDI=;
	b=IBE/FoPcA/gW5xjiX92g22JWyYaJXtRFRoEqx5mNIwqxpbPhTXugWbXjDE84vSnrTs4fqh
	F/DdsCJFilNE3uHs6QXFBUK1cPmBdceIxY65VA1UM837uRfW2rk1zLO4kXAjibHPio7KYs
	o04aTzo3y9TJYvcWdnSUoRWp8DjAVHk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1740574843;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eV1PgXSxgT3EJSl3MlbGDNhaKizGJ7yoBU7RQU64dDI=;
	b=TxLBR8DqEWDb6ejWvQraRoXkCq6CurcCa/9gjCfO/sMx+s6fnJfruCMOAAjOk8uF5defJ5
	3gvx3SlVZPk5p2CA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1740574843;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eV1PgXSxgT3EJSl3MlbGDNhaKizGJ7yoBU7RQU64dDI=;
	b=IBE/FoPcA/gW5xjiX92g22JWyYaJXtRFRoEqx5mNIwqxpbPhTXugWbXjDE84vSnrTs4fqh
	F/DdsCJFilNE3uHs6QXFBUK1cPmBdceIxY65VA1UM837uRfW2rk1zLO4kXAjibHPio7KYs
	o04aTzo3y9TJYvcWdnSUoRWp8DjAVHk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1740574843;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eV1PgXSxgT3EJSl3MlbGDNhaKizGJ7yoBU7RQU64dDI=;
	b=TxLBR8DqEWDb6ejWvQraRoXkCq6CurcCa/9gjCfO/sMx+s6fnJfruCMOAAjOk8uF5defJ5
	3gvx3SlVZPk5p2CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2CE051377F;
	Wed, 26 Feb 2025 13:00:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Qyq5CnsQv2ePJQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 26 Feb 2025 13:00:43 +0000
Date: Wed, 26 Feb 2025 14:00:37 +0100
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
Message-ID: <20250226130037.GS5777@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <Z7rGXJSX57gEfXPw@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7rGXJSX57gEfXPw@gondor.apana.org.au>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,openedhand.com,linux-foundation.org,chromium.org,oberhumer.com,arm.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 

On Sun, Feb 23, 2025 at 02:55:24PM +0800, Herbert Xu wrote:
> The compression code in LZO never checked for output overruns.
> Fix this by checking for end of buffer before each write.

Does it have to check for the overruns? The worst case compression
result size is known and can be calculated by the formula. Using big
enough buffer is part of the correct usage of LZO. All in-kernel users
of lzo1x_1_compress() seem to provide the target buffer calculated by
lzo1x_worst_compress(). F2FS, JFFS2, BTRFS. Not sure about ZRAM.

What strikes me as alarming that you insert about 20 branches into a
realtime compression algorithm, where everything is basically a hot
path.  Branches that almost never happen, and never if the output buffer
is big enough.

Please drop the patch.
