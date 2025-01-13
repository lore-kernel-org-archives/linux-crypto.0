Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4050A1A8F94
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jan 2025 16:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736784036; cv=none; b=mhY9186oIeP6+zHK5J/WhjY32m8vOmxB5xDj4LmxUUvHaWr4VLBA0v8bx8k/vRI20WYKKCGdWwsmRA25Eu45gyorQOe6lXiCFIgcgT6eLZ/3KguNTKdlSQOGI1bQ82UKMLvYAq0jsM2R1QC9M9w81ERgshpkgdWUkuUun4ohOD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736784036; c=relaxed/simple;
	bh=U63hLjCD511aiZtI6wBXk4r+F1Db8b834IB+nclDIWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gAA655eIBmzc0zyhAJdFY6lu3pvYlSB4IRfpnDPwHCFdYEhtoNURmXenL2NWzHlnrcYRVc/+zxRYJ7p2SmelSBw9DDHuemdK8YZ1vqf4+VhOfsqsyy7xKGBVH2DG2DJxhYokXYqiWbuGahAEyZr6XXVXNSYgZ54BFSeJg85bbew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ue7kVBv+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=X6AHweaC; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ue7kVBv+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=X6AHweaC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ue7kVBv+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="X6AHweaC";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ue7kVBv+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="X6AHweaC"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5EFC11F390;
	Mon, 13 Jan 2025 16:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736784032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vda4nrcULrd5MJxsVAvxNAt0W2dXKm/1uYcjULq4nnw=;
	b=Ue7kVBv+AVwwvjtt12jUemftedVZJbo0yUx32fPMNSKaY9leQFNNQ4hIYkb0HBFUoyJUV4
	TvI03BAcpUfFo6ebLV5d2EdwBqETBcka3l+X7i8DY5fcv1s4R4yQ9y4N41QHzeSWls6nQn
	wuCAz+GWzJ5dN0j+h2fHYd9ZDC5+4DI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736784032;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vda4nrcULrd5MJxsVAvxNAt0W2dXKm/1uYcjULq4nnw=;
	b=X6AHweaCDF2OPHqvDaboeIdivQ+RzMF58BEySs4HLZTtHuONcOk2it1iyQ4JS5MYG0oPTj
	UAPF9RMLqpAowrAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ue7kVBv+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=X6AHweaC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736784032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vda4nrcULrd5MJxsVAvxNAt0W2dXKm/1uYcjULq4nnw=;
	b=Ue7kVBv+AVwwvjtt12jUemftedVZJbo0yUx32fPMNSKaY9leQFNNQ4hIYkb0HBFUoyJUV4
	TvI03BAcpUfFo6ebLV5d2EdwBqETBcka3l+X7i8DY5fcv1s4R4yQ9y4N41QHzeSWls6nQn
	wuCAz+GWzJ5dN0j+h2fHYd9ZDC5+4DI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736784032;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vda4nrcULrd5MJxsVAvxNAt0W2dXKm/1uYcjULq4nnw=;
	b=X6AHweaCDF2OPHqvDaboeIdivQ+RzMF58BEySs4HLZTtHuONcOk2it1iyQ4JS5MYG0oPTj
	UAPF9RMLqpAowrAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3331713310;
	Mon, 13 Jan 2025 16:00:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2moSDKA4hWejWAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jan 2025 16:00:32 +0000
Message-ID: <fdd92f24-d581-4d81-b0eb-7780f7ae2971@suse.de>
Date: Mon, 13 Jan 2025 17:00:31 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] nvmet-tcp: support secure channel concatenation
To: Keith Busch <kbusch@kernel.org>
Cc: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20241203110238.128630-1-hare@kernel.org>
 <20241203110238.128630-11-hare@kernel.org> <Z36o7IqZnwkuckwF@kbusch-mbp>
 <69208b76-71ac-464f-bdb9-50c9c5558ac6@suse.de> <Z4REeAUzXi3z2jeb@kbusch-mbp>
 <f5772112-abdd-4b20-a505-3ce71fe8d7ba@suse.de> <Z4U2cEhXMkwZeEDm@kbusch-mbp>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <Z4U2cEhXMkwZeEDm@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5EFC11F390
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 1/13/25 16:51, Keith Busch wrote:
> On Mon, Jan 13, 2025 at 10:34:48AM +0100, Hannes Reinecke wrote:
>> On 1/12/25 23:38, Keith Busch wrote:
>> diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
>> index 486afe598184..10e453b2436e 100644
>> --- a/drivers/nvme/host/Kconfig
>> +++ b/drivers/nvme/host/Kconfig
>> @@ -109,7 +109,7 @@ config NVME_HOST_AUTH
>>          bool "NVMe over Fabrics In-Band Authentication in host side"
>>          depends on NVME_CORE
>>          select NVME_AUTH
>> -       select NVME_KEYRING if NVME_TCP_TLS
>> +       select NVME_KEYRING
>>          help
>>            This provides support for NVMe over Fabrics In-Band Authentication in
>>            host side.
>>
>>
>> which obviously needs to be folded into patch 'nvme-tcp: request
>> secure channel concatenation' (the cited patch is a red herring;
>> it only exposes the issue, but the issue got introduced with the
>> patch to nvme-tcp).
>>
>> Can you fold it in or shall I resubmit?
> 
> Sure, I can fold it in.
> 
> Were you okay with my merge conflict resolution on this patch too?

Yeah, go for it.

At worst I'll need to fix it up later on :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
