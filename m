Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1095518E772
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 06:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729060859; cv=none; b=tkx8405qOY/O+RpOdPL7/CUVG6OHyVsvq3Yp9TsO7GSfEsOFa3ZN7U3cJ8FsoGfSjxUg9dmYK3co6reBmIPbpsOAF9/FyI8IwTHr+1CtQYUhw69bqI0kP95/6Nz7U/YS+sPG69gg7Pn8q5DTF9hTOxOsWexlqK/wSEcsj9Smaeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729060859; c=relaxed/simple;
	bh=y1GkrEbMne2hN4G50vtd3yXpt91i5pbr0/N+737j6HQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tK+b3oEmvll/8X9G+Cp5MCpOPvyntxe2Z/7BT3ztfXUREDLNcCEB+cpNNQlKac3jD1wPhWRrlX517+TrUtsVOP40DcSLkRTXHHZkgBVBQ6SqdWGMyGiUuPx+uo8C60Pm3zd0M7afYoPrThUWLv2mghbgYM6F2xaB4LeucLJk+tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BHzVj3fW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gmyfamEO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uBkRXVx3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Oj1rxwVH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BHzVj3fW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gmyfamEO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uBkRXVx3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Oj1rxwVH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E388B1F839;
	Wed, 16 Oct 2024 06:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729060855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9R5uIroVqXXx3QtUxVOQW3D+wg8+A9m7sxTYmWRD9pc=;
	b=BHzVj3fWpvSNZdtCEKm1649cqZgMa7zbtVlfjriDRKG0eVlEG+yODrjDZHLbO13Mcta3Zr
	coY6TGATHNvXqftjHzlvw58fXepuy5KqSSKFTHEBQQUiCpHPOzZvJ4MJ8H7AsKl0n0kKge
	HQm7Eah1koVHFGNYMExjADQNs7t7HC4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729060855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9R5uIroVqXXx3QtUxVOQW3D+wg8+A9m7sxTYmWRD9pc=;
	b=gmyfamEOqo5i4uOrqZUmxcYXXjtgva84L1x5aMlvtpUzXuY6k9IjdrngvKRq/nH5SvfN4Y
	8OCp9wSsDonA0pCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uBkRXVx3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Oj1rxwVH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729060854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9R5uIroVqXXx3QtUxVOQW3D+wg8+A9m7sxTYmWRD9pc=;
	b=uBkRXVx3ybptv43P25tpsq6Nq8+gU8Phr9pC0E9BZVI5K1U4QmXv/OLSoYHJiQ5/HBGwCb
	+08J2dIxTR55WfXfNNPc95fsuX3yc9LnQEa+dMQdS+HJtUY/RC9HDQIJ5PUn9s0xFynqUJ
	GTnxPj1qEmcv+kPHxYb9pcvO37375ok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729060854;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9R5uIroVqXXx3QtUxVOQW3D+wg8+A9m7sxTYmWRD9pc=;
	b=Oj1rxwVHhTuCe+gpjFgJ6PyggTy8rMk6nKryEWb4qiizMfxMS8T+Oga2S/Gue34I1Q7p8s
	NtSaN9pJnGuXnOBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9931613433;
	Wed, 16 Oct 2024 06:40:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id esS1I/ZfD2fdBQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 16 Oct 2024 06:40:54 +0000
Message-ID: <83934544-0e4e-42eb-a15b-8189a46273c7@suse.de>
Date: Wed, 16 Oct 2024 08:40:54 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] crypto,fs: Separate out hkdf_extract() and
 hkdf_expand()
To: Eric Biggers <ebiggers@kernel.org>
Cc: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20241011155430.43450-1-hare@kernel.org>
 <20241011155430.43450-2-hare@kernel.org>
 <20241014193814.GB1137@sol.localdomain>
 <e9ea2690-b3ac-47f0-a148-9e355841b6d0@suse.de>
 <20241015154110.GA2444622@google.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241015154110.GA2444622@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E388B1F839
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 10/15/24 17:41, Eric Biggers wrote:
> On Tue, Oct 15, 2024 at 05:05:40PM +0200, Hannes Reinecke wrote:
>> On 10/14/24 21:38, Eric Biggers wrote:
>>> On Fri, Oct 11, 2024 at 05:54:22PM +0200, Hannes Reinecke wrote:
>>>> Separate out the HKDF functions into a separate module to
>>>> to make them available to other callers.
>>>> And add a testsuite to the module with test vectors
>>>> from RFC 5869 to ensure the integrity of the algorithm.
>>>
>>> integrity => correctness
>>>
>> Okay.
>>
>>>> +config CRYPTO_HKDF
>>>> +	tristate
>>>> +	select CRYPTO_SHA1 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
>>>> +	select CRYPTO_SHA256 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
>>>> +	select CRYPTO_HASH2
>>>
>>> Any thoughts on including SHA512 tests instead of SHA1, given that SHA1 is
>>> obsolete and should not be used?
>>>
>> Hmm. The original implementation did use SHA1, so I used that.
>> But sure I can look into changing that.
> 
> If you're talking about fs/crypto/hkdf.c which is where you're borrowing the
> code from, that uses SHA512.
> 
Actually, I was talking about the test vectors themselves. RFC 5869 only 
gives test vectors for SHA1 and SHA256, so that's what I've used.
I've found additional test vectors for the other functions at
https://github.com/brycx/Test-Vector-Generation/blob/master/HKDF/hkdf-hmac-sha2-test-vectors.md
so I'll be using them for adding tests for SHA384 and SHA512 (TLS on 
NVMe-over-TCP is using SHA384, too) and delete the SHA1 ones.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

