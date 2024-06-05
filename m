Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A5C194AC3
	for <linux-crypto@vger.kernel.org>; Wed,  5 Jun 2024 12:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717591352; cv=none; b=koeB251jXTrTk0DvtMiMgOrRwQNCXAkLj9EivAEOH+bLOy0dsnS4nfsxTazyZtZDTsf47BgVhJHdF4qAhQEpLGxwovZNp+gxGdMEA5Lnok0RzCvLrm8xDlIRyMbaoLGfZF+DwLwi0f5k5MTuY84+cM79Ix+i4hcQuF6wZx8qsig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717591352; c=relaxed/simple;
	bh=h05TdsIKEUGpo7N52v95DB6DcC+c0lzno4wxlI4sfMY=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=s7MvS12cpJwaVxqtMQBO5VhY8IlGK1OFqfHE8EYI+Ky4His11TZJvokStuJqPMyUHzIKgf3UNnf7of7XJwqZ0nUmpCWGuNxKRcLwESTgdxDZSpuCJX/asETF5QtSiOtpHw9DVu96NWZWQTQ89hih0mosIzntxslfiJfwSXEUn8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=hF1WJs4b; arc=none smtp.client-ip=198.47.19.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="hF1WJs4b"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 455CgOdw117343;
	Wed, 5 Jun 2024 07:42:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1717591344;
	bh=fphuPQadrNBbQ4rdduS4sMvOsK0fPYaRZmfRQMFKdzg=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=hF1WJs4bOUIgu8tvbVgt4xCBGq0ZfebvOAMv8otE0Gv42cPwBYndKC2RPCWOkGoQu
	 rOgxxB+LUaf/C8zuZVr1DprJXsPa5ULdmsEIF8iL8xMxs6gFmVM7nq5jxL3iZgcdLM
	 mR/nW5G5p6C4/9eggcG4TwVJGBEpjO7GcZ2FsWp0=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 455CgOUw061654
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 5 Jun 2024 07:42:24 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 5
 Jun 2024 07:42:23 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 5 Jun 2024 07:42:23 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 455CgNG9047753;
	Wed, 5 Jun 2024 07:42:23 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>, <vigneshr@ti.com>,
        <j-choudhary@ti.com>
Subject: Re: [RFC] crypto: sa2ul - sha1/sha256/sha512 support
In-Reply-To: <Zlb4SHWuY9CHstnI@gondor.apana.org.au>
References: <878r02f6bv.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <Zlb4SHWuY9CHstnI@gondor.apana.org.au>
Date: Wed, 5 Jun 2024 18:12:22 +0530
Message-ID: <87bk4fa7dd.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Wed, May 22, 2024 at 04:42:52PM +0530, Kamlesh Gurudasani wrote:
>>
>> For incremental hasing, we have to keep the FRAG bit set.
>> For last packet, we have to unset the FRAG bit and then send the last
>> packet in. But we don't have a way to know if it is last packet.
>
> I don't understand.  Can't your user just submit the request as
> a digest instead of init+update+final? Wouldn't that already work
> with your driver as is?
Thanks for the response Herbert.

The way I understand algif_hash calls the digest function[0] if entire
file(file whose SHA needs to be calculated) is less than 16 *
PAGE_SIZE(4 kb for us) 

For any file more than 64 kb, it will fall back to init->update->finup[1]
Implementing init-> update -> finup (SA2UL supports this)
But with this selftest will fail for
init -> update -> final(SA2UL doesn't support this)

Hence we suggested that if we can save 64kb(size of one update) in
context so in final we have one update available.(kind of virtual
finup).

This will pass the self test as well.

Let me know what you think.

Kamlesh

[0]https://elixir.bootlin.com/linux/latest/source/crypto/algif_hash.c#L137
[1]https://elixir.bootlin.com/linux/latest/source/crypto/algif_hash.c#L151
