Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98966824BF
	for <linux-crypto@vger.kernel.org>; Wed, 22 May 2024 11:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716376382; cv=none; b=B2QxAHg6xII2BKUBQdl6DMPaF7fPX43/8KF7TgLbZujVdh3Vt0rJ9fLq7omdcQNBZvmINNBJiMYqiVe51lxb1W3evjokODjLm5W46q38KzgSSb9jJBz5zAyMEZhCd5RTIaQ49tsfZnNGmVXTdHLttrYnlZSvbxekyvfjjyzOqaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716376382; c=relaxed/simple;
	bh=10uC4wZyIFgEpO020mRjHoxu4Yuv32pwltsA6vdKj8o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HiQHdRSX92zgYnN2VcpOZebGvCBPS8nYX5HXCF78mhDx0QgE9rWG7JfAVpcQjj8dA5q6jHnlpEFXwQwU+/CLvIV1HUph2uEkZJSEXPPJVC/BWYlSDJ0QLoMkVkFWiqDTZ9wh1+yET6FDnpZGEUMIIWAG0eSsXXHTCaGjsXrE13w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=CUrQ5/57; arc=none smtp.client-ip=198.47.23.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="CUrQ5/57"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 44MBCsuM095085;
	Wed, 22 May 2024 06:12:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1716376374;
	bh=10uC4wZyIFgEpO020mRjHoxu4Yuv32pwltsA6vdKj8o=;
	h=From:To:CC:Subject:Date;
	b=CUrQ5/57JV/lla62BoYZT0YhOkcJDp3QNvcS6FQy/MJavhAjacWCl4YPYcNEyAjAN
	 PD/uHMaFkvUxPswnEyi21RiKJgrqGhOOcGnE0hOPt6Z9v+i3W1EBhJ/ccEqNRhQC1f
	 gkd9rXZSZKLPtFYnh/lxig1qqmctVSfg8zM2h4OE=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 44MBCsWM051079
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 22 May 2024 06:12:54 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 22
 May 2024 06:12:53 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 22 May 2024 06:12:53 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 44MBCrEj046455;
	Wed, 22 May 2024 06:12:53 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC: <vigneshr@ti.com>, <j-choudhary@ti.com>
Subject: [RFC] crypto: sa2ul - sha1/sha256/sha512 support 
Date: Wed, 22 May 2024 16:42:52 +0530
Message-ID: <878r02f6bv.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Hi Herbert,

TI's crypto accelerator SA2UL doesn't support partial hashing (can't
export hash in between) but it does support incremental hashing (can
process multiple updates).

Currently in driver, only digest is being offloaded to hardware.
init + update + final are implemented using software fall back method.

Multiple of our customer wants to use SA2UL for openssl, which basically
ends up calling init + n X update + final, which ends up using software
fallback(CPU) method.

For incremental hasing, we have to keep the FRAG bit set.
For last packet, we have to unset the FRAG bit and then send the last
packet in. But we don't have a way to know if it is last packet.

We can implement update function to offload to HW, and then call
implemented finup for last packet. But this will fail the selftest combo
of init + update + final. If final is called without sending the last
packet with FRAG bit unset, SHA can't be extracted from SA2UL. As we
have no way to know whether it is a last update or not, the last packet
was also sent in with FRAG bit set.

I found a old thread[0] where Tero has tried to do this by appending all the
data from updates in one buffer and dump them in to SA2UL in one shot.
His idea was rejected because

"These states could potentially be placed on the stack so they
must not be large."

But now we know that FRAG bit can be used. The problem of not able to
know which is last packet can be solved if we can have a lag of one
update packet.

As in, the data that came in first update will be stored
in buffer stored in context and, when second update comes, we pass the
first updates data from buffer to SA2UL and stores the data that came in second
update in buffer. This way when final function is being called we
have last packet in global buffer and that can be sent with FRAG bit unset
to get the SHA.

All we need is buffer only big enough to hold the data that can
be MAX size of data that can come in update from AF_ALG or cryptodev.

With this solution, we still can't support intermediate hash, so export
function will not export intermediate hash. But import and export
functions are not marked as mandatory and we don't really need them either.

Let me know if this solution is upstreamable or if you have any other suggestions.

Thanks,
Kamlesh

[0]https://patchwork.kernel.org/project/linux-crypto/patch/20200615071452.25141-4-t-kristo@ti.com/#23454245
