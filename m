Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D61C1E0B6C
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 10:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733221649; cv=none; b=hgV6rU1TUpY+UoSiptosjUd4pY2NIWvQo8Ab1L702U9ddC8NEVTMNa/7tJ0d7UH3605d27pYM/6LEwQzdSarSj70+HLQbA5u73Gj7PzBPp4h7dfJE9caJb0WITwLPiBVbMdTt3b8wMhwLV6P9Mxfst5+m1GwHm2UMbTnZ/nkcAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733221649; c=relaxed/simple;
	bh=67niyQ4NXkrW3zimkhYYTlTLDl7UdOZ/sZSP1/DmYmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MG9ClnKrBQMdwNoFdK+5WnLa/CtCzBqFeAfsrNyoFn1Am/8ilhkM3CkiWMf1RX91cW4OmsGWv7gHMFK07ckHQcDr/syqZldemLIsEUad/Pcp5doro7fuocpUYpvRVfbCtP5MFJOkSahoDZ7w9mJuVB1908303O4W2MNdEqqN8IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cwDaIsq3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=skAKMCEM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FLhjkCNk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HKHgBvSa; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cwDaIsq3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="skAKMCEM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FLhjkCNk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HKHgBvSa"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DB35C1F445;
	Tue,  3 Dec 2024 10:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733221644; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=peUQf4uTLvt3R9q9vtd509iJ60TVWz2fEyTMNb4MgjE=;
	b=cwDaIsq3x+rjPlhLk2r3VyZo5VK//RrL3rHzE2DSkbmUO34uaj+kfLre6NkTn5/UKJZZWB
	LyOtDNpcixUs15WELRy7mI4Hi6UOG96KfN5uA8YKHGBVIMue8smjwvI37iYiiONixQNnB0
	KaifN4fHETzu8ImwkSa+IjMgv5oUZE8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733221644;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=peUQf4uTLvt3R9q9vtd509iJ60TVWz2fEyTMNb4MgjE=;
	b=skAKMCEM8vmuq3gNLlZ/sCAQ6+z/c718s+L4aHHA+WdOKSoLn3jRv+XOFQaSHNF+aNjjZK
	MDymCMvhXOyQ3RCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733221643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=peUQf4uTLvt3R9q9vtd509iJ60TVWz2fEyTMNb4MgjE=;
	b=FLhjkCNk/4RyW8xLA3w7Am3PVjEIvurs8Pipf0citK3EbJ1DeENA0tAZY4UI6aMaoWhWZJ
	B1zMUR2wk4CNOqdAOO8J5TW0Qf7QKxoHfe16hUht4jEVynKx4jRIVmDQy/QIEwdEwWtOTf
	98jFN494b/EFb9/NZx7slMQCk1vG3nU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733221643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=peUQf4uTLvt3R9q9vtd509iJ60TVWz2fEyTMNb4MgjE=;
	b=HKHgBvSakQ8/JUjv9ZmNN81aYBJU+1QN1xZtnIyud0GOzT4GQul3r4Wxr/tP2WfiN1Q+ec
	j080IutZejddUFAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C2FCC139C2;
	Tue,  3 Dec 2024 10:27:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jcz+LgvdTmfGYgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Dec 2024 10:27:23 +0000
Message-ID: <12cdcc5e-8f11-45b1-92f3-9d60d3836a53@suse.de>
Date: Tue, 3 Dec 2024 11:27:23 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] nvme: add nvme_auth_derive_tls_psk()
To: Maurizio Lombardi <mlombard@redhat.com>, Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20241202142959.81321-1-hare@kernel.org>
 <20241202142959.81321-5-hare@kernel.org>
 <CAFL455kHV2ADBs2wUe3i0j00c1SHyKdjs=OeGj4uTZyCDdP6iQ@mail.gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAFL455kHV2ADBs2wUe3i0j00c1SHyKdjs=OeGj4uTZyCDdP6iQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 12/2/24 18:04, Maurizio Lombardi wrote:
> po 2. 12. 2024 v 15:32 odesílatel Hannes Reinecke <hare@kernel.org> napsal:
>> +       ret = crypto_shash_setkey(hmac_tfm, prk, prk_len);
>> +       if (ret)
>> +               goto out_free_prk;
>> +
>> +       info_len = strlen(psk_digest) + strlen(psk_prefix) + 5;
>> +       info = kzalloc(info_len, GFP_KERNEL);
>> +       if (!info)
>> +               goto out_free_prk;
> 
> ret should be set to ENOMEM here
> 
Will be fixed for the next round.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
