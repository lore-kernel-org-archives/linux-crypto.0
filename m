Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6245A194A73
	for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2024 07:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729495364; cv=none; b=asgpjF76IwKFNP34gFF4+kG2pvSxnOT0jMdRsLIREWqhId1+HxLuFSvvs3QrCeTwY3BsrFS2vIpXMM/D0U94eNp/CXvPPAZQ5BZCEl6HdE1H4gCoTk3y+7FRclkEH0xxLBr2n/8o5dPRVgpR6w89dkSUElDGhfQ+CtwXHOeMHgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729495364; c=relaxed/simple;
	bh=ma5oWpKgDcE9Llfxz/0eYSEgnERAszMcDxtbi0C/hgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rWQfiNz7XBCCNuTg8cbrsdjGBIOAb4dxI/x2iN1O5wjyamUiwIs6rGIJnt7JQgS36bj3IQRW7Kr3WQnlsyqOaGm3/v2kqItmrdwQ4kLRg9xC2sRELA7L0sPJ3pqod/O5qtK+3MIwA9AS8kDVGex+3LeHz4wamQVKz+ZomrAsTBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RFz7lUwg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ikOik0zI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RFz7lUwg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ikOik0zI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RFz7lUwg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ikOik0zI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RFz7lUwg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ikOik0zI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A13D21FD8;
	Mon, 21 Oct 2024 07:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729495360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=63x7T2WZS3a9tOGqGmMFT1vXx38GaIhE8XuB2nmdJ5o=;
	b=RFz7lUwgu8UCsJKyzF3SHlzXLhK/FLzb11YxDudGBVlVtspp8WNc7MT7+v4aMyZC8JMFEF
	lTUb9/mFV9H2cd6Go3/LB7uaR2zAobgxRn3lzRRQlaWmMOtWF6RTDYXqdpXfbPCYo4ki5v
	NA5g0wbNmFis/F/qBZuKLDkDLEv5ULE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729495360;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=63x7T2WZS3a9tOGqGmMFT1vXx38GaIhE8XuB2nmdJ5o=;
	b=ikOik0zIb1iFnD98NZbcBfkFkYvg/O/w+wHUHwQvHvHdvkik1FUkqFnA6jMC1Ej4z+NPc6
	oGU3uvWlykRaE9Bg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729495360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=63x7T2WZS3a9tOGqGmMFT1vXx38GaIhE8XuB2nmdJ5o=;
	b=RFz7lUwgu8UCsJKyzF3SHlzXLhK/FLzb11YxDudGBVlVtspp8WNc7MT7+v4aMyZC8JMFEF
	lTUb9/mFV9H2cd6Go3/LB7uaR2zAobgxRn3lzRRQlaWmMOtWF6RTDYXqdpXfbPCYo4ki5v
	NA5g0wbNmFis/F/qBZuKLDkDLEv5ULE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729495360;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=63x7T2WZS3a9tOGqGmMFT1vXx38GaIhE8XuB2nmdJ5o=;
	b=ikOik0zIb1iFnD98NZbcBfkFkYvg/O/w+wHUHwQvHvHdvkik1FUkqFnA6jMC1Ej4z+NPc6
	oGU3uvWlykRaE9Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3EAB9136DC;
	Mon, 21 Oct 2024 07:22:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DyE4CkABFmceTgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 21 Oct 2024 07:22:40 +0000
Message-ID: <71faf1a3-6550-4246-be67-46fc12cc6e75@suse.de>
Date: Mon, 21 Oct 2024 09:22:39 +0200
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
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
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
>> diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
>> index 371e14f0a203..902c8ba59562 100644
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
> 
> I'd add a warning if that is not the case here.
> 
Okay.

>> +        if (!chap->qid && ctrl->opts->concat &&
>> +            (ret = nvme_auth_secure_concat(ctrl, chap))) {
>> +            dev_warn(ctrl->device,
>> +                 "%s: qid %d failed to enable secure concatenation\n",
>> +                 __func__, chap->qid);
>> +            chap->error = ret;
>> +        }
>>           return;
>>       }
>> @@ -912,6 +1008,12 @@ static void nvme_ctrl_auth_work(struct 
>> work_struct *work)
>>                "qid 0: authentication failed\n");
>>           return;
>>       }
>> +    /*
>> +     * Only run authentication on the admin queue for
>> +     * secure concatenation
>> +     */
>> +    if (ctrl->opts->concat)
>> +        return;
>>       for (q = 1; q < ctrl->queue_count; q++) {
>>           ret = nvme_auth_negotiate(ctrl, q);
>> diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
>> index 432efcbf9e2f..93e9041b9657 100644
>> --- a/drivers/nvme/host/fabrics.c
>> +++ b/drivers/nvme/host/fabrics.c
>> @@ -472,8 +472,9 @@ int nvmf_connect_admin_queue(struct nvme_ctrl *ctrl)
>>       result = le32_to_cpu(res.u32);
>>       ctrl->cntlid = result & 0xFFFF;
>>       if (result & (NVME_CONNECT_AUTHREQ_ATR | 
>> NVME_CONNECT_AUTHREQ_ASCR)) {
>> -        /* Secure concatenation is not implemented */
>> -        if (result & NVME_CONNECT_AUTHREQ_ASCR) {
>> +        /* Check for secure concatenation */
>> +        if ((result & NVME_CONNECT_AUTHREQ_ASCR) &&
>> +            !ctrl->opts->concat) {
>>               dev_warn(ctrl->device,
>>                    "qid 0: secure concatenation is not supported\n");
>>               ret = -EOPNOTSUPP;
>> @@ -550,7 +551,7 @@ int nvmf_connect_io_queue(struct nvme_ctrl *ctrl, 
>> u16 qid)
>>           /* Secure concatenation is not implemented */
>>           if (result & NVME_CONNECT_AUTHREQ_ASCR) {
>>               dev_warn(ctrl->device,
>> -                 "qid 0: secure concatenation is not supported\n");
>> +                 "qid %d: secure concatenation is not supported\n", 
>> qid);
>>               ret = -EOPNOTSUPP;
>>               goto out_free_data;
>>           }
>> @@ -706,6 +707,7 @@ static const match_table_t opt_tokens = {
>>   #endif
>>   #ifdef CONFIG_NVME_TCP_TLS
>>       { NVMF_OPT_TLS,            "tls"            },
>> +    { NVMF_OPT_CONCAT,        "concat"        },
>>   #endif
>>       { NVMF_OPT_ERR,            NULL            }
>>   };
>> @@ -735,6 +737,7 @@ static int nvmf_parse_options(struct 
>> nvmf_ctrl_options *opts,
>>       opts->tls = false;
>>       opts->tls_key = NULL;
>>       opts->keyring = NULL;
>> +    opts->concat = false;
>>       options = o = kstrdup(buf, GFP_KERNEL);
>>       if (!options)
>> @@ -1053,6 +1056,14 @@ static int nvmf_parse_options(struct 
>> nvmf_ctrl_options *opts,
>>               }
>>               opts->tls = true;
>>               break;
>> +        case NVMF_OPT_CONCAT:
>> +            if (!IS_ENABLED(CONFIG_NVME_TCP_TLS)) {
>> +                pr_err("TLS is not supported\n");
>> +                ret = -EINVAL;
>> +                goto out;
>> +            }
>> +            opts->concat = true;
>> +            break;
>>           default:
>>               pr_warn("unknown parameter or missing value '%s' in ctrl 
>> creation request\n",
>>                   p);
>> @@ -1079,6 +1090,23 @@ static int nvmf_parse_options(struct 
>> nvmf_ctrl_options *opts,
>>               pr_warn("failfast tmo (%d) larger than controller loss 
>> tmo (%d)\n",
>>                   opts->fast_io_fail_tmo, ctrl_loss_tmo);
>>       }
>> +    if (opts->concat) {
>> +        if (opts->tls) {
>> +            pr_err("Secure concatenation over TLS is not supported\n");
>> +            ret = -EINVAL;
>> +            goto out;
>> +        }
>> +        if (opts->tls_key) {
>> +            pr_err("Cannot specify a TLS key for secure 
>> concatenation\n");
>> +            ret = -EINVAL;
>> +            goto out;
>> +        }
>> +        if (!opts->dhchap_secret) {
>> +            pr_err("Need to enable DH-CHAP for secure concatenation\n");
>> +            ret = -EINVAL;
>> +            goto out;
>> +        }
>> +    }
>>       opts->host = nvmf_host_add(hostnqn, &hostid);
>>       if (IS_ERR(opts->host)) {
>> diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
>> index 21d75dc4a3a0..9cf5b020adba 100644
>> --- a/drivers/nvme/host/fabrics.h
>> +++ b/drivers/nvme/host/fabrics.h
>> @@ -66,6 +66,7 @@ enum {
>>       NVMF_OPT_TLS        = 1 << 25,
>>       NVMF_OPT_KEYRING    = 1 << 26,
>>       NVMF_OPT_TLS_KEY    = 1 << 27,
>> +    NVMF_OPT_CONCAT        = 1 << 28,
>>   };
>>   /**
>> @@ -101,6 +102,7 @@ enum {
>>    * @keyring:    Keyring to use for key lookups
>>    * @tls_key:    TLS key for encrypted connections (TCP)
>>    * @tls:        Start TLS encrypted connections (TCP)
>> + * @concat:     Enabled Secure channel concatenation (TCP)
>>    * @disable_sqflow: disable controller sq flow control
>>    * @hdr_digest: generate/verify header digest (TCP)
>>    * @data_digest: generate/verify data digest (TCP)
>> @@ -130,6 +132,7 @@ struct nvmf_ctrl_options {
>>       struct key        *keyring;
>>       struct key        *tls_key;
>>       bool            tls;
>> +    bool            concat;
>>       bool            disable_sqflow;
>>       bool            hdr_digest;
>>       bool            data_digest;
>> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
>> index 313a4f978a2c..4c735b88b434 100644
>> --- a/drivers/nvme/host/nvme.h
>> +++ b/drivers/nvme/host/nvme.h
>> @@ -1132,6 +1132,7 @@ void nvme_auth_stop(struct nvme_ctrl *ctrl);
>>   int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid);
>>   int nvme_auth_wait(struct nvme_ctrl *ctrl, int qid);
>>   void nvme_auth_free(struct nvme_ctrl *ctrl);
>> +void nvme_auth_revoke_tls_key(struct nvme_ctrl *ctrl);
>>   #else
>>   static inline int nvme_auth_init_ctrl(struct nvme_ctrl *ctrl)
>>   {
>> @@ -1154,6 +1155,7 @@ static inline int nvme_auth_wait(struct 
>> nvme_ctrl *ctrl, int qid)
>>       return -EPROTONOSUPPORT;
>>   }
>>   static inline void nvme_auth_free(struct nvme_ctrl *ctrl) {};
>> +static void nvme_auth_revoke_tls_key(struct nvme_ctrl *ctrl) {};
>>   #endif
>>   u32 nvme_command_effects(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
>> diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
>> index b68a9e5f1ea3..efb35eef1915 100644
>> --- a/drivers/nvme/host/sysfs.c
>> +++ b/drivers/nvme/host/sysfs.c
>> @@ -780,10 +780,10 @@ static umode_t nvme_tls_attrs_are_visible(struct 
>> kobject *kobj,
>>           return 0;
>>       if (a == &dev_attr_tls_key.attr &&
>> -        !ctrl->opts->tls)
>> +        !ctrl->opts->tls && !ctrl->opts->concat)
>>           return 0;
>>       if (a == &dev_attr_tls_configured_key.attr &&
>> -        !ctrl->opts->tls_key)
>> +        (!ctrl->opts->tls_key || ctrl->opts->concat))
>>           return 0;
>>       if (a == &dev_attr_tls_keyring.attr &&
>>           !ctrl->opts->keyring)
>> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
>> index 3e416af2659f..b8a3461b617c 100644
>> --- a/drivers/nvme/host/tcp.c
>> +++ b/drivers/nvme/host/tcp.c
>> @@ -233,7 +233,7 @@ static inline bool nvme_tcp_tls_configured(struct 
>> nvme_ctrl *ctrl)
>>       if (!IS_ENABLED(CONFIG_NVME_TCP_TLS))
>>           return 0;
>> -    return ctrl->opts->tls;
>> +    return ctrl->opts->tls || ctrl->opts->concat;
>>   }
>>   static inline struct blk_mq_tags *nvme_tcp_tagset(struct 
>> nvme_tcp_queue *queue)
>> @@ -1948,7 +1948,7 @@ static int nvme_tcp_alloc_admin_queue(struct 
>> nvme_ctrl *ctrl)
>>       if (nvme_tcp_tls_configured(ctrl)) {
>>           if (ctrl->opts->tls_key)
>>               pskid = key_serial(ctrl->opts->tls_key);
>> -        else {
>> +        else if (ctrl->opts->tls) {
>>               pskid = nvme_tls_psk_default(ctrl->opts->keyring,
>>                                 ctrl->opts->host->nqn,
>>                                 ctrl->opts->subsysnqn);
>> @@ -1978,9 +1978,25 @@ static int __nvme_tcp_alloc_io_queues(struct 
>> nvme_ctrl *ctrl)
>>   {
>>       int i, ret;
>> -    if (nvme_tcp_tls_configured(ctrl) && !ctrl->tls_pskid) {
>> -        dev_err(ctrl->device, "no PSK negotiated\n");
>> -        return -ENOKEY;
>> +    if (nvme_tcp_tls_configured(ctrl)) {
>> +        if (ctrl->opts->concat) {
>> +            /*
>> +             * The generated PSK is stored in the
>> +             * fabric options
>> +             */
>> +            if (!ctrl->opts->tls_key) {
>> +                dev_err(ctrl->device, "no PSK generated\n");
>> +                return -ENOKEY;
>> +            }
>> +            if (ctrl->tls_pskid &&
>> +                ctrl->tls_pskid != key_serial(ctrl->opts->tls_key)) {
>> +                dev_err(ctrl->device, "Stale PSK id %08x\n", ctrl- 
>> >tls_pskid);
>> +                ctrl->tls_pskid = 0;
>> +            }
>> +        } else if (!ctrl->tls_pskid) {
>> +            dev_err(ctrl->device, "no PSK negotiated\n");
>> +            return -ENOKEY;
>> +        }
>>       }
>>       for (i = 1; i < ctrl->queue_count; i++) {
>> @@ -2211,6 +2227,21 @@ static void nvme_tcp_reconnect_or_remove(struct 
>> nvme_ctrl *ctrl,
>>       }
>>   }
>> +/*
>> + * The TLS key needs to be revoked when:
>> + * - concatenation is enabled and
>> + *   -> This is a generated key and only valid for this session
>> + * - the generated key is present in ctrl->tls_key and
>> + *   -> authentication has completed and the key has been generated
>> + * - tls has been enabled
>> + *   -> otherwise we are about to reset the admin queue after 
>> authentication
>> + *      to enable TLS with the generated key
>> + */
>> +static bool nvme_tcp_key_revoke_needed(struct nvme_ctrl *ctrl)
>> +{
>> +    return ctrl->opts->concat && ctrl->opts->tls_key && ctrl->tls_pskid;
>> +}
>> +
>>   static int nvme_tcp_setup_ctrl(struct nvme_ctrl *ctrl, bool new)
>>   {
>>       struct nvmf_ctrl_options *opts = ctrl->opts;
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
Sure.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
