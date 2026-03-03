Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A345C377001
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523802; cv=none; b=mNLXzoACtQWJfKhl6yczJBQhEOjJBfDt7ZZbPlf98H1YKwBFhYm1rDpOCsIxiMdcHs/iLni2MMz/6sPhnU7ZkmTujz5KzFdjmZmchRGPkaYueOntTH1cmPO7BDwrBRbedfbvZjnsTxaGx3YjZunsXkWzUP8kMAqf3htUFDD+Fs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523802; c=relaxed/simple;
	bh=F9N33XgFzu/IR2L1PC+KBiGrj6AyTL/nMiU3X8/O0C8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qu6zXMBaySmsVj0QqSpnco3+lCrTGYSPmgM2CymdrpnsV/vdPk+3KwGOyvxe2xdPvODcs/D1XknR0WbnNeTmHS949lndaAKCfqj8crUJroIY2fQtAjRR3NfyRDe+ItE1WOUerUOnjLBHFQFnOXpXOYxy5iwC+nq15g1Qs8ZAh78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=alX4LfoO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2/wt1waX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Zcogpfa9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rNeH465u; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="alX4LfoO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2/wt1waX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Zcogpfa9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rNeH465u"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EEA335BDE6;
	Tue,  3 Mar 2026 07:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9T8MXFMMo+drkLYH41nsR9xI4Y/iHMMvMNMBGw/wteE=;
	b=alX4LfoOes/VER/b4OSSenlpZmRVqVJ+MmsrMNtD/e6iZgWAZ7bXtiijhCfoI4FwNbkUMQ
	iDe9qAQeO0kI1OOQQ0YABPuEjcu17Y6QfIm3oRlRES/bKH55Ifz/1Qa0q1uvnxI0csrzH1
	iMS9ps6HkYhKlJJow46NR9+v63iOBl8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523800;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9T8MXFMMo+drkLYH41nsR9xI4Y/iHMMvMNMBGw/wteE=;
	b=2/wt1waXJ/RdklQUZc0XB/c97LEWROWb38q3TYmr0sgHyN2pEiakOBuyahsjJjjZ3DKDqI
	crJWDF7mkdE+/MBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9T8MXFMMo+drkLYH41nsR9xI4Y/iHMMvMNMBGw/wteE=;
	b=Zcogpfa9FAu2AH9INm5qLBUkAHT+s3UimaR6wNbBpOeUPiNQJp3Z5GhNrIKB/OhBoHUZ0Q
	jL5qyvgjEgNCzE94madUI+5W7EM/qwZRom+TgydiOOBeYbqWMO8WMbbKUSbK5Vc6I/CNrc
	gDt8rSNh+TWtGNPMXXq7j0FuQ/a9Mkw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523798;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9T8MXFMMo+drkLYH41nsR9xI4Y/iHMMvMNMBGw/wteE=;
	b=rNeH465uY+wydyWLXjRYKGODdXQ6Coh/4VbZ6BNLlCs+qJPzIPD9Ip9rAArCHlEn3ROdWN
	Fuqs8ouiPyVOZbAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 852E93EA69;
	Tue,  3 Mar 2026 07:43:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 74u8HhaRpmmtWAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Mar 2026 07:43:18 +0000
Message-ID: <cff9f152-6b1b-44a0-b390-99b5b3ee5ff8@suse.de>
Date: Tue, 3 Mar 2026 08:43:18 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/21] nvme-auth: target: remove obsolete
 crypto_has_shash() checks
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-17-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-17-ebiggers@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 3/2/26 08:59, Eric Biggers wrote:
> Since nvme-auth is now doing its HMAC computations using the crypto
> library, it's guaranteed that all the algorithms actually work.
> Therefore, remove the crypto_has_shash() checks which are now obsolete.
> 
> However, the caller in nvmet_auth_negotiate() seems to have also been
> relying on crypto_has_shash(nvme_auth_hmac_name(host_hmac_id)) to
> validate the host_hmac_id.  Therefore, make it validate the ID more
> directly by checking whether nvme_auth_hmac_hash_len() returns 0 or not.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/target/auth.c             | 9 ---------
>   drivers/nvme/target/configfs.c         | 3 ---
>   drivers/nvme/target/fabrics-cmd-auth.c | 4 +---
>   3 files changed, 1 insertion(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
