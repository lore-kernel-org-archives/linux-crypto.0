Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA0A12B64
	for <linux-crypto@vger.kernel.org>; Thu, 25 Jul 2024 11:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721908223; cv=none; b=N4a+O9ztg6d58ckdS08mA1sX6cfO4V+iw7zz9JXC3YjILoOi+wyG+8e2/qQRx8WfCbAHkWN9ahRjFvVjOwcLEffq8Le4GJ/gxnyaPo32X8/j14RlkT2Xd+62OTKOapTtS8GKNHmRAxytqtdpBlZzWDoc4CsMDEjXtc2yc/Q5Mcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721908223; c=relaxed/simple;
	bh=Zwj8ZqUz5r6BEw7+r0w64+jnacyh1B1y3oPgRksVsH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=spLEe/bfkiMgtJFMLIEaXTdw7+cdyNnSHQnvnOeDqsEMlDwrOwUjAN2hKLxuqrB/LW5GNiqEXjFXXVB4km5b/FGDochiybJoBBnZZtc6JSuigVy8qVQaWfkX5RiD0VP2kRwocUkACyZ+AK69wgPaJr8pSfmKKvaItnUZSIHQ12Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Pu3k8FNQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=o1oCANS1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Pu3k8FNQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=o1oCANS1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Pu3k8FNQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="o1oCANS1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Pu3k8FNQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="o1oCANS1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BAB5D21A6B;
	Thu, 25 Jul 2024 11:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721908219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=voRwSZrJEOFd/xnLyYK20i8daq81INo4ohUTHXeg5sY=;
	b=Pu3k8FNQZFVNXe5OkpeZJlD0VACtwUSNZ4v+Xj/qXzI/UdI2tkOLiLZ6BwFzTFA7hmIRPg
	NcNR9JYet1EXQRMJ/HN+UOKO4T062oDKqvVJB1qfJDcAtTAlsfl3Rou7F2NgflWAXtzVXO
	sgpMv49QPXWt+0jsX8q3F3Mw8fuEgno=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721908219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=voRwSZrJEOFd/xnLyYK20i8daq81INo4ohUTHXeg5sY=;
	b=o1oCANS1jpCB1Vfbv9VQyy2V+M2V3+/5CZWexSwQg2iNvyaTJv2/5778EDoQp0z5IhXh3z
	p+lVSxpHlLEwMZAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Pu3k8FNQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o1oCANS1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721908219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=voRwSZrJEOFd/xnLyYK20i8daq81INo4ohUTHXeg5sY=;
	b=Pu3k8FNQZFVNXe5OkpeZJlD0VACtwUSNZ4v+Xj/qXzI/UdI2tkOLiLZ6BwFzTFA7hmIRPg
	NcNR9JYet1EXQRMJ/HN+UOKO4T062oDKqvVJB1qfJDcAtTAlsfl3Rou7F2NgflWAXtzVXO
	sgpMv49QPXWt+0jsX8q3F3Mw8fuEgno=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721908219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=voRwSZrJEOFd/xnLyYK20i8daq81INo4ohUTHXeg5sY=;
	b=o1oCANS1jpCB1Vfbv9VQyy2V+M2V3+/5CZWexSwQg2iNvyaTJv2/5778EDoQp0z5IhXh3z
	p+lVSxpHlLEwMZAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 805251368A;
	Thu, 25 Jul 2024 11:50:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j457Hvs7omYCYwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 25 Jul 2024 11:50:19 +0000
Message-ID: <f69aee16-8238-48cc-986a-6d9dc7f6d933@suse.de>
Date: Thu, 25 Jul 2024 13:50:19 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] nvmet-tcp: support secure channel concatenation
To: Eric Biggers <ebiggers@kernel.org>, Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-crypto@vger.kernel.org,
 linux-nvme@lists.infradead.org
References: <20240722142122.128258-1-hare@kernel.org>
 <20240722142122.128258-9-hare@kernel.org>
 <20240723014854.GC2319848@google.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240723014854.GC2319848@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Rspamd-Queue-Id: BAB5D21A6B

On 7/23/24 03:48, Eric Biggers wrote:
> On Mon, Jul 22, 2024 at 04:21:21PM +0200, Hannes Reinecke wrote:
>> +	ret = nvme_auth_generate_digest(sq->ctrl->shash_id, psk, psk_len,
>> +					sq->ctrl->subsysnqn,
>> +					sq->ctrl->hostnqn, &digest);
>> +	if (ret) {
>> +		pr_warn("%s: ctrl %d qid %d failed to generate digest, error %d\n",
>> +			__func__, sq->ctrl->cntlid, sq->qid, ret);
>> +		goto out_free_psk;
>> +	}
>> +	ret = nvme_auth_derive_tls_psk(sq->ctrl->shash_id, psk, psk_len,
>> +				       digest, &tls_psk);
>> +	if (ret) {
>> +		pr_warn("%s: ctrl %d qid %d failed to derive TLS PSK, error %d\n",
>> +			__func__, sq->ctrl->cntlid, sq->qid, ret);
>> +		goto out_free_digest;
>> +	}
> 
> This reuses 'psk' as both an HMAC key and as input keying material for HKDF.
> It's *probably* still secure, but this violates cryptographic best practices in
> that it reuses a key for multiple purposes.  Is this a defect in the spec?
> 
This is using a digest calculated from the actual PSK key material, 
true. You are right that with that we probably impact cryptographic
reliability, but that that is what the spec mandates.

Actual reason for this modification was the need to identify the TLS 
PSKs for each connection, _and_ support key refresh.

We identify TLS PSKs by the combination of '<hash> <hostnqn> 
<subsysnqn>', where '<hostnqn>' is the identification of the
initiator (source), and '<subsynqn>' the identification of the
target. But as we regenerate the PSK for each reset we are having
a hard time identifying the newly generated PSK by the original
'<hash> <hostnqn> <subsysnqn>' tuple only.
We cannot delete the original TLS PSK directly as it might be used
by other connections, so there will be a time where both PSKs
are valid and have to be stored in the keyring.

And keeping a global 'revision' counter is horrible, the alternative
of having a per-connection instance counter is similarly unpleasant.

Not ideal, true, so if you have better ideas I'd like to hear them.

But thanks for your consideration. I'll be bringing them up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

