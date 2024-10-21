Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3B61C32EC
	for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2024 15:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729524739; cv=none; b=Xh0PJzZnQ5PpTgbMfMYOlJuPnPPgdWEY/aa5dvaGspmm7Ra7HgCNwaIcjJDga9Z/kvffUQqu3FXUvfNXiK2L8ZU0LWcVA3dPyn5aSJ1OTv6Rt3bzNXQ9fJ9Ec0zAIEbYTeBr2j2u9cuCdz1GjBcWXQfmxN7oTd2QrBVD/jJbni0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729524739; c=relaxed/simple;
	bh=BC9DmSi1ac+9XM/aHB57wCVU9HXpEujy3j+mFw3OYMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lf9xOTtVPdUVPGzjWgeT/y7VlN0VRAYaHcnw8g1BO5So7jCy2ifmXV2E1SwB2gwUg9ebRonw3tbtanLf5n4M+6uyB8LMqBJn/3loO3tWrg2+WP6mHDUk7lze4sRCtjH0FK9eHOcxeJ3CkNh6e1USuRMIlvC733qWcylHTqK5gqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4315e9e9642so37956475e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2024 08:32:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729524736; x=1730129536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=43UnT+pFGN/YtllYopifa6ZWEaQaAuDJazNLhRyQg+g=;
        b=RYXnatIo2YJ++8/Cdy/if0r74cuVEHz5O+k1yfVDCNfOLi1nNnIUxSl9ZUU4XD7S0C
         aNsUzw2WyiKywBIrjQ2laeUTDdUyHjsKUjhI4DMRrtOyiOifaUQAI15cVWflIBot8WXz
         RhPeymZxKsTkoqEOnJ12THDq6OaPmb2kXzzXogBzNpMPbBsFB91vYl6wYgt+WAmSdWxQ
         g+BmoaKGaWj+Is++at4JmfpoN0Hd1lmrxFQIFGtUI/DWuxho9jhbL5NQpG2oOCz3WHeu
         NMW3BC/Ul8zi1G7W6RDtKa1PdRrKhtBp6ZpPl1VhCphh7k4gw9gYbs8z5oghKXj6cazO
         rGOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpKqgYqMHjkfkfVwVr1ClKYAuyyG7fHzGp5RFIplCLlMTWICwxF0sBSZaZzoa+rc9ffwfYyt1nD7eGgA0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsENeEygdo8XPGANn0IS5x4T6Mu6wpBpCrtK7TsOBYJ/dPO/oE
	fP+gqcMRJo20AxKxy0zNqUhYTW0jNJnQ3dlxjP/xbGhzpTthPDy+
X-Google-Smtp-Source: AGHT+IEP5TEn2oZzz0bJqnjDuhV4Vk01puR4VsoCK0og6+x1FdquNP63k9jUmbXcnF40AaeijMWbiA==
X-Received: by 2002:a05:600c:3110:b0:431:60ec:7a96 with SMTP id 5b1f17b1804b1-4316169ac06mr94805705e9.25.1729524735392;
        Mon, 21 Oct 2024 08:32:15 -0700 (PDT)
Received: from [10.100.102.74] (89-138-78-158.bb.netvision.net.il. [89.138.78.158])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0b9bc9csm4541692f8f.108.2024.10.21.08.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 08:32:15 -0700 (PDT)
Message-ID: <0b07ae7c-0324-4e29-8058-dce4d29fe5cd@grimberg.me>
Date: Mon, 21 Oct 2024 18:32:14 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] nvme-tcp: request secure channel concatenation
To: Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@kernel.org>,
 Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20241018063343.39798-1-hare@kernel.org>
 <20241018063343.39798-7-hare@kernel.org>
 <a188adf5-55be-4524-b8eb-63f7470a4b15@grimberg.me>
 <56fde9ae-8e27-4ade-bdc4-99bf3f53a299@suse.de>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <56fde9ae-8e27-4ade-bdc4-99bf3f53a299@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 21/10/2024 14:00, Hannes Reinecke wrote:
> On 10/20/24 23:04, Sagi Grimberg wrote:
>>
>>
>>
>> On 18/10/2024 9:33, Hannes Reinecke wrote:
>>> Add a fabrics option 'concat' to request secure channel concatenation.
>>> When secure channel concatenation is enabled a 'generated PSK' is 
>>> inserted
>>> into the keyring such that it's available after reset.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@kernel.org>
>>> ---
>>>   drivers/nvme/host/auth.c    | 108 
>>> +++++++++++++++++++++++++++++++++++-
>>>   drivers/nvme/host/fabrics.c |  34 +++++++++++-
>>>   drivers/nvme/host/fabrics.h |   3 +
>>>   drivers/nvme/host/nvme.h    |   2 +
>>>   drivers/nvme/host/sysfs.c   |   4 +-
>>>   drivers/nvme/host/tcp.c     |  47 ++++++++++++++--
>>>   include/linux/nvme.h        |   7 +++
>>>   7 files changed, 191 insertions(+), 14 deletions(-)
>>>
> [ .. ]
>>> @@ -2314,6 +2345,8 @@ static void 
>>> nvme_tcp_error_recovery_work(struct work_struct *work)
>>>                   struct nvme_tcp_ctrl, err_work);
>>>       struct nvme_ctrl *ctrl = &tcp_ctrl->ctrl;
>>> +    if (nvme_tcp_key_revoke_needed(ctrl))
>>> +        nvme_auth_revoke_tls_key(ctrl);
>>
>> Having this sprayed in various places in the code is really confusing.
>>
>> Can you please add a small comment on each call-site? just for our 
>> future selves
>> reading this code?
>>
>> Outside of that, patch looks good.
>>
> Weelll ...
> We need to reset the negotiated PSK exactly in three places:
> - reset
> - error recovery
> - teardown
> Much like we need to do for every other queue-related resource.
>
> And in one of your previous reviews you stated that you do _not_
> want to have 'nvme_auth_revoke_tls_key()' checking if the key
> needs to be revoked, but rather have a check function.

Sounds right.

> Otherwise I could just move the check into nvme_auth_revoke_tls_key()'
> and drop the 'revoke needed' call.

I prefer that we don't

>
> Furthermore we don't need to check if the key needs to be revoked
> during teardown (answer will always be 'yes').

won't it also be revoked in setup?

>
> So I'm quite unsure what to do now ... document that we need
> to release the key when doing a reset or error recovery?
> Move the check back into nvme_auth_tls_revoke_key()?
> Hmm?

Just a little documentation to why we like to revoke the key so many 
times ;)


