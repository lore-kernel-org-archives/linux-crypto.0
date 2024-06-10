Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134FC81AA3
	for <linux-crypto@vger.kernel.org>; Mon, 10 Jun 2024 13:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718024937; cv=none; b=UGDjfjsbJqR6hEd01NCmicPSJr88LJCesf+5BClPhhevGoS88wUxm1OFSSlPWLq78K6YI3vsMBZ34K4Alg6aQonVRfYnNI+OVgFQnJEPa5CHw5Z3kY2jxYST4XrjruHtpkO8lTzBBEpBbbPtvmUzi1S+iCswC+G2Qy0XdtwtavE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718024937; c=relaxed/simple;
	bh=oybp3JFAr3wTJPdAFvYSarD5UWo5q0VJCnDpSizsw0c=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VAO5BmYJw9YxSSzF02L9USIMvsHa1l/QyahNmrCsKYds/EiTLCjnVZZkNDTzyr0ebwONEd08691cL4yZM///NEHJre3k7sNEv0cw6hvIhI3YWDen5BzIKlvy5MWzqV6UKfZH0LcqrXxN+Ub0ouTZyDpWMq1dY474+uvAPZhLLhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=MXYbNkKJ; arc=none smtp.client-ip=198.47.19.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="MXYbNkKJ"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 45AD8php012552;
	Mon, 10 Jun 2024 08:08:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1718024931;
	bh=VCuyluWRe0kdY3edTUcSI33guxGTsG/dvJqSM+cc77w=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=MXYbNkKJNafuP8/EyOa4DJ3bTo8nC37DZLTy5VVLEs3oX3OT/qFy9cNVUkWJZ2ZXs
	 tKXiaYFcMTJ1MVANAqw8a9b5X+y0u1PcwuI5JMQI7BCO4xl/2Nlf+zkGRyJT+PwdtI
	 G27Ymf0aiuz3KjHpaboVKdD8B7EkvNZosrfl+bh0=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 45AD8p3Z063229
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 10 Jun 2024 08:08:51 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 10
 Jun 2024 08:08:50 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 10 Jun 2024 08:08:50 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 45AD8oLB052821;
	Mon, 10 Jun 2024 08:08:50 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>, <vigneshr@ti.com>,
        <j-choudhary@ti.com>
Subject: Re: [RFC] crypto: sa2ul - sha1/sha256/sha512 support
In-Reply-To: <ZmLZ2Zl8HUQc0jST@gondor.apana.org.au>
References: <878r02f6bv.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <Zlb4SHWuY9CHstnI@gondor.apana.org.au>
 <87bk4fa7dd.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <ZmEYiw_IgbC-ksoJ@gondor.apana.org.au>
 <875xum9t2a.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <ZmLZ2Zl8HUQc0jST@gondor.apana.org.au>
Date: Mon, 10 Jun 2024 18:38:49 +0530
Message-ID: <87wmmx7xni.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Thu, Jun 06, 2024 at 05:33:41PM +0530, Kamlesh Gurudasani wrote:
>>
>> Also, the size that can be held by one sg list [0] is 204 entries,
>> which can hold upto 800KB of data. I'm not sure if this is still true.
>> Old article. If we consider chaining we can have more data, not sure how
>> HW handles that.
>
> If it's the SG list size that's limiting you then we should look
> into allowing bigger SG lists for af_alg to be constructed.
>

Increasing the size of sg list will sove our problem to certain extent,
but not completely.

There are few scenarios where we fail,
1. If we increase the size of sg list to handle 100Mb, file size with more
than 100Mb will still fall back to init->update->finup.
SA2UL HW supports only upto 4MB max in one shot, so internally in driver we
have to break the sg list in chunks of 4MB anyway. Will take performance hit.

2. There is scenario of MSG_MORE. If the user wants to break the file
in multiple chunks because of memory limitation and then send it to
SA2UL, then again we fall back to init->update->final.


Now all this scenarios will work if we can have a 64kb of buffer
for one cra_init->init->n*update->final->cra->exit

I think this would be better solution as against increasing the sg list
size to a big value in af_alg.

With the solution of saving 64kb in context, we still won't be able to
export partial hashed state(HW limitation), but we don't even want partial hashed
states. But we can then utilize our HW at fullest as it supports
incremental hashing. 

Our HW will work with init->n*updates->finup WITHOUT 64KB saved in
context, but it will FAIL the selftest with init->update->final

With the solution with 64KB(AFALG_MAX_PAGES * PAGE_SIZE) saved in
context, selftest will also PASS and then we don't have to tinker around
for the use case which use init -> update -> FINAL as standard
offloading.


Kamlesh



> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
