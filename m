Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD96B333434
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 09:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772444762; cv=none; b=K6ec6IXOHwGRbULJaQJdD3NS+J0KNcrUHQql97h3q/2avd2hyU0aNrsv03AEi5k0H3tZAKeUjq4J7EOktoXf9khPIPdf0tmyID++lUAfWaPi/zS15fbs4OY9pqjGponDt+5ilKWpwtVv6SVqFA/xrmJ6aeEwATLqnkTQfTQBGVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772444762; c=relaxed/simple;
	bh=w1AT2ey+rR4bDcyJbOuPqpNKs4S8LzbtPySx41XN26M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AtDbr211wlc/yybXraOhJH7D2IFOsNffIE27nygwMd00RDcos9x1FNCxf04XFAYaVWnpB9nieDwWj3EIv0FyRxyfl5zM/C//jmsWnScOUY/2bWLRH4WodahYMxqhs+zJXtqfSef/MkLGXQvs7nSpLzEVV29lYEsMsNWDPsjNVBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qnzhGNFE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Z86Z4WTt; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qnzhGNFE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Z86Z4WTt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qnzhGNFE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Z86Z4WTt";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qnzhGNFE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Z86Z4WTt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 147173F576;
	Mon,  2 Mar 2026 09:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772444760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D/U0xKOyiXRvqpQJlGIPBl/4/gi8+uoVU7Fp6j2yrBc=;
	b=qnzhGNFEiEEqo2iDww0G9a0+BoIYcRiCBJ2HN807yZBsnGjjjEV9e5cs3LF2Ho9hHoJsnY
	PEJoV7wcbk6S1QHZwg5CgwUjgM5q92k8PqYqAVvCmH/dgWKbe161CMTam1UAO/LwfyRmqM
	7WhgsJwcycAB0e0pvFuVKAHD/f3xo6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772444760;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D/U0xKOyiXRvqpQJlGIPBl/4/gi8+uoVU7Fp6j2yrBc=;
	b=Z86Z4WTtEhy0jZP9Nnua/55yzcnE4fwEtQbTRYnqvRVOss6bX1HUDLPnznFD0i6Q/Sm7Gp
	dXpZIi4ccBLZ+TCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772444760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D/U0xKOyiXRvqpQJlGIPBl/4/gi8+uoVU7Fp6j2yrBc=;
	b=qnzhGNFEiEEqo2iDww0G9a0+BoIYcRiCBJ2HN807yZBsnGjjjEV9e5cs3LF2Ho9hHoJsnY
	PEJoV7wcbk6S1QHZwg5CgwUjgM5q92k8PqYqAVvCmH/dgWKbe161CMTam1UAO/LwfyRmqM
	7WhgsJwcycAB0e0pvFuVKAHD/f3xo6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772444760;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D/U0xKOyiXRvqpQJlGIPBl/4/gi8+uoVU7Fp6j2yrBc=;
	b=Z86Z4WTtEhy0jZP9Nnua/55yzcnE4fwEtQbTRYnqvRVOss6bX1HUDLPnznFD0i6Q/Sm7Gp
	dXpZIi4ccBLZ+TCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1D6A3EA69;
	Mon,  2 Mar 2026 09:45:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wafHLlZcpWm1AwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 02 Mar 2026 09:45:58 +0000
Message-ID: <35af7502-48e9-4176-af85-4a4d4c7c58b7@suse.de>
Date: Mon, 2 Mar 2026 10:45:58 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/21] nvme-auth: use proper argument types
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-4-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-4-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
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

On 3/2/26 08:59, Eric Biggers wrote:
> For input parameters, use pointer to const.  This makes it easier to
> understand which parameters are inputs and which are outputs.
> 
> In addition, consistently use char for strings and u8 for binary.  This
> makes it easier to understand what is a string and what is binary data.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/common/auth.c  | 47 ++++++++++++++++++++-----------------
>   drivers/nvme/host/auth.c    |  3 ++-
>   drivers/nvme/target/auth.c  |  5 ++--
>   drivers/nvme/target/nvmet.h |  2 +-
>   include/linux/nvme-auth.h   | 26 ++++++++++----------
>   5 files changed, 44 insertions(+), 39 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
