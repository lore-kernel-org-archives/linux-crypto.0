Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6259D2E7193
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 06:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755758676; cv=none; b=l4bfPfeSVqOPTqoa9DQTimJfAoEK7k+bYAic/kvr7ihbxzQ6UtSWQyq3aVE0ywxDsU7RxetPcav2Nw+ol4TBhCq+ULdI+MEG8qnttmtaS/rvhY5lrtCPCk1t8ocG8T9csM4lSB+Sb60pkWZJ2y7CGyqHn4kG8BcgWFPONBWzv18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755758676; c=relaxed/simple;
	bh=DBGOH3d61zhvqWlu+J6jtwyvSoxInWWlJNYDnLBd8GE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nwHdVCFOTUlc+37MvUZiWg7A3WQhp0KGAycZOOq+LxnhNgFcvsEFu/PD4ytsgzAYGNDSBdaaycqlODIdl6RbrVtnzgUf7A/nZMgKF3v3tzALhH4FpcP49yI9pDic07pnrMu363vFOz1lIsLo/MYQwUHFIk6ECngj3qe+XoClYCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EMg1YY39; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9XINEA2B; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EMg1YY39; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9XINEA2B; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EMg1YY39";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9XINEA2B";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EMg1YY39";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9XINEA2B"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 79FD821B7A;
	Thu, 21 Aug 2025 06:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755758672; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=InAkVj+0f+oTzBZfDquhzuW4FV55ImDwZNuzKyalzN4=;
	b=EMg1YY39lUV1WnRRXT4Do5vuoHg8AYBnWDKrAlnrIAPhff+53QDtiVgglJKt8UFypl9BFC
	9sOeGxnIskDgeaG0Xifg5MuM5154G7KO+t+Gllf2IW/TrdhU+848VsExsCW2zjJx0l3k90
	EOn+VPll9JmEaVOa2XYhiqkvsiQsJOw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755758672;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=InAkVj+0f+oTzBZfDquhzuW4FV55ImDwZNuzKyalzN4=;
	b=9XINEA2B79CDhHIc0UDQQnpP3zenhRVfr7vV2WuyJ3rOLpDc1eqHOB0BgIPJhcZ8w8PHBN
	mieu7sIekWCCG6BA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755758672; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=InAkVj+0f+oTzBZfDquhzuW4FV55ImDwZNuzKyalzN4=;
	b=EMg1YY39lUV1WnRRXT4Do5vuoHg8AYBnWDKrAlnrIAPhff+53QDtiVgglJKt8UFypl9BFC
	9sOeGxnIskDgeaG0Xifg5MuM5154G7KO+t+Gllf2IW/TrdhU+848VsExsCW2zjJx0l3k90
	EOn+VPll9JmEaVOa2XYhiqkvsiQsJOw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755758672;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=InAkVj+0f+oTzBZfDquhzuW4FV55ImDwZNuzKyalzN4=;
	b=9XINEA2B79CDhHIc0UDQQnpP3zenhRVfr7vV2WuyJ3rOLpDc1eqHOB0BgIPJhcZ8w8PHBN
	mieu7sIekWCCG6BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2544B13867;
	Thu, 21 Aug 2025 06:44:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ILJlB1DApmhmdgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 21 Aug 2025 06:44:32 +0000
Message-ID: <2b51c5ce-23cf-41ac-ba98-3eea7a67f1c0@suse.de>
Date: Thu, 21 Aug 2025 08:44:31 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: hkdf: add hkdf_expand_label()
To: Chris Leech <cleech@redhat.com>, Eric Biggers <ebiggers@kernel.org>
Cc: hare@kernel.org, Christoph Hellwig <hch@lst.de>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 linux-nvme@lists.infradead.org, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
References: <20250820091211.25368-1-hare@kernel.org>
 <20250820091211.25368-2-hare@kernel.org> <20250820184633.GB1838@quark>
 <aKYmhusP6povB_TU@my-developer-toolbox-latest>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aKYmhusP6povB_TU@my-developer-toolbox-latest>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 8/20/25 21:48, Chris Leech wrote:
> On Wed, Aug 20, 2025 at 11:46:33AM -0700, Eric Biggers wrote:
>> On Wed, Aug 20, 2025 at 11:12:10AM +0200, hare@kernel.org wrote:
>>> From: Chris Leech <cleech@redhat.com>
>>>
>>> Provide an implementation of RFC 8446 (TLS 1.3) HKDF-Expand-Label
>>>
>>> Cc: Eric Biggers <ebiggers@kernel.org>
>>> Signed-off-by: Chris Leech <cleech@redhat.com>
>>> Signed-off-by: Hannes Reinecke <hare@kernel.org>
>>> ---
>>>   crypto/hkdf.c         | 55 +++++++++++++++++++++++++++++++++++++++++++
>>>   include/crypto/hkdf.h |  4 ++++
>>>   2 files changed, 59 insertions(+)
>>>
>>> ...
>>
>> Does this belong in crypto/hkdf.c?  It seems to be specific to a
>> particular user of HKDF.
> 
> While this is needed for NVMe/TLS, it's a case of the NVMe
> specifications referencing a function defined in the TLS 1.3 RFC to be
> used.  I though it would be clearest to fix the open-coded implemenation
> by creating an RFC complient function, which is now no-longer specific
> to NVMe so I moved it out to crypto/hkdf.c
> 
> I don't know that there will be other users, it just seemed to make the
> most sense there.
> 
But having said that, we can easily move it into the nvme code, and let
others move it into crypto if there is a need.
Will be updating the patchset.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
