Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591071DDC2D
	for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2024 07:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729496210; cv=none; b=eFWitTY0cMMrxMXOEezQQS4hDwG0QO9O8xKL4JIUJAZ0wF122z/G6C45B5cyYrj7O7HsRcoMfVGh6DcrBzQCUV1jDNcEGSFy/3iehZRVHqo7TxxLrqa4RXTntVbkkg7wZo0qCQqyxjXKY1FAVlIX7sr4WGN+3DZIy81T+w4dHWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729496210; c=relaxed/simple;
	bh=cg6i9ZrF2sMdk1V6CY8lUAwsBoDMUMFnT43bcIYMeU0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YVpgbZTfQDE3CisnM7RuIJVNfpQA8j2+s8Ik9zDsYQlN/HXfIhjqYxOEWEk+exSNLjQY6kXyK5Gu5Ws8BCVUkDg/t4RXUVPUvGXK2pfHPpDlGF1EZzmCSH30uOxESpvEnd/kYbxJvU8H8OB3w35DKTBOhMvHUGDp5YotUvyspps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-37d49a7207cso3013865f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2024 00:36:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729496206; x=1730101006;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7z9AQDH/axtlM5skrfxOefymtsdnDWAhql5dr5c5XEU=;
        b=fpDGrYIsUWNRJRPdbB+2VhaJBxKcaQSA8HDWZL+1PcrDQ8MSLBYckVWoGa/A6buP/X
         xKHNZQsElJ2FUxPi3uD0oqSC7TfiQYMnDWnHMwZ6tXImfaAyfb6OZf2+XAAJYkMho08b
         G3wWq+uejb6SghnCyM3GrX+dfY9NfdPWbGLCn3nyxYOBext+e3oZqdM+pfyQkxNvB1es
         tvJkEkRexmnOvKXUi89l7V3J2NkZHm0uL6yBaACNPkyRJ5hzwToJreisJ2db6cH/XSLf
         +2BF7k/XXrMpnY9dsY+DTpFqcBIBBedMxZmaGVeWWgmLvXd/CMAb6ZOI59IhDE6YrYri
         cLyg==
X-Forwarded-Encrypted: i=1; AJvYcCW4nU4MNgLqhaB+ABihVahi4cOHXwojrGxnL4ezBRcWRULK7sQParSUKteH4U3LSrXGrY3uYjn/0xHu3ac=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx0PYISu9JKWL2m6NnkXT3MVvJk1XFSJRDkU2B9Q8xeVBBN2c+
	48wCy9HOHBDWQARatfg5BD4VnMf0TUX4uAz9ep7VtT+REUZpmq9r
X-Google-Smtp-Source: AGHT+IGwxAZXDoFxBiYjnprdyBVMuX/JrqMe5rYb/faMMdMtEbnnVW5u0SALMKOBlyrbACpvJAzdFw==
X-Received: by 2002:a05:6000:a86:b0:37d:3650:fae5 with SMTP id ffacd0b85a97d-37eab6ec44dmr6896650f8f.52.1729496206525;
        Mon, 21 Oct 2024 00:36:46 -0700 (PDT)
Received: from [10.50.4.202] (bzq-84-110-32-226.static-ip.bezeqint.net. [84.110.32.226])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0a4b26dsm3576472f8f.45.2024.10.21.00.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 00:36:46 -0700 (PDT)
Message-ID: <880bedd1-1487-49e1-9d56-0eabd5797baf@grimberg.me>
Date: Mon, 21 Oct 2024 10:36:45 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] nvmet-tcp: support secure channel concatenation
To: Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@kernel.org>,
 Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20241018063343.39798-1-hare@kernel.org>
 <20241018063343.39798-9-hare@kernel.org>
 <4bb5aa23-6f59-462d-9f50-44e5edaec7e1@grimberg.me>
 <3d656683-b091-4a5a-b064-39afe4896c52@suse.de>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <3d656683-b091-4a5a-b064-39afe4896c52@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

>>>
>>> diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
>>> index 7c51c2a8c109..671600b5c64b 100644
>>> --- a/drivers/nvme/target/tcp.c
>>> +++ b/drivers/nvme/target/tcp.c
>>> @@ -1073,10 +1073,11 @@ static int nvmet_tcp_done_recv_pdu(struct 
>>> nvmet_tcp_queue *queue)
>>>       if (unlikely(!nvmet_req_init(req, &queue->nvme_cq,
>>>               &queue->nvme_sq, &nvmet_tcp_ops))) {
>>> -        pr_err("failed cmd %p id %d opcode %d, data_len: %d\n",
>>> +        pr_err("failed cmd %p id %d opcode %d, data_len: %d, 
>>> status: %04x\n",
>>>               req->cmd, req->cmd->common.command_id,
>>>               req->cmd->common.opcode,
>>> - le32_to_cpu(req->cmd->common.dptr.sgl.length));
>>> + le32_to_cpu(req->cmd->common.dptr.sgl.length),
>>> +               le16_to_cpu(req->cqe->status));
>>>           nvmet_tcp_handle_req_failure(queue, queue->cmd, req);
>>>           return 0;
>>> @@ -1602,6 +1603,7 @@ static void 
>>> nvmet_tcp_release_queue_work(struct work_struct *w)
>>>       /* stop accepting incoming data */
>>>       queue->rcv_state = NVMET_TCP_RECV_ERR;
>>> +    nvmet_sq_put_tls_key(&queue->nvme_sq);
>>>       nvmet_tcp_uninit_data_in_cmds(queue);
>>>       nvmet_sq_destroy(&queue->nvme_sq);
>>>       cancel_work_sync(&queue->io_work);
>>> @@ -1807,6 +1809,23 @@ static void nvmet_tcp_tls_handshake_done(void 
>>> *data, int status,
>>>       spin_unlock_bh(&queue->state_lock);
>>> cancel_delayed_work_sync(&queue->tls_handshake_tmo_work);
>>> +
>>> +    if (!status) {
>>> +        struct key *tls_key = nvme_tls_key_lookup(peerid);
>>> +
>>> +        if (IS_ERR(tls_key)) {
>>
>> It is not clear to me how this can happen. Can you explain?
>>
> Passing key information between kernel and handshake daemon is
> done purely by key IDs (not the keys itself).
> So we will be getting a key ID back from the handshaked daemon,
> and we need to validate that; the user (or admin software) could
> have invalidated the key while the handshake was running, or before
> we had a chance to process the reply from the handshake daemon.

Got it. thanks.
