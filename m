Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6EC37104C
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523655; cv=none; b=Pn/R7XU856yzZJMakBoiSqxh0FXVnTrWav0/n4agZUjo+Zn6Uba0aA6vVrZqrBcaxFQukDmvLpWvIDUxveoWOv8Y7SAhtCgaGlcpMWCH6QexS0Rpkpq1uOamGF1OgejjodDsEPz3VToqDWpxFjY7vlUhXCz+y/JGUCVk+9XVZLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523655; c=relaxed/simple;
	bh=q9QsVGOExNJAiy3cu+ESnSOgFmW+7AOejGR1Cf/HDMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BZAFtnuHqfNLfUTp3JDFHoXpvz+pddVSUyqqIchIIhvRDFPoHGWrQ+X8HOlumzdvlFVdC8fMZluvoj9LcMu4d8+qhf5Bntrl+txnKdpFCCYWfey1ivgHEtDh9TQ0YNrmiyRdMC7F9oFaRU5ipSHnfpAQdOMwVDdI0dtqdw5PrtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KktpMrOe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=D2l8hyqn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KktpMrOe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=D2l8hyqn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KktpMrOe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="D2l8hyqn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KktpMrOe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="D2l8hyqn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9C6095BDE6;
	Tue,  3 Mar 2026 07:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kOWuec/rmo25hHv+qYYaz8BgQGVMtjarbOKHYLM8Bjs=;
	b=KktpMrOejv+OKFBvfFkzgnfGMFGQv8qbT8aee4RIQSzV011ssV+KIC1RnyjaoHTRkLfbuP
	XrnYrW/eJcEk9v5Uxzq0yLrcCLbKeVBUYNtwmX7qaSjBMllvOL4ytwA9e8tcve2e/k5GGl
	5iFmIvWbLdLYpnmbHfdZeONChZRqzpg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kOWuec/rmo25hHv+qYYaz8BgQGVMtjarbOKHYLM8Bjs=;
	b=D2l8hyqnK+OAv5hnjVJhUBgT224HOQBMdEXczOk8YHZdQMBaQfqwjIicqOulpW9ALK0B4Y
	bsZkWB5qDtDu0ZAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KktpMrOe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D2l8hyqn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kOWuec/rmo25hHv+qYYaz8BgQGVMtjarbOKHYLM8Bjs=;
	b=KktpMrOejv+OKFBvfFkzgnfGMFGQv8qbT8aee4RIQSzV011ssV+KIC1RnyjaoHTRkLfbuP
	XrnYrW/eJcEk9v5Uxzq0yLrcCLbKeVBUYNtwmX7qaSjBMllvOL4ytwA9e8tcve2e/k5GGl
	5iFmIvWbLdLYpnmbHfdZeONChZRqzpg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kOWuec/rmo25hHv+qYYaz8BgQGVMtjarbOKHYLM8Bjs=;
	b=D2l8hyqnK+OAv5hnjVJhUBgT224HOQBMdEXczOk8YHZdQMBaQfqwjIicqOulpW9ALK0B4Y
	bsZkWB5qDtDu0ZAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 244513EA69;
	Tue,  3 Mar 2026 07:40:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GRrTBoOQpmlQVgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Mar 2026 07:40:51 +0000
Message-ID: <b47595fb-2c9e-42d6-ae88-236cc12e8119@suse.de>
Date: Tue, 3 Mar 2026 08:40:50 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/21] nvme-auth: host: use crypto library in
 nvme_auth_dhchap_setup_host_response()
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-14-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-14-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-5.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -5.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9C6095BDE6

On 3/2/26 08:59, Eric Biggers wrote:
> For the HMAC computation in nvme_auth_dhchap_setup_host_response(), use
> the crypto library instead of crypto_shash.  This is simpler, faster,
> and more reliable.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/host/auth.c | 59 ++++++++++++++--------------------------
>   1 file changed, 21 insertions(+), 38 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
