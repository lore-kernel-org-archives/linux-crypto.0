Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF5813C838
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jul 2024 06:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721715979; cv=none; b=MW6zibnGkQnrZMWDdl0X768XhBIIpwH2v4OfMik5RdpQm8SoaQZlMkOQ65p3y/KKhl39m9lcLNYmdETpUb+0qwl6fkiGW0mbAaZ+cMQOCF9jw9Qb1LIcdYKZwnUpBddFQGD07/nQFQDjpzNk+NDksRTNaS2bIcwA+XcVrNl+DkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721715979; c=relaxed/simple;
	bh=vJfyGkkJ6paFRI1owsV8tkJ4WHqP9mCQHgd1DR0nWQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cJgozfkQw+ZSckStS3ircrpZK9Cr36M1d1mIJME5nIbeyTFLU4JKZOwuuFRFj3VeaaDAbx2BTyitEPbUdzWKA+Ul+6T3QI56U0ixyEGtoMLTH+NCErUo7QrqsxTZDieZDhJZBaOLvRztnOtbpk/0TJwSezDOdAbzxdqWKpaMOaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jKZYmX/h; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ONlrhsmX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=s94xDyjQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JAgPTDof; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jKZYmX/h";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ONlrhsmX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s94xDyjQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JAgPTDof"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E50541FBA2;
	Tue, 23 Jul 2024 06:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721715976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVaMf9c+l8gM9tbWJVbYHvoX5kYpyszS0eYVw3y7AhA=;
	b=jKZYmX/htBO1DYvPe0mFjDMOQJ89BnLi+V9i43DyMI8u4L/hdXHXVwhLKyyK0JqUnAGEuE
	D0n7OVVC6kPQ0P7qXQUcA3nBNHCd4ITWJnKftorPteGYgH+OhAquxBiF0dgR2H0lrafWQN
	i+r1XDOLN9UzUqLOw+y/lzMnUpOkhb4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721715976;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVaMf9c+l8gM9tbWJVbYHvoX5kYpyszS0eYVw3y7AhA=;
	b=ONlrhsmXd5ATkdjqoNbd0sxywSdSsIX8K0An/VoD8w1fvrRhgdagZNuu7X6fU0fqFyQ0ic
	ZGHCTDVsOwsEvHCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721715975; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVaMf9c+l8gM9tbWJVbYHvoX5kYpyszS0eYVw3y7AhA=;
	b=s94xDyjQGUEBMRpl+guIzC/nThd7sZX7nb8MBstFatd3o9lHgNTnrvP4UGsr65IZLAtsgy
	+UTT64+nnMWpc4338CYdnHAkBSaNg7MyoFKhkOmjzwqlniEL2TgrnAK1ucCj31g27f0e9M
	68vDSYHHfNle2ctBdHndjM7WFOKmycY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721715975;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVaMf9c+l8gM9tbWJVbYHvoX5kYpyszS0eYVw3y7AhA=;
	b=JAgPTDofH9pvrRIZS+NPbS9h7ieW4q0LNvkb2zXNgqbMMU6QmzX9T+skxrmIUYFQMlf/AS
	Z3wAyDlIF3ppE1Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D99813888;
	Tue, 23 Jul 2024 06:26:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kQrLHgdNn2a2QwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 23 Jul 2024 06:26:15 +0000
Message-ID: <d0101bf1-5f71-4fe4-b391-e6d761c8a9e3@suse.de>
Date: Tue, 23 Jul 2024 08:26:15 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/9] nvme: add nvme_auth_derive_tls_psk()
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>, Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-crypto@vger.kernel.org,
 linux-nvme@lists.infradead.org
References: <20240722142122.128258-1-hare@kernel.org>
 <20240722142122.128258-5-hare@kernel.org>
 <20240723014715.GB2319848@google.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240723014715.GB2319848@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.09
X-Spamd-Result: default: False [-4.09 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO

On 7/23/24 03:47, Eric Biggers wrote:
> On Mon, Jul 22, 2024 at 04:21:17PM +0200, Hannes Reinecke wrote:
>> +/*
>> + * Derive a TLS PSK as specified in TP8018 Section 3.6.1.3:
>> + *   TLS PSK and PSK identity Derivation
>> + *
>> + * The TLS PSK shall be derived as follows from an input PSK
>> + * (i.e., either a retained PSK or a generated PSK) and a PSK
>> + * identity using the HKDF-Extract and HKDF-Expand-Label operations
>> + * (refer to RFC 5869 and RFC 8446) where the hash function is the
>> + * one specified by the hash specifier of the PSK identity:
>> + * 1. PRK = HKDF-Extract(0, Input PSK); and
>> + * 2. TLS PSK = HKDF-Expand-Label(PRK, "nvme-tls-psk", PskIdentityContext, L),
>> + * where PskIdentityContext is the hash identifier indicated in
>> + * the PSK identity concatenated to a space character and to the
>> + * Base64 PSK digest (i.e., "<hash> <PSK digest>") and L is the
>> + * output size in bytes of the hash function (i.e., 32 for SHA-256
>> + * and 48 for SHA-384).
>> + */
>> +int nvme_auth_derive_tls_psk(int hmac_id, u8 *psk, size_t psk_len,
>> +		u8 *psk_digest, u8 **ret_psk)
>> +{
>> +	struct crypto_shash *hmac_tfm;
>> +	const char *hmac_name;
>> +	const char *psk_prefix = "tls13 nvme-tls-psk";
>> +	size_t info_len, prk_len;
>> +	char *info;
>> +	unsigned char *prk, *tls_key;
>> +	int ret;
>> +
>> +	hmac_name = nvme_auth_hmac_name(hmac_id);
>> +	if (!hmac_name) {
>> +		pr_warn("%s: invalid hash algoritm %d\n",
>> +			__func__, hmac_id);
>> +		return -EINVAL;
>> +	}
>> +	if (hmac_id == NVME_AUTH_HASH_SHA512) {
>> +		pr_warn("%s: unsupported hash algorithm %s\n",
>> +			__func__, hmac_name);
>> +		return -EINVAL;
>> +	}
>> +
>> +	hmac_tfm = crypto_alloc_shash(hmac_name, 0, 0);
>> +	if (IS_ERR(hmac_tfm))
>> +		return PTR_ERR(hmac_tfm);
>> +
>> +	prk_len = crypto_shash_digestsize(hmac_tfm);
>> +	prk = kzalloc(prk_len, GFP_KERNEL);
>> +	if (!prk) {
>> +		ret = -ENOMEM;
>> +		goto out_free_shash;
>> +	}
>> +
>> +	ret = hkdf_extract(hmac_tfm, psk, psk_len, prk);
>> +	if (ret)
>> +		goto out_free_prk;
>> +
>> +	ret = crypto_shash_setkey(hmac_tfm, prk, prk_len);
>> +	if (ret)
>> +		goto out_free_prk;
>> +
>> +	info_len = strlen(psk_digest) + strlen(psk_prefix) + 1;
>> +	info = kzalloc(info_len, GFP_KERNEL);
>> +	if (!info)
>> +		goto out_free_prk;
>> +
>> +	memcpy(info, psk_prefix, strlen(psk_prefix));
>> +	memcpy(info + strlen(psk_prefix), psk_digest, strlen(psk_digest));
> 
> The code doesn't match the description given in the function comment (which
> looks like it was quoted from a specification).
> 
> The code does HKDF-Expand with info="tls13 nvme-tls-psk<PSK digest>".
> 
> The description does HKDF-Expand-Label with Label="nvme-tls-psk",
> Context="<hash identifier> <PSK digest>", Length=digest_size.
> 
> Not only does the code not actually use <hash identifier>, but it doesn't follow
> the definition of HKDF-Expand-Label from RFC8446
> (https://datatracker.ietf.org/doc/html/rfc8446#section-7.1) in that it's missing
> all the length fields.  So the info string used by the actual code ends up being
> quite different from the one specified.
> 
Aw. Guess you are right. Will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

