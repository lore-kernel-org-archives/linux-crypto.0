Received: from psionic.psi5.com (psionic.psi5.com [185.187.169.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC143A640A;
	Fri, 27 Mar 2026 09:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.187.169.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774605581; cv=none; b=MbFVof/JreQxw0fVeBWe7iAKuB0UMn7zKq1Pq2RoP2idPr+r34W2uwjQjs8QzG2fF0r7KWBN3oz1Rld37cZL0hUiVYpVoFi/ddphO4X2y3qSAEFXf6o5djRxKQBLD7SzIo+CL04DncB3oYA62taeGOMAssdZD6O6BDQB0bnPG7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774605581; c=relaxed/simple;
	bh=/5Bw5lC9kJ+iFDnZK+UIW5K4PD0LHuzTSnNiSrEXoZA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=omSJJfHAXGsk/TE4VbMV2WrlgnFYkScLJ9FPBRQIbMnvHgzvMB9zJj+83AFVA+CjjT0wqBr1z1dSZYc17dGPnX57JkZAJe2OmP67bG+tmvvHSPFVkNJ/ZEeGgLX6wkUBsTqNoEpQ0j+zehi2ccHJhxFUwGf5pmOH7fDbZjgvXAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de; spf=pass smtp.mailfrom=hogyros.de; arc=none smtp.client-ip=185.187.169.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hogyros.de
Received: from [IPV6:2400:2410:b120:f200:a1f3:73da:3a04:160d] (unknown [IPv6:2400:2410:b120:f200:a1f3:73da:3a04:160d])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by psionic.psi5.com (Postfix) with ESMTPSA id E405D3F01D;
	Fri, 27 Mar 2026 10:59:24 +0100 (CET)
Message-ID: <35e00d0f-85f6-457a-99b4-703caf3e1e6e@hogyros.de>
Date: Fri, 27 Mar 2026 18:59:21 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] crypto: Remove arch-optimized des and des3_ede code
To: Eric Biggers <ebiggers@kernel.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, x86@kernel.org,
 Harald Freudenberger <freude@linux.ibm.com>,
 Holger Dengler <dengler@linux.ibm.com>
References: <20260326201246.57544-1-ebiggers@kernel.org>
 <0982d4341f58e2f1181bc472dc9c9d8542148e3c.camel@physik.fu-berlin.de>
 <20260326202733.GA2657@quark>
Content-Language: en-US
From: Simon Richter <Simon.Richter@hogyros.de>
In-Reply-To: <20260326202733.GA2657@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 3/27/26 5:27 AM, Eric Biggers wrote:

> In general that's good of course, but DES and 3DES?  Really?  Why is
> effort going into these obsolete algorithms at all?

If there's dedicated instructions, we need to emulate them, even if the 
kernel stops using them, because userspace might still use them. The 
alternative is implementing them as a trap in the kernel that delegates 
to the crypto subsystem, and nobody wants that. O_O

I wonder if it would make sense to split between "crypto" and "offload" 
subsystems, so the "crypto" side can focus on a small number of 
contemporary algorithms and give them simple, easily auditable 
interfaces, and move all the complexity of asynchronous request 
processing in offload hardware over to the "offloading" side. The 
userspace API would also move to the "offloading" subsystem.

This would give the offloading subsystem a bit more flexibility in API 
design as well, so we could maybe represent offload capabilities in 
network or storage hardware as well, or allow userspace to set policies 
or find an optimized routing, without compromising security in the 
crypto subsystem.

However, even from the "crypto" perspective I believe that we can't get 
around support for asynchronous offload devices, because of mobile 
devices. I suspect no one would be building dedicated silicon for 
asynchronous AES into mobile CPUs if that wasn't worth it somehow -- so 
if such a device is present, we want to use it as much as possible, 
because the expectation is that while the difference in performance 
compared to the CPU is hardly noticeable, the difference in battery 
lifetime is (that's why dropping async request support from fscrypt 
makes it largely useless on mobile).

Most of the other offload scenarios are already handled bypassing the 
crypto subsystem: the network stack has its own offloading mechanism, 
while nx-gzip is a regular device driver and does not even register an 
acomp algorithm (even though that would be really cool for zram/zswap, 
and would benefit dozens (dozens!) of users).

A lot of the resistance to changes in the crypto subsystem comes from 
the long tail, either hardware that is somewhat seldom, or built for 
some special purpose where the crypto APIs are already a limiting 
factor, and further consolidation towards standard PCs is making the 
situation worse.

I can certainly see that the complexity in the API that would be needed 
to support all the interesting use cases is somewhat undesirable, hence 
the idea to split off generic transforms and allow the interfaces there 
to become more expressive (on-device dmabufs, in-place operation, 
device-side contexts, device-side queues, device-to-device transfer 
offload, ...).

The current state where these use cases are technically inside the scope 
of the crypto subsystem, but deemed out of scope by the crypto subsystem 
leaves them in a kind of limbo, and that is very frustrating.

I don't know if it will be worth it to dedicate a weekend to 
implementing nx-gzip support as an acomp module, or nx-aes support as 
acrypt, or if that work would be rejected or removed in half a year, and 
I'm sure maintainers of ports to older hardware feel similar.

    Simon
