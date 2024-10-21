Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781B81DEFCE
	for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2024 07:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729495805; cv=none; b=SASbkLgiFJ8PQ956Who6Ugt/iBZoeaCCcNdeZ2N6y7GRWWNeT0Cbkq4p16Ra7MySWH2C3QWBZ1kkmBLb7MwwOK0YNYwQ9u/sLWEPLkelE3jrLT/aSvvgZqaeJk0Bx1nGV/72cpN6qmFX9vxmYdIGH4ezWCylTLUcPdgHOR8CKTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729495805; c=relaxed/simple;
	bh=BRuClP9U/nFZ0ixoo7DgjYESjPYU+B/hgXdNiMpvcic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sBTHw2Ga7RlYqWtGxoLkt5QG0FyvTfLUezm1B2IvESKlifMs7G1a+Z6N+w59bwzMDMO7NNy7RgETMYWYcmoe8zM2o6LkVm/gFteGvMGZE6MZrI+WzPcfh0qhwwKe+grHgbcDpwoEM+rx5jEC5Us3gFNCkyXlgbCUb29l4fRxNHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Sm/lHmvl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VatEIJtc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Sm/lHmvl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VatEIJtc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Sm/lHmvl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VatEIJtc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Sm/lHmvl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VatEIJtc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 953A21FF7A;
	Mon, 21 Oct 2024 07:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729495800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=irUgNocQ29MnklJ1tDcSZVQjbnndXs+i3HPvHyDLU/8=;
	b=Sm/lHmvlJaIo510P5AHwuFeYhsEJ2EhtjY0RtRZelYUlFlvVNtVAaGGaY1I9AeldK8LQaq
	zXUdiBKZsBbjHpK4QfElqjQaKIqb0TiOvPG3GR6LCSEpZX87ZtRF1xqeRsRt0O8FVY3H0s
	OqzWIq9nXc4yeNXSeBMO2Tis9I66W3I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729495800;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=irUgNocQ29MnklJ1tDcSZVQjbnndXs+i3HPvHyDLU/8=;
	b=VatEIJtcEGxXDH/lAdjj9Coiwm2jmw3wTcWLZHkupkGje9/yBd9a5DcfDbMd0MxDFN+wGF
	ePKhldq4QZ8glhDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Sm/lHmvl";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VatEIJtc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729495800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=irUgNocQ29MnklJ1tDcSZVQjbnndXs+i3HPvHyDLU/8=;
	b=Sm/lHmvlJaIo510P5AHwuFeYhsEJ2EhtjY0RtRZelYUlFlvVNtVAaGGaY1I9AeldK8LQaq
	zXUdiBKZsBbjHpK4QfElqjQaKIqb0TiOvPG3GR6LCSEpZX87ZtRF1xqeRsRt0O8FVY3H0s
	OqzWIq9nXc4yeNXSeBMO2Tis9I66W3I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729495800;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=irUgNocQ29MnklJ1tDcSZVQjbnndXs+i3HPvHyDLU/8=;
	b=VatEIJtcEGxXDH/lAdjj9Coiwm2jmw3wTcWLZHkupkGje9/yBd9a5DcfDbMd0MxDFN+wGF
	ePKhldq4QZ8glhDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4CFCD136DC;
	Mon, 21 Oct 2024 07:30:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5MvrEPgCFmcpUAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 21 Oct 2024 07:30:00 +0000
Message-ID: <3d656683-b091-4a5a-b064-39afe4896c52@suse.de>
Date: Mon, 21 Oct 2024 09:29:59 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] nvmet-tcp: support secure channel concatenation
To: Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@kernel.org>,
 Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20241018063343.39798-1-hare@kernel.org>
 <20241018063343.39798-9-hare@kernel.org>
 <4bb5aa23-6f59-462d-9f50-44e5edaec7e1@grimberg.me>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <4bb5aa23-6f59-462d-9f50-44e5edaec7e1@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 953A21FF7A
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCPT_COUNT_SEVEN(0.00)[7];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 10/20/24 23:13, Sagi Grimberg wrote:
> 
> 
> 
> On 18/10/2024 9:33, Hannes Reinecke wrote:
>> Evaluate the SC_C flag during DH-CHAP-HMAC negotiation and insert
>> the generated PSK once negotiation has finished.
>>
>> Signed-off-by: Hannes Reinecke <hare@kernel.org>
>> ---
>>   drivers/nvme/target/auth.c             | 72 +++++++++++++++++++++++++-
>>   drivers/nvme/target/fabrics-cmd-auth.c | 49 +++++++++++++++---
>>   drivers/nvme/target/fabrics-cmd.c      | 33 +++++++++---
>>   drivers/nvme/target/nvmet.h            | 38 +++++++++++---
>>   drivers/nvme/target/tcp.c              | 23 +++++++-
>>   5 files changed, 192 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
>> index 7897d02c681d..7470ac020db6 100644
>> --- a/drivers/nvme/target/auth.c
>> +++ b/drivers/nvme/target/auth.c
>> @@ -15,6 +15,7 @@
>>   #include <linux/ctype.h>
>>   #include <linux/random.h>
>>   #include <linux/nvme-auth.h>
>> +#include <linux/nvme-keyring.h>
>>   #include <asm/unaligned.h>
>>   #include "nvmet.h"
>> @@ -138,7 +139,7 @@ int nvmet_setup_dhgroup(struct nvmet_ctrl *ctrl, 
>> u8 dhgroup_id)
>>       return ret;
>>   }
>> -u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl)
>> +u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
>>   {
>>       int ret = 0;
>>       struct nvmet_host_link *p;
>> @@ -164,6 +165,11 @@ u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl)
>>           goto out_unlock;
>>       }
>> +    if (nvmet_queue_tls_keyid(req->sq)) {
>> +        pr_debug("host %s tls enabled\n", ctrl->hostnqn);
>> +        goto out_unlock;
>> +    }
>> +
>>       ret = nvmet_setup_dhgroup(ctrl, host->dhchap_dhgroup_id);
>>       if (ret < 0) {
>>           pr_warn("Failed to setup DH group");
>> @@ -232,6 +238,9 @@ u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl)
>>   void nvmet_auth_sq_free(struct nvmet_sq *sq)
>>   {
>>       cancel_delayed_work(&sq->auth_expired_work);
>> +#ifdef CONFIG_NVME_TARGET_TCP_TLS
>> +    sq->tls_key = 0;
>> +#endif
>>       kfree(sq->dhchap_c1);
>>       sq->dhchap_c1 = NULL;
>>       kfree(sq->dhchap_c2);
>> @@ -260,6 +269,12 @@ void nvmet_destroy_auth(struct nvmet_ctrl *ctrl)
>>           nvme_auth_free_key(ctrl->ctrl_key);
>>           ctrl->ctrl_key = NULL;
>>       }
>> +#ifdef CONFIG_NVME_TARGET_TCP_TLS
>> +    if (ctrl->tls_key) {
>> +        key_put(ctrl->tls_key);
>> +        ctrl->tls_key = NULL;
>> +    }
>> +#endif
>>   }
>>   bool nvmet_check_auth_status(struct nvmet_req *req)
>> @@ -541,3 +556,58 @@ int nvmet_auth_ctrl_sesskey(struct nvmet_req *req,
>>       return ret;
>>   }
>> +
>> +void nvmet_auth_insert_psk(struct nvmet_sq *sq)
>> +{
>> +    int hash_len = nvme_auth_hmac_hash_len(sq->ctrl->shash_id);
>> +    u8 *psk, *digest, *tls_psk;
>> +    size_t psk_len;
>> +    int ret;
>> +#ifdef CONFIG_NVME_TARGET_TCP_TLS
>> +    struct key *tls_key = NULL;
>> +#endif
>> +
>> +    ret = nvme_auth_generate_psk(sq->ctrl->shash_id,
>> +                     sq->dhchap_skey,
>> +                     sq->dhchap_skey_len,
>> +                     sq->dhchap_c1, sq->dhchap_c2,
>> +                     hash_len, &psk, &psk_len);
>> +    if (ret) {
>> +        pr_warn("%s: ctrl %d qid %d failed to generate PSK, error %d\n",
>> +            __func__, sq->ctrl->cntlid, sq->qid, ret);
>> +        return;
>> +    }
>> +    ret = nvme_auth_generate_digest(sq->ctrl->shash_id, psk, psk_len,
>> +                    sq->ctrl->subsysnqn,
>> +                    sq->ctrl->hostnqn, &digest);
>> +    if (ret) {
>> +        pr_warn("%s: ctrl %d qid %d failed to generate digest, error 
>> %d\n",
>> +            __func__, sq->ctrl->cntlid, sq->qid, ret);
>> +        goto out_free_psk;
>> +    }
>> +    ret = nvme_auth_derive_tls_psk(sq->ctrl->shash_id, psk, psk_len,
>> +                       digest, &tls_psk);
>> +    if (ret) {
>> +        pr_warn("%s: ctrl %d qid %d failed to derive TLS PSK, error 
>> %d\n",
>> +            __func__, sq->ctrl->cntlid, sq->qid, ret);
>> +        goto out_free_digest;
>> +    }
>> +#ifdef CONFIG_NVME_TARGET_TCP_TLS
>> +    tls_key = nvme_tls_psk_refresh(NULL, sq->ctrl->hostnqn, sq->ctrl- 
>> >subsysnqn,
>> +                       sq->ctrl->shash_id, tls_psk, psk_len, digest);
>> +    if (IS_ERR(tls_key)) {
>> +        pr_warn("%s: ctrl %d qid %d failed to refresh key, error %ld\n",
>> +            __func__, sq->ctrl->cntlid, sq->qid, PTR_ERR(tls_key));
>> +        tls_key = NULL;
>> +        kfree_sensitive(tls_psk);
>> +    }
>> +    if (sq->ctrl->tls_key)
>> +        key_put(sq->ctrl->tls_key);
>> +    sq->ctrl->tls_key = tls_key;
>> +#endif
>> +
>> +out_free_digest:
>> +    kfree_sensitive(digest);
>> +out_free_psk:
>> +    kfree_sensitive(psk);
>> +}
>> diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/ 
>> target/fabrics-cmd-auth.c
>> index 3f2857c17d95..cf4b38c0e7bd 100644
>> --- a/drivers/nvme/target/fabrics-cmd-auth.c
>> +++ b/drivers/nvme/target/fabrics-cmd-auth.c
>> @@ -43,8 +43,26 @@ static u8 nvmet_auth_negotiate(struct nvmet_req 
>> *req, void *d)
>>            data->auth_protocol[0].dhchap.halen,
>>            data->auth_protocol[0].dhchap.dhlen);
>>       req->sq->dhchap_tid = le16_to_cpu(data->t_id);
>> -    if (data->sc_c)
>> -        return NVME_AUTH_DHCHAP_FAILURE_CONCAT_MISMATCH;
>> +    if (data->sc_c != NVME_AUTH_SECP_NOSC) {
>> +        if (!IS_ENABLED(CONFIG_NVME_TARGET_TCP_TLS))
>> +            return NVME_AUTH_DHCHAP_FAILURE_CONCAT_MISMATCH;
>> +        /* Secure concatenation can only be enabled on the admin 
>> queue */
>> +        if (req->sq->qid)
>> +            return NVME_AUTH_DHCHAP_FAILURE_CONCAT_MISMATCH;
>> +        switch (data->sc_c) {
>> +        case NVME_AUTH_SECP_NEWTLSPSK:
>> +            if (nvmet_queue_tls_keyid(req->sq))
>> +                return NVME_AUTH_DHCHAP_FAILURE_CONCAT_MISMATCH;
>> +            break;
> 
> fallthru instead?
> 
Yeah, will do.

>> +        case NVME_AUTH_SECP_REPLACETLSPSK:
>> +            if (!nvmet_queue_tls_keyid(req->sq))
>> +                return NVME_AUTH_DHCHAP_FAILURE_CONCAT_MISMATCH;
>> +            break;
>> +        default:
>> +            return NVME_AUTH_DHCHAP_FAILURE_CONCAT_MISMATCH;
>> +        }
>> +        ctrl->concat = true;
>> +    }
>>       if (data->napd != 1)
>>           return NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
>> @@ -103,6 +121,13 @@ static u8 nvmet_auth_negotiate(struct nvmet_req 
>> *req, void *d)
>>                nvme_auth_dhgroup_name(fallback_dhgid));
>>           ctrl->dh_gid = fallback_dhgid;
>>       }
>> +    if (ctrl->dh_gid == NVME_AUTH_DHGROUP_NULL &&
>> +        ctrl->concat) {
>> +        pr_debug("%s: ctrl %d qid %d: NULL DH group invalid "
>> +             "for secure channel concatenation\n", __func__,
>> +             ctrl->cntlid, req->sq->qid);
>> +        return NVME_AUTH_DHCHAP_FAILURE_CONCAT_MISMATCH;
>> +    }
>>       pr_debug("%s: ctrl %d qid %d: selected DH group %s (%d)\n",
>>            __func__, ctrl->cntlid, req->sq->qid,
>>            nvme_auth_dhgroup_name(ctrl->dh_gid), ctrl->dh_gid);
>> @@ -154,6 +179,12 @@ static u8 nvmet_auth_reply(struct nvmet_req *req, 
>> void *d)
>>       kfree(response);
>>       pr_debug("%s: ctrl %d qid %d host authenticated\n",
>>            __func__, ctrl->cntlid, req->sq->qid);
>> +    if (!data->cvalid && ctrl->concat) {
>> +        pr_debug("%s: ctrl %d qid %d invalid challenge\n",
>> +             __func__, ctrl->cntlid, req->sq->qid);
>> +        return NVME_AUTH_DHCHAP_FAILURE_FAILED;
>> +    }
>> +    req->sq->dhchap_s2 = le32_to_cpu(data->seqnum);
>>       if (data->cvalid) {
>>           req->sq->dhchap_c2 = kmemdup(data->rval + data->hl, data->hl,
>>                            GFP_KERNEL);
>> @@ -163,11 +194,15 @@ static u8 nvmet_auth_reply(struct nvmet_req 
>> *req, void *d)
>>           pr_debug("%s: ctrl %d qid %d challenge %*ph\n",
>>                __func__, ctrl->cntlid, req->sq->qid, data->hl,
>>                req->sq->dhchap_c2);
>> -    } else {
>> +    }
>> +    if (req->sq->dhchap_s2 == 0) {
>> +        if (ctrl->concat)
>> +            nvmet_auth_insert_psk(req->sq);
>>           req->sq->authenticated = true;
>> +        kfree(req->sq->dhchap_c2);
>>           req->sq->dhchap_c2 = NULL;
>> -    }
>> -    req->sq->dhchap_s2 = le32_to_cpu(data->seqnum);
>> +    } else if (!data->cvalid)
>> +        req->sq->authenticated = true;
>>       return 0;
>>   }
>> @@ -241,7 +276,7 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
>>               pr_debug("%s: ctrl %d qid %d reset negotiation\n",
>>                    __func__, ctrl->cntlid, req->sq->qid);
>>               if (!req->sq->qid) {
>> -                dhchap_status = nvmet_setup_auth(ctrl);
>> +                dhchap_status = nvmet_setup_auth(ctrl, req);
>>                   if (dhchap_status) {
>>                       pr_err("ctrl %d qid 0 failed to setup re- 
>> authentication\n",
>>                              ctrl->cntlid);
>> @@ -298,6 +333,8 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
>>           }
>>           goto done_kfree;
>>       case NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2:
>> +        if (ctrl->concat)
>> +            nvmet_auth_insert_psk(req->sq);
>>           req->sq->authenticated = true;
>>           pr_debug("%s: ctrl %d qid %d ctrl authenticated\n",
>>                __func__, ctrl->cntlid, req->sq->qid);
>> diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/ 
>> fabrics-cmd.c
>> index c4b2eddd5666..9a1256deee51 100644
>> --- a/drivers/nvme/target/fabrics-cmd.c
>> +++ b/drivers/nvme/target/fabrics-cmd.c
>> @@ -199,10 +199,26 @@ static u16 nvmet_install_queue(struct nvmet_ctrl 
>> *ctrl, struct nvmet_req *req)
>>       return ret;
>>   }
>> -static u32 nvmet_connect_result(struct nvmet_ctrl *ctrl)
>> +static u32 nvmet_connect_result(struct nvmet_ctrl *ctrl, struct 
>> nvmet_req *req)
>>   {
>> +    bool needs_auth = nvmet_has_auth(ctrl, req);
>> +    key_serial_t keyid = nvmet_queue_tls_keyid(req->sq);
>> +
>> +    /* Do not authenticate I/O queues for secure concatenation */
>> +    if (ctrl->concat && req->sq->qid)
>> +        needs_auth = false;
>> +
>> +    if (keyid)
>> +        pr_debug("%s: ctrl %d qid %d should %sauthenticate, tls psk 
>> %08x\n",
>> +             __func__, ctrl->cntlid, req->sq->qid,
>> +             needs_auth ? "" : "not ", keyid);
>> +    else
>> +        pr_debug("%s: ctrl %d qid %d should %sauthenticate%s\n",
>> +             __func__, ctrl->cntlid, req->sq->qid,
>> +             needs_auth ? "" : "not ",
>> +             ctrl->concat ? ", secure concatenation" : "");
>>       return (u32)ctrl->cntlid |
>> -        (nvmet_has_auth(ctrl) ? NVME_CONNECT_AUTHREQ_ATR : 0);
>> +        (needs_auth ? NVME_CONNECT_AUTHREQ_ATR : 0);
>>   }
>>   static void nvmet_execute_admin_connect(struct nvmet_req *req)
>> @@ -251,7 +267,7 @@ static void nvmet_execute_admin_connect(struct 
>> nvmet_req *req)
>>       uuid_copy(&ctrl->hostid, &d->hostid);
>> -    dhchap_status = nvmet_setup_auth(ctrl);
>> +    dhchap_status = nvmet_setup_auth(ctrl, req);
>>       if (dhchap_status) {
>>           pr_err("Failed to setup authentication, dhchap status %u\n",
>>                  dhchap_status);
>> @@ -269,12 +285,13 @@ static void nvmet_execute_admin_connect(struct 
>> nvmet_req *req)
>>           goto out;
>>       }
>> -    pr_info("creating %s controller %d for subsystem %s for NQN 
>> %s%s%s.\n",
>> +    pr_info("creating %s controller %d for subsystem %s for NQN 
>> %s%s%s%s.\n",
>>           nvmet_is_disc_subsys(ctrl->subsys) ? "discovery" : "nvm",
>>           ctrl->cntlid, ctrl->subsys->subsysnqn, ctrl->hostnqn,
>> -        ctrl->pi_support ? " T10-PI is enabled" : "",
>> -        nvmet_has_auth(ctrl) ? " with DH-HMAC-CHAP" : "");
>> -    req->cqe->result.u32 = cpu_to_le32(nvmet_connect_result(ctrl));
>> +        ctrl->pi_support ? ", T10-PI" : "",
>> +        nvmet_has_auth(ctrl, req) ? ", DH-HMAC-CHAP" : "",
>> +        nvmet_queue_tls_keyid(req->sq) ? ", TLS" : "");
>> +    req->cqe->result.u32 = cpu_to_le32(nvmet_connect_result(ctrl, req));
>>   out:
>>       kfree(d);
>>   complete:
>> @@ -330,7 +347,7 @@ static void nvmet_execute_io_connect(struct 
>> nvmet_req *req)
>>           goto out_ctrl_put;
>>       pr_debug("adding queue %d to ctrl %d.\n", qid, ctrl->cntlid);
>> -    req->cqe->result.u32 = cpu_to_le32(nvmet_connect_result(ctrl));
>> +    req->cqe->result.u32 = cpu_to_le32(nvmet_connect_result(ctrl, req));
>>   out:
>>       kfree(d);
>>   complete:
>> diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
>> index 190f55e6d753..c2e17201c757 100644
>> --- a/drivers/nvme/target/nvmet.h
>> +++ b/drivers/nvme/target/nvmet.h
>> @@ -121,6 +121,9 @@ struct nvmet_sq {
>>       u32            dhchap_s2;
>>       u8            *dhchap_skey;
>>       int            dhchap_skey_len;
>> +#endif
>> +#ifdef CONFIG_NVME_TARGET_TCP_TLS
>> +    struct key        *tls_key;
>>   #endif
>>       struct completion    free_done;
>>       struct completion    confirm_done;
>> @@ -237,6 +240,7 @@ struct nvmet_ctrl {
>>       u64            err_counter;
>>       struct nvme_error_slot    slots[NVMET_ERROR_LOG_SLOTS];
>>       bool            pi_support;
>> +    bool            concat;
>>   #ifdef CONFIG_NVME_TARGET_AUTH
>>       struct nvme_dhchap_key    *host_key;
>>       struct nvme_dhchap_key    *ctrl_key;
>> @@ -246,6 +250,9 @@ struct nvmet_ctrl {
>>       u8            *dh_key;
>>       size_t            dh_keysize;
>>   #endif
>> +#ifdef CONFIG_NVME_TARGET_TCP_TLS
>> +    struct key        *tls_key;
>> +#endif
>>   };
>>   struct nvmet_subsys {
>> @@ -716,13 +723,29 @@ static inline void nvmet_req_bio_put(struct 
>> nvmet_req *req, struct bio *bio)
>>           bio_put(bio);
>>   }
>> +#ifdef CONFIG_NVME_TARGET_TCP_TLS
>> +static inline key_serial_t nvmet_queue_tls_keyid(struct nvmet_sq *sq)
>> +{
>> +    return sq->tls_key ? key_serial(sq->tls_key) : 0;
>> +}
>> +static inline void nvmet_sq_put_tls_key(struct nvmet_sq *sq)
>> +{
>> +    if (sq->tls_key) {
>> +        key_put(sq->tls_key);
>> +        sq->tls_key = NULL;
>> +    }
>> +}
>> +#else
>> +static inline key_serial_t nvmet_queue_tls_keyid(struct nvmet_sq *sq) 
>> { return 0; }
>> +static inline void nvmet_sq_put_tls_key(struct nvmet_sq *sq) {}
>> +#endif
>>   #ifdef CONFIG_NVME_TARGET_AUTH
>>   void nvmet_execute_auth_send(struct nvmet_req *req);
>>   void nvmet_execute_auth_receive(struct nvmet_req *req);
>>   int nvmet_auth_set_key(struct nvmet_host *host, const char *secret,
>>                  bool set_ctrl);
>>   int nvmet_auth_set_host_hash(struct nvmet_host *host, const char 
>> *hash);
>> -u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl);
>> +u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_req *req);
>>   void nvmet_auth_sq_init(struct nvmet_sq *sq);
>>   void nvmet_destroy_auth(struct nvmet_ctrl *ctrl);
>>   void nvmet_auth_sq_free(struct nvmet_sq *sq);
>> @@ -732,16 +755,18 @@ int nvmet_auth_host_hash(struct nvmet_req *req, 
>> u8 *response,
>>                unsigned int hash_len);
>>   int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8 *response,
>>                unsigned int hash_len);
>> -static inline bool nvmet_has_auth(struct nvmet_ctrl *ctrl)
>> +static inline bool nvmet_has_auth(struct nvmet_ctrl *ctrl, struct 
>> nvmet_req *req)
>>   {
>> -    return ctrl->host_key != NULL;
>> +    return ctrl->host_key != NULL && !nvmet_queue_tls_keyid(req->sq);
>>   }
>>   int nvmet_auth_ctrl_exponential(struct nvmet_req *req,
>>                   u8 *buf, int buf_size);
>>   int nvmet_auth_ctrl_sesskey(struct nvmet_req *req,
>>                   u8 *buf, int buf_size);
>> +void nvmet_auth_insert_psk(struct nvmet_sq *sq);
>>   #else
>> -static inline u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl)
>> +static inline u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl,
>> +                  struct nvmet_req *req)
>>   {
>>       return 0;
>>   }
>> @@ -754,11 +779,12 @@ static inline bool 
>> nvmet_check_auth_status(struct nvmet_req *req)
>>   {
>>       return true;
>>   }
>> -static inline bool nvmet_has_auth(struct nvmet_ctrl *ctrl)
>> +static inline bool nvmet_has_auth(struct nvmet_ctrl *ctrl,
>> +                  struct nvmet_req *req)
>>   {
>>       return false;
>>   }
>>   static inline const char *nvmet_dhchap_dhgroup_name(u8 dhgid) 
>> { return NULL; }
>> +static inline void nvmet_auth_insert_psk(struct nvmet_sq *sq) {};
>>   #endif
>> -
>>   #endif /* _NVMET_H */
>> diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
>> index 7c51c2a8c109..671600b5c64b 100644
>> --- a/drivers/nvme/target/tcp.c
>> +++ b/drivers/nvme/target/tcp.c
>> @@ -1073,10 +1073,11 @@ static int nvmet_tcp_done_recv_pdu(struct 
>> nvmet_tcp_queue *queue)
>>       if (unlikely(!nvmet_req_init(req, &queue->nvme_cq,
>>               &queue->nvme_sq, &nvmet_tcp_ops))) {
>> -        pr_err("failed cmd %p id %d opcode %d, data_len: %d\n",
>> +        pr_err("failed cmd %p id %d opcode %d, data_len: %d, status: 
>> %04x\n",
>>               req->cmd, req->cmd->common.command_id,
>>               req->cmd->common.opcode,
>> -            le32_to_cpu(req->cmd->common.dptr.sgl.length));
>> +               le32_to_cpu(req->cmd->common.dptr.sgl.length),
>> +               le16_to_cpu(req->cqe->status));
>>           nvmet_tcp_handle_req_failure(queue, queue->cmd, req);
>>           return 0;
>> @@ -1602,6 +1603,7 @@ static void nvmet_tcp_release_queue_work(struct 
>> work_struct *w)
>>       /* stop accepting incoming data */
>>       queue->rcv_state = NVMET_TCP_RECV_ERR;
>> +    nvmet_sq_put_tls_key(&queue->nvme_sq);
>>       nvmet_tcp_uninit_data_in_cmds(queue);
>>       nvmet_sq_destroy(&queue->nvme_sq);
>>       cancel_work_sync(&queue->io_work);
>> @@ -1807,6 +1809,23 @@ static void nvmet_tcp_tls_handshake_done(void 
>> *data, int status,
>>       spin_unlock_bh(&queue->state_lock);
>>       cancel_delayed_work_sync(&queue->tls_handshake_tmo_work);
>> +
>> +    if (!status) {
>> +        struct key *tls_key = nvme_tls_key_lookup(peerid);
>> +
>> +        if (IS_ERR(tls_key)) {
> 
> It is not clear to me how this can happen. Can you explain?
> 
Passing key information between kernel and handshake daemon is
done purely by key IDs (not the keys itself).
So we will be getting a key ID back from the handshaked daemon,
and we need to validate that; the user (or admin software) could
have invalidated the key while the handshake was running, or before
we had a chance to process the reply from the handshake daemon.

> Other than that, patch looks good.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
