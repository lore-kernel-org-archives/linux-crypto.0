Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C591375ADC
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523746; cv=none; b=YbBoMISuGasEsEvH2gdD53coWEkSfOP/hM3788h5SnQPhGOywIQSHYyKWFQbhgU4HSNu4/8FOIbP+awszsz6jhXYB9oS4f5wdcBzclGqPlcLZKkIaXmsqLRO3tqzM2wIbNeOkIQZlfxdhgkbKeAqESDyiM2oRKzHrtPaG3qAXW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523746; c=relaxed/simple;
	bh=GunnaXa3nuW0u9gWuCSCE3V31DfXbUFXGGqrgoit3kA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SALMfrGpkxVtPG6HEpOb8TP4ndQyH8GRSWqymSUBUQs/UUjgRqdkkLhe4aAvN+L0dnyPZvvD7gLZfwYtXi6llucV+AHXDwIn+X6Fhx1Q4vtVBrG6IJ3JjZMotuTnzm+D1lPyduSWI82kGmHiIFLpO8dzobkJ7VQl7sCNJB4D/30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KWOlAq6B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=doE+k2Ny; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KWOlAq6B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=doE+k2Ny; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KWOlAq6B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="doE+k2Ny";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KWOlAq6B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="doE+k2Ny"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7849E3F8DB;
	Tue,  3 Mar 2026 07:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aGge6psEBg+tCQ+E544M8G0DoZPwjTYjapOYJenkSK8=;
	b=KWOlAq6BjyUVJl21q6WEfaVXT1M8InCsImUdpUpEGylXjov9NGA8Tnh+b2ml6fFCaPIMb3
	prMNLauyFFhv4D4uaIewRIZWOW3AmZO/44LGFdKHQLBBY3RQcT2R3T8THfWqQrqpbIsj0S
	e+Y4c4bK8PJ32MzBPgQ1awjpfVEbd0g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523743;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aGge6psEBg+tCQ+E544M8G0DoZPwjTYjapOYJenkSK8=;
	b=doE+k2NyGqFj3Ua9FTdY5VuOWqObJD6NFm5WUfWRg6RiklVaablsqCZFYv8XBn/fBYVxOS
	CG9NHKuQY7h+j+Dw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KWOlAq6B;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=doE+k2Ny
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aGge6psEBg+tCQ+E544M8G0DoZPwjTYjapOYJenkSK8=;
	b=KWOlAq6BjyUVJl21q6WEfaVXT1M8InCsImUdpUpEGylXjov9NGA8Tnh+b2ml6fFCaPIMb3
	prMNLauyFFhv4D4uaIewRIZWOW3AmZO/44LGFdKHQLBBY3RQcT2R3T8THfWqQrqpbIsj0S
	e+Y4c4bK8PJ32MzBPgQ1awjpfVEbd0g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523743;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aGge6psEBg+tCQ+E544M8G0DoZPwjTYjapOYJenkSK8=;
	b=doE+k2NyGqFj3Ua9FTdY5VuOWqObJD6NFm5WUfWRg6RiklVaablsqCZFYv8XBn/fBYVxOS
	CG9NHKuQY7h+j+Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D168C3EA69;
	Tue,  3 Mar 2026 07:42:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eR/yLt6QpmlnVwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Mar 2026 07:42:22 +0000
Message-ID: <3ae4fa34-e8e8-47fb-934f-f9c580d78d92@suse.de>
Date: Tue, 3 Mar 2026 08:42:22 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/21] nvme-auth: host: remove allocation of crypto_shash
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-16-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-16-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 7849E3F8DB
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 3/2/26 08:59, Eric Biggers wrote:
> Now that the crypto_shash that is being allocated in
> nvme_auth_process_dhchap_challenge() and stored in the
> struct nvme_dhchap_queue_context is no longer used, remove it.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/host/auth.c | 29 ++---------------------------
>   1 file changed, 2 insertions(+), 27 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
