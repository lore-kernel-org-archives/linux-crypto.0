Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE06738CFEB
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 09:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772444708; cv=none; b=DsRExU/PN4JsrfFPJeuEtY1Ntr3s1sOxc0Prz1eQBA6f5vJPHs1ff4egAikZ6Oc9VWsG+D0+upnhkJN49bPY5q0/3S4+AkJkmOGogdBCoz+kb5yCK1U+lTc+7Fv7gkJogqtYsMH3dKpEdEOwX9LNxrw+iW82f3grUa4fa44DY7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772444708; c=relaxed/simple;
	bh=OvYr1g6hbso7sJ2LKzpEUT3mbBurs4F3H6WiUNLqQq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VcTEz6Sv2v7qGVcIcg1z8HD3ttGfnNckXSnUpLjt9f7Z39UZw6tAHXpJNoMqrSvAzHauhXfmbAlezl16akc4i2YsQhZ1V3zVzwAeZcN9SR4jTPPaG3N04+uMco4hhwgI+SqdLv/6y6il2/1+yxjG2R08E8Q2Nq+aGalt7K6wO84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ii+j2bEV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0d7+T7Ad; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ii+j2bEV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0d7+T7Ad; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ii+j2bEV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0d7+T7Ad";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ii+j2bEV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0d7+T7Ad"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 167193F576;
	Mon,  2 Mar 2026 09:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772444706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qBVko8jLwSyS0O7PNlS7odM9qMV2t3vljohaDoZTuWI=;
	b=ii+j2bEVXfkXHolhfmnZDnHkpgIHZm9rBe3fha4PKkhYdBuXKOMPOmuNK7GrdG0bBtIETh
	EiI+6RwvBXl2nz2MY6eHl2NtJem6sLjCQegk0xU5yPhup7MyHgc9yq+ddELZsjdEjmu2qm
	Ec4IUH/hIEFciFPit8yINxwi4e7oMRE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772444706;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qBVko8jLwSyS0O7PNlS7odM9qMV2t3vljohaDoZTuWI=;
	b=0d7+T7Ad2VJKtLdw5LxrmT9bgYKp+EtFXfFFwVjNed58tLWf1ZoEeEQdRQWbM+sbzw1HJI
	fLvIhfObUH14HSCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772444706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qBVko8jLwSyS0O7PNlS7odM9qMV2t3vljohaDoZTuWI=;
	b=ii+j2bEVXfkXHolhfmnZDnHkpgIHZm9rBe3fha4PKkhYdBuXKOMPOmuNK7GrdG0bBtIETh
	EiI+6RwvBXl2nz2MY6eHl2NtJem6sLjCQegk0xU5yPhup7MyHgc9yq+ddELZsjdEjmu2qm
	Ec4IUH/hIEFciFPit8yINxwi4e7oMRE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772444706;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qBVko8jLwSyS0O7PNlS7odM9qMV2t3vljohaDoZTuWI=;
	b=0d7+T7Ad2VJKtLdw5LxrmT9bgYKp+EtFXfFFwVjNed58tLWf1ZoEeEQdRQWbM+sbzw1HJI
	fLvIhfObUH14HSCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7B4A3EA6C;
	Mon,  2 Mar 2026 09:45:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DzEgNCFcpWlhAgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 02 Mar 2026 09:45:05 +0000
Message-ID: <9c3be754-25d0-4de4-9f4e-2108eea9efba@suse.de>
Date: Mon, 2 Mar 2026 10:45:05 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/21] nvme-auth: common: constify static data
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-3-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-3-ebiggers@kernel.org>
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
> Fully constify the dhgroup_map and hash_map arrays.  Remove 'const' from
> individual fields, as it is now redundant.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/common/auth.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
