Received: from smtpcmd0642.aruba.it (smtpcmd0642.aruba.it [62.149.156.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1854C221FB2
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 15:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757951285; cv=none; b=E1SxuuMyb0p4qQDX5KuH6HdQpYTkziAiGZKdc1f4eLRm6fKtqjLHN69v9Pn0ti/tSndL/KF0l5YXC/PuJt5w43eCKfIsQdtAljD+ckIZIbcDIE8mCOo4JUg/pYSwVQbKUGZagl3Z1YbSLDb6Wh139KZiEYpwSetxQoufTcdJdt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757951285; c=relaxed/simple;
	bh=Y5CHTpGWpxHiIpghft6ThGk3RIITD3fo1Y++9qn/Vo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z2egpCXDgJz5yVbHnOaPMxH7Xtaym3os+Jl37nQrUXZdk2cF0U7yS2hERhtX79Fb1TNh5v4+rN4E0m9VQrH7AMfxgKO2ywWP8XkxLgRVBF9H6zG2NT+djs4Y68Zk/9ZVTCdO5oe9CKXz0aaNtQ40yKr1CoMkjVVzp5lHdt/iTTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com; spf=pass smtp.mailfrom=enneenne.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=l+BGA/tU; arc=none smtp.client-ip=62.149.156.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="l+BGA/tU"
Received: from [192.168.1.58] ([79.0.204.227])
	by Aruba SMTP with ESMTPSA
	id yBQqusQyaL0IyyBQrun1wO; Mon, 15 Sep 2025 17:47:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1757951277; bh=Y5CHTpGWpxHiIpghft6ThGk3RIITD3fo1Y++9qn/Vo8=;
	h=Date:MIME-Version:Subject:To:From:Content-Type;
	b=l+BGA/tU0GGUwBGnt1EUlHe7awPcyxtRIJc3o26Izixca3mf6yAc4g0cCioChCd5S
	 SQ7kTDuAP7nkUrmAwlfaM1u1dEWx/sAvdEQfMUQDu8kYkZdme121QOWmIAHmTXFBlb
	 hFbp25CbMh5TepRFV/kN/18ywPkZCHurPmsuoBFtL85VdaomP3avYn5klC3/n1QuV/
	 m5FkWUyfdwH8EvgsvzyLd2scZat4mfQ0E+LncftVwFWsd+vOgLLV54b1REtbp4Msna
	 L7Gsf8D/I2GnXXa6diYRVnNOdOi1IwJB0+9hSSFR0AUaiFqdhOymLq3jPzev9R72Rm
	 xLnEB1jWQR0jg==
Message-ID: <87f17424-b50e-45a0-aefa-b1c7a996c36c@enneenne.com>
Date: Mon, 15 Sep 2025 17:47:56 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [V1 0/4] User API for KPP
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>
References: <20250915084039.2848952-1-giometti@enneenne.com>
 <20250915145059.GC1993@quark>
From: Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <20250915145059.GC1993@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfAk7i3p/xdGbM3PK3OF15MTgsaOjtVxM4NoT+/SgOgtlMdzs9AhcBN6bkohqeAsUJ99ruKZEg5K68DR9bwLJtiCaqlM/tTJcSYploRVO8eVfnrJo2F2J
 Y+B3nH21M/zVb86Xu8DfiDgsCcKMPW6SJZ8wZMmmp5r0nJiItmaZj7kSOqqS/pKazhBi+UhgXvSa/0Dw+dGbihHJblwD5YJ3QwFfGjYn9/QhBm+0sG46CeXs
 W7pstqdu9ozl8qT6vT+ivi5LDQiJ1wbztWcqUlaCFPksBFC1yrGs2ntEOPxoa5AfVb2RRM6Oo2kfrIvXZwfBVQ==

On 15/09/25 16:50, Eric Biggers wrote:
> On Mon, Sep 15, 2025 at 10:40:35AM +0200, Rodolfo Giometti wrote:
>> This patchset adds a dedicated user interface for the Key-agreement
>> Protocol Primitive (KPP).
>>
>>  From user applications, we can now use the following specification for
>> AF_ALG sockets:
>>
>>      struct sockaddr_alg sa = {
>>              .salg_family = AF_ALG,
>>              .salg_type = "kpp",
>>              .salg_name = "ecdh-nist-p256",
>>      };
>>
>> Once the private key is set with ALG_SET_KEY or (preferably)
>> ALG_SET_KEY_BY_KEY_SERIAL, the user program reads its public key from
>> the socket and then writes the peer's public key to the socket.
>>
>> The shared secret calculated by the selected kernel algorithm is then
>> available for reading.
>>
>> For example, if we create a trusted key like this:
>>
>>      kpriv_id=$(keyctl add trusted kpriv "new 32" @u)
>>
>> A simple example code is as follows:
>>
>>      key_serial_t key_id;
>>
>>      /* Generate the socket for KPP operation */
>>      sk_fd = socket(AF_ALG, SOCK_SEQPACKET, 0);
>>      bind(sk_fd, (struct sockaddr *)&sa, sizeof(sa));
>>
>>      /* kpriv_id holds the trusted key ID */
>>      setsockopt(sk_fd, SOL_ALG, ALG_SET_KEY_BY_KEY_SERIAL,
>>                 &key_id, sizeof(key_id));
>>
>>      /* Get the operational socket */
>>      op_fd = accept(sk_fd, NULL, 0);
>>
>>      /* Read our public key */
>>      recv(op_fd, pubkey, pubkey_len, 0);
>>
>>      /* Write the peer's public key */
>>      send(op_fd, peer_pubkey, peer_pubkey_len, 0);
>>
>>      /* Read the shared secret */
>>      len = recv(op_fd, secret, secret_len, 0);
>>
>> Each time we write a peer's public key, we can read a different shared
>> secret.
>>
>> Rodolfo Giometti (4):
>>    crypto ecdh.h: set key memory region as const
>>    crypto kpp.h: add new method set_secret_raw in struct kpp_alg
>>    crypto ecdh.c: define the ECDH set_secret_raw method
>>    crypto: add user-space interface for KPP algorithms
>>
>>   crypto/Kconfig        |   8 ++
>>   crypto/Makefile       |   1 +
>>   crypto/algif_kpp.c    | 286 ++++++++++++++++++++++++++++++++++++++++++
>>   crypto/ecdh.c         |  31 +++++
>>   include/crypto/ecdh.h |   2 +-
>>   include/crypto/kpp.h  |  29 +++++
>>   6 files changed, 356 insertions(+), 1 deletion(-)
>>   create mode 100644 crypto/algif_kpp.c
> 
> First, this lacks any description of a use case.

The main purpose of using this implementation is to be able to use the kernel's 
trusted keys as private keys. Trusted keys are protected by a TPM or other 
hardware device, and being able to generate private keys that can only be 
(de)encapsulated within them is (IMHO) a very useful and secure mechanism for 
storing a private key.

> Second, *if* this is done at all, then it must give access to hardware
> drivers *only*.  We've had way too many problems with userspace software
> inappropriately depending on the in-kernel software crypto code via
> AF_ALG, when it should just be doing the crypto in userspace.

I see, but in userspace there is no better way to protect a private key than 
using trusted keys.

> The asymmetric algorithms are especially bad because the in-kernel
> implementations of most of them (all except Curve25519, I think) have
> known timing attack vulnerabilities.  Implementing these algorithms is
> really hard, and the in-kernel implementations just haven't had the same
> level of care applied to them as userspace implementations.

I think this is true when talking about kernel software implementations, but is 
it the same when we consider possible hardware implementations?

> We've seen time and time again that if a UAPI is offered, then userspace
> will use it, even when it's not the appropriate solution.  Then it can't
> be fixed, and everyone ends up worse off.

I understand your point, so please let me know if I have any chance of this 
patch set (once fixed and revised) being merged into the kernel; otherwise, I'll 
give up right away. :)

Thanks for your considerations.

Ciao,

Rodolfo

-- 
GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming
