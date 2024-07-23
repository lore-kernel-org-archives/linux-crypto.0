Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1654813C8EC
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jul 2024 06:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721715408; cv=none; b=hYbrj8hAwB9AoqhWs1denRb1qBF52eIM7XzeegaVO+3UHnn5azaoGtmOlSg/KjqYOxBcdhortQIcGAujwNlbIZ//KEjq4isbdTZ4NDJF/5U/bJScTMpN2Rq0SFT4ZhT6Wcu8QMzN5AapGZRyAT6UWltS9G9f9OkjKNzA/YP0DQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721715408; c=relaxed/simple;
	bh=WC/t2N4c+smropX83XZk91BeBhBYIQ47JLdh8Xfd//U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J6SveYtC6xn0pnolfK1SJzjfJYqD/eimUVlsijhm1O0yjlqTQbWp0ZlK9OrQIY6N9pax6Wv3iIVA/bCrfn8jIm5wgCCw6Z6lj+nHD6KrvG/unb3N/ubCAiOe1nmxNtK0s6QzN1cxK3u11D9Wu7IgvEyNJ+ieyqBqk54VYNSco+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PEMq63ws; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bgaSE8W/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gR7Uw46x; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4JIeEN+N; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PEMq63ws";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bgaSE8W/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gR7Uw46x";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4JIeEN+N"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ED31E21BB4;
	Tue, 23 Jul 2024 06:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721715405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bnDXtVW8vLqjI8gTj7vn6pURXrUcdHQg4Mema0/dSG8=;
	b=PEMq63ws2cbIqmzLirFKAAYTReV1oAjkKDN10nPtWnWUGyJqJFNNJ9c1M1ZXP6z+ErUyUJ
	z7jR7XN0h6kLBKa60hP1GQAHJfJ3RJ+MmErlRpfREcRD8tibiOR6/6uJgL/orESyawBmzD
	7w6V+oHPApl8lqnKepDAYl8LzZwEGpk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721715405;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bnDXtVW8vLqjI8gTj7vn6pURXrUcdHQg4Mema0/dSG8=;
	b=bgaSE8W/qnNqaYBjxqUBctENBm0mvBXy9KuF10W7F7o6Z8r3k+V1RMsdeX3lk7YGYMXLgA
	vJUYyObvWOdB0mDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721715404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bnDXtVW8vLqjI8gTj7vn6pURXrUcdHQg4Mema0/dSG8=;
	b=gR7Uw46xVfFRgKEBtUcGYfMWXAj2ZZP811WZomYN3fgC6/H4enPujfk+NJngC4hM8krwkA
	zR7/anMv8dDeC6mzEia4XkBJaXVEK5kDnGW7iDdp4ANU6yo3HnO2sciOrXP4h7KQN44Nn4
	Rb1fjMxSTFks4EKB7DcnOzlejHW/+rM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721715404;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bnDXtVW8vLqjI8gTj7vn6pURXrUcdHQg4Mema0/dSG8=;
	b=4JIeEN+N9YcscPivwN+vSctDznpKBDc89Hmk7NY26T/KXz7O01sn77aZBJg6SmYCVXRKuD
	pUcWkBCcCV0EW/CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9248513888;
	Tue, 23 Jul 2024 06:16:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b1qKIcxKn2buQAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 23 Jul 2024 06:16:44 +0000
Message-ID: <f3cd61ee-6744-4105-8c0d-e8bd964d6942@suse.de>
Date: Tue, 23 Jul 2024 08:16:44 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 0/9] nvme: implement secure concatenation
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>, Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-crypto@vger.kernel.org,
 linux-nvme@lists.infradead.org
References: <20240722142122.128258-1-hare@kernel.org>
 <20240722222823.GA2303815@google.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240722222823.GA2303815@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.09
X-Spamd-Result: default: False [-4.09 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO

On 7/23/24 00:28, Eric Biggers wrote:
> On Mon, Jul 22, 2024 at 04:21:13PM +0200, Hannes Reinecke wrote:
>>
>> Patchset can be found at
>> git.kernel.org:/pub/scm/linux/kernel/git/hare/nvme.git
>> branch secure-concat.v8
> 
> Not a valid git URL.
> 
git://git.kernel.org/pub/scm/linux/kernel/git/hare/nvme.git
branch secure-concat.v8
base commit f178e8f9eaa900a353145179fc0164a12acfbb2c

Sorry for the inconvenience.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

