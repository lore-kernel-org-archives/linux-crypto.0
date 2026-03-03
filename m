Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC5D34752F
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523881; cv=none; b=jJIlPhkUBMfzc5mbcDxLVwf31GfBoTIqpj3+cWy4hR/0k+hZowBHbTJWEmlgMsaFOeQ0RAxy++FKivnb87ZpJRxrldHSyLwsf2uq45boOFsv9qTtk2cTK+OxPWYbetdxFv+7THm7Nu0ke8qw5TlZFFdWKoGpRUhng0XQA3FKBrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523881; c=relaxed/simple;
	bh=6qiPe4/8KgiU6ZtW3QPk9jZOra+NfpHusnRFAYmHkEo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iy5aB0O9QdshzOTCWT6J+LYkfLP5CXm6pkC9oI07ZkIretmFeVN+aTI1mEuOGLeOo/U0O0gBqjenGWoE71KkPbNR6pQBF2XFrDyGREVcctSzHQjAKceVqWrmoVDmjnC5ex+ej0dfIiyxFDbyIWDc6P5kpwUyaf4xWFrabE9aHDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0XaUfeoG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8ztXs0Fn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0XaUfeoG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8ztXs0Fn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0XaUfeoG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8ztXs0Fn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0XaUfeoG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8ztXs0Fn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 65E485BDE6;
	Tue,  3 Mar 2026 07:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523878; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ajrKneFZSoY6bzxzWiKtEt9bfWnDbeRRSW13GD8aFOA=;
	b=0XaUfeoGxRH+pShMp9zDtUmJeco2uJtVzV0aTDUHf/Hj+DQaGvHGHsYoA3MBlY6OHSWr9v
	tRdsGva8XNLqZ+gUTIbx/07mX0COara8Hwp3pea/n1m2AqFSc850fJ4M1iGtLCtnNOQF9A
	WOOO2SszbC7wqUEXZVhndqwrnbUKXOg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523878;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ajrKneFZSoY6bzxzWiKtEt9bfWnDbeRRSW13GD8aFOA=;
	b=8ztXs0FnsCw88/t4Ik1P5sZh1ACez5h8AF0r7IRhJVpFpo/xPXB6fpem4RSCV7iYFQA2sK
	yYJIXeLlWxynYFBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523878; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ajrKneFZSoY6bzxzWiKtEt9bfWnDbeRRSW13GD8aFOA=;
	b=0XaUfeoGxRH+pShMp9zDtUmJeco2uJtVzV0aTDUHf/Hj+DQaGvHGHsYoA3MBlY6OHSWr9v
	tRdsGva8XNLqZ+gUTIbx/07mX0COara8Hwp3pea/n1m2AqFSc850fJ4M1iGtLCtnNOQF9A
	WOOO2SszbC7wqUEXZVhndqwrnbUKXOg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523878;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ajrKneFZSoY6bzxzWiKtEt9bfWnDbeRRSW13GD8aFOA=;
	b=8ztXs0FnsCw88/t4Ik1P5sZh1ACez5h8AF0r7IRhJVpFpo/xPXB6fpem4RSCV7iYFQA2sK
	yYJIXeLlWxynYFBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D5EC43EA69;
	Tue,  3 Mar 2026 07:44:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cXa3MmWRpmmwWQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Mar 2026 07:44:37 +0000
Message-ID: <057aea5c-31b3-4dd9-835b-d69ed8b230d1@suse.de>
Date: Tue, 3 Mar 2026 08:44:37 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/21] nvme-auth: target: use crypto library in
 nvmet_auth_ctrl_hash()
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-19-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-19-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 3/2/26 08:59, Eric Biggers wrote:
> For the HMAC computation in nvmet_auth_ctrl_hash(), use the crypto
> library instead of crypto_shash.  This is simpler, faster, and more
> reliable.  Notably, this eliminates the crypto transformation object
> allocation for every call, which was very slow.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/target/auth.c | 94 ++++++++++----------------------------
>   1 file changed, 25 insertions(+), 69 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
