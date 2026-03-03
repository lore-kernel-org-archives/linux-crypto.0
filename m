Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF8429A2
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523981; cv=none; b=XGV34al9SD4p/fWFfyl6Diw7Q0D2iiHOs9LELnh/QvbldKkYFTYHFuQmUlsuKLjZ608DzzhokFhOBJKdAFMIPcFxlUP7DNsLn6dd+Gjq+H8gShJNF1PX3w8qHaOJcaS3rqd8jAGg6mA4FBGlEve6TqtcZygx5xtjgeZn/Kbkh6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523981; c=relaxed/simple;
	bh=XmSSNhkcJ/8OaU/WHvtymAHZ+L7pcVah1YtezE9Ftz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uc5Q05zYcKHfhHMsParOcCgKEVMRZgVvM/QJW04okwFO6UCFRehu11tg16hPnvxRFzrsdAp2asetNT91bqjPcNoH3HTmcaWjZ4QEZ955ISviTcGa+RFyen8OHKFfcEBqReZXWSVeNCBYJpxnzGWZhiWhhtoXFgYr/GKzsZhE9y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lD5Zk96o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=K9o/H7Vp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lD5Zk96o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=K9o/H7Vp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lD5Zk96o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="K9o/H7Vp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lD5Zk96o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="K9o/H7Vp"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8C33E5BDE6;
	Tue,  3 Mar 2026 07:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gQs2nWE2CfmYT6KOxTMv7zDJD3Mzsk0PiYtXLL1dPm4=;
	b=lD5Zk96oB50qU/e6z/jtPwE9r9ED2RP253fW6OTWSI4q5bJ6POotiMWTRdKs1iJA8JK9Sw
	WsAZdN7UvCP3+ZeBe2dAODSChrW3R4s+6dLWmJ+3UTT6UJ8vN3qB1sA3oNv39gxR0Kroj2
	CvPIFx/UAgfVoCQlsaAvu+fZKCuAasQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523978;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gQs2nWE2CfmYT6KOxTMv7zDJD3Mzsk0PiYtXLL1dPm4=;
	b=K9o/H7VpdQhY1LVdYx1TON0FNovcGPx3SKPR5Hx0+h35FWbaQsXxNFZwI6AuEvrWYc/qte
	84+g2cCmrLnPBuCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772523978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gQs2nWE2CfmYT6KOxTMv7zDJD3Mzsk0PiYtXLL1dPm4=;
	b=lD5Zk96oB50qU/e6z/jtPwE9r9ED2RP253fW6OTWSI4q5bJ6POotiMWTRdKs1iJA8JK9Sw
	WsAZdN7UvCP3+ZeBe2dAODSChrW3R4s+6dLWmJ+3UTT6UJ8vN3qB1sA3oNv39gxR0Kroj2
	CvPIFx/UAgfVoCQlsaAvu+fZKCuAasQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772523978;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gQs2nWE2CfmYT6KOxTMv7zDJD3Mzsk0PiYtXLL1dPm4=;
	b=K9o/H7VpdQhY1LVdYx1TON0FNovcGPx3SKPR5Hx0+h35FWbaQsXxNFZwI6AuEvrWYc/qte
	84+g2cCmrLnPBuCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3180D3EA69;
	Tue,  3 Mar 2026 07:46:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mEUoCsqRpmnyWwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Mar 2026 07:46:18 +0000
Message-ID: <d7678b60-0249-429f-bfd2-2eb663d485cc@suse.de>
Date: Tue, 3 Mar 2026 08:46:17 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/21] crypto: remove HKDF library
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-22-ebiggers@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260302075959.338638-22-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO

On 3/2/26 08:59, Eric Biggers wrote:
> Remove crypto/hkdf.c, since it's no longer used.  Originally it had two
> users, but now both of them just inline the needed HMAC computations
> using the HMAC library APIs.  That ends up being better, since it
> eliminates all the complexity and performance issues associated with the
> crypto_shash abstraction and multi-step HMAC input formatting.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   crypto/Kconfig        |   6 -
>   crypto/Makefile       |   1 -
>   crypto/hkdf.c         | 573 ------------------------------------------
>   include/crypto/hkdf.h |  20 --
>   4 files changed, 600 deletions(-)
>   delete mode 100644 crypto/hkdf.c
>   delete mode 100644 include/crypto/hkdf.h
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
