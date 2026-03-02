Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A4C396D2E
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 10:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772446227; cv=none; b=Q5BLiKnS8XNbwdkPHecPLADVw7oZO1xgaHQ3IrpyrQUtXS58aArG7erXaDxyPTj3xRMzi8z8jZ7Lc1agkxMOgfMb/qhVyS1W/JfNxFA+MsW1jQUrEesGf9SrC+etfpGBWea4UTkZiSamJr6SNGJyInea226rd2cG44W2jJiK5m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772446227; c=relaxed/simple;
	bh=2XK92ivxH1IYof5OBDjAwo0HQYXuHVGXLD8xpo7SNRY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qvOhiGfLO9q1JkIn4HbiCoRQPrJwfbjKUIGXEEAZRc72Cmk5eRhUS1SrjckyYq65qAdWFX7TiUXIHAsc8t5/kbU8OHGUsjTHBrWwZS9hfF3dwRvVhvgLeykiAe0LhVygnTY1AmT8udwpuLH5ysZtIPuapkYnUDRidnnkJSK1az0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GC6jS0JN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VlvEnnWT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GC6jS0JN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VlvEnnWT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GC6jS0JN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VlvEnnWT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GC6jS0JN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VlvEnnWT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B54245BD0E;
	Mon,  2 Mar 2026 10:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772446224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lp/Xt92lO0XbwR9i9sLl7/h6vP5h5//3md93gyhNT1o=;
	b=GC6jS0JN42QAA0NzpxPJYn8ynNfAD8Yfa0Lsu9UEPfFTQxNeGkX2Yy5MYy2YWqoAhrOM42
	NjzrHVNcxs47ZOpZiTtscZmipwFtDRvzDG/Md/syV27xA1HU+6xdLiWGZALrj5/5aaE6tW
	dU0iVjo+ec0Xc+vN0+8bPH12NA5IyOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772446224;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lp/Xt92lO0XbwR9i9sLl7/h6vP5h5//3md93gyhNT1o=;
	b=VlvEnnWTXORMxTEJ27cfsqXI1LQgIL2wO/mhumyGFcfV+FRp2nSaBySok5mmceRfPQ91QL
	0tHaI3HbMtw78ODA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772446224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lp/Xt92lO0XbwR9i9sLl7/h6vP5h5//3md93gyhNT1o=;
	b=GC6jS0JN42QAA0NzpxPJYn8ynNfAD8Yfa0Lsu9UEPfFTQxNeGkX2Yy5MYy2YWqoAhrOM42
	NjzrHVNcxs47ZOpZiTtscZmipwFtDRvzDG/Md/syV27xA1HU+6xdLiWGZALrj5/5aaE6tW
	dU0iVjo+ec0Xc+vN0+8bPH12NA5IyOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772446224;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lp/Xt92lO0XbwR9i9sLl7/h6vP5h5//3md93gyhNT1o=;
	b=VlvEnnWTXORMxTEJ27cfsqXI1LQgIL2wO/mhumyGFcfV+FRp2nSaBySok5mmceRfPQ91QL
	0tHaI3HbMtw78ODA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 986033EA69;
	Mon,  2 Mar 2026 10:10:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 69u8JBBipWk0HwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 02 Mar 2026 10:10:24 +0000
Message-ID: <8c2df312-7982-45c9-8627-4919c2e78938@suse.de>
Date: Mon, 2 Mar 2026 11:10:24 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/21] nvme-auth: common: use crypto library in
 nvme_auth_augmented_challenge()
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-10-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-10-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On 3/2/26 08:59, Eric Biggers wrote:
> For the hash and HMAC computations in nvme_auth_augmented_challenge(),
> use the crypto library instead of crypto_shash.  This is simpler,
> faster, and more reliable.  Notably, this eliminates two crypto
> transformation object allocations for every call, which was very slow.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/common/auth.c | 96 ++++++++++++++------------------------
>   1 file changed, 36 insertions(+), 60 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
