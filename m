Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B08A148FE6
	for <linux-crypto@vger.kernel.org>; Thu, 29 Aug 2024 10:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724927977; cv=none; b=QNKnHUR4FOFsrUuVSrwsExVejzP4lWeo1vuHeLwWTY0f5KsJBYZrWdoqSl9YK1vjZBx+T72HXwH/Es7La7MhBDMVh7p+z13cHair/OLyMTnsmHpef2CRbOMFjPshQxDwy7PmdbK/Vy6q42490SYfWh4/ukrzLVfHj/EK5OsgwYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724927977; c=relaxed/simple;
	bh=OweuFUKQAOjxbdDkOEDUOSR7IxRw309TxNZ08ivM0Y4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z2tAiSVKHcSbuZt55dGxmFW2hfSSJbeYKm7LzJj2/ffT9z6r4wLwx2WL4VpBajJ1fH2rnn6L4WEbhBgFGmaSBLBd82hRbbSvY0cKOL/tuC4RCIGqqRXIGr3asQ+h0+m8j8QpnK4iTkRbwo1EjKZ3DMSPgmUcoA8aRVpCZOLBvRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GTNVpHSg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xBiO97bT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GTNVpHSg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xBiO97bT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GTNVpHSg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xBiO97bT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GTNVpHSg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xBiO97bT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 73AD92198F;
	Thu, 29 Aug 2024 10:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1724927973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=umAStsEu04FsvooHLwG3t9d1B3HZBKR11TXDxfQmkyk=;
	b=GTNVpHSg4DSyId8y/KBi3DEgL/NBVtt7LA6X2mezPgGOtapNM7xCryTlvsPc6NTNfNvoZu
	3nr09imU18rKA6tMHP+eHwu24F0YrSIu5eXUQpmFlo31L3VPfOzkDIFUM2DGDpvxp1KvcO
	jno8OqmTQaUhlWCH7zgMY06hSL3nm8Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1724927973;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=umAStsEu04FsvooHLwG3t9d1B3HZBKR11TXDxfQmkyk=;
	b=xBiO97bTOgBqiQeyxIeFRDQVB4+9lNOX9MqLe3NSPE3lSz/hRyjs/QI8Ga6fK2UutzD7AU
	N7StbYX9bM+lu+Dg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GTNVpHSg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xBiO97bT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1724927973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=umAStsEu04FsvooHLwG3t9d1B3HZBKR11TXDxfQmkyk=;
	b=GTNVpHSg4DSyId8y/KBi3DEgL/NBVtt7LA6X2mezPgGOtapNM7xCryTlvsPc6NTNfNvoZu
	3nr09imU18rKA6tMHP+eHwu24F0YrSIu5eXUQpmFlo31L3VPfOzkDIFUM2DGDpvxp1KvcO
	jno8OqmTQaUhlWCH7zgMY06hSL3nm8Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1724927973;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=umAStsEu04FsvooHLwG3t9d1B3HZBKR11TXDxfQmkyk=;
	b=xBiO97bTOgBqiQeyxIeFRDQVB4+9lNOX9MqLe3NSPE3lSz/hRyjs/QI8Ga6fK2UutzD7AU
	N7StbYX9bM+lu+Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 501AC139B0;
	Thu, 29 Aug 2024 10:39:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gTIKE+VP0GZ6CQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 29 Aug 2024 10:39:33 +0000
Message-ID: <0697a6c9-85a3-4f56-879c-b096fb5072b8@suse.de>
Date: Thu, 29 Aug 2024 12:39:33 +0200
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
References: <20240813111512.135634-1-hare@kernel.org>
 <20240813111512.135634-2-hare@kernel.org>
 <20240827175225.GA2049@sol.localdomain>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240827175225.GA2049@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 73AD92198F
X-Spam-Level: 
X-Spamd-Result: default: False [-6.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -6.51
X-Spam-Flag: NO

On 8/27/24 19:52, Eric Biggers wrote:
> On Tue, Aug 13, 2024 at 01:15:04PM +0200, Hannes Reinecke wrote:
>> Separate out the HKDF functions into a separate module to
>> to make them available to other callers.
>> And add a testsuite to the module with test vectors
>> from RFC 5869 to ensure the integrity of the algorithm.
[ .. ]
>> +	desc->tfm = hmac_tfm;
>> +
>> +	for (i = 0; i < okmlen; i += hashlen) {
>> +
>> +		err = crypto_shash_init(desc);
>> +		if (err)
>> +			goto out;
>> +
>> +		if (prev) {
>> +			err = crypto_shash_update(desc, prev, hashlen);
>> +			if (err)
>> +				goto out;
>> +		}
>> +
>> +		if (info && infolen) {
> 
> 'if (infolen)' instead of 'if (info && infolen)'.  The latter is a bad practice
> because it can hide bugs.
> 
Do I need to set a 'WARN_ON(!info)' (or something) in this case? Or are 
the '->update' callbacks expected to handle it themselves?

[ .. ]
>> diff --git a/include/crypto/hkdf.h b/include/crypto/hkdf.h
>> new file mode 100644
>> index 000000000000..ee3e7d21a5fe
>> --- /dev/null
>> +++ b/include/crypto/hkdf.h
>> @@ -0,0 +1,34 @@
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
>> +#ifdef CONFIG_CRYPTO_HKDF
>> +int hkdf_extract(struct crypto_shash *hmac_tfm, const u8 *ikm,
>> +		 unsigned int ikmlen, const u8 *salt, unsigned int saltlen,
>> +		 u8 *prk);
>> +int hkdf_expand(struct crypto_shash *hmac_tfm,
>> +		const u8 *info, unsigned int infolen,
>> +		u8 *okm, unsigned int okmlen);
>> +#else
>> +static inline int hkdf_extract(struct crypto_shash *hmac_tfm,
>> +			       const u8 *ikm, unsigned int ikmlen,
>> +			       const u8 *salt, unsigned int saltlen,
>> +			       u8 *prk)
>> +{
>> +	return -ENOTSUP;
>> +}
>> +static inline int hkdf_expand(struct crypto_shash *hmac_tfm,
>> +			      const u8 *info, unsigned int infolen,
>> +			      u8 *okm, unsigned int okmlen)
>> +{
>> +	return -ENOTSUP;
>> +}
>> +#endif
>> +#endif
> 
> This header is missing <crypto/hash.h> which it depends on.
> 
> Also the !CONFIG_CRYPTO_HKDF stubs are unnecessary and should not be included.
> 
But that would mean that every call to '#include <crypto/hkdf.h>' would 
need to be encapsulated by 'CONFIG_CRYPTO_HKDF' (or the file itself is
conditionally compiled on that symbol).
Is that the direction you want to head?

Thanks for the review!

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

