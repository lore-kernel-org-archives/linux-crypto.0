Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9623112AD
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523944; cv=none; b=fgIV/XryS92jLInKDpsPqVuNwOGQA8F5OKzYUr8jlyELiipCidcXgySyruKLUnj/qvJuXUDo8dbSqUef9wyN8+zU3vMTkgA8UOAnFKbI8Zvyt+LwKhI2Mx77TEaiirQH/GwXUyQRatR58pAz0lTZwO4k9wJex8BWX48UEHKHSf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523944; c=relaxed/simple;
	bh=rQfV+H+sTLJK2b9ovytFw3VPddQS59WDloIG/vOrq4w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l7uO3ZJomwPdj21n57W/5EDmbx+GfBHNowu6IdFELTaGYzVbD/Npt98xaLqz0JKljHeOm70R0RWvYm/ekz9ikCjioNN8f8yvvzAUN+BhEKOuYhlmRdSpqjR3OQVQdEoIumg3cDUy7FDKnuQY54TKxjoHS7Al9aB5QhfMKDyDINg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zC+AYLb7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZMzm1Fo6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zC+AYLb7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZMzm1Fo6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zC+AYLb7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZMzm1Fo6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zC+AYLb7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZMzm1Fo6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3DB925BDE6;
	Tue,  3 Mar 2026 07:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2BH4cVTR346OxZ9Nd+HiNV4zlvPtz1v2wgxn2sOYm0E=;
	b=zC+AYLb7+iGeKXe3oChAdfiZy9839z+KxQ2aLvvqMeHBBTV03No4b1t1OrMRPJDtOe44e3
	oFEJV2b7hPVOPbLF2WIaLWG0NhhX8MqGyKc7+HYXR8QpwjuqDT8iUvD+Z6t4SVET7CAh3B
	MHSfkR2kvErPOB0cxMoGSW2LDw94kjQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523941;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2BH4cVTR346OxZ9Nd+HiNV4zlvPtz1v2wgxn2sOYm0E=;
	b=ZMzm1Fo6xIk7k7KKkt5Zwbyxwsg46KsXG2L80F4p9ekc5Yqz1tjrVGGSHhPqyqUqrOa75d
	rBMl3S4vY4epcSBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zC+AYLb7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZMzm1Fo6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2BH4cVTR346OxZ9Nd+HiNV4zlvPtz1v2wgxn2sOYm0E=;
	b=zC+AYLb7+iGeKXe3oChAdfiZy9839z+KxQ2aLvvqMeHBBTV03No4b1t1OrMRPJDtOe44e3
	oFEJV2b7hPVOPbLF2WIaLWG0NhhX8MqGyKc7+HYXR8QpwjuqDT8iUvD+Z6t4SVET7CAh3B
	MHSfkR2kvErPOB0cxMoGSW2LDw94kjQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523941;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2BH4cVTR346OxZ9Nd+HiNV4zlvPtz1v2wgxn2sOYm0E=;
	b=ZMzm1Fo6xIk7k7KKkt5Zwbyxwsg46KsXG2L80F4p9ekc5Yqz1tjrVGGSHhPqyqUqrOa75d
	rBMl3S4vY4epcSBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB62C3EA69;
	Tue,  3 Mar 2026 07:45:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xCUKK6SRpmkyWwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Mar 2026 07:45:40 +0000
Message-ID: <4fbdb2aa-dacb-4669-a487-86bf03914ea6@suse.de>
Date: Tue, 3 Mar 2026 08:45:36 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/21] nvme-auth: common: remove selections of no-longer
 used crypto modules
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-21-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-21-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3DB925BDE6

On 3/2/26 08:59, Eric Biggers wrote:
> Now that nvme-auth uses the crypto library instead of crypto_shash,
> remove obsolete selections from the NVME_AUTH kconfig option.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/common/Kconfig | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/nvme/common/Kconfig b/drivers/nvme/common/Kconfig
> index 1ec507d1f9b5f..f1639db65fd38 100644
> --- a/drivers/nvme/common/Kconfig
> +++ b/drivers/nvme/common/Kconfig
> @@ -5,16 +5,12 @@ config NVME_KEYRING
>          select KEYS
>   
>   config NVME_AUTH
>   	tristate
>   	select CRYPTO
> -	select CRYPTO_HMAC
> -	select CRYPTO_SHA256
> -	select CRYPTO_SHA512
>   	select CRYPTO_DH
>   	select CRYPTO_DH_RFC7919_GROUPS
> -	select CRYPTO_HKDF
>   	select CRYPTO_LIB_SHA256
>   	select CRYPTO_LIB_SHA512
>   
>   config NVME_AUTH_KUNIT_TEST
>   	tristate "KUnit tests for NVMe authentication" if !KUNIT_ALL_TESTS

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
