Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E872375ACE
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523614; cv=none; b=LvvgV0zg2nFLF+LYNcXuXuHmdG/CwNPTr9iQEkJMx/ukx3fMYD413ESuFUZIHuW9AdzhInBRKABzCviqEW6yPoV8nY2PkruEwiLVMwDz1I5lisCtHTGcCpycXYX98YhkrDat4yTki8IoGe8FggsEgGtQlk8kuCmHQxSDxCptfvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523614; c=relaxed/simple;
	bh=Bpx5lJ10A442KJNrHALHXOAzeBQ1SUvRWuznjs4KXr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ox3clapAD/DVid9vUcJ/bOxK3M8HRvJGvlbVMN2yVEiiyK5an5oaR7vZ5rqpIyqCveQI0zFGKb12421NmhrgBEjs2+eKOFL7gtVAz95i/qTMM5VGElYqxQTl2RT3Flhd4YlY75t1E0jGp6Z8mTj4XncLgygEUfRC9MGcJguzgJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=W0d5qUtD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TQZji029; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=W0d5qUtD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TQZji029; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="W0d5qUtD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TQZji029";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="W0d5qUtD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TQZji029"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB0873F8D0;
	Tue,  3 Mar 2026 07:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wlRPoi9db6GfDV73KhcksIfci5f3IGrrGyMKzeEDywU=;
	b=W0d5qUtDJM6vuOKLNfXd7lXPtZNjcaVs/xVU4szPZrgWdaYkmuC6pyChIOP+8OIDEDwKvY
	z+xrvq3+tJjJ3z2RW4jWYX0+2TuKeTGIDkYyKWtmLVfChS+ETYm0+dwqhpcFIGhIQXVit/
	Xr0tZlpw0vk69n1ra8c5Atvft6XP8pk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523610;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wlRPoi9db6GfDV73KhcksIfci5f3IGrrGyMKzeEDywU=;
	b=TQZji0293zj391ocEeLEIcRqVE8v3w2tWkgJIiLYpjKZc8X0KEa0H7qSGZjvreTzKtkGmu
	X6O6L++VWAoc8XAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=W0d5qUtD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TQZji029
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wlRPoi9db6GfDV73KhcksIfci5f3IGrrGyMKzeEDywU=;
	b=W0d5qUtDJM6vuOKLNfXd7lXPtZNjcaVs/xVU4szPZrgWdaYkmuC6pyChIOP+8OIDEDwKvY
	z+xrvq3+tJjJ3z2RW4jWYX0+2TuKeTGIDkYyKWtmLVfChS+ETYm0+dwqhpcFIGhIQXVit/
	Xr0tZlpw0vk69n1ra8c5Atvft6XP8pk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523610;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wlRPoi9db6GfDV73KhcksIfci5f3IGrrGyMKzeEDywU=;
	b=TQZji0293zj391ocEeLEIcRqVE8v3w2tWkgJIiLYpjKZc8X0KEa0H7qSGZjvreTzKtkGmu
	X6O6L++VWAoc8XAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E0F53EA69;
	Tue,  3 Mar 2026 07:40:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QQsEGVqQpmnLVAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Mar 2026 07:40:10 +0000
Message-ID: <05658bdd-074c-4e06-ada8-536ad49b17cb@suse.de>
Date: Tue, 3 Mar 2026 08:40:09 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/21] nvme-auth: common: use crypto library in
 nvme_auth_derive_tls_psk()
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-13-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-13-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-5.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -5.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CB0873F8D0

On 3/2/26 08:59, Eric Biggers wrote:
> For the HKDF-Expand-Label computation in nvme_auth_derive_tls_psk(), use
> the crypto library instead of crypto_shash and crypto/hkdf.c.
> 
> While this means the HKDF "helper" functions are no longer utilized,
> they clearly weren't buying us much: it's simpler to just inline the
> HMAC computations directly, and this code needs to be tested anyway.  (A
> similar result was seen in fs/crypto/.  As a result, this eliminates the
> last user of crypto/hkdf.c, which we'll be able to remove as well.)
> 
> As usual this is also a lot more efficient, eliminating the allocation
> of a transformation object and multiple other dynamic allocations.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/common/auth.c | 156 +++++++++++++------------------------
>   1 file changed, 53 insertions(+), 103 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
