Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296811CB9E5
	for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2024 15:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729004744; cv=none; b=YkXEu7FfaiekuMXmXJyKmiwF90vYj/j0g+U+ObrG4K/tLRimOFPMHugpXOLiOYILbaZxup5fbHaRSzEKya/WQLzBLp7WomqvBwTLoN8CRjyN/xdPIJ3UEZisegIpa22Vj0ddGOO8neOewt324v5zAIOckagMyio2p3xjtCBN2XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729004744; c=relaxed/simple;
	bh=E5jd1CrJvmV33pLcnCAUbcdlk4ZziDaQZzO8AZMc26E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kXo1MplO1TcFAFshG47ZLgdzNlqjaJD/eC2zUJS6bbUpOS4Z/dducjFOd1bNnxsSP41+EEFeWUzqWIsoyacBClUXRxwf9eCUAd/+F8ioK+7+RSKJiqPs6J2LBG4nksPt3C3LhhEItHpIPlyBtQGK+NxPM02OWXf2uhDd3MfTHZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JjS9k/Uz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3Yp/strL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JjS9k/Uz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3Yp/strL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JjS9k/Uz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3Yp/strL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JjS9k/Uz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3Yp/strL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 41BE71F450;
	Tue, 15 Oct 2024 15:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729004741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j4xT9U7FDOMzMZFomABcNhM50Qz+zE1JWPc8NJdw1JQ=;
	b=JjS9k/UzFZPG+OpwJbAW6Szg4sk44b8IxHSnMaSSmyaqCnGbLMf97oLaEN3nWiBAhDcoQz
	eeGuirNmd23AAe+2BWauMQ+Ec0D+e7N9PCZ46W5ZjqMNC0n4W8p87cPvOAOqcgZ+M8z35E
	kI1mjMmv/+rvU02ff/raRh6SGKX+694=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729004741;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j4xT9U7FDOMzMZFomABcNhM50Qz+zE1JWPc8NJdw1JQ=;
	b=3Yp/strLS0z7W8iBU7rxJA7dWx+HCsOd4IZeUjbauwsct3hImsvgkGrzMYAsCm4WQFAH/6
	QQoX9IQmdQ/rYABQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="JjS9k/Uz";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="3Yp/strL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729004741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j4xT9U7FDOMzMZFomABcNhM50Qz+zE1JWPc8NJdw1JQ=;
	b=JjS9k/UzFZPG+OpwJbAW6Szg4sk44b8IxHSnMaSSmyaqCnGbLMf97oLaEN3nWiBAhDcoQz
	eeGuirNmd23AAe+2BWauMQ+Ec0D+e7N9PCZ46W5ZjqMNC0n4W8p87cPvOAOqcgZ+M8z35E
	kI1mjMmv/+rvU02ff/raRh6SGKX+694=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729004741;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j4xT9U7FDOMzMZFomABcNhM50Qz+zE1JWPc8NJdw1JQ=;
	b=3Yp/strLS0z7W8iBU7rxJA7dWx+HCsOd4IZeUjbauwsct3hImsvgkGrzMYAsCm4WQFAH/6
	QQoX9IQmdQ/rYABQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2229113A42;
	Tue, 15 Oct 2024 15:05:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id su1oAMWEDmfaEQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 15 Oct 2024 15:05:41 +0000
Message-ID: <e9ea2690-b3ac-47f0-a148-9e355841b6d0@suse.de>
Date: Tue, 15 Oct 2024 17:05:40 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] crypto,fs: Separate out hkdf_extract() and
 hkdf_expand()
To: Eric Biggers <ebiggers@kernel.org>, Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org,
 linux-crypto@vger.kernel.org
References: <20241011155430.43450-1-hare@kernel.org>
 <20241011155430.43450-2-hare@kernel.org>
 <20241014193814.GB1137@sol.localdomain>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241014193814.GB1137@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 41BE71F450
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim,suse.de:mid];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 10/14/24 21:38, Eric Biggers wrote:
> On Fri, Oct 11, 2024 at 05:54:22PM +0200, Hannes Reinecke wrote:
>> Separate out the HKDF functions into a separate module to
>> to make them available to other callers.
>> And add a testsuite to the module with test vectors
>> from RFC 5869 to ensure the integrity of the algorithm.
> 
> integrity => correctness
> 
Okay.

>> +config CRYPTO_HKDF
>> +	tristate
>> +	select CRYPTO_SHA1 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
>> +	select CRYPTO_SHA256 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
>> +	select CRYPTO_HASH2
> 
> Any thoughts on including SHA512 tests instead of SHA1, given that SHA1 is
> obsolete and should not be used?
> 
Hmm. The original implementation did use SHA1, so I used that.
But sure I can look into changing that.

>> +int hkdf_expand(struct crypto_shash *hmac_tfm,
>> +		const u8 *info, unsigned int infolen,
>> +		u8 *okm, unsigned int okmlen)
>> +{
>> +	SHASH_DESC_ON_STACK(desc, hmac_tfm);
>> +	unsigned int i, hashlen = crypto_shash_digestsize(hmac_tfm);
>> +	int err;
>> +	const u8 *prev = NULL;
>> +	u8 counter = 1;
>> +	u8 tmp[HASH_MAX_DIGESTSIZE];
>> +
>> +	if (WARN_ON(okmlen > 255 * hashlen ||
>> +		    hashlen > HASH_MAX_DIGESTSIZE))
>> +		return -EINVAL;
> 
> The crypto API guarantees HASH_MAX_DIGESTSIZE, so checking that again is not
> very useful.
> 
Okay, will be removing that check.

>> +
>> +	memzero_explicit(tmp, HASH_MAX_DIGESTSIZE);
> 
> The zeroization above is unnecessary.  If it's done anyway, it is just an
> initialization, so it should use an initializer '= {}' instead of
> memzero_explicit() which is intended for "destruction".
> 
Ok.

>> +MODULE_ALIAS_CRYPTO("hkdf");
> 
> This alias does not make sense and is unnecessary.  These are library functions
> that are not exposed by name through the crypto API, so there is no need to wire
> them up to the module autoloading accordingly.
> 
Ok.

>> diff --git a/include/crypto/hkdf.h b/include/crypto/hkdf.h
>> new file mode 100644
>> index 000000000000..c1f23a32a6b6
>> --- /dev/null
>> +++ b/include/crypto/hkdf.h
>> @@ -0,0 +1,18 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * HKDF: HMAC-based Key Derivation Function (HKDF), RFC 5869
>> + *
>> + * Extracted from fs/crypto/hkdf.c, which has
>> + * Copyright 2019 Google LLC
>> + */
>> +
>> +#ifndef _CRYPTO_HKDF_H
>> +#define _CRYPTO_HKDF_H
>> +
>> +int hkdf_extract(struct crypto_shash *hmac_tfm, const u8 *ikm,
>> +		 unsigned int ikmlen, const u8 *salt, unsigned int saltlen,
>> +		 u8 *prk);
>> +int hkdf_expand(struct crypto_shash *hmac_tfm,
>> +		const u8 *info, unsigned int infolen,
>> +		u8 *okm, unsigned int okmlen);
>> +#endif
> 
> This needs to include <crypto/hash.h>.
> 
> Otherwise there will be errors if someone includes this as their first header.
> 
Will do.

Thanks for the review!

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
