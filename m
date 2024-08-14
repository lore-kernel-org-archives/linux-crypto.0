Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0C27345B
	for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 06:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723615916; cv=none; b=Z4JupntupbVN7brrgduwYqS4PxV5aqqlGS5nC9gS12L8+oJxPfjEzb2r3l1LGAubmweFvoellojazUT458ZlybAzIv2vp8T8iecwF6AQNERPm56x8jHJgjCigvksumIi4T/tPnGly33NFI2y3zqbnQnmDbf7zmsMSHbjbeJQ+9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723615916; c=relaxed/simple;
	bh=/9U85E/aZUh9CkNRJCjxX8PKA2Ej8RfdhaDSfFGtIUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qEdZ/qBEwkGM3p4tkOd0V9vE1GJ9YQYtuH9Q20j684wupZBbxHHY/dGpKOfE6Iax4rl+wrQPUgPYEx9b4WRLf+UgYouyM/md0ZSYFByIqzsd7QScdSDZPeYSsNsXIjNT0v82QQJ4UCmKrh88jtvK2I+NCLlFyFMbck8//hIe6eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ECCCbUtc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LwJd/qgr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ECCCbUtc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LwJd/qgr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ECCCbUtc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LwJd/qgr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ECCCbUtc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LwJd/qgr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7BDB52259D;
	Wed, 14 Aug 2024 06:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723615912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L77LMhB1RZ1z2/fegLqCgeWr+Rz3ex9q8mOsIhpqmG8=;
	b=ECCCbUtcm9ZBXNwVzNvPRf0HSZK9qkBsRx2FBaFCFKMueIF1Xj3Tp0VmHyDTuWCesx14su
	/P2G1qb950I2Grw0r2I2HujfmKXeq8WPDk8U/7VWvLI++LGCKh8h2c1v0SrKZRtTPR1I/8
	f6kgTlgxA2QZge5KOgfjNGuqNzYpVtE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723615912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L77LMhB1RZ1z2/fegLqCgeWr+Rz3ex9q8mOsIhpqmG8=;
	b=LwJd/qgrb1dMOe4OuNWucNEb0Kw4DszKBUI4DOXVv+gg6DVe2+vn3l4RSrTU28nWmcqMHz
	00oj9JiLOL3tqPCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723615912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L77LMhB1RZ1z2/fegLqCgeWr+Rz3ex9q8mOsIhpqmG8=;
	b=ECCCbUtcm9ZBXNwVzNvPRf0HSZK9qkBsRx2FBaFCFKMueIF1Xj3Tp0VmHyDTuWCesx14su
	/P2G1qb950I2Grw0r2I2HujfmKXeq8WPDk8U/7VWvLI++LGCKh8h2c1v0SrKZRtTPR1I/8
	f6kgTlgxA2QZge5KOgfjNGuqNzYpVtE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723615912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L77LMhB1RZ1z2/fegLqCgeWr+Rz3ex9q8mOsIhpqmG8=;
	b=LwJd/qgrb1dMOe4OuNWucNEb0Kw4DszKBUI4DOXVv+gg6DVe2+vn3l4RSrTU28nWmcqMHz
	00oj9JiLOL3tqPCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 345861348F;
	Wed, 14 Aug 2024 06:11:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8jDzCqhKvGbFGQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 14 Aug 2024 06:11:52 +0000
Message-ID: <5051f4e7-cce4-436f-b4c8-cf121330e4c2@suse.de>
Date: Wed, 14 Aug 2024 08:11:51 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] nvme-tcp: request secure channel concatenation
Content-Language: en-US
To: Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@kernel.org>,
 Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20240813111512.135634-1-hare@kernel.org>
 <20240813111512.135634-7-hare@kernel.org>
 <4b64fa0f-cfda-465c-8be6-60b4cf60f558@grimberg.me>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <4b64fa0f-cfda-465c-8be6-60b4cf60f558@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.29
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 8/13/24 21:45, Sagi Grimberg wrote:
> 
> On 13/08/2024 14:15, Hannes Reinecke wrote:
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
>> diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
>> index 371e14f0a203..d2fdaefd236f 100644
>> --- a/drivers/nvme/host/auth.c
>> +++ b/drivers/nvme/host/auth.c
[ .. ]
>> @@ -833,6 +921,14 @@ static void nvme_queue_auth_work(struct 
>> work_struct *work)
>>       }
>>       if (!ret) {
>>           chap->error = 0;
>> +        /* Secure concatenation can only be enabled on the admin 
>> queue */
>> +        if (!chap->qid && ctrl->opts->concat &&
>> +            (ret = nvme_auth_secure_concat(ctrl, chap))) {
>> +            dev_warn(ctrl->device,
>> +                 "%s: qid %d failed to enable secure concatenation\n",
>> +                 __func__, chap->qid);
>> +            chap->error = ret;
>> +        }
> 
> Lets break up the if condition:
> 
>      if (!chap->qid && ctrl->opts->concat) {
>          ret = nvme_auth_secure_concat(ctrl, chap);
>          if (!ret)
>              return;
>          dev_warn(ctrl->device,
>              "%s: qid %d failed to enable secure concatenation\n",
>               __func__, chap->qid);
>          chap->error = ret;
>      }
> 
> 
> 
Okay.

>>           return;
> 
> No need for the return statement.
> 
[ .. ]
>> diff --git a/include/linux/nvme.h b/include/linux/nvme.h
>> index 7b2ae2e43544..8072edf3c842 100644
>> --- a/include/linux/nvme.h
>> +++ b/include/linux/nvme.h
>> @@ -1678,6 +1678,13 @@ enum {
>>       NVME_AUTH_DHGROUP_INVALID    = 0xff,
>>   };
>> +enum {
>> +    NVME_AUTH_SECP_NOSC        = 0x00,
>> +    NVME_AUTH_SECP_SC        = 0x01,
>> +    NVME_AUTH_SECP_NEWTLSPSK    = 0x02,
>> +    NVME_AUTH_SECP_REPLACETLSPSK    = 0x03,
>> +};
>> +
>>   union nvmf_auth_protocol {
>>       struct nvmf_auth_dhchap_protocol_descriptor dhchap;
>>   };
> 
> Wandering if splitting core/fabrics from tcp would be viable here...

Well, authentication is a base functionality, not a tcp one.
Even though it's pretty much TCP-centric.
So I'd rather keep in in nvme.h for now.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

