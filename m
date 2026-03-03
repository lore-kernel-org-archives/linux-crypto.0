Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37C137701F
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523839; cv=none; b=AOMn7TlfwJw/gMHmQUCyqOg1iRwVCiIbgdxk8TCRpOeg7wNhhMiSCEvlHaLW2a9zouGMNlwrvt9Dk+hw2HCcm5w0hOis61R6vsZctck9KWKdvb4DHZO9RUxqO4Zxq4Fnojdhu76wseBf3P2wlcW5Uam/lLFds/zhBJ4l3jBvcas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523839; c=relaxed/simple;
	bh=OS/ypuOvuxxlhf5YMGx70pJNhDWpd587f9L66DOTUnM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NObWZfnKOmna2OJxnUe5G4z/SfNUOtmx6fjIpROtfU1bOYkqKDkChGxLuMq97gtGtVEkUGchv6kLufoaMJx6rNcKzVRkD7Ay1A6q1YaiN3Ln/zP7VBTQmz3eUNyKpJkTpqGkHFtXWfwffB0dQ7p7Cj1YF4CCEiTF+6ekcgMQ6Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g7mOnStT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TOKZ3bxe; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g7mOnStT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TOKZ3bxe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g7mOnStT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TOKZ3bxe";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g7mOnStT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TOKZ3bxe"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0A0643F8DB;
	Tue,  3 Mar 2026 07:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5P/ehVriDcWyI4ygOKIkxjzfoCGTOu9q+Jm26/5nEik=;
	b=g7mOnStTOYXx0Mt3ocOCEJFoMQlOYWa6OOunYTIVsSfLK1F6nKYTvH2MVSgDAgGFrBGkTH
	ezneXxMK+IcW5ZaSJ9tox0zd5M90vT6qLnu0bYgP43WyC6bITcIH2U4epmRymrL11dPIAg
	SLo4xom8jx/MO4IjtIMlrDYeKPAmCvg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523836;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5P/ehVriDcWyI4ygOKIkxjzfoCGTOu9q+Jm26/5nEik=;
	b=TOKZ3bxefvWWxpj1IL2Sc4hmdhthSn3Z/Ocfu0U0UdeeZqlJWPIF+xLQKkfwMDdkwBgMTt
	HOj6k7ZpyaA7tABA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5P/ehVriDcWyI4ygOKIkxjzfoCGTOu9q+Jm26/5nEik=;
	b=g7mOnStTOYXx0Mt3ocOCEJFoMQlOYWa6OOunYTIVsSfLK1F6nKYTvH2MVSgDAgGFrBGkTH
	ezneXxMK+IcW5ZaSJ9tox0zd5M90vT6qLnu0bYgP43WyC6bITcIH2U4epmRymrL11dPIAg
	SLo4xom8jx/MO4IjtIMlrDYeKPAmCvg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523836;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5P/ehVriDcWyI4ygOKIkxjzfoCGTOu9q+Jm26/5nEik=;
	b=TOKZ3bxefvWWxpj1IL2Sc4hmdhthSn3Z/Ocfu0U0UdeeZqlJWPIF+xLQKkfwMDdkwBgMTt
	HOj6k7ZpyaA7tABA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A64C53EA69;
	Tue,  3 Mar 2026 07:43:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZjcVJDqRpmlpWQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Mar 2026 07:43:54 +0000
Message-ID: <8101db9c-c9fc-4725-a8e5-fe9ebc2b5a43@suse.de>
Date: Tue, 3 Mar 2026 08:43:54 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/21] nvme-auth: target: use crypto library in
 nvmet_auth_host_hash()
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-18-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-18-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On 3/2/26 08:59, Eric Biggers wrote:
> For the HMAC computation in nvmet_auth_host_hash(), use the crypto
> library instead of crypto_shash.  This is simpler, faster, and more
> reliable.  Notably, this eliminates the crypto transformation object
> allocation for every call, which was very slow.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/target/auth.c | 90 ++++++++++++--------------------------
>   1 file changed, 28 insertions(+), 62 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
