Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48B5335067
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 10:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772445961; cv=none; b=ZQ84XSzIrsPoSGR1kjyqkvQPeo0U4CMgsMv64dNfpJgEltA/M7XbqFig9fbtRSYKUZt2xt70Z9w1tCxaNXKf7OQRGLumsga2iOPxZzR50tElIl9BxOknZIhlieW694XcEksn9B8BLIUdqonKv4nYaYl2xqD6A/CLPNto4pYXHqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772445961; c=relaxed/simple;
	bh=BALwNx4OBrFK/38KHKjRXGBJqU/+v4FHrEIc/POgKnU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rs8vhI0yDuxyzgmeGRjili2E2HwH7WCIpXwTONDiBzhjVDiYeTUsvJP5xtepejPG1Y6nD4d1Ko0HGe6WLcAY/numJ9273WRYzt8rRipvGSzwOQNlvPX4b+d4Aw+qRAAz6/FQP6JnR+nR43/+v6omu9e2RjW1ipkYEpn/D+g9r3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MNxHgpJJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=88DPedVk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MNxHgpJJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=88DPedVk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MNxHgpJJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="88DPedVk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MNxHgpJJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="88DPedVk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 170E93F9BB;
	Mon,  2 Mar 2026 10:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772445958; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qVChAO171ajg/wsgH5z25YqjnCm/E5UW7OHtL7PpYMA=;
	b=MNxHgpJJvG9zUUIcznRRARchtVIz1WOuARqRydm9ifMD+F2iyEWNvbxhSkxBt/Tf/8GlCn
	evPZqyauMKNhMnkIoSW8TnF5bFB9RLOWpOx0U4AH4M5lCxBTgek38OZ1O7W/+slB9wR3yd
	Xv9d+z7lOKzM1zwTEY2qsgvsKOomFs8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772445958;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qVChAO171ajg/wsgH5z25YqjnCm/E5UW7OHtL7PpYMA=;
	b=88DPedVkwNZuYTmKqiAaAK6fhkwe1+A8Q0exOx4vMKu22s92FaqR3d+/7aPAbyMX2CuYQI
	ulgEwwL+X/pd6PCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772445958; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qVChAO171ajg/wsgH5z25YqjnCm/E5UW7OHtL7PpYMA=;
	b=MNxHgpJJvG9zUUIcznRRARchtVIz1WOuARqRydm9ifMD+F2iyEWNvbxhSkxBt/Tf/8GlCn
	evPZqyauMKNhMnkIoSW8TnF5bFB9RLOWpOx0U4AH4M5lCxBTgek38OZ1O7W/+slB9wR3yd
	Xv9d+z7lOKzM1zwTEY2qsgvsKOomFs8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772445958;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qVChAO171ajg/wsgH5z25YqjnCm/E5UW7OHtL7PpYMA=;
	b=88DPedVkwNZuYTmKqiAaAK6fhkwe1+A8Q0exOx4vMKu22s92FaqR3d+/7aPAbyMX2CuYQI
	ulgEwwL+X/pd6PCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF0973EA69;
	Mon,  2 Mar 2026 10:05:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U7LeOQVhpWlPGgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 02 Mar 2026 10:05:57 +0000
Message-ID: <148d0d2c-8996-43c5-a8ab-10231818ecc7@suse.de>
Date: Mon, 2 Mar 2026 11:05:57 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/21] nvme-auth: common: explicitly verify psk_len ==
 hash_len
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-7-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-7-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.28
X-Spam-Level: 
X-Spamd-Result: default: False [-4.28 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.18)[-0.898];
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
> nvme_auth_derive_tls_psk() is always called with psk_len == hash_len.
> And based on the comments above nvme_auth_generate_psk() and
> nvme_auth_derive_tls_psk(), this isn't an implementation choice but
> rather just the length the spec uses.  Add a check which makes this
> explicit, so that when cleaning up nvme_auth_derive_tls_psk() we don't
> have to retain support for arbitrary values of psk_len.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/common/auth.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
> index 2f83c9ddea5ec..9e33fc02cf51a 100644
> --- a/drivers/nvme/common/auth.c
> +++ b/drivers/nvme/common/auth.c
> @@ -786,10 +786,15 @@ int nvme_auth_derive_tls_psk(int hmac_id, const u8 *psk, size_t psk_len,
>   		pr_warn("%s: unsupported hash algorithm %s\n",
>   			__func__, hmac_name);
>   		return -EINVAL;
>   	}
>   
> +	if (psk_len != nvme_auth_hmac_hash_len(hmac_id)) {
> +		pr_warn("%s: unexpected psk_len %zu\n", __func__, psk_len);
> +		return -EINVAL;
> +	}
> +
>   	hmac_tfm = crypto_alloc_shash(hmac_name, 0, 0);
>   	if (IS_ERR(hmac_tfm))
>   		return PTR_ERR(hmac_tfm);
>   
>   	prk_len = crypto_shash_digestsize(hmac_tfm);

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
