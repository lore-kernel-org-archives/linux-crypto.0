Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4524D33EB09
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 11:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763033575; cv=none; b=loY0/6Rif7f24IEF1VzMdIYUqhTfFIc2m1byISCk4Ts1ghRH1Eko1tM+X2WP4molOMRzusuv6zkjSV2p9EpjB83CIaUbA3xHnZkY3Bvhdrf4J1ncsN0us76oc1MO9VXRdJRJ543RzDqD0Rifq9wmt07Mb7uGC2VsnDHFtSgOXjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763033575; c=relaxed/simple;
	bh=Mmy8HLsN+9VTkIrCOYAzOVEqpjJvJEr3CCWRr17FEf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=srpRsS5Pm6mc9RrbWslXkLbE51EpoaOSFbTjpY4HWPaXiHk+glvLcigYTG+E9kNFlEMFnGpD8WRD/WcB1s00cPKnOSeYnEukXNikuQhOnsnr96D21sgTaJ6G6q0PMj38cTjxH7sqBNUJ5BcE+GxtyQDL5jfxZtlRui+yi4OhUuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XIm7wIYq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Fb5YATRG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XIm7wIYq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Fb5YATRG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XIm7wIYq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Fb5YATRG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XIm7wIYq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Fb5YATRG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6A0041F451;
	Thu, 13 Nov 2025 11:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763033572;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zc5l5U7SdpWG8xXJCR9IManqkHn3AloOjl5uiAAiDPM=;
	b=XIm7wIYqj7OMtO+jrdioOdAavhgbd+zWnpG5ZW+9XORVP35AnyzEnwMbssUje6rqCP8T3c
	3yyCvYgBK4XwQ0kML9Qzw6D/Pu0wPMo+4Lzr7M3ieV9R3reu1XjBG+plAyroX/JhpGn451
	/mBgw/r6xgqAJ37EvbCYO4zh0eLn//c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763033572;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zc5l5U7SdpWG8xXJCR9IManqkHn3AloOjl5uiAAiDPM=;
	b=Fb5YATRGC/md0+94fjO34M2U1hw20L4+ECWFiF2pZU9OBZiUNT1XmuGt+Hq/sOiyIJ+7Zu
	9MCCebXFupO2KQCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XIm7wIYq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Fb5YATRG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763033572;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zc5l5U7SdpWG8xXJCR9IManqkHn3AloOjl5uiAAiDPM=;
	b=XIm7wIYqj7OMtO+jrdioOdAavhgbd+zWnpG5ZW+9XORVP35AnyzEnwMbssUje6rqCP8T3c
	3yyCvYgBK4XwQ0kML9Qzw6D/Pu0wPMo+4Lzr7M3ieV9R3reu1XjBG+plAyroX/JhpGn451
	/mBgw/r6xgqAJ37EvbCYO4zh0eLn//c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763033572;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zc5l5U7SdpWG8xXJCR9IManqkHn3AloOjl5uiAAiDPM=;
	b=Fb5YATRGC/md0+94fjO34M2U1hw20L4+ECWFiF2pZU9OBZiUNT1XmuGt+Hq/sOiyIJ+7Zu
	9MCCebXFupO2KQCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C22F3EA61;
	Thu, 13 Nov 2025 11:32:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NMhpEuTBFWmKcAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 13 Nov 2025 11:32:52 +0000
Date: Thu, 13 Nov 2025 12:32:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: zstd - Annotate struct zstd_ctx with __counted_by
Message-ID: <20251113113251.GO13846@suse.cz>
Reply-To: dsterba@suse.cz
References: <20251108120740.149799-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251108120740.149799-2-thorsten.blum@linux.dev>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 6A0041F451
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -4.21

On Sat, Nov 08, 2025 at 01:07:40PM +0100, Thorsten Blum wrote:
> Add the __counted_by() compiler attribute to the flexible array member
> 'wksp' to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE.
> 
> Use struct_size(), which provides additional compile-time checks for
> structures with flexible array members (e.g., __must_be_array()), for
> the allocation size for a new 'zstd_ctx' while we're at it.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: David Sterba <dsterba@suse.com>

As this is crypto/zstd.c there's no need to sync with upstream zstd code
so it can go via the crypto tree.
