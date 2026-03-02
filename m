Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A992338D009
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 10:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772446082; cv=none; b=T013jx9EjJ6TJRkvrQYvYZtGIEnJ/MVZV+ei5So+InbQgKPOLn2yc2KV1UMHRbkkz6JUZfNn4EAWv9KWob0MtH6XULkRsIN2Vs2LzmEChrsy1Dte0vdUyRC4WHRkOGUKxp2MwSiRTGkMK5/G0bfen3qf7WWlGOHQVPidsb/rSv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772446082; c=relaxed/simple;
	bh=qRj++780KT7534ZiWFFMxUcaEJObM2QkvWRM/HvLkyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nN5rBzsVWzMqLPzhAuoKL8k+6s6vbe1hQUDEn+clLHyQUzQ2CrH30rrMPnsm+Aqagi1Q+k3oZGZHzHGlKPtyNNMsN2xmh+/GZaE84HrF1dp6EXMImWaPQVYM9ypkrq7lvViGtn88evNvNSkvRwPo48btzdl8p0JRXrZ+Z8Sc89s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=T/vvG853; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZoXbPelb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=s9tuw9iQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vCGiyjSf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="T/vvG853";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZoXbPelb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s9tuw9iQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vCGiyjSf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DD6A75BD0E;
	Mon,  2 Mar 2026 10:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772446080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ITLQYA/HzG0UhdcNDBEdsI0BRF3I2G8Ft9JGx3o4SBg=;
	b=T/vvG853YOJiuK5UzkB6ihZL64Wh8XTyykkQ85uoqegfES+BVSmxX/s7eFozmCSEXj3tzr
	lsVnnANNESREQU/mtw+cVOTGYu2Ngwt5AhFrpL8V44zgYsRWqkLCWz1k5AoNhvovzYwI36
	ReiubUFVHgC3ygBBJofTHr5jSW+UsZo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772446080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ITLQYA/HzG0UhdcNDBEdsI0BRF3I2G8Ft9JGx3o4SBg=;
	b=ZoXbPelbPI7mva+tb5Btq7jv8MTXhkjpA+LXUm4hfKhswUKfm+RPmhFs07Zn3UW+bRlLPf
	O8wAHEO+BjqJKBDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772446079; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ITLQYA/HzG0UhdcNDBEdsI0BRF3I2G8Ft9JGx3o4SBg=;
	b=s9tuw9iQaQzw/bP0+2Yb66Po3/NSQsNvqF2V+WxtxgczTwUDD/gCTW/pAief9YLPG26w/y
	pLon0v8SwIigCVYhxHF80nvmb7b4dJxF5o+YMy4gHF9SOVR1SFzn2jf7/cAlBkmQtOl1ji
	g5Dwf08Un9VHfUQplXnCf9EnxUQjxxM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772446079;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ITLQYA/HzG0UhdcNDBEdsI0BRF3I2G8Ft9JGx3o4SBg=;
	b=vCGiyjSfMRHol09o8AVqIRa1bkY4yMVIHUs+Y5ilVK5Mk2QC99hyob7TpSuU7zgAla5Qim
	4h1YRMVhOVoolmAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C208C3EA69;
	Mon,  2 Mar 2026 10:07:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dw+zLn9hpWmYHAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 02 Mar 2026 10:07:59 +0000
Message-ID: <1417c781-cb2a-42c4-9fc5-9839f377772b@suse.de>
Date: Mon, 2 Mar 2026 11:07:59 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/21] nvme-auth: common: add HMAC helper functions
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-8-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-8-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
> Add some helper functions for computing HMAC-SHA256, HMAC-SHA384, or
> HMAC-SHA512 values using the crypto library instead of crypto_shash.
> These will enable some significant simplifications and performance
> improvements in nvme-auth.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/common/Kconfig |  2 ++
>   drivers/nvme/common/auth.c  | 66 +++++++++++++++++++++++++++++++++++++
>   include/linux/nvme-auth.h   | 14 ++++++++
>   3 files changed, 82 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
