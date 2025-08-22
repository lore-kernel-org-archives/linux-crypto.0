Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7A37262F
	for <linux-crypto@vger.kernel.org>; Fri, 22 Aug 2025 06:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755842943; cv=none; b=TjwJJxDgYv04kTJr5RpPW5bdsGcz6LJd3M1GdLYU4SsBWEriYpeYPMp8SPNY/vRQ5fsqccTQsoIZ2vomeoORgYCUdXQ0kQBYnNe4f6RABHRXDnP/DX4wAnsphICVdFlVilvXdKDEOcUKkH0chGeAW6FGAzz0dpFb4dW8PzTW11A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755842943; c=relaxed/simple;
	bh=H92uzviLhyH08OGG2ptnRHcEagsSnVI8O6PniX2mhdA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g3mI/syBU3HnJFUezIAkUxzwfqiSsvzjexkxG4aie2i2Oe0ICf8xl17TDXm/PPzNam6IMax8T277sZg1EzUmySZiXwv1VQNBQStfIaTJXoVOa4qMP6Bx9g5h5C9WTOfCtBv86W415Al+lpVG9dkY5HFA1mMZj9oSikPyQ+f8BYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P4UU85s6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vWKflsgh; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P4UU85s6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vWKflsgh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="P4UU85s6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vWKflsgh";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="P4UU85s6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vWKflsgh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C48411FBB7;
	Fri, 22 Aug 2025 06:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755842939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RXcc8Qi3I7erKPfKf0vjWVMReCyCUrsBEQ+Ly40WZ7Y=;
	b=P4UU85s6tdpJGQ9qRi35Fef56l7A+jr6/EohcBGcZvACxP8Orczujhykvmky5iZ6hYNJBv
	zdWY/c49U9xwAC59HAW1uwbaMewVku5v3/52ybWkf43UTqSCsikQ9LES3XjUKWrWj8AIW3
	bgCRxK9P3hQsqiferpEmCHZ0//VLmlg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755842939;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RXcc8Qi3I7erKPfKf0vjWVMReCyCUrsBEQ+Ly40WZ7Y=;
	b=vWKflsghuu8xC+9omqIuL5unM/8RKWihh4INQ9+FUp5ctXr0a1es4PfLipI4d0ZgFUXUPw
	bVfZUCbk3joDMiBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755842939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RXcc8Qi3I7erKPfKf0vjWVMReCyCUrsBEQ+Ly40WZ7Y=;
	b=P4UU85s6tdpJGQ9qRi35Fef56l7A+jr6/EohcBGcZvACxP8Orczujhykvmky5iZ6hYNJBv
	zdWY/c49U9xwAC59HAW1uwbaMewVku5v3/52ybWkf43UTqSCsikQ9LES3XjUKWrWj8AIW3
	bgCRxK9P3hQsqiferpEmCHZ0//VLmlg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755842939;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RXcc8Qi3I7erKPfKf0vjWVMReCyCUrsBEQ+Ly40WZ7Y=;
	b=vWKflsghuu8xC+9omqIuL5unM/8RKWihh4INQ9+FUp5ctXr0a1es4PfLipI4d0ZgFUXUPw
	bVfZUCbk3joDMiBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6DCF713931;
	Fri, 22 Aug 2025 06:08:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7fgRGXsJqGgfcQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 22 Aug 2025 06:08:59 +0000
Message-ID: <c2aa9eed-7207-4018-b5dc-b1b3c3e0fa34@suse.de>
Date: Fri, 22 Aug 2025 08:08:58 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] nvme: fixup HKDF-Expand-Label implementation
To: Eric Biggers <ebiggers@kernel.org>, Chris Leech <cleech@redhat.com>
Cc: linux-nvme@lists.infradead.org, Hannes Reinecke <hare@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
References: <20250821204816.2091293-1-cleech@redhat.com>
 <20250822010923.GA2458@quark>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250822010923.GA2458@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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

On 8/22/25 03:09, Eric Biggers wrote:
> On Thu, Aug 21, 2025 at 01:48:14PM -0700, Chris Leech wrote:
>> As per RFC 8446 (TLS 1.3) the HKDF-Expand-Label function is using vectors
>> for the 'label' and 'context' field, but defines these vectors as a string
>> prefixed with the string length (in binary). The implementation in nvme
>> is missing the length prefix which was causing interoperability issues
>> with spec-conformant implementations.
>>
>> This patchset adds a function 'hkdf_expand_label()' to correctly implement
>> the HKDF-Expand-Label functionality and modifies the nvme driver to utilize
>> this function instead of the open-coded implementation.
>>
>> As usual, comments and reviews are welcome.
> 
> Well, it's nice that my review comment from last year is finally being
> addressed: https://lore.kernel.org/r/20240723014715.GB2319848@google.com
> 
Yeah, because I misread your comments, and was only focussed on the
'length' field (which is a 16-bit field at the start), and not on the
length fields of the individual vectors.

Reading specs is hard...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
