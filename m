Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A63377EBA
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jun 2026 16:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781021501; cv=none; b=dyrfgKKShongWo2nbcji17jwUuBks20mi2QXsojPyfFnBwP6wlu3xGvrCJ3Byg9B0ZBaeSya5a/LkSLxDgTGVPg1qU+SuWVZHBmoBnHAKDmtLASzVP+zMziV5Mq8O4/0Fg78VvCyD722tNnqTratoltgXROXIWkjipRxvSzQIzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781021501; c=relaxed/simple;
	bh=SAwVSIpbBVSSm/QOrxOQeLPJSaQMMq+APGawOi2mwz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fsd77qQ42w2zmYNdbSiAsI71BUK8zwRLnoF7lBvVYY//jOFcX4AV5/4IZkJayM8eeODHnI0RlBX/c04/qXIomqu2oNCN0ZLD6LHnmM5iI7ppRjUBcGPKVXBYGFFRQmnVwbQtgSBA+zG06gxxlW9RBEXmrclh+x55KnHuM6xS7c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YaRDK5EO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=snR0Stvk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YaRDK5EO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="snR0Stvk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781021498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eUi2jL88nb99lUkzNQdrBv5hE8psb1dm+z91nfr54A0=;
	b=YaRDK5EOXx+3P8WMtA+5YjqWT4CxRDNHlySXMPkUTII2NIBkJlIUt+sqGhBcTLvSc6Wg1x
	CLF86fuhjNZcVWuHas8Q6NU9EdDPfVwLGPPWO4oOje3YrIqk1MdVF5clUsBRJCxk/eyDfH
	b68/5qI3iEmalfEW7TkekppmIvsOlIw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-BUiA2U_oOBSh56r6UCxhNQ-1; Tue, 09 Jun 2026 12:11:35 -0400
X-MC-Unique: BUiA2U_oOBSh56r6UCxhNQ-1
X-Mimecast-MFC-AGG-ID: BUiA2U_oOBSh56r6UCxhNQ_1781021494
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490b8adf8b8so52298445e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 09:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781021494; x=1781626294; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eUi2jL88nb99lUkzNQdrBv5hE8psb1dm+z91nfr54A0=;
        b=snR0StvkBf9vI3vfMMe/NhUTl11QWCcbn5pB8YxUfArcwtuRP6kg39uyA/xiSy3wv9
         9V5bOxePQ1sUDVZox6siw3oN+J3kL4blxCfY7OT98xkYM5virOYN0WSlSz60A8xZJ0pq
         DYzH170AyunFCriXVvfVSWU6cQtOcUtHBeR24eV3hpownOXXb4ZsZlx7PM7yKTrkc/pA
         hizqc+xOaz7uAhwRNmAuo+sySg4qEGIjw32Z1aU/d7dUORN7bDfqWUJWgF4NRz0UG2kF
         zR4hmJXaVl1nQN9vUPOlZ0oAjWgzyMGUf7vcgpqMl8wAAszC18Er19fDj0p8R3/lb0su
         JLJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781021494; x=1781626294;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eUi2jL88nb99lUkzNQdrBv5hE8psb1dm+z91nfr54A0=;
        b=OJt6kzJF6pe/upnKqaiFGZaY8qboY9oHmAWRLqZujXwZwskTn6DoW2uYCC3iiABbAQ
         xA57CT4MDPQrrKSmS45n42FHPEYPpUNPz3cdyW65UUcuyyeg4WrzuOqK1R6BaW6kE8WD
         0kwPueHGug3eDGHyKTrgrEfHQPGj8/8rQWNO0WNA+4TZbYz253Qs1aNm9xEOdghwzj18
         9m96TYT8dJQ5Sw2HxtHrCqsL6jN1q0i+bh0bXMZ1WghAxGOsvv2hUa7u0qVnydEgNmWq
         yab7WPWu1j4ksavKPKvbFgjUhvNn+ACojVXilwud71yh2saKk3N9cjft61abqcaVcfAP
         6qAQ==
X-Forwarded-Encrypted: i=1; AFNElJ/o17Ka2hwgAx6pR6/tJRaWSJpzsc4rAb8vcFidBPOPJBrDe2mjpIOaoDkFnnAOk8R0QGBPupX07sSud0w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8wHhRks3a5CXzDV6w+SPhZybqHd1bpzqy812uYqzZDO0ae5Q7
	i8DddayFRGcOzQNUWonN87N7j6vjjrIVYo8peZREusNKOKihyX8/N+urmGEPI0kccaaId8xNfHA
	tx8Bl9moQMmXvPNhjYkmGswfVJAX+tLKCXdh2+aHc2ye6+f8Rd4uvmApDCBKxkc01Sw==
X-Gm-Gg: Acq92OH2uUVhyZMHtXmJkcI4FNhz7/THqA6DgHniyq4EavRG17WWwi2UTLn+SutVmFr
	N7Js8v7Zlz4I3jUMHujA2XNZeT2bL1s/AHMCnmPVQxblQg8LVf3Ef3tKs/SxKgSj9e6c5v+PUc/
	q6iVF5LneBLOFEG7rTdKyvLbuabWWPzhYKeDSGk1ceayBMrERXCl3O9d09xcU4THnwf3oanOATt
	Btz9ugyteFuaE1cXet5HuQ4wsl3XMu9GJvcMoUorIuHL8HYGt7y/OANxsekx8Ogo2vfhPqd1nAM
	WySjV2U9Qmr47CfJ49JCVUmZ4t7SwiAaa+GkX5PaHxJ0FyCyEy8XTtsHiY5mXJfDdZVqv9igZqE
	yXoCM5qPeaFU2eN472+AuZM7VwKOvFt99eXw76AreN49SG+B7GbfrTAGdRvy2c+tROA==
X-Received: by 2002:a05:600c:529b:b0:490:5380:f2cb with SMTP id 5b1f17b1804b1-490c2528b6amr350246135e9.0.1781021494227;
        Tue, 09 Jun 2026 09:11:34 -0700 (PDT)
X-Received: by 2002:a05:600c:529b:b0:490:5380:f2cb with SMTP id 5b1f17b1804b1-490c2528b6amr350245255e9.0.1781021493734;
        Tue, 09 Jun 2026 09:11:33 -0700 (PDT)
Received: from [192.168.88.32] ([150.228.93.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc40716bsm524282715e9.12.2026.06.09.09.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2026 09:11:33 -0700 (PDT)
Message-ID: <a4091402-e7c0-415e-a2a4-67d2b509462f@redhat.com>
Date: Tue, 9 Jun 2026 18:11:31 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 0/5] Consolidate FCrypt and PCBC code into
 net/rxrpc/
To: David Howells <dhowells@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Marc Dionne <marc.c.dionne@gmail.com>, netdev@vger.kernel.org,
 linux-afs@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Eric Biggers <ebiggers@kernel.org>
References: <20260608173921.GA434331@google.com>
 <20260522050740.84561-1-ebiggers@kernel.org>
 <CAB9dFduBir-41_Ef4noEJPHsFU-++JHDxMU-6S7B8pBYynvadA@mail.gmail.com>
 <20260603050557.GB18149@sol> <764077.1780985938@warthog.procyon.org.uk>
From: Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <764077.1780985938@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 6/9/26 8:18 AM, David Howells wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
>>> If there's no more feedback, could this be applied to net-next?
>>
>> Any update on this?
> 
> It's fine by me, but I'm not sure what I need to do with it - shouldn't it
> already be in the netdev queue, or do I need to post it?

This slipped under my radar, sorry. I just revived it in PW. Also, I
think we need an explicit ack from Herbert.

Link to ML post:

https://lore.kernel.org/all/20260522050740.84561-1-ebiggers@kernel.org/

Thanks,

Paolo


