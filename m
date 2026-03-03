Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21F41946DA
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523466; cv=none; b=OPhcDk6qiwBCYyTfcaRwF0wmWux/ncbF1zRbye/37A9TaPNYuGeXts3s86T4ckpiuTTkl9VppC4deeeQe+eCOdNn12rQW6bP6wA+6cMcIU/a7uc3+PZgurs5fWHJMejHVV9lP+FUNv8ZdRXXaUsbkdp7s7kTjfbwIqbdx+e9608=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523466; c=relaxed/simple;
	bh=8jremwXF6MvZIYE5C5bU6vfwzeokybBaTqUcqXN+H/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sxxp6GwBlGLWb0puGyH+f9WmVCPqbyWg9X21251AvDYKDpbpxiorSeYKcyOtNwL29SvzWsS8LV7AGlShU0FCp2Pnq1RH1rRwguFFcb0PVbSXQ/221rc2CxHgEx7N1Gqdnl+kVqRlyhdHH5k6Xstj5sRjBxK5pKBN2XCv/5nrOrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RsxiGaGH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=k29SroCd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RsxiGaGH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=k29SroCd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RsxiGaGH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="k29SroCd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RsxiGaGH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="k29SroCd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2F3E23F761;
	Tue,  3 Mar 2026 07:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xWqb6V7iOXRUFg8aNu66SVZMaqlTYOKThqyDajBkU90=;
	b=RsxiGaGHRo5J36NGPYLG4gH36rUhNrPdiF8PoConz+Lg3aVY3ctykeZBt4Cy8LuEc6NTot
	nBecRKQouiavvPiW4iTkip5HCpfG54fK7DbHwZ91y6ofUZRSQStGJSLe/AICvvxWF/3l5U
	0/14uetEvw4qUKvk6bjyKx13KwnhEuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523463;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xWqb6V7iOXRUFg8aNu66SVZMaqlTYOKThqyDajBkU90=;
	b=k29SroCdVFm1C8eWfH37Kx5cq9bkXMoymWtmXPGdCtM1Xepadu8wrYH/Ducmj2iF/G+nzf
	EjiAv06Ti3HHJzCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RsxiGaGH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=k29SroCd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xWqb6V7iOXRUFg8aNu66SVZMaqlTYOKThqyDajBkU90=;
	b=RsxiGaGHRo5J36NGPYLG4gH36rUhNrPdiF8PoConz+Lg3aVY3ctykeZBt4Cy8LuEc6NTot
	nBecRKQouiavvPiW4iTkip5HCpfG54fK7DbHwZ91y6ofUZRSQStGJSLe/AICvvxWF/3l5U
	0/14uetEvw4qUKvk6bjyKx13KwnhEuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523463;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xWqb6V7iOXRUFg8aNu66SVZMaqlTYOKThqyDajBkU90=;
	b=k29SroCdVFm1C8eWfH37Kx5cq9bkXMoymWtmXPGdCtM1Xepadu8wrYH/Ducmj2iF/G+nzf
	EjiAv06Ti3HHJzCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B4C73EA69;
	Tue,  3 Mar 2026 07:37:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Zg/GI8aPpmkgUgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Mar 2026 07:37:42 +0000
Message-ID: <7291430e-8867-42ec-a744-84ae02fdfc4b@suse.de>
Date: Tue, 3 Mar 2026 08:37:42 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/21] nvme-auth: common: use crypto library in
 nvme_auth_generate_psk()
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-11-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-11-ebiggers@kernel.org>
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
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 2F3E23F761
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 3/2/26 08:59, Eric Biggers wrote:
> For the HMAC computation in nvme_auth_generate_psk(), use the crypto
> library instead of crypto_shash.  This is simpler, faster, and more
> reliable.  Notably, this eliminates the crypto transformation object
> allocation for every call, which was very slow.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/common/auth.c | 63 +++++++++-----------------------------
>   1 file changed, 14 insertions(+), 49 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
