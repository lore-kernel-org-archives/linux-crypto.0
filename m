Received: from arcturus.nroach44.id.au (arcturus.nroach44.id.au [45.32.188.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CB2199949;
	Tue, 17 Mar 2026 02:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.32.188.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773716118; cv=none; b=OH3H9tDBRJmvV2M+MtselNM6iUBUgZ9E2oM/xhex+NDSnU+y4wWKy4Xk6XU/nEASOimvnp+EplQPcsvXijDjXrOVI1PwmmmoJdj+hvZGjUUQFEhF7ncbIREeFf05mu4uoUc6ueemq6//jYmZFmgeQrKTv+4CcMpvmEoR13E+Npo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773716118; c=relaxed/simple;
	bh=WBxbirtXgTFP2VO7Ap9qDqDninnQarfWnxFphtwYMok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JcnshG55nSK8mBLOFce/4trbXhImhzSfXo+ew+AdChTqG1VAx1hraZfoNxdSnqjGs4kEn676Kgz4Jd5VvRIfeDC2HeyTVjktEa8TAlspYX58Rf44EhWCu4WJ8uRG7CqsTGVieBM0kgoWfxZR7Z76qEkUHn7+mMKOwailHCVqL0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nroach44.id.au; spf=pass smtp.mailfrom=nroach44.id.au; dkim=pass (2048-bit key) header.d=nroach44.id.au header.i=@nroach44.id.au header.b=g1xk3dJM; dkim=pass (2048-bit key) header.d=nroach44.id.au header.i=@nroach44.id.au header.b=g1xk3dJM; dkim=pass (2048-bit key) header.d=nroach44.id.au header.i=@nroach44.id.au header.b=JP2J5s6l; arc=none smtp.client-ip=45.32.188.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nroach44.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nroach44.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nroach44.id.au header.i=@nroach44.id.au header.b="g1xk3dJM";
	dkim=pass (2048-bit key) header.d=nroach44.id.au header.i=@nroach44.id.au header.b="g1xk3dJM";
	dkim=pass (2048-bit key) header.d=nroach44.id.au header.i=@nroach44.id.au header.b="JP2J5s6l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nroach44.id.au;
	s=dYX2HNEqNNRL; t=1773715741;
	bh=WBxbirtXgTFP2VO7Ap9qDqDninnQarfWnxFphtwYMok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g1xk3dJMeyU11DO8+6BWu1PkqqcelwnS6VNs/CWcHSvLNr4AC02beHmLxDSx7WptI
	 zf1BMr5YW9Ctz3dLqzBnaX0rzs3r3xknUxUYUttWkoNq/+UYcJ6mJD2wIH8gwIaIpu
	 lZkYm6irFP75/vu26zC4fdR2UDlgh47+PkndZFxha/qJtOSq9x7NCYI+OxinKH4ctr
	 4JrlA7mq0Kik12iycHmNWZPIQefdgBajUX0ZJoeEzgnipgqgVTr9POTDBrtuZOqiJQ
	 GCbrIY3O7Gwj4F1RNsEbFf7s25YJE3LvW/GAkYR9bMmiKRLxeFD0Mkti0lQmPDExnS
	 5sx7dZavDD5/w==
Received: from arcturus.nroach44.id.au (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by arcturus.nroach44.id.au (Postfix) with ESMTPS id 91D0430E95;
	Tue, 17 Mar 2026 10:49:01 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nroach44.id.au;
	s=dYX2HNEqNNRL; t=1773715741;
	bh=WBxbirtXgTFP2VO7Ap9qDqDninnQarfWnxFphtwYMok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g1xk3dJMeyU11DO8+6BWu1PkqqcelwnS6VNs/CWcHSvLNr4AC02beHmLxDSx7WptI
	 zf1BMr5YW9Ctz3dLqzBnaX0rzs3r3xknUxUYUttWkoNq/+UYcJ6mJD2wIH8gwIaIpu
	 lZkYm6irFP75/vu26zC4fdR2UDlgh47+PkndZFxha/qJtOSq9x7NCYI+OxinKH4ctr
	 4JrlA7mq0Kik12iycHmNWZPIQefdgBajUX0ZJoeEzgnipgqgVTr9POTDBrtuZOqiJQ
	 GCbrIY3O7Gwj4F1RNsEbFf7s25YJE3LvW/GAkYR9bMmiKRLxeFD0Mkti0lQmPDExnS
	 5sx7dZavDD5/w==
Received: by arcturus.nroach44.id.au (Postfix, from userid 5555)
	id 723EB3168E; Tue, 17 Mar 2026 10:49:01 +0800 (AWST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nroach44.id.au;
	s=dYX2HNEqNNRL; t=1773715734;
	bh=WBxbirtXgTFP2VO7Ap9qDqDninnQarfWnxFphtwYMok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JP2J5s6l142aPSILmiqSHKSx7HuUp4QaBlVsjeo3KUFows0BEHG/VwVWMaZ3iQVeB
	 uZHdZV3G9DgW0gjbGjeffNmp0WJ4qA3cIsP6U6A0PN+tI6wv/oi6WfAL7jiMAVuQDh
	 D7jzoGXGViLc6HZ1cq6d8DO3CzQhakGt8W6cLJ+gLcNZUvkEIKgnfnYWQY9KdY9/1G
	 HaFAqsII7TecAkVjwsamy2NJMUvZrq9TqJRYAnzA5t/1apLZHUbhgG1C1Rey7pwhIg
	 92MfTKQJaVxwJvLiQPnsiUILspdpTYvBRTPZoyQ+UHJYoKE3P08eU5gXR9v8YqXHV+
	 G/Hx1JHQfJBYQ==
Received: from [IPV6:2403:5814:4228:10:3a62:38:7f97:4cc] (unknown [IPv6:2403:5814:4228:10:3a62:38:7f97:4cc])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by arcturus.nroach44.id.au (Postfix) with ESMTPSA id C88F030E95;
	Tue, 17 Mar 2026 10:48:53 +0800 (AWST)
Message-ID: <ca9ba2ec-849c-4f86-8ac9-274ac4b5f885@nroach44.id.au>
Date: Tue, 17 Mar 2026 10:48:52 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Does the SPARC optimized crypto and CRC code actually work?
To: Eric Biggers <ebiggers@kernel.org>, Andreas Larsson
 <andreas@gaisler.com>, "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
References: <20260316204211.GA2661@quark>
Content-Language: en-US
From: Nathaniel Roach <nroach44@nroach44.id.au>
In-Reply-To: <20260316204211.GA2661@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/3/26 04:42, Eric Biggers wrote:
> Hi,
>
> The Linux kernel contains various SPARC crypto opcodes optimized
> functions in lib/crypto/sparc/, lib/crc/sparc/, and arch/sparc/crypto/.
>
> As the kernel's crypto and CRC code has been refactored over time, we've
> been updating how the SPARC optimized code is integrated accordingly.
> However, QEMU doesn't support the SPARC crypto opcodes, which means that
> even though I (and maybe others) been running the tests on SPARC kernels
> in QEMU, this doesn't actually execute the SPARC optimized code.
>
> So I have to ask: is someone in the SPARC community actually testing
> this code regularly?  That includes running all the KUnit tests for
> crypto and CRC as well as the traditional crypto self-tests.
>
> If not, then unless QEMU support is forthcoming I'd suggest we drop this
> code to avoid issues on SPARC systems.  The generic code is much better
> tested and we know that it works on any architecture, including SPARC.
> Correctness is the first priority, especially for cryptography.
>
> - Eric
>
I've been testing some of the PCI changes that have come through on my 
T5-2. I'll happily add some tests for the crypto functions, I've just 
got no idea how to do so.
