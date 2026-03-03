Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0065376BF1
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523703; cv=none; b=rxPGTuK+xcf2AUoKoTkXwEIJzyCJ2Df4mWC97ohrjPFzU1XNFQdqw4bY3MK4Mjyf7awz8IOyl1u8O5BqpmZwO6miT1yQpNDNqxR2xCjixvXl7VWQEdpJmqvLdS3D4gzkJ67woyVx9ht4iwzWfoH8XYf1vTgHnlBqV+XzQTnshz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523703; c=relaxed/simple;
	bh=uXxEbJU0vDFXLgbczYuLSRLLwyWhON9kNZQHTY8IgT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fs8Cwd7rUTk1VYLmDremdF/fyZkXyaBoDdZEapWIU1eSnT9f59qZpxyhDaFMmZJWXEprkYQXFq1dyk73ZGypDzLxmGF0d6OrrNhMoBQJ4LvByr5N2nUxwnv5qGDYuT7LZouDI3LGm9KZCv0eIDM42owqsqH/qogJOevbX5uLWPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Y7jqCL3O; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=34NiyXFv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TVQeOSeP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=btocTzBt; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Y7jqCL3O";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="34NiyXFv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TVQeOSeP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="btocTzBt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EE1385BDE6;
	Tue,  3 Mar 2026 07:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523701; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2z86S1GxNMWbE0WSWFBq+tnVJE2ol2rlXDkD+ITvq7k=;
	b=Y7jqCL3ObxdRx/RJD+45To7p+6OU7uM4i4EZubzCDxjMndyP63I52FsENgKWo3uey98pkW
	OICbBBxFzagIT6o7FyHD4FwFxVBX+QbFHIfA9TyAzvZbZnkM9nIXOeP+ob8PkFvb+r2il2
	rRtI96zqR6N59n4yEGuSRJa3UrHrgUo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523701;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2z86S1GxNMWbE0WSWFBq+tnVJE2ol2rlXDkD+ITvq7k=;
	b=34NiyXFvOsR9eelHLyONQZO4Z0EFudHCCkGH4CezK+fPhXA+8QPq/SIO6cfjYDA+t4euFr
	QSKeUgK0IOupzRDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TVQeOSeP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=btocTzBt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2z86S1GxNMWbE0WSWFBq+tnVJE2ol2rlXDkD+ITvq7k=;
	b=TVQeOSePTamAfqr2AOaSEvVAI1IU+iOvfU43CHw8tPZfipeTZ2WKj53YZfmTt+8HTbOIYw
	hO4AXLn87RGi2PKD1pMKMKm3MS/kg/Qbtlro16Q8Jzo2S/+0NiLO1s6zTgEUCaqBflWmQ/
	urO8YCcm6jmpX2+Y/4cU1OPSfAPkTMI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523700;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2z86S1GxNMWbE0WSWFBq+tnVJE2ol2rlXDkD+ITvq7k=;
	b=btocTzBtILf0yzEWVrmQqORywhuA55tQpVW0wpwqNfpgC/sx+vsdBdrBpkoI4M/ZVoFtI0
	+iAAKuV9HQxPxwBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 89E183EA69;
	Tue,  3 Mar 2026 07:41:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kioqILSQpmmxVgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Mar 2026 07:41:40 +0000
Message-ID: <2a317bf8-260d-4535-ad03-33310e83ac0b@suse.de>
Date: Tue, 3 Mar 2026 08:41:40 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/21] nvme-auth: host: use crypto library in
 nvme_auth_dhchap_setup_ctrl_response()
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-15-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-15-ebiggers@kernel.org>
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
X-Rspamd-Queue-Id: EE1385BDE6

On 3/2/26 08:59, Eric Biggers wrote:
> For the HMAC computation in nvme_auth_dhchap_setup_ctrl_response(), use
> the crypto library instead of crypto_shash.  This is simpler, faster,
> and more reliable.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/host/auth.c | 56 +++++++++++++++-------------------------
>   1 file changed, 21 insertions(+), 35 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
