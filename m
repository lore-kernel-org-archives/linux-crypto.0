Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4F525F984
	for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740751335; cv=none; b=IaGe/Mqhc1yui1q1A2GyhCDiZ9tmurKgSPhaONGXqrZ50kQqglMSbtkQg1cWnc6/8xrx62vr6IzWVKqUMbUXvVvMiDiNUvxuW7bACD0FPZXhL6F0h3aaAnPP5DhPqp1a54wrQ4vOj7VU7GIcTwJwAcPmF2Z7Rq+PEzJ4JYBLbSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740751335; c=relaxed/simple;
	bh=60f2tf8+Q61ODb9EAamNDtZStEDwNFI/8mtjmT4G+vA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i5a8k2DDDMdh1RxstRR7JC8cOU+dBjYjgtxR9k+S12jCEkbMv3dcDJgWEwC31JJGOD7+3N9b57lNe0Y9Aij4qpl9cGjCd4eF3/DpfaRkDTUhom8GLapgbojQEA3WE+SjJFpUchgKxUSHJ4E9KkDA5o/X7L1cNE6LypohCYM+VHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Lc/99VkK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/MdT/ZA7; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Lc/99VkK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/MdT/ZA7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Lc/99VkK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/MdT/ZA7";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Lc/99VkK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/MdT/ZA7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8AC6A2115A;
	Fri, 28 Feb 2025 14:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1740751331;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ieFVkh81wzHwy4yD1oAp6FeseWp9jqBiLhRYlkqkKlg=;
	b=Lc/99VkK7P5nqTnylAC2eYLlISSWY+Bh95K7CjxIz2ur1OIjEX5hFq5Yp0/5lidze8R+VY
	MZMWe2NwhgZSlJx/UnolyHeufrGCPsbEOgY7k2d6uZcEgiiT52gkBzwJywb5EYaJG++Uq7
	5695VzdkruGTAhuHkgxslBhRqHaBKuk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1740751331;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ieFVkh81wzHwy4yD1oAp6FeseWp9jqBiLhRYlkqkKlg=;
	b=/MdT/ZA704IGk/ag5YsKVhB5+sqBcnbxaIMbS77r6vQhO4STxQs0NoE3CYAdWEfDBMZL+L
	N0WECa9W9tPD05DQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Lc/99VkK";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/MdT/ZA7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1740751331;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ieFVkh81wzHwy4yD1oAp6FeseWp9jqBiLhRYlkqkKlg=;
	b=Lc/99VkK7P5nqTnylAC2eYLlISSWY+Bh95K7CjxIz2ur1OIjEX5hFq5Yp0/5lidze8R+VY
	MZMWe2NwhgZSlJx/UnolyHeufrGCPsbEOgY7k2d6uZcEgiiT52gkBzwJywb5EYaJG++Uq7
	5695VzdkruGTAhuHkgxslBhRqHaBKuk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1740751331;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ieFVkh81wzHwy4yD1oAp6FeseWp9jqBiLhRYlkqkKlg=;
	b=/MdT/ZA704IGk/ag5YsKVhB5+sqBcnbxaIMbS77r6vQhO4STxQs0NoE3CYAdWEfDBMZL+L
	N0WECa9W9tPD05DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 64235137AC;
	Fri, 28 Feb 2025 14:02:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3cA0GOPBwWe6LAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 28 Feb 2025 14:02:11 +0000
Date: Fri, 28 Feb 2025 15:02:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Nitin Gupta <nitingupta910@gmail.com>,
	Richard Purdie <rpurdie@openedhand.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
	Dave Rodgman <dave.rodgman@arm.com>
Subject: Re: [PATCH] lib/lzo: Avoid output overruns when compressing
Message-ID: <20250228140210.GI5777@suse.cz>
Reply-To: dsterba@suse.cz
References: <Z7rGXJSX57gEfXPw@gondor.apana.org.au>
 <20250226130037.GS5777@twin.jikos.cz>
 <qahmi4ozfatd4q5h4qiykinucdry6jcbee6eg4rzelyge2zmlg@norwskwechx6>
 <CAMj1kXFKBynkfBFmQ1tbgZ0fTOP0pg5453NFGxVGvmePrKssug@mail.gmail.com>
 <bnvklfvsoh34663ttsboec6aidxmu2cib32okb4vyi2iitdqme@lbvte54od7gi>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bnvklfvsoh34663ttsboec6aidxmu2cib32okb4vyi2iitdqme@lbvte54od7gi>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Queue-Id: 8AC6A2115A
X-Spam-Score: -4.21
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gondor.apana.org.au,vger.kernel.org,gmail.com,openedhand.com,linux-foundation.org,oberhumer.com,arm.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:mid,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Fri, Feb 28, 2025 at 10:55:35PM +0900, Sergey Senozhatsky wrote:
> On (25/02/28 13:43), Ard Biesheuvel wrote:
> > On Fri, 28 Feb 2025 at 06:24, Sergey Senozhatsky
> > <senozhatsky@chromium.org> wrote:
> > >
> > > On (25/02/26 14:00), David Sterba wrote:
> > > > What strikes me as alarming that you insert about 20 branches into a
> > > > realtime compression algorithm, where everything is basically a hot
> > > > path.  Branches that almost never happen, and never if the output buffer
> > > > is big enough.
> > > >
> > > > Please drop the patch.
> > >
> > > David, just for educational purposes, there's only safe variant of lzo
> > > decompression, which seems to be doing a lot of NEED_OP (HAVE_OP) adding
> > > branches and so on, basically what Herbert is adding to the compression
> > > path.  So my question is - why NEED_OP (if (!HAVE_OP(x)) goto output_overrun)
> > > is a no go for compression, but appears to be fine for decompression?
> > >
> > 
> > Because compression has a bounded worst case (compressing data with
> > LZO can actually increase the size but only by a limited amount),
> > whereas decompressing a small input could produce gigabytes of output.
> 
> One can argue that sometimes we know the upper bound.  E.g. zswap
> and zram always compress physical pages, so decompression cannot
> result in a bigger (than the original physical page) data.

So for ZRAM it would make sense to have "unsafe" decompression as the
data never leave the kernel space and cannot be tampered with from the
outside, unlike what filesystem deals with. This can gain some speed up.
