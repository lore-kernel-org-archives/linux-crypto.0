Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05A81E4BE
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jul 2024 06:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721715853; cv=none; b=rHAxCf47jdqsW6dEmjZKI8oFw0QVgxrT882BYJqnAraTHLIqcltUAcx2rJ0LfT3LeCCHbo5fZd7FusxHKkYtHfs7xNLVtI0cKab44xc0DybwfPHveWeAWl2kiHvqn9eUfJeyVr4iB3ntSDS/rZCmXWhGL9Ud+aSBmquLj2Y6ddw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721715853; c=relaxed/simple;
	bh=h85wNqE+j08NdTb7FARCbK1zPRBZBPxImCLWBzf4Gfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bhxl2mFlUiTWzWLA3y/YGqTHQsE/gJaTEZoPINnDNIsr+NUes/GW8VCfg6FNjdJEto4rEiQ6R9PYG3EXbkpJf/zY6Bmt1LhlZmjbYu1fj2l3lVeCzPrs0TyuWyorSlXAxd6ODIk5Ip9k3AlGWbdgaMssGIpH+SG+dhMvI2zgejA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=trJNUFkS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lgg15eu2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=trJNUFkS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lgg15eu2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="trJNUFkS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lgg15eu2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="trJNUFkS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lgg15eu2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F2F021F387;
	Tue, 23 Jul 2024 06:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721715850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OEITy78FO3t1YAeFiajyfi1Xs3jFEWuZv1WjhZ+fRqM=;
	b=trJNUFkSTaIrBRM+mVB0xq26WbigzX7MINh1+f2X+/iCcuC7Qg7yaN3EOt7A2S+YfBCAHj
	bAE2y19VknyWuMMTv3qI0m1M65WcAAMF5C+Q7x+9HkhZA3EPAR97tuTuRM8PieUjbSqZiS
	BH+jJ8MFjh30XwQJvbk9FLP6yaTx3AM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721715850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OEITy78FO3t1YAeFiajyfi1Xs3jFEWuZv1WjhZ+fRqM=;
	b=lgg15eu2LB6oIU0jjfJsEazUNp/Xrgcgg9lmp5+VCsbyaizzoTN71e5InAhVmpSeI42U5p
	3KMOHs6DFrJ9SbBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=trJNUFkS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lgg15eu2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721715850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OEITy78FO3t1YAeFiajyfi1Xs3jFEWuZv1WjhZ+fRqM=;
	b=trJNUFkSTaIrBRM+mVB0xq26WbigzX7MINh1+f2X+/iCcuC7Qg7yaN3EOt7A2S+YfBCAHj
	bAE2y19VknyWuMMTv3qI0m1M65WcAAMF5C+Q7x+9HkhZA3EPAR97tuTuRM8PieUjbSqZiS
	BH+jJ8MFjh30XwQJvbk9FLP6yaTx3AM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721715850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OEITy78FO3t1YAeFiajyfi1Xs3jFEWuZv1WjhZ+fRqM=;
	b=lgg15eu2LB6oIU0jjfJsEazUNp/Xrgcgg9lmp5+VCsbyaizzoTN71e5InAhVmpSeI42U5p
	3KMOHs6DFrJ9SbBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 973D213888;
	Tue, 23 Jul 2024 06:24:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gAC3IolMn2b7QgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 23 Jul 2024 06:24:09 +0000
Message-ID: <08bd78ee-d772-44a3-a89a-c9c0bb27e487@suse.de>
Date: Tue, 23 Jul 2024 08:24:09 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] crypto,fs: Separate out hkdf_extract() and
 hkdf_expand()
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>, Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-crypto@vger.kernel.org,
 linux-nvme@lists.infradead.org
References: <20240722142122.128258-1-hare@kernel.org>
 <20240722142122.128258-2-hare@kernel.org>
 <20240723013602.GA2319848@google.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240723013602.GA2319848@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.30 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: F2F021F387

On 7/23/24 03:36, Eric Biggers wrote:
> On Mon, Jul 22, 2024 at 04:21:14PM +0200, Hannes Reinecke wrote:
>> diff --git a/crypto/Makefile b/crypto/Makefile
>> index edbbaa3ffef5..b77fc360f0ff 100644
>> --- a/crypto/Makefile
>> +++ b/crypto/Makefile
>> @@ -29,6 +29,7 @@ obj-$(CONFIG_CRYPTO_ECHAINIV) += echainiv.o
>>   
>>   crypto_hash-y += ahash.o
>>   crypto_hash-y += shash.o
>> +crypto_hash-y += hkdf.o
>>   obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
> 
> This should go under a kconfig option CONFIG_CRYPTO_HKDF that is selected by the
> users that need it.  That way the code will be built only when needed.
> 
Okay.

> Including a self-test would also be desirable.
> 
First time for me, but ok.

>> diff --git a/crypto/hkdf.c b/crypto/hkdf.c
>> new file mode 100644
>> index 000000000000..22e343851c0b
>> --- /dev/null
>> +++ b/crypto/hkdf.c
>> @@ -0,0 +1,112 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Implementation of HKDF ("HMAC-based Extract-and-Expand Key Derivation
>> + * Function"), aka RFC 5869.  See also the original paper (Krawczyk 2010):
>> + * "Cryptographic Extraction and Key Derivation: The HKDF Scheme".
>> + *
>> + * This is used to derive keys from the fscrypt master keys.
> 
> This is no longer in fs/crypto/, so the part about fscrypt should be removed.
> 
Will be removing this line.

>> +/*
>> + * HKDF consists of two steps:
>> + *
>> + * 1. HKDF-Extract: extract a pseudorandom key of length HKDF_HASHLEN bytes from
>> + *    the input keying material and optional salt.
> 
> It doesn't make sense to refer to HKDF_HASHLEN here since it is specific to
> fs/crypto/.
> 
Ok.

>> +/* HKDF-Extract (RFC 5869 section 2.2), unsalted */
>> +int hkdf_extract(struct crypto_shash *hmac_tfm, const u8 *ikm,
>> +		 unsigned int ikmlen, u8 *prk)
> 
> Needs kerneldoc now that this is a library interface.
> 
Indeed, will be updating the comment.

>> +{
>> +	unsigned int prklen = crypto_shash_digestsize(hmac_tfm);
>> +	u8 *default_salt;
>> +	int err;
>> +
>> +	default_salt = kzalloc(prklen, GFP_KERNEL);
>> +	if (!default_salt)
>> +		return -ENOMEM;
> 
> Now that this is a library interface, it should take the salt as a parameter,
> and the users who want the default salt should explicitly specify that.  If we
> only provide support for unsalted use, that might inadventently discourage the
> use of a salt in future code.  As the function is named hkdf_extract(), people
> might also overlook that it's unsalted and doesn't actually match the RFC's
> definition of HKDF-Extract.
> 
> The use of kzalloc here is also inefficient, as the maximum length of a digest
> is known (HKDF_HASHLEN in fs/crypto/ case, HASH_MAX_DIGESTSIZE in general).
> 
I was trying to keep the changes to the actual code to a minimum, so I 
didn't modify the calling sequence of the original code.
But sure, passing in the 'salt' as a parameter is sensible.

>> +	err = crypto_shash_setkey(hmac_tfm, default_salt, prklen);
>> +	if (!err)
>> +		err = crypto_shash_tfm_digest(hmac_tfm, ikm, ikmlen, prk);
>> +
>> +	kfree(default_salt);
>> +	return err;
>> +}
>> +EXPORT_SYMBOL_GPL(hkdf_extract);
>> +
>> +/*
>> + * HKDF-Expand (RFC 5869 section 2.3).
>> + * This expands the pseudorandom key, which was already keyed into @hmac_tfm,
>> + * into @okmlen bytes of output keying material parameterized by the
>> + * application-specific @info of length @infolen bytes.
>> + * This is thread-safe and may be called by multiple threads in parallel.
>> + */
>> +int hkdf_expand(struct crypto_shash *hmac_tfm,
>> +		const u8 *info, unsigned int infolen,
>> +		u8 *okm, unsigned int okmlen)
> 
> Needs kerneldoc now that this is a library interface.
> 
Ok.

>> diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
>> index 5a384dad2c72..9c2f9aca9412 100644
>> --- a/fs/crypto/hkdf.c
>> +++ b/fs/crypto/hkdf.c
>> // SPDX-License-Identifier: GPL-2.0
>> /*
>> * Implementation of HKDF ("HMAC-based Extract-and-Expand Key Derivation
>> * Function"), aka RFC 5869.  See also the original paper (Krawczyk 2010):
>> * "Cryptographic Extraction and Key Derivation: The HKDF Scheme".
>> *
>> * This is used to derive keys from the fscrypt master keys.
>> *
>> * Copyright 2019 Google LLC
>> */
> 
> The above file comment should be adjusted now that this file doesn't contain the
> actual HKDF implementation.
> 
Ok.

>> @@ -118,61 +105,24 @@ int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
>>   			u8 *okm, unsigned int okmlen)
>>   {
>>   	SHASH_DESC_ON_STACK(desc, hkdf->hmac_tfm);
>> -	u8 prefix[9];
>> -	unsigned int i;
>> +	u8 *prefix;
>>   	int err;
>> -	const u8 *prev = NULL;
>> -	u8 counter = 1;
>> -	u8 tmp[HKDF_HASHLEN];
>>   
>>   	if (WARN_ON_ONCE(okmlen > 255 * HKDF_HASHLEN))
>>   		return -EINVAL;
>>   
>> +	prefix = kzalloc(okmlen + 9, GFP_KERNEL);
>> +	if (!prefix)
>> +		return -ENOMEM;
>>   	desc->tfm = hkdf->hmac_tfm;
>>   
>>   	memcpy(prefix, "fscrypt\0", 8);
>>   	prefix[8] = context;
>> +	memcpy(prefix + 9, info, infolen);
> 
> This makes the variable called 'prefix' no longer be the prefix, but rather the
> full info string.  A better name for it would be 'full_info'.
> 
> Also, it's being allocated with the wrong length.  It should be 9 + infolen.
> 
Will fix it up.

>> +	err = hkdf_expand(hkdf->hmac_tfm, prefix, infolen + 8,
>> +			  okm, okmlen);
>> +	kfree(prefix);
> 
> kfree_sensitive()
> 
>> diff --git a/include/crypto/hkdf.h b/include/crypto/hkdf.h
>> new file mode 100644
>> index 000000000000..bf06c080d7ed
>> --- /dev/null
>> +++ b/include/crypto/hkdf.h
>> @@ -0,0 +1,18 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +/*
>> + * HKDF: HMAC-based Key Derivation Function (HKDF), RFC 5869
>> + *
>> + * Extracted from fs/crypto/hkdf.c, which has
>> + * Copyright 2019 Google LLC
>> + */
> 
> If this is keeping the copyright of fs/crypto/hkdf.c, the license needs to stay
> the same (GPL-2.0, not GPL-2.0-or-later).
> 
Will be modifying it.

Thanks a lot for your review!

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

