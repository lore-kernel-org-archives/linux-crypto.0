Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6D11E6DD5
	for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2024 11:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729508406; cv=none; b=qM4W1/Tj15h5kVeVYEpswNQb30Qkj7bUCu6RsfDFa3KQ2Ox/vJGHTjYTOagLTlDzJzY2jKY4wXltjP5a1Rb631sLlmBvFqZI70BzALXUvWRISLl/Oh7YLgZeUxgfmFiJ0iLmxueWGKJMqMlGrmc4I0T4EMnrZ4I+J2eBRpXlzWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729508406; c=relaxed/simple;
	bh=v3byH3b2yN40LcVQcImhT3M3wr9xJUITrmKDPJQNLPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UPN+LjAEyBmxKmNIIgjlxwPk6qQyjDhwibg2DrYUbt8qQLiy0v/QzMNyP3NH+SUOQewaRHmS87m8dLW3Q/B9GS1Hn4uUt6CgtExv18nnI3nk80YiEJY4pyO38Gj/dclz8FelhXNQ3Obm0Q9ncQ7DPLvVTadcSTwsAXPKYYVXpXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Rsm6B9DQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HgTKdWln; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Rsm6B9DQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HgTKdWln; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Rsm6B9DQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HgTKdWln";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Rsm6B9DQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HgTKdWln"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8350621DFC;
	Mon, 21 Oct 2024 11:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729508402; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CgK36wjlxbJdTiiaCUnolUOrYVh9ODBCeSqkr9s1y6I=;
	b=Rsm6B9DQi4C4XN8BF3ZNWaLosM9doy3I0PeazOeCZplscIro2EFjACG3BgNxMweMBT5GMq
	a31g5N18k+gu5ZsQexKz3ZGDKEsvktiM7uGNwUL/Tfb+95aFp0TOPdB1vjvrKSZV1pwIiN
	tageIAx97tZ4bVog2lsiN5H065DZ1f4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729508402;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CgK36wjlxbJdTiiaCUnolUOrYVh9ODBCeSqkr9s1y6I=;
	b=HgTKdWlnS+4CkHxhVgejR2ufIUbKWLL0poB439oBL81rdHk1TB4nVoi2Pvqk2uU4STtGWC
	2lK+kYKYiy8wnRDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Rsm6B9DQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HgTKdWln
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729508402; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CgK36wjlxbJdTiiaCUnolUOrYVh9ODBCeSqkr9s1y6I=;
	b=Rsm6B9DQi4C4XN8BF3ZNWaLosM9doy3I0PeazOeCZplscIro2EFjACG3BgNxMweMBT5GMq
	a31g5N18k+gu5ZsQexKz3ZGDKEsvktiM7uGNwUL/Tfb+95aFp0TOPdB1vjvrKSZV1pwIiN
	tageIAx97tZ4bVog2lsiN5H065DZ1f4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729508402;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CgK36wjlxbJdTiiaCUnolUOrYVh9ODBCeSqkr9s1y6I=;
	b=HgTKdWlnS+4CkHxhVgejR2ufIUbKWLL0poB439oBL81rdHk1TB4nVoi2Pvqk2uU4STtGWC
	2lK+kYKYiy8wnRDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 658FF136DC;
	Mon, 21 Oct 2024 11:00:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I/ROGDI0FmeREwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 21 Oct 2024 11:00:02 +0000
Message-ID: <56fde9ae-8e27-4ade-bdc4-99bf3f53a299@suse.de>
Date: Mon, 21 Oct 2024 13:00:02 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] nvme-tcp: request secure channel concatenation
To: Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@kernel.org>,
 Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20241018063343.39798-1-hare@kernel.org>
 <20241018063343.39798-7-hare@kernel.org>
 <a188adf5-55be-4524-b8eb-63f7470a4b15@grimberg.me>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <a188adf5-55be-4524-b8eb-63f7470a4b15@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8350621DFC
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 10/20/24 23:04, Sagi Grimberg wrote:
> 
> 
> 
> On 18/10/2024 9:33, Hannes Reinecke wrote:
>> Add a fabrics option 'concat' to request secure channel concatenation.
>> When secure channel concatenation is enabled a 'generated PSK' is 
>> inserted
>> into the keyring such that it's available after reset.
>>
>> Signed-off-by: Hannes Reinecke <hare@kernel.org>
>> ---
>>   drivers/nvme/host/auth.c    | 108 +++++++++++++++++++++++++++++++++++-
>>   drivers/nvme/host/fabrics.c |  34 +++++++++++-
>>   drivers/nvme/host/fabrics.h |   3 +
>>   drivers/nvme/host/nvme.h    |   2 +
>>   drivers/nvme/host/sysfs.c   |   4 +-
>>   drivers/nvme/host/tcp.c     |  47 ++++++++++++++--
>>   include/linux/nvme.h        |   7 +++
>>   7 files changed, 191 insertions(+), 14 deletions(-)
>>
[ .. ]
>> @@ -2314,6 +2345,8 @@ static void nvme_tcp_error_recovery_work(struct 
>> work_struct *work)
>>                   struct nvme_tcp_ctrl, err_work);
>>       struct nvme_ctrl *ctrl = &tcp_ctrl->ctrl;
>> +    if (nvme_tcp_key_revoke_needed(ctrl))
>> +        nvme_auth_revoke_tls_key(ctrl);
> 
> Having this sprayed in various places in the code is really confusing.
> 
> Can you please add a small comment on each call-site? just for our 
> future selves
> reading this code?
> 
> Outside of that, patch looks good.
> 
Weelll ...
We need to reset the negotiated PSK exactly in three places:
- reset
- error recovery
- teardown
Much like we need to do for every other queue-related resource.

And in one of your previous reviews you stated that you do _not_
want to have 'nvme_auth_revoke_tls_key()' checking if the key
needs to be revoked, but rather have a check function.
Otherwise I could just move the check into nvme_auth_revoke_tls_key()'
and drop the 'revoke needed' call.

Furthermore we don't need to check if the key needs to be revoked
during teardown (answer will always be 'yes').

So I'm quite unsure what to do now ... document that we need
to release the key when doing a reset or error recovery?
Move the check back into nvme_auth_tls_revoke_key()?
Hmm?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
