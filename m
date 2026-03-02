Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C511B38F259
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 10:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772445920; cv=none; b=V0LI7421SOSm3lE8BeqvkxWoOf4S1PkmcKnykS1xkx8KS3oge4+nphWCk0W1qC39I6KJcN5b18Yo7CMToCyDTEZVDTBngEwLdpTl87GmFE+cT98UHI8FM2D5aiulM5F0nr/v6OlQYjhM2q6pRPgF0rOlzUFFJBYRRQ723ehWCzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772445920; c=relaxed/simple;
	bh=0J0bMWSC1a7uBtzsogkehUe5xn9m91L9sergu0o2AAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i9CWLhirMOVdkm8NyopQw7ddYlaAoZJhEf24mvDWJACwsThQirfGeawXXFrEMcFAj18p8RfZ9XFyS1dPQHU4r714OGmvUVgRVXi75jAljeg1UmBKoUE+pyBcqYdem2q3YDTUqOeCEy2WtfynuK0p+cF6njIdhz9nnVjySzz+RG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XQcImHsV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=s0HkiEhb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XQcImHsV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=s0HkiEhb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XQcImHsV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="s0HkiEhb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XQcImHsV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="s0HkiEhb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0C1F55BD0E;
	Mon,  2 Mar 2026 10:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772445918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gW2Dv5MX3PTpyq2MHkXE7pAGCImHbavoXyxJlpxMrec=;
	b=XQcImHsVdjhmhyo5mMVhhcHAkPPooptlPICn2itpJ8Xmu9eaosetDZfxTHiHvCyiLEjT4Y
	YQkEa0tpVObzXNn3Xw5eeUg8BYAoO81TPB7pLgutdQU115q+gDoDPzPDEoyI0LZ9rC2x23
	vdkZ+0w3UJvyb16E1cWhTWhyelq8aJE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772445918;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gW2Dv5MX3PTpyq2MHkXE7pAGCImHbavoXyxJlpxMrec=;
	b=s0HkiEhbpW5x6ov4wZVWayVsH9R7JprVZqMpk2NXEUZJU3Hh3M4NrHSdDsNTe9oBwrseye
	s3ynlXCDsp9MJQCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XQcImHsV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=s0HkiEhb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772445918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gW2Dv5MX3PTpyq2MHkXE7pAGCImHbavoXyxJlpxMrec=;
	b=XQcImHsVdjhmhyo5mMVhhcHAkPPooptlPICn2itpJ8Xmu9eaosetDZfxTHiHvCyiLEjT4Y
	YQkEa0tpVObzXNn3Xw5eeUg8BYAoO81TPB7pLgutdQU115q+gDoDPzPDEoyI0LZ9rC2x23
	vdkZ+0w3UJvyb16E1cWhTWhyelq8aJE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772445918;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gW2Dv5MX3PTpyq2MHkXE7pAGCImHbavoXyxJlpxMrec=;
	b=s0HkiEhbpW5x6ov4wZVWayVsH9R7JprVZqMpk2NXEUZJU3Hh3M4NrHSdDsNTe9oBwrseye
	s3ynlXCDsp9MJQCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E55543EA69;
	Mon,  2 Mar 2026 10:05:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7EaLN91gpWmEGQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 02 Mar 2026 10:05:17 +0000
Message-ID: <202c867c-5d9c-4495-af42-c04dc52697cb@suse.de>
Date: Mon, 2 Mar 2026 11:05:17 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/21] nvme-auth: rename nvme_auth_generate_key() to
 nvme_auth_parse_key()
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-6-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-6-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0C1F55BD0E

On 3/2/26 08:59, Eric Biggers wrote:
> This function does not generate a key.  It parses the key from the
> string that the caller passes in.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/common/auth.c | 4 ++--
>   drivers/nvme/host/auth.c   | 7 +++----
>   drivers/nvme/host/sysfs.c  | 4 ++--
>   include/linux/nvme-auth.h  | 2 +-
>   4 files changed, 8 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
