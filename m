Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B557E8F5E
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jan 2025 07:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736408035; cv=none; b=PiprOheeiGcOibLMvFuM1ULmINH+pgHvwXoETfIPKv1CQeE7SJP1SgfjGkZVbSbPGsYPi4w2/JzSQCnoZu+KoxdA2+OLgvfr1FotBvowXI35fv6tE4/7cTnJBS2qpvS8IR1NytY8TGP8EKc0pYnNpbNtjnjMiT00vfkHmJUzsoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736408035; c=relaxed/simple;
	bh=M8slUUoLpocKpJ2ptxXZQXMoDzWUv9EKKfuQvtPRkeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i1jNYz8DopwL41vyRnoJy+obtDDuGpzrzhgcU02qMNy0iAskf3RAKiAMICPiJ1TVP7ka0RHlwql1Tg1ZA2TruXvax7VlW0Tqah/eaxyAMSkOh6VQa5qVsIv3iqIJiu8ClhkMtoq2dOZysY6a2aGMvgpBX47fALzs1YaT3RwSJJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aV8a4cRK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nE2MuhYH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aV8a4cRK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nE2MuhYH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aV8a4cRK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nE2MuhYH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aV8a4cRK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nE2MuhYH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BE0BF1F38E;
	Thu,  9 Jan 2025 07:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736408031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=htiklAAu6bOQ7XJrCLtxl1e87pc1u1ygZzZ5r3hu898=;
	b=aV8a4cRKMYNBFONRyo+Fc3hr6I1Q3u8LgqhV0no2JFlwhb3viI0SsU7hD4GJca1U5jv9dv
	zOXuHmaZu7A/Sv+z2SCPWHPpa29mBnRtn/02RM8bUlz5iGVUWHx4s+wS23qd3CrdHZ0eoY
	PXR5P1yEGMrsEWlgVIm5gfEicnDyYcE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736408031;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=htiklAAu6bOQ7XJrCLtxl1e87pc1u1ygZzZ5r3hu898=;
	b=nE2MuhYH8O5MBtfaGzZnTSbv7gd8E2n3Mv4dCkz8y0VIh2tvB4OnXBsxNja+FOaXW2gOzp
	9gHIcNB0MACFGFCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aV8a4cRK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nE2MuhYH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736408031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=htiklAAu6bOQ7XJrCLtxl1e87pc1u1ygZzZ5r3hu898=;
	b=aV8a4cRKMYNBFONRyo+Fc3hr6I1Q3u8LgqhV0no2JFlwhb3viI0SsU7hD4GJca1U5jv9dv
	zOXuHmaZu7A/Sv+z2SCPWHPpa29mBnRtn/02RM8bUlz5iGVUWHx4s+wS23qd3CrdHZ0eoY
	PXR5P1yEGMrsEWlgVIm5gfEicnDyYcE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736408031;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=htiklAAu6bOQ7XJrCLtxl1e87pc1u1ygZzZ5r3hu898=;
	b=nE2MuhYH8O5MBtfaGzZnTSbv7gd8E2n3Mv4dCkz8y0VIh2tvB4OnXBsxNja+FOaXW2gOzp
	9gHIcNB0MACFGFCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A5B113876;
	Thu,  9 Jan 2025 07:33:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kQkdHN97f2fGWQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 09 Jan 2025 07:33:51 +0000
Message-ID: <69208b76-71ac-464f-bdb9-50c9c5558ac6@suse.de>
Date: Thu, 9 Jan 2025 08:33:51 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] nvmet-tcp: support secure channel concatenation
To: Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 linux-nvme@lists.infradead.org, Eric Biggers <ebiggers@kernel.org>,
 linux-crypto@vger.kernel.org
References: <20241203110238.128630-1-hare@kernel.org>
 <20241203110238.128630-11-hare@kernel.org> <Z36o7IqZnwkuckwF@kbusch-mbp>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <Z36o7IqZnwkuckwF@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BE0BF1F38E
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 1/8/25 17:33, Keith Busch wrote:
> On Tue, Dec 03, 2024 at 12:02:37PM +0100, Hannes Reinecke wrote:
>> Evaluate the SC_C flag during DH-CHAP-HMAC negotiation and insert
>> the generated PSK once negotiation has finished.
> 
> ...
> 
>> @@ -251,7 +267,7 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
>>   
>>   	uuid_copy(&ctrl->hostid, &d->hostid);
>>   
>> -	dhchap_status = nvmet_setup_auth(ctrl);
>> +	dhchap_status = nvmet_setup_auth(ctrl, req);
>>   	if (dhchap_status) {
>>   		pr_err("Failed to setup authentication, dhchap status %u\n",
>>   		       dhchap_status);
>> @@ -269,12 +285,13 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
>>   		goto out;
>>   	}
> 
> This one had some merge conflicts after applying the pci endpoint
> series from Damien. I tried to resolve it, the result is here:
> 
>    https://git.infradead.org/?p=nvme.git;a=commitdiff;h=11cb42c0f4f4450b325e38c8f0f7d77f5e1a0eb0
> 
> The main conflict was from moving the nvmet_setup_auth() call from
> nvmet_execute_admin_connect() to nvmet_alloc_ctrl().

I'll give it a spin and check how it holds up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
