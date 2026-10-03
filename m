Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC841CAA6D;
	Sat,  3 Oct 2026 07:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791012726; cv=none; b=kR2Ceqi/FzYnaPCGhJtdXyQBZaPkt6WmyY9boK5Q0W6M+6i7IZ0JfExb9QQAUac7GMnGdUzvA7Bx3DvJ2cP7I6uqV7Fx83zfqjnzzWaQjClA+bhpPAezHGe11zLalSPhWtX3A26ZZKcuqr4r+8DfaZYvo5JpoOWWYjwReLqVVYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791012726; c=relaxed/simple;
	bh=lW4jU0rgUwVCAXMdj5R6M9jkWzHgc21RwLdTYVcBIks=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=RfVopgrNDwZAtOK6YhypsNzsXwzMVCw8XfrOxefBUN0JW3fasbxzgSUSIWPceLS74YwO12KUXbTqmCmJAh5pG4hdvnTpFKmXahjcwrhFeRcWL10baojZRFluFJyVkNz8Sb1NQk9hqsyXZiEn5Pmywppjp057cc7ZDE6Ws8qIZKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P85Brt73; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P85Brt73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E721F0089B;
	Sat,  3 Oct 2026 07:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791012724;
	bh=4VEmLjyRjf8Qvg2LMZxEQtyqpIDGiu9mpIfBw4CjgoY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=P85Brt73KUT6Z1RRpX0AoGGJHOPD566eoEKeCyVK9zR1mDp4xz8Hwk6YSOaKimchK
	 nNm3gUTekQpJJko+hyxNJfqH7J+1MyDuOipm1KO66NrU/fSrrtSAYwiUQsyyaaxfPE
	 mlCQrimnq5DqqxLnFk2hijrBgrjd2CZ/sPkhO7Aq0dIBTenc5t+dksLLLlms1UtVle
	 q0uJg0fD4AGmk/jZt5TEEyrZqVKAK8dJcIo/1dfDirGwIjJ6tkQsrQ6DJCLVZtiLMk
	 uRcFXAVbgWbPcWKn7Vg9+BmabZ9WtacIKkMsVVyqI5OR/t2pnn7TYs4myZcJSYyrL8
	 //QNjdv2JY65A==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6588A198003A;
	Sat,  3 Oct 2026 03:32:02 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Sat, 03 Oct 2026 03:32:02 -0400
X-ME-Sender: <xms:cK_Aao66tBT4SWeS5MUZiUkdvCdGYuJZOZ68rD289ueeG1sx6D7TsQ>
    <xme:cK_AakvWBSt9DS28J2KvwqVin8JYbsNqRMOqwS9vv8qX_U90FtPOzFA4NGgXTlasy
    Cwh5YTdFGNpNYrubD3xt4n7g_1SxZzlGyzcmCsh8zn88YCjYbPLhjOx>
X-ME-Proxy-Cause: dmFkZTE0yaIvcJoyKUS2wC2MTUrgiztPATsDZhFTsu6K+1E7h8b9DzPQUZtbLGBdqlwX9B
    5ihlcyXTnas7GOLEgClLsfpq0hLg7RtuJeG1GG3tOU+fVIwzDso136G/po6TDs9sCm2Hmb
    VXpAaTA8TWgUdhhNRWcjoeAhpw9NLpL25sQJmmzezLXG6PUJUcVtQ77s4hNu4Yv27S5+bp
    YzW3RBGYurCHF/RaLTkDpVucpyfQNXeHByTveMZ9mr7sje2Wm93JoB+zFtpWOrd+BXc+Cd
    n65msms5C5E+05MZQDQTCD+6wccgKwokPvFpyzz/CWzIA7+3yeuWWt3I2PdEWM+NnLvEFH
    SNR0inOBwrkS89wb0MaNngod8hT1AbqIDZJQaUAXsspitA7J6tsk4GQnTFGGRlWsYZqNon
    0iKDzcgwzp5Kf51pIJvpPn3cpueMVY4qq/rB3aYKmLFRi/7fYl+/vG4NeXd2UeiP9cOqUP
    SpfhIe05pT0/qJ7BGUOmhMLsLnJwAttl2j7Y2SdoPSWQnnpOw5jwwFJXtbOYEhQmQyo0dx
    8bxPAo8VU7Gj5MTMMHOxCjG4JPgAvYuVVtlDlZyLOcf3DvPOHCLvoEBYQp/NkkIEkbH7ls
    iwv9vArdeLDxeHaDzPrwkf8pIj1DtljEvvAJprnw6Am1cUYaBjJzvSOnl0ow
X-ME-Proxy: <xmx:cq_AamydFc75JWEBcBEVBrrNnxJzWbrKrhgZZfFiejsaJfapMdI0fQ>
    <xmx:cq_Aai994oCWoed86LqPTlHeYHIGqrMM-INwVaqa44wmmpG2NEdoXg>
    <xmx:cq_Aamhb8M3aNswFU-85-lQsFWvyK2ec2fbZHXwEQppDmNvVmYCkdg>
    <xmx:cq_AahG7o2dzznihXJ0EP8NONnapiSZAidalravU27nO_L3Bm_r8zA>
    <xmx:cq_Aat9HTuC4zz8Ovq8_bG84cExcCQCziE0KpA7NjmT_V0ujqzIth-n->
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 79940F80096; Sat,  3 Oct 2026 03:32:00 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 03 Oct 2026 09:31:39 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Andrew Morton" <akpm@linux-foundation.org>
Message-Id: <019c709e-9513-44c1-bbb0-82cb16040709@app.fastmail.com>
In-Reply-To: <asB7QVFMlgKgbje2@zx2c4.com>
References: <20261002223708.39183-1-ebiggers@kernel.org>
 <asB7QVFMlgKgbje2@zx2c4.com>
Subject: Re: [PATCH] lib: Move SipHash into lib/crypto/
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Sat, 3 Oct 2026, at 05:49, Jason A. Donenfeld wrote:
> On Fri, Oct 02, 2026 at 03:37:08PM -0700, Eric Biggers wrote:
>> The addition of SipHash to lib/ predated the existence of the
>> lib/crypto/ directory.  Since it's a cryptographic algorithm, move it
>> from the top-level lib/ directory to lib/crypto/.
>> 
>> Specifically:
>> 
>> - Move both siphash.c and siphash_kunit.c.  Keep the header
>>   <linux/siphash.h> as-is for now.
>> 
>> - Keep the dedicated MAINTAINERS entry for SipHash.  Just update the
>>   file paths it references.
>
> Given that I'm also listed in the crypto section, I think we may as well
> delete the whole separate entry.
>
> The only downside of this change is that those hsiphash functions are,
> erm, a bit less than cryptographic-strength. But maybe such concerns
> don't really matter any more at this stage, and we might as well group
> it all in lib/crypto/ where it all belonged originally anyway.
>
> Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
>

Either works for me.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
