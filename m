Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962694A3F09;
	Mon, 31 Aug 2026 17:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788196121; cv=none; b=K6UDvddqzlLwJiFXtuRPV6gbXMSpSNYmQI/pkhH5Z1MZIE7BMispwDLZZ/3/v+u7RcGZlHkcNUynGa95wz83ZvWu2dEz481S4gGqPRDBQZ5wingz/fHnzjOuSFJMv9yrLBM1UIAK7mkKPpqy96TwjsSGpEt7wDbJs8ZNt4+6CW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788196121; c=relaxed/simple;
	bh=GX9zKrPigmHj+v2k+YwuUFEmZj7N8As0e+GtBKY9DRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UF4zWjaiegWAfJwDjFAHQU8nMb6/97wENhbBMT4l2Cf1BoU7vE5JTVAVog1hmyOaMH1+WmiInT5xD65P8BVlhPcuMMGb+7UMKtcClzQUVKErQQfK99rOp89vP/siX7/jrBGJ0nMdj/GXgeWBUZCcrS6HAkCRFHG8/3+NGteKGTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0nn/gmK/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Kx908lem; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tquanlMq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dfAjh7b6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0nn/gmK/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Kx908lem";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tquanlMq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dfAjh7b6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1D95D1FB40;
	Mon, 31 Aug 2026 17:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788196113;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T08dI9Iw3KNR2yX5J7IEZRW6zdx5gwNRyAnd9Oo8rm0=;
	b=0nn/gmK//tECVFw9kMQzCIYjaDBG9pc9giSFnldhzgNxvjah+M38DWC/AFvQxF5j7aImZk
	2WfLg//dQqHvagDiHXW7u9mE6+mk9CXHrfJtIOIDdnEAPFRbUbZ1m16oVye8ER7HSgdu+q
	J9amFPl7fxekiA+AQtghAWN8RHvsafY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788196113;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T08dI9Iw3KNR2yX5J7IEZRW6zdx5gwNRyAnd9Oo8rm0=;
	b=Kx908lem+O0Q7DB+qa8DNM9gZMJcnzMHvJ/GSKBAPStIdVMQacu8r0vNTx2qiMR33X3dRR
	4T23BK4n4RiFsSCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tquanlMq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dfAjh7b6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788196109;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T08dI9Iw3KNR2yX5J7IEZRW6zdx5gwNRyAnd9Oo8rm0=;
	b=tquanlMqgHLCFN0LN4UVYW78gQxaYhE5Ylu40V+WaES5rEmShfD4RzGH1RDzAp9x0G6pdI
	OCzrOlS8z/ubtgdJPa+a7B9HwD0u9kvLKqFZKUvLIuQ/7qy8mWDotzqUhQtXQDl8DLWhkY
	Nt64DVkBn18n7bmDtaJDd5BifmL2IbM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788196109;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T08dI9Iw3KNR2yX5J7IEZRW6zdx5gwNRyAnd9Oo8rm0=;
	b=dfAjh7b6JKVR/W3pc8g+zAUUXHcBzLwe0d+kD62DvWUYr7UFwOEth5/UxsmFI+QLAWFFjt
	XQDsSuuAhI0Kv6CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E7B8F13515;
	Mon, 31 Aug 2026 17:08:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IvViOAy1lWo/GQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 31 Aug 2026 17:08:28 +0000
Date: Mon, 31 Aug 2026 19:08:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>, David Sterba <dsterba@suse.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Nick Terrell <terrelln@fb.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	yosry@kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kernel Team <kernel-team@meta.com>
Subject: Re: [PATCH 0/3] zstd: probe the CPU for BMI2 support once, not per
 context
Message-ID: <20260831170823.GH9053@suse.cz>
Reply-To: dsterba@suse.cz
References: <CAHk-=whZf9=X+qKkO9_pQzbLdOnbMw5yO8gu0TkahegVW3cC-g@mail.gmail.com>
 <c0bca273-1395-419a-a2eb-5627f2243452@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c0bca273-1395-419a-a2eb-5627f2243452@linux.dev>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 1D95D1FB40
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,kernel.org,suse.com,vger.kernel.org,fb.com,cmpxchg.org,gmail.com,linux.dev,meta.com];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto,suse.cz:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Flag: NO

On Fri, Aug 28, 2026 at 10:54:07PM +0100, Usama Arif wrote:
> > pattern entirely, and be taught to have a *helper* macro that just turns
> > into 0 for when DYNAMIC_BMI2 is not set, and turns into using that stupid
> > flag in user mode, and for the kernel it should just turn into that
> > "cpu_feature_enabled(X86_FEATURE_BMI2)"
> > 
> > Why does it check for both BMI1 and BMI2 anyway? And Arif added an
> > extra check for ABM. That all looks bogus. You can't have BMI2 without
> > having BMI1, so all this code looks completely bogus to begin with.
> > 
> 
> The three checks came from interpreting BMI2_TARGET_ATTRIBUTE("lzcnt,bmi,bmi2")
> as requiring all three feature bits. Agreed that this is unnecessary here.
> The kernel path should check only X86_FEATURE_BMI2.
> 
> I was also trying to preserve zstd’s standalone-library behavior.

I've created https://github.com/facebook/zstd/issues/4752 upstream so
the canges can be synced back and not lost on next update. Regarding the
whole ZSTD code update, there's no 1.6.0 release yet.
