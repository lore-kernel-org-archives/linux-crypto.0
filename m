Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD92154454
	for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2024 06:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724049786; cv=none; b=Vim5E2E5qCiJL9MTZK/WbCmXf97hHlat6JXUow7eQqSrA8J6Lf/lxXZJf9ICn2lcwtHMXrUviqY7NHEIEhyrLJbz3QpC8NMATXJRQumPfHJTsepIjtIurbagt3kACMwhvT9zEqoTZGPFyDhND40obv/vyFLKam/urHkWvwa0nCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724049786; c=relaxed/simple;
	bh=swujPn2bqZqF7Qn/5MKewxMvGXNaqaNVvdeyQXLr8AI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qhJcb+wDF9CgDKT+Sp+DPJUSXTPJFhnY14mcG15/E/iGaaxIUI/kuj9KT1fCO7oo7nCB+WKBzM+UYpdaaC6MKlpaFAG+e5PvfBXWM8rK5+nkLnGWNuaHPd4/joQIvOlniiFucuOsAhYbfuKPHLALyXT2yC3O3rLtzfFQDZnwKPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BeTvQqQs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=O9XYnEGQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BeTvQqQs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=O9XYnEGQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BeTvQqQs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="O9XYnEGQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BeTvQqQs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="O9XYnEGQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6FA8C1FE4D;
	Mon, 19 Aug 2024 06:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1724049782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kYJ7IrM/sJw93LV44EVrCcZd+5zxpLgMtNaiTu5IIlg=;
	b=BeTvQqQsoFVO1lzo+FNj2LCbjorAPSVzb3khiI+I0VbEVIgs+MsI0w6tmIeCqW6tHidIUz
	Tf9oAA8w61rwq27oNJpGhbs2WP6hYhpZYSqOkRtbSo6ZjLGjflsyLfiCcNCces9c2f6OEi
	iT6Q/t83uT2fTWVmNOKrMZlXZMfYfqc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1724049782;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kYJ7IrM/sJw93LV44EVrCcZd+5zxpLgMtNaiTu5IIlg=;
	b=O9XYnEGQcTDEEd52DEM1CXmfo+C0O9K6use9jm6FQgdVIr6YKIrNw+OzgxskywyHYUIYFx
	J4IpGcWoSnaRdYBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1724049782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kYJ7IrM/sJw93LV44EVrCcZd+5zxpLgMtNaiTu5IIlg=;
	b=BeTvQqQsoFVO1lzo+FNj2LCbjorAPSVzb3khiI+I0VbEVIgs+MsI0w6tmIeCqW6tHidIUz
	Tf9oAA8w61rwq27oNJpGhbs2WP6hYhpZYSqOkRtbSo6ZjLGjflsyLfiCcNCces9c2f6OEi
	iT6Q/t83uT2fTWVmNOKrMZlXZMfYfqc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1724049782;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kYJ7IrM/sJw93LV44EVrCcZd+5zxpLgMtNaiTu5IIlg=;
	b=O9XYnEGQcTDEEd52DEM1CXmfo+C0O9K6use9jm6FQgdVIr6YKIrNw+OzgxskywyHYUIYFx
	J4IpGcWoSnaRdYBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A9D6137C3;
	Mon, 19 Aug 2024 06:43:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yL18BHbpwma0cgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 19 Aug 2024 06:43:02 +0000
Message-ID: <5f0eee28-289f-4a84-a292-eda119783ed4@suse.de>
Date: Mon, 19 Aug 2024 08:43:01 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv9 0/9] nvme: implement secure concatenation
Content-Language: en-US
To: Kamaljit Singh <Kamaljit.Singh1@wdc.com>,
 Hannes Reinecke <hare@kernel.org>, hch <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Eric Biggers <ebiggers@kernel.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <20240813111512.135634-1-hare@kernel.org>
 <BY5PR04MB6849C928A957A4C549A94020BC812@BY5PR04MB6849.namprd04.prod.outlook.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <BY5PR04MB6849C928A957A4C549A94020BC812@BY5PR04MB6849.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Score: -4.30

On 8/16/24 20:32, Kamaljit Singh wrote:
> Hi Hannes,
> 
>> Patchset can be found at
>> git.kernel.org:/pub/scm/linux/kernel/git/hare/nvme.git
>> branch secure-concat.v9
> I don't see the .v9 branch under that repo. Did you mean secure-concat.v8 branch?
> 
Sorry. Pushed now.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

