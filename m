Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2051946DA
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523516; cv=none; b=j318XHJBDnXbjra+0XteHdJwc0j7g2N27gVec7YKGxSQ31vLwSWuITb4yl5iQGBLdGUlZYKNaPH7gBuDmugxtkwQJltXF70qLV60fGG5Wm6GuT7l9bh4L4ffG2xpTJ0dSJQQCbp0Etwu5IASU+8XloU9tX2x4yp68DixaMenvYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523516; c=relaxed/simple;
	bh=AplaPQlWVAnB8hS2I1uQn8esgo/Cw9EMzHe93XxB4v8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a2RtBlcsm3gjMhWYlU07M1F0WxLELju68tW3XNzd3ox9eFexc7F63lh0kIMHeFiP8HYgxnOygvNA1FzxiwX5sMVxyq6Pzh7AvCml3iJ0NYj1diWBS9nsMxkSBcsrdmsm4NHkzrZn/biWTAlLYAWZPIkiVIft3PNgd6P4o4VZ9l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NGswETZ/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8Hwsz7zx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NGswETZ/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8Hwsz7zx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NGswETZ/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8Hwsz7zx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NGswETZ/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8Hwsz7zx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 452815BDE6;
	Tue,  3 Mar 2026 07:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e9Zb+wU5ucVvGvCjl/XPYdDp78YIUCzyyzZHQPOqy/U=;
	b=NGswETZ/sV9XfctzvotvEBHPnjY9OEoR5BV+b1zPys+VAhrfBdXrYJZPWljV1RPP3GRiJU
	1/oALMGH+BE+N0wgGpORqrVq0RU7nGIFyWrSAFsgEmbAghez5KYQ2Wzbti0+FEsvwqxayA
	vdmsBMwZRwRc4ck2L/6/GY/AR/kcKec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e9Zb+wU5ucVvGvCjl/XPYdDp78YIUCzyyzZHQPOqy/U=;
	b=8Hwsz7zxasmIGKU2MatOrjhe86a8bRY2Xch3kyqI24K++asc0wn760TgnHcY39xXfBLuGQ
	NJQ9lgnD9bRgzpDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="NGswETZ/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8Hwsz7zx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e9Zb+wU5ucVvGvCjl/XPYdDp78YIUCzyyzZHQPOqy/U=;
	b=NGswETZ/sV9XfctzvotvEBHPnjY9OEoR5BV+b1zPys+VAhrfBdXrYJZPWljV1RPP3GRiJU
	1/oALMGH+BE+N0wgGpORqrVq0RU7nGIFyWrSAFsgEmbAghez5KYQ2Wzbti0+FEsvwqxayA
	vdmsBMwZRwRc4ck2L/6/GY/AR/kcKec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e9Zb+wU5ucVvGvCjl/XPYdDp78YIUCzyyzZHQPOqy/U=;
	b=8Hwsz7zxasmIGKU2MatOrjhe86a8bRY2Xch3kyqI24K++asc0wn760TgnHcY39xXfBLuGQ
	NJQ9lgnD9bRgzpDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C39E13EA69;
	Tue,  3 Mar 2026 07:38:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qgTNLfePpmnHUgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Mar 2026 07:38:31 +0000
Message-ID: <52386179-7150-40fc-9cfe-647351805c39@suse.de>
Date: Tue, 3 Mar 2026 08:38:31 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/21] nvme-auth: common: use crypto library in
 nvme_auth_generate_digest()
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-12-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-12-ebiggers@kernel.org>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 452815BDE6
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 3/2/26 08:59, Eric Biggers wrote:
> For the HMAC computation in nvme_auth_generate_digest(), use the crypto
> library instead of crypto_shash.  This is simpler, faster, and more
> reliable.  Notably, this eliminates the crypto transformation object
> allocation for every call, which was very slow.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/common/auth.c | 87 +++++++++++---------------------------
>   1 file changed, 25 insertions(+), 62 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
