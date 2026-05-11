Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9063B7744
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2026 21:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778533407; cv=none; b=DObgDM+bIuiphxbB4pqGbJlLkgc0DfBBDDKKo4YjPdynB/nn6xKk5YD1EXhtKHdFlWAPkOxq2q6ZEC1NejSw5Ahc8PaL23r29UsQianbCANWQeG8QqT4hI16RXi7W1EHzk3LUBovIfT2cKmQc5zgX0DrYlqNhqR3s7nqtyjujwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778533407; c=relaxed/simple;
	bh=+NPExyxgo8HU6B6S+16brBkL/23BFRjYZRCRMSCRDlY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Kb+u4Q9MAd4iCYFcR3wkfLZmP12yA8SO1/oGlGWTxT/Xe5Qj9HKsQ4FwLSStn1fCjhfMlPUcvXzMhsDt47Km8Wxxhhu22m4A2Tcxuuxz9XJjidcSRmkLjKAprdIFYmtvasHw8X2KJsJpt7iM78JWXDdx8gGcrDJnlD7pcwkxwBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48d102471a4so47549085e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 11 May 2026 14:03:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778533404; x=1779138204;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jz3M0PDIssZI97ILfGYCglTutVrokgfI2vbgfWrvds4=;
        b=M+e6jse5VtLIwLIRnorI+2fDPCsHRaYLxqNI2B7hDcoSo0vEiBVGGrhWdECzPEDrwi
         ID/lWMI7XnuP5Xtpg+SPWwp6JmSyOAbnp8jPR5YU9O4Smpu53GXBLhgI/LzY8+XEqm/C
         ker3eCKHqX33DmHf5olUKnYhLA/myOwlncbIignDLODylmz3ygDBknodwejs73r/xlI7
         94mI9mLMqoevJ0AfrA45I5kmcOjnen3tW0SEEbOIWalRF5OnqFYucw99HC0sU2rSwhPy
         8up6FUXHMIb4VEhuUTYm1s8K8trSKzHtqvIVSbcZWJNFCtIQiiFy3Qmu8980q0KYUsO5
         mJjw==
X-Forwarded-Encrypted: i=1; AFNElJ8Ns8QerLYh+Lmc9fV6hb+2eSgUKDTB767Z/2fE5+15RC6s6NubSz+fdZTj97eWgn6ap824t3nMVgH1pVc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLkbBiwBxGdOFxEILcnB+1/xUj3DR8T7AsfFk4+ChKTieUyUb4
	WSLLu3wVIQsB38IqmgdEZkNiQsO7ElzIdc9IYUGw03+njD/rCv4Hi7YW
X-Gm-Gg: Acq92OHQi6nUR3saZegjkpgeu5oN0e4bihEkH7XV0VbRJXJAEiXYxOdK7XMzjoNT6xe
	SkRXlBEJ5wvtyKL0ISSMx+JMUB2ODDRi6B5cSVA0Y1DAhQ0vuDqFPXegxBhbirAMUx9p87j4mmp
	kXa61irhZqWsw0fOTNyzxU/yLnSDgvabxEcUtTVgUW7r0nW79Xk3jCF35eZtps3hQ5iTZcGbuDw
	bbGHUuycPJAzUee86hemF8V4czs/yKGgM/kQHVtVGSVkNGMGxsqgFzLnTbEX4inV/3Sn+/AS4dW
	bjRZx3g5vd1oSnVucfYagH3n2P0BGiaVp2aVDFSDCwuVACdeNeyDodUfQXmbCRSbHsziDL9NVXR
	EnDfjA1gGvd0j37BjItzAa1VVc+jGQpkWmXOdTZN1hmrkybrzrMV7DMwE4XH4Sw9AjuLjEQLYE8
	q7jIU55YUJei/cddz/8L6T0eXNzywk5YnovCv2ytonLNEOw2t34SdcUzR0qrlLNBxhWiUsGeCD+
	/o=
X-Received: by 2002:a05:600c:8b62:b0:47e:e2eb:bc22 with SMTP id 5b1f17b1804b1-48e6748afe8mr234131845e9.5.1778533403812;
        Mon, 11 May 2026 14:03:23 -0700 (PDT)
Received: from ?IPV6:2a0a:ef40:96b:a101:6f5c:d416:bfa6:dfbd? ([2a0a:ef40:96b:a101:6f5c:d416:bfa6:dfbd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8f4389a6sm2225605e9.22.2026.05.11.14.03.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2026 14:03:23 -0700 (PDT)
Message-ID: <3bfcf406-fdde-4303-9bd6-0d8d21ddba37@linux.win>
Date: Mon, 11 May 2026 22:03:21 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ignat Korchagin <ignat@linux.win>
Subject: Re: [PATCH] crypto: af_alg - Document the deprecation of AF_ALG
To: Eric Biggers <ebiggers@kernel.org>, Kamran Khan <kz@inspirated.com>
Cc: Jeff Barnes <jeffbarnes@linux.microsoft.com>,
 Andy Lutomirski <luto@amacapital.net>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <CALCETrVqG+1yErRJjkxvJrf=A+Vu84HTR4Bx1Pcd8G1C0PJcMA@mail.gmail.com>
 <14A441D8-5370-44BE-8732-99BF8107C3FD@getmailspring.com>
 <0b8bba44-f6bb-4d69-b9d4-5787c276d41a@inspirated.com>
 <20260510163204.GA2279@sol>
Content-Language: en-GB
In-Reply-To: <20260510163204.GA2279@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/05/2026 17:32, Eric Biggers wrote:

> On Sun, May 10, 2026 at 08:54:07AM -0700, Kamran Khan wrote:
>> Hi,
>>
>> AF_ALG is useful not just for hardware-offloading, but also for memory
>> isolation so that applications only get oracle access to the crypto keys and
>> a memory-safety vulnerability in user applications would not immediately put
>> the secret key material at risk.
> Note that if that memory-safety vulnerability leads to code execution in
> the application, then it doesn't matter that it "only" has oracle
> access.  It can still decrypt any data encrypted by that key.


I don't think fully discounting hardware offloading is beneficial here. 
HW accelerators will be produced and without a common interface vendors 
would start implementing their own "bespoke" drivers with bespoke 
userspace interfaces (we already had such proposals), which in turn may 
introduce more attack surface. Yes, AF_ALG needs substantial 
improvement, but at least it can be a standardisation point.


> The relevant threat model would be arbitrary reads, not any
> "memory-safety vulnerability".
>
>> I understand and appreciate the concern with complex attack surface and the
>> increased frequency of attacks in this area. But I fear that completely
>> removing AF_ALG increases the risk for userspace applications relying on it
>> for memory isolation.
>>
>> What alternatives do userspace applications have on Linux for ensuring
>> crypto keys are not exposed in user memory? That is, FreeBSD and NetBSD
>> natively provide /dev/crypto; removing AF_ALG would kill the only equivalent
>> option on the Linux side for kernel-delegated cryptography.
> The standard solution is simply to use an isolated userspace process
> like ssh-agent.  Yes, the keys will be in "user memory".  But "not
> exposed in user memory" is *not* a correct statement of the problem.
>
> (Also note that protecting not-actively-in-use data from arbitrary read
> primitives doesn't require cryptography at all.  That can be done simply
> by using mprotect() to remove read permission from the memory, then
> temporarily adding it back when it needs to be accessed.)
>
> In any case, any hypothetical security benefit provided by AF_ALG would
> have to be *very high* to outweigh the continuous stream of
> vulnerabilities in it.  I understand that people using AF_ALG might not
> be familiar with that continuous stream of vulnerabilities, but it would


Is it actually that much compared to other features/subsystems, like 
eBPF or user namespaces? But we don't rush to deprecate those - instead 
trying to harden them and come up with better design.


> be worth spending some time researching what has been going on.
>
> - Eric


Ignat

