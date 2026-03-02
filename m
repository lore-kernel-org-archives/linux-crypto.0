Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD5472631
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 09:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772444678; cv=none; b=bSC3Qy0mf2dVUO1rbDX0XpnGFY2ORUKuAApdlqgcZ9mlnJPxyQirZNY8nbmttq2jGV0CrjCj9qKnpB9Y4GBMf3F9rUzebPsqnxZD8sG1UKYjCJV+CkGi7eHdzfgKj9JhjCuh4L2jexkHA9VUuZfR5KnZmd5kh3OCYBXC356sVGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772444678; c=relaxed/simple;
	bh=N6fJIPYnUqfVKoiqNISsVrNlA6oiqT8WsQUJu7jAw3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tV2/hbsAlummRsK7NOR1uK4rCYihB5Ax20weyyBraZHg4HwDYFxRNhcHhGe2LTBosu72tApGtTG6V3jXCHciJsOseeNuXy6DwfhWlDakxI5A5u5i5jss3ZqVyzd8WMnlbHQvn59/k3N9fxMYX1wDNzlVz2UtBeyBfz0gNV7SI2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EP1zsVKN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XgUrZgKu; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EP1zsVKN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XgUrZgKu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EP1zsVKN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XgUrZgKu";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EP1zsVKN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XgUrZgKu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4BA053F374;
	Mon,  2 Mar 2026 09:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772444675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w8XttDxywmg5Qj2nmpy3Yg0g0Qe73kllRxnPHj3uWzY=;
	b=EP1zsVKNilw5Ged4erOEJ8/L2Ll3mgRWE+I200fYVNwtmV587TUK833AJXhNlSPi+hrEHh
	fKK5sC3/856xVrAlwA64yNb9/YIlg20mv7WpLiUXz8HLWoxr/x+0ndwG6lxJRkSy7JOnZV
	DQCXZxCNOBFVo95Q3o2hMpxtmIWZGDk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772444675;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w8XttDxywmg5Qj2nmpy3Yg0g0Qe73kllRxnPHj3uWzY=;
	b=XgUrZgKu8Q7SFq03o/9N2WhjFzisD2hIIXkjwxgo1311Kht91YBGsqqR0nLSy9Av1U4zkf
	T3CbeFRi04X0UdCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EP1zsVKN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XgUrZgKu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772444675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w8XttDxywmg5Qj2nmpy3Yg0g0Qe73kllRxnPHj3uWzY=;
	b=EP1zsVKNilw5Ged4erOEJ8/L2Ll3mgRWE+I200fYVNwtmV587TUK833AJXhNlSPi+hrEHh
	fKK5sC3/856xVrAlwA64yNb9/YIlg20mv7WpLiUXz8HLWoxr/x+0ndwG6lxJRkSy7JOnZV
	DQCXZxCNOBFVo95Q3o2hMpxtmIWZGDk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772444675;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w8XttDxywmg5Qj2nmpy3Yg0g0Qe73kllRxnPHj3uWzY=;
	b=XgUrZgKu8Q7SFq03o/9N2WhjFzisD2hIIXkjwxgo1311Kht91YBGsqqR0nLSy9Av1U4zkf
	T3CbeFRi04X0UdCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2D0D93EA69;
	Mon,  2 Mar 2026 09:44:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ptqNCgNcpWmYAQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 02 Mar 2026 09:44:35 +0000
Message-ID: <49cb0779-562e-4966-a819-344cd0bd7a9a@suse.de>
Date: Mon, 2 Mar 2026 10:44:34 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/21] nvme-auth: add NVME_AUTH_MAX_DIGEST_SIZE constant
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-2-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 4BA053F374
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 3/2/26 08:59, Eric Biggers wrote:
> Define a NVME_AUTH_MAX_DIGEST_SIZE constant and use it in the
> appropriate places.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/nvme/common/auth.c | 6 ++----
>   drivers/nvme/host/auth.c   | 6 +++---
>   include/linux/nvme.h       | 5 +++++
>   3 files changed, 10 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
