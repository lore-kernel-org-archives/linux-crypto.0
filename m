Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD953FE37B
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 10:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783594032; cv=none; b=SyvGbe+TRpIjMMkDhv8RQ3wx7dAYrND+VR99zZblx/B1THZ6KPBvgBd8ylwscCamUtQRhFVaO+UgGAVHkWE8Ca15YXsjZunudltcPcHWNLfaIHhSg4VHqWNmiYJKpMUOMVSTR004gnSiadA3yAPmhQMFRvqiMIFKG9J5CDfaT/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783594032; c=relaxed/simple;
	bh=ERhA28gW3zPBu8A9nTqt/emd3kcTU7hsRdu2i+9fXMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pjjz4j3rqjxCQRfEDcPZtfu473CtRO/ECPr8xP8yugsBzGREChaGwSUc3UZI6M8H6iY2q7O2WAfIxZ7vngof+i/VAyd2tkNnv+VOfEYICUy47EjfDBX0/r+p+Ozt0UHH+iZ5pOldWldAuDycGTkNoqkLZK0gr+cypKlQhzOlwbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cOLDYbrc; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cOLDYbrc"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493e8d4f4dcso9113035e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2026 03:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783594029; x=1784198829; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=of5gRsdVmbBHCG6pnezBlEM9PY3kQvwq9GIhBuSVwwE=;
        b=cOLDYbrcXMOigNXMZAdkDatbTg011MZTbUIvgM4Vrog12/ZqgwickxMW++PRNeKmme
         0uBQkL5qdOR77fmNPthf/JPyfDrVNKJ4PT2LOt0k8i9lDqV/PaJ+HZmQyzoN7iaC1wkW
         t35jbN9SJ+6Ma9du6GnMKaW0LnVir3+A6rlzpFUH80emigGQtIZ4FPiz0jfYv769f3A4
         sLihRzilr3mLVbYclgAmRvqmNLp71jjLHXZ9EbaLrcX3fwK36vg0lKiSpIYrO2svLymq
         x5tOrxFdZFXhcLy6vGOJRWazRc5a1isBJBQgW+LxUVoJ8AdZ0/5er7YZYV2YYWNscz1o
         03Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783594029; x=1784198829;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=of5gRsdVmbBHCG6pnezBlEM9PY3kQvwq9GIhBuSVwwE=;
        b=OIaJiFjUCg2Xy57uSkSVb2jtn4fGWJLKaQOzl0VFikgXGZkh6sb32EX3BpjIRPZvD+
         HK88hhR+8mvWJrCXRnsJClYMttn6ZlrTwCf3Ej+h6hLOm3aPRLqEUgDr1yq49+qErPtz
         mZkMKnXclcCP+3NY/+V5IoWdDZlv2sHP0EcQv+qdC3n1Y52bw7J9hVuBi8rklr1GaaZj
         JC0LhXehqFzKRvIsaczJABlASs2eTO62hARkVqYLN2PZURTEt4UDNg7EX5jBcOM8D31S
         +qaIh33nK+XyiiJfSkPZN/DVcQiri8FbmG8b7VDd42pGiJ61JcuTcBed948vd1AeXY9K
         9WpA==
X-Gm-Message-State: AOJu0Yzmq1JW/hZEOqhtDNlf4KXMB6otzhqcHwkdJrJmD5ihFxq7lhUu
	hKXtWPza4wWiIBvrmWSzSO0RXAp9zOeTbVyvQ/hXbCbQlFjoDsXeQGi5
X-Gm-Gg: AfdE7clkbhVtXB9bEGmSBFkK5xLKgEAUxZtLOWWnBCW+MKFIxt9KwbcgMAMaM7oW4qV
	CHaNTJPMKV8PPxlV4s1DJjMLkdh+o5g4c7TZa1nzKCMGVJzNklMS17aUBFWd3wo/7hNhtkHk0y+
	Oeg/eSjx6kQBPRJ9ouXjpLr8id+SqQNvJ4uByWKfe1G3m8n54CFqM+kk5GCXkMjQBbfEmCBZmjB
	eIh0z9iZ+nsSq7Llyirc6bbiCl6OEfRIjfis2XFUec10FAKHM3Q+Ht12nNXv/yYmtP/nDgEqtfM
	OJMFlBskjO+bXZJusgx4nv4B4W96UfwhKG98dQN0FnCWhsoVRKeWm8uaaIRPkY5kVDEEHEWwQPU
	Sus7eSckHxQkWGYMooI4yOkQS/6DiF8W9WxnvxpjfrnWAZXfh1OCzKk24y5ZuIWtdzeiJbeiTX9
	KShChkv5Z6y35R6rArHw==
X-Received: by 2002:a05:600c:1d08:b0:493:be0e:377c with SMTP id 5b1f17b1804b1-493e6891facmr61165505e9.24.1783594028916;
        Thu, 09 Jul 2026 03:47:08 -0700 (PDT)
Received: from [192.168.1.220] ([176.74.141.242])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6f373csm89178955e9.14.2026.07.09.03.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 03:47:08 -0700 (PDT)
Message-ID: <aac82bdd-6a28-4e65-97f4-3d5942d2a6af@gmail.com>
Date: Thu, 9 Jul 2026 12:47:06 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: AF_ALG deprecation fallout
To: Eric Biggers <ebiggers@kernel.org>,
 Christoph Anton Mitterer <calestyo@scientia.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
References: <27816cc353731e8e5484adad7d0fc447777727d8.camel@scientia.org>
 <20260708011112.GA3890@sol>
 <04fbbc8611699e469f44edbccdf3cf1ac65075d3.camel@scientia.org>
 <20260708030153.GA14700@sol>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20260708030153.GA14700@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/26 5:01 AM, Eric Biggers wrote:
> On Wed, Jul 08, 2026 at 04:14:04AM +0200, Christoph Anton Mitterer wrote:
>> [X]Chacha, IIRC, would anyway be used without XTS...
> 
> It's possible that some of the "aead" ciphers will need to continue to
> be supported in AF_ALG too (in addition to privileged use of "ccm(aes)",
> which already is on the list since bluez uses it).
> 
> But we need a specific list.

Cryptsetup can use AF_ALG to check if AEAD is supported, but it tries to use
it later anyway, just error messages are more cryptic (hidden in DM kernel log).

So we should not depend on AEAD AF_ALG support.

However, it would be nice to have simple API to check (usable by normal user)
if kernel supports some cipher/mode/keysize/... without trigerring module load
(as AF_ALG does).


>> Well, I personally don't use any others, but of course other might.
>> What about all these legacy modes that were used for years in examples,
>> like cast5-cbc-essiv, aes-cbc-essiv, etc.?
> 
> First, the essiv component is not relevant, as far as I can tell.
> algif_skcipher actually does have essiv support, but it's a relatively
> recent addition and cryptsetup doesn't use it.
> 
> So the potential AF_ALG uses there would be "cbc(cast5)" and "cbc(aes)".
> 
>> Does your list have any effects on things like chained algos (which I
>> think cryptsetup allows to use for tcrypt).
> 
> AF_ALG has never supported cipher cascades itself.

TCRYPT (Truecrypt/Veractypt compatible) supports it, but it handles chain in own code,
calling always only one cipher to decryot.
For activation it stacks several dm-crypt devices, so no chain in crypto API is needed.

My intention was to support all, even historic, combinations, because people
have old containers. (Note, we only support existing container, we cannot create it.)

Current Veracrypt supports these individual ciphers (and some chains of them),
that is what we can use through AF_ALG:

- AES, Serpent, Twofish, Camellia, Kuznyechik (not in mainline only as external
package, in Debian as gost-crypto-dkms package), all in XTS mode.

Historic containers (TrueCrypt) can use:
- AES, Serpent, Twofish in LRW mode
- AES, Serpent, Twofish, Cast5, in CBC mode

There is also very old support for DES3_EDE and Blowfish, these need some tricks,
I would ignore them.

See cryptsetup lib/tcrypt/tcrypt.c for details.


> 
>> I've wrote just before on the cryptsetup mailing list, that we have the
>> nice integrity support in cryptsetup for quite some years now, but I
>> guess only few people actually use it because all the available
>> algorithms/modes were kinda recommended against[0].
>>
>> I think XChacha20+Poly1305 might be in reach (but still not actually
>> usable?), having finally a large enough nonce (192bits?).
> 
> The kernel has had XChaCha20Poly1305 support internally since 2019, but
> support for it hasn't been added to dm-crypt yet.

See my explanation here
https://gitlab.com/cryptsetup/cryptsetup/-/merge_requests/420#note_2520172869

> 
>> So any chances that the kernel provides a usable AEAD mode for AES (or
>> maybe even Serpent ;-P)?
>>
>> Like with GCM but a larger nonce?
> 
> We probably should add XAES-256-GCM support at some point, which takes
> 192-bit nonces.  Historically it hasn't been feasible to do anything
> that uses per-request AES keys in the kernel, since the kernel's crypto
> API wasn't designed for that.  But we're now moving to a simpler API
> where the algorithms including AES-GCM are implemented using regular
> functions.  We can build XAES-256-GCM support on top of that.

That would be nice.

Milan

