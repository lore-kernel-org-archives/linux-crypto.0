Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24531957FC
	for <linux-crypto@vger.kernel.org>; Thu,  6 Jun 2024 12:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717675436; cv=none; b=KdhsQHyDgQYHEmbN+q1+49f9vzLJfLQUrhExGjkiq5kRiBcIy7C17cgeatdgKFuOBtE2MfaNQVNrg0gMNZSl6N7fL91tZ4/3NbNeYQrN/fAL42aGJdzH/nWV8NGOiGJ2Fmjy8/0xzJtx176/Ag6OCj0suFWHWtIVpEQtvMYbuy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717675436; c=relaxed/simple;
	bh=DDjp6SAOUmiaQhinPu0H4EgZL7a3XELcpC/m7+nYolk=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SrYl0ZuAMWE9Fso6t3pbfk0uyRoZoD+MWuganZoMzolMT9x81sAaXS8bguMNrbMyp9kCObEkJ8DYyKOteAyba3K1pLBUwB3kmPsju+2TKIOIOU+L3OnVi12nmYp+2YMJ0VjYMyKWH+qG+oiw3MPnoM+BAZCDWwy6+r/vMlMlTt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Wr0d40gA; arc=none smtp.client-ip=198.47.19.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Wr0d40gA"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 456C3hRc106199;
	Thu, 6 Jun 2024 07:03:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1717675423;
	bh=Hbdq/RsCgFWFbIG6n/9OvqIQFuGH2NUTGrSCEJC1KsM=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=Wr0d40gAYhOy58FPtiMyy3twVlb3CwU2zi/qp/gStTDIhqDqFQfM72U3C79Ajr1yW
	 f/jMEPFUdmDBDsKiHudRhuLIjsaAd3dufrjnPbm4iQjbEEchNcG0C4LmbC1ABhRJ+h
	 XqTzISeQ2T9JPp5ZGy4RWeuEOcbKhXfzKjBH+TL0=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 456C3h4l115799
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 6 Jun 2024 07:03:43 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 6
 Jun 2024 07:03:42 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 6 Jun 2024 07:03:42 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 456C3gTk048792;
	Thu, 6 Jun 2024 07:03:42 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>, <vigneshr@ti.com>,
        <j-choudhary@ti.com>
Subject: Re: [RFC] crypto: sa2ul - sha1/sha256/sha512 support
In-Reply-To: <ZmEYiw_IgbC-ksoJ@gondor.apana.org.au>
References: <878r02f6bv.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <Zlb4SHWuY9CHstnI@gondor.apana.org.au>
 <87bk4fa7dd.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <ZmEYiw_IgbC-ksoJ@gondor.apana.org.au>
Date: Thu, 6 Jun 2024 17:33:41 +0530
Message-ID: <875xum9t2a.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Wed, Jun 05, 2024 at 06:12:22PM +0530, Kamlesh Gurudasani wrote:
>>
>> The way I understand algif_hash calls the digest function[0] if entire
>> file(file whose SHA needs to be calculated) is less than 16 *
>> PAGE_SIZE(4 kb for us) 
>
> If that is the concern we should explore increasing the limit,
> or at least making it configurable.  The limit exists in order
> to prevent user-space from exhausting kernel memory, so it is
> meant to be admin-configurable.
Increasing the limit is do able.

But even if we increase the limit to ~1Mb. Calculating the file with size
bigger than that will again fall back to init-> update -> finup.

Also, the size that can be held by one sg list [0] is 204 entries,
which can hold upto 800KB of data. I'm not sure if this is still true.
Old article. If we consider chaining we can have more data, not sure how
HW handles that.

If the file size is about 100 MB in that case it will fallback to init
-> update -> finup.

If at max I can get 800KB, then I think it would be better if we save
64kb in context and implement virtual finup in init -> update -> final.

Allocating 800kb in algif_hash module vs 64kb in sa2ul driver.

This would be generic solution and will fit all scenarios.

If we rely on digest, it will always have some limitation.
Like if user allocates only 5MB buffer and file size was 10MB and data
came in two update() instead of one digest(). (MSG_MORE flag scenario
in algif_hash)

[0]https://lwn.net/Articles/234617/

Cheers,
Kamlesh

>
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
