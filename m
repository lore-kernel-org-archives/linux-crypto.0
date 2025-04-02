Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D09136A
	for <linux-crypto@vger.kernel.org>; Wed,  2 Apr 2025 06:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743573914; cv=none; b=Lh8bfNw7PZXQrwI+irqjdhT0bzCdoHZRJBeiAqq5JNGioq+DNNCN+3V2Noh4uAFn+znAlP1dH3Yr2GJqjuazCGddXoqt1Lg4u8N0IDTah+wS3Wxut3OwiVoJ0+Vi6syRSZw+/eMbdNK7YySQ09yUk3XNJZqL5ASPTR6aE40QMXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743573914; c=relaxed/simple;
	bh=z52db7Alic/MyhVNgML3R++VtkTV6ul+HbHtTBsNhZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FnPy5lLN6neGFWWdK712heF7p3fTzJmbmTwHfzONkrP6LWhygNVIlmxFmtJj0vzzgyCE+hCKOOnCwrcAdXMsKwRNu0eycOZ23hlPuuiw811U7XtlP6Tp2kC5qM4YuMO5EVBRzB+PONJSh/3iQWhUVENYnYeoFuewl2ctkfAzlGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OcqffsnO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iyMKy8gD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OcqffsnO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iyMKy8gD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OcqffsnO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iyMKy8gD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OcqffsnO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iyMKy8gD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F27EB1F445;
	Wed,  2 Apr 2025 06:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1743573911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mHawtca0ZbdMVxnPz3HbR330xVHKj61w7MmZxOEahMI=;
	b=OcqffsnOFgVhm4WhK6IdG+lYOJhVY0/HubyK76GtcudMuNxsYELVHMK3KZ9u9QgWKcWyZx
	F8bmHAqgGvwoyM6hoKo6JQvsYu7NhL7Fx7RBFFcv0PpDbd2r5la3QPgHidqntA+7ZdDgKc
	b4P+4d3l/0PX4EluYFI05/aQGsZ6CSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1743573911;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mHawtca0ZbdMVxnPz3HbR330xVHKj61w7MmZxOEahMI=;
	b=iyMKy8gDATfO6XK2wDJFFdZhHcRXYdbpvrMx8oqPamvA19muX1yOluIqIBR3FX5Cliarnr
	ovWBltbsQDjg12Cg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OcqffsnO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iyMKy8gD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1743573911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mHawtca0ZbdMVxnPz3HbR330xVHKj61w7MmZxOEahMI=;
	b=OcqffsnOFgVhm4WhK6IdG+lYOJhVY0/HubyK76GtcudMuNxsYELVHMK3KZ9u9QgWKcWyZx
	F8bmHAqgGvwoyM6hoKo6JQvsYu7NhL7Fx7RBFFcv0PpDbd2r5la3QPgHidqntA+7ZdDgKc
	b4P+4d3l/0PX4EluYFI05/aQGsZ6CSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1743573911;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mHawtca0ZbdMVxnPz3HbR330xVHKj61w7MmZxOEahMI=;
	b=iyMKy8gDATfO6XK2wDJFFdZhHcRXYdbpvrMx8oqPamvA19muX1yOluIqIBR3FX5Cliarnr
	ovWBltbsQDjg12Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7ABBE137D4;
	Wed,  2 Apr 2025 06:05:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jQtfG5bT7Gd5BAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 02 Apr 2025 06:05:10 +0000
Message-ID: <d9885697-25c2-4f2b-822d-444a10f0c78d@suse.de>
Date: Wed, 2 Apr 2025 08:05:09 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: Kconfig - correct references in config
 CRYPTO_HKDF
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Lukas Bulwahn <lbulwahn@redhat.com>
Cc: "David S . Miller" <davem@davemloft.net>,
 Hannes Reinecke <hare@kernel.org>, Keith Busch <kbusch@kernel.org>,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lukas Bulwahn <lukas.bulwahn@redhat.com>
References: <20250401121354.20897-1-lukas.bulwahn@redhat.com>
 <Z-vZKlqdAtvyeUjj@gondor.apana.org.au>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <Z-vZKlqdAtvyeUjj@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F27EB1F445
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 4/1/25 14:16, Herbert Xu wrote:
> On Tue, Apr 01, 2025 at 02:13:54PM +0200, Lukas Bulwahn wrote:
>>
>> diff --git a/crypto/Kconfig b/crypto/Kconfig
>> index dbf97c4e7c59..f601a4ec6d1a 100644
>> --- a/crypto/Kconfig
>> +++ b/crypto/Kconfig
>> @@ -143,8 +143,8 @@ config CRYPTO_ACOMP
>>   
>>   config CRYPTO_HKDF
>>   	tristate
>> -	select CRYPTO_SHA256 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
>> -	select CRYPTO_SHA512 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
>> +	select CRYPTO_SHA256 if !CRYPTO_MANAGER_DISABLE_TESTS
>> +	select CRYPTO_SHA512 if !CRYPTO_MANAGER_DISABLE_TESTS
> 
> Why not just drop CRYPTO_MANAGER_DISABLE_TESTS and select the
> SHA algorithms unconditionally?
> 
Fine with me. I was just trying to follow precedent here when creating
the original patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
