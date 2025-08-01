Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754A126FA54;
	Fri,  1 Aug 2025 15:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754061481; cv=none; b=mjnLvgY4dng4mkr5o6eHWe32Jn5NmYH/ORgfRQ4YFai++sCCUZoVr9m5+t6OY/6m3+0b4W2K+Q9/Ha9GJs0k3186w5ZNuGZlVfVSz7gj5e0mxX9cFqvbyxZIH7T3sKfTirix/S6PNr8gbyNhsfn4VkoKlh1qJI+W+PTzixdmVqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754061481; c=relaxed/simple;
	bh=foIr1t1FXk+cD/2GYbCBY/2aovvYRyH8Hi4VffLVJy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VzC60TCoyBXYuFFUAiA3WIFM/Qr+99SPU1Y96ejpfREv4titQMSFGqIM1Vv6/tDGNZINrVckM5W3CQerd3fklCswXQemC592y0PgFrOtmXbGQvN/9DljNpn8dXF9iiYonvCCgzvcgO4oJlMZDAQNuEw3+IClX+4xzckvRzBOeUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZGbooI8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZGbooI8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BF4C4CEE7;
	Fri,  1 Aug 2025 15:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754061480;
	bh=foIr1t1FXk+cD/2GYbCBY/2aovvYRyH8Hi4VffLVJy0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZGbooI8YQVwPLc060y++wBkGU1MgDxOMaZA1jurjIozfZscChLCuSSo7Exq6cJnDD
	 xa1EepAgTdE6YkUJXBeo2KKGkeYUnea6VmE7kZND9zj0YqQVDtrIztlBalQxHtXsDX
	 dcTSCJJLCOCXHk2aQ3O15q4VI9bukXXFCq5ackkMYU+ekjhW7+UJJyxVRb1LHGnunl
	 hlw5KpP/+GyIZa7fTKqhIn1kQ9q48jNk9hHusGKD+YZmONpSxPfbz1Q+xKM5Tc2xxz
	 xLdBb9nJuAUO3wHVpVnQa00p1lT9dD+sBHzxf9Oz/oXu4vrQ7vPhNIgoHWKZGHaWa4
	 Ccs0SmimRR8oA==
Message-ID: <59a973c8-4cf1-46b4-960e-a54c64ffdaed@kernel.org>
Date: Fri, 1 Aug 2025 17:17:56 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net] mptcp: use HMAC-SHA256 library instead of open-coded
 HMAC
Content-Language: en-GB, fr-BE
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Mat Martineau <martineau@kernel.org>,
 Geliang Tang <geliang@kernel.org>, netdev@vger.kernel.org,
 mptcp@lists.linux.dev
References: <20250731195054.84119-1-ebiggers@kernel.org>
 <245ef75d-44d5-4b66-9f28-68182f177fad@kernel.org>
 <20250731214156.GB1312@quark>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20250731214156.GB1312@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Eric,

On 31/07/2025 23:41, Eric Biggers wrote:
> On Thu, Jul 31, 2025 at 11:27:50PM +0200, Matthieu Baerts wrote:
>> Hi Eric,
>>
>> On 31/07/2025 21:50, Eric Biggers wrote:
>>> Now that there are easy-to-use HMAC-SHA256 library functions, use these
>>> in net/mptcp/crypto.c instead of open-coding the HMAC algorithm.
>>>
>>> Remove the WARN_ON_ONCE() for messages longer than SHA256_DIGEST_SIZE.
>>> The new implementation handles all message lengths correctly.
>>>
>>> The mptcp-crypto KUnit test still passes after this change.
>>
>> Thank you for this patch! It is a good idea, and it looks good to me!
>>
>> Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
>>
>> One small detail: net-next is currently closed [1], and I don't think
>> this patch can be applied in -net. So except if you plan to take it in
>> the libcrypto tree for 6.17 -- but that's probably strange -- what I can
>> do is to apply it in the MPTCP tree, and send it to net-next later on.
>> Is this OK for you?
>>
>> [1] https://patchwork.hopto.org/net-next.html
>>
>> Cheers,
>> Matt
>> --
> 
> The MPTCP tree (and then net-next) for 6.18 is fine.  I know this isn't
> a great time to send patches, but I just happened to have some time now.

No problem, having this patch now is fine for MPTCP. I just queued it
for 6.18.

Applied in our tree (feat. for net-next):

New patches for t/upstream:
- 1eadc6f75c43: mptcp: use HMAC-SHA256 library instead of open-coded HMAC
- Results: 94c274f914c9..5c7ec796258e (export)

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

