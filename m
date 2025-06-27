Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1271F0E34;
	Fri, 27 Jun 2025 06:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751004912; cv=none; b=VMQkR1JUZQuRwxovkDF6yyLe3c09/D1k2BOFcOe8MK1qeuGjrTBq+icfXhKL5G3Jlfgscl0OONMFqKEzlsTVDH2Zl7aWJUxzAxc4fB+HgCfRjUWr2DpTH0XDhUA9kTXvuvqRWNz00f+C57oNdi6k8xP/oVCVWo3QRFnmvw3YvPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751004912; c=relaxed/simple;
	bh=ho1Mpm1BJGQKhTyqMeXmsElZRcoUvPwpcxQ4YCshUKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWjOqMVowl/sYoTaq3zVMPKNWZvZ//HblW9pg4x0oJpkCqfUP/NGQiEYlXDFiEPhEChOSfHeIU8Xe5JQVDt09ziUFVSrolpeTYNjmhJ+FOEKM4IWsKFD6gMyg0ERIwKGoaRy64AKmVyHcP2GlptgFqrKLgj6auhFjkZiXGvWcpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=RS4vt791; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="RS4vt791"
Received: from [10.8.193.3] (unknown [50.47.147.87])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id DD1233F189;
	Fri, 27 Jun 2025 06:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1751004901;
	bh=/N7X5FWAGiV9qNbZhl0HebTtvu44whWkWgtP35K6Pes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=RS4vt791TCKs4X6kEG5L77ki2W2NrsZFHx5zdXMcQ3g7B5Yh5FOQBXlrLO8+H1n4V
	 91Z8+LTsyOFVfWDw92Hnbbxj6NkLRXPKr672XwAMexILNpIt8k7LY2JnMdaUe7JTxd
	 L3cOiE+4OR//gii9ELUm/ONjBBnOr+AmfPsL6uuCjil8gZRhnNofQGo7DrHSS+4Hlu
	 JPSxGR4wms73hxarNLD9N/pxwZ8an0GPk/9AOx6V2ybG1QRWXpzB/hXalOyZEf4s3n
	 xE6wf1DXJANCq8EA6nYXEHaNDhmI9zFQ3AG6wRcH4mE6GO0y3N0UNLgK5ez8zyhhPm
	 7Awnikxws4lGA==
Message-ID: <540b7f72-58fa-4ee3-9b5b-6cd81c5959a7@canonical.com>
Date: Thu, 26 Jun 2025 23:14:50 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] apparmor: use SHA-256 library API instead of crypto_shash
 API
To: Eric Biggers <ebiggers@kernel.org>
Cc: apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20250428190430.850240-1-ebiggers@kernel.org>
 <20250514042147.GA2073@sol>
 <4f37c07c-3a39-4c98-b9c4-13356f5a10dc@canonical.com>
 <20250612191105.GE1283@sol>
 <c80d4e69-ef03-462c-9084-e6bb56f428e6@canonical.com>
 <20250627035918.GA15797@sol>
Content-Language: en-US
From: John Johansen <john.johansen@canonical.com>
Autocrypt: addr=john.johansen@canonical.com; keydata=
 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 lT9Q
Organization: Canonical
In-Reply-To: <20250627035918.GA15797@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/25 20:59, Eric Biggers wrote:
> On Sun, Jun 22, 2025 at 02:16:07PM -0700, John Johansen wrote:
>> On 6/12/25 12:11, Eric Biggers wrote:
>>> On Sat, May 17, 2025 at 12:43:30AM -0700, John Johansen wrote:
>>>> On 5/13/25 21:21, Eric Biggers wrote:
>>>>> On Mon, Apr 28, 2025 at 12:04:30PM -0700, Eric Biggers wrote:
>>>>>> From: Eric Biggers <ebiggers@google.com>
>>>>>>
>>>>>> This user of SHA-256 does not support any other algorithm, so the
>>>>>> crypto_shash abstraction provides no value.  Just use the SHA-256
>>>>>> library API instead, which is much simpler and easier to use.
>>>>>>
>>>>>> Signed-off-by: Eric Biggers <ebiggers@google.com>
>>>>>> ---
>>>>>>
>>>>>> This patch is targeting the apparmor tree for 6.16.
>>>>>>
>>>>>>     security/apparmor/Kconfig  |  3 +-
>>>>>>     security/apparmor/crypto.c | 85 ++++++--------------------------------
>>>>>>     2 files changed, 13 insertions(+), 75 deletions(-)
>>>>>
>>>>> Any interest in taking this patch through the apparmor or security trees?
>>>>>
>>>> I can take it through my tree
>>>
>>> Thanks!  I notice this isn't in v6.16-rc1.  Do you have a pull request planned?
>>>
>>
>> Hey Eric,
>>
>> sorry I have been sick and didn't get a 6.16 pull request out. I am slowly trying
>> to dig my way out of the backlog, which is several weeks deeo. I might get together
>> a small PR of bug fixes before the 6.17 merge window but the bulk of what is in
>> apparmor-next will be waiting to merge in 6.17 now.
> 
> Hope you're feeling better!  Actually, would you mind if instead I took this
I lot, though still generally tired/low on energy

> patch (with your ack) through the libcrypto-next tree for 6.17?
> Otherwise there will be a silent merge conflict after I apply
> https://lore.kernel.org/r/20250625070819.1496119-11-ebiggers@kernel.org/
> 
Avoiding a merge conflict? You have my ACK and blessing I will pull it out of
the apparmor tree asap


