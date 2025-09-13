Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EDE28D830
	for <linux-crypto@vger.kernel.org>; Sat, 13 Sep 2025 09:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757755106; cv=none; b=CEdGx5opQEICPylOwtZdNzexCTSh5D2gQMpNqeazAdd4c37ZTm9a88bztTblERa/gwg/MJaJvRkfIFDjSzAXQ7PYGWPq8EUwHIWqHuZZJi4sAQRxQCKD4Iw4X8liLitkeAiM/24VwJQlOqbbomX5UsChCILP1gCC8VMmuFJg33Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757755106; c=relaxed/simple;
	bh=tQPJI8UaH9ShwL2oT9fh+RYd5uFF1Ym6c4WmLro0tIA=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=oNEbMgcDWBtF0AZ9FdEnjZaSJ+P6iIJk93eC1JBiu0DgdEORZPXydqvYiElWY7eK4dI4GM21ktp8EO8O5VkWrEgc9ckIC4c4ypYvXAYJOmBYXhmnxWeNnSVRikpt5faQ80jOTHGRf4ooHX8foBXXAGznjALu5jbjuq8Rl298abs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Bo2nk8Lb; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Bo2nk8Lb"
Received: from lelvem-sh01.itg.ti.com ([10.180.77.71])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTP id 58D9IF4i681873;
	Sat, 13 Sep 2025 04:18:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1757755095;
	bh=tQPJI8UaH9ShwL2oT9fh+RYd5uFF1Ym6c4WmLro0tIA=;
	h=Date:To:CC:From:Subject;
	b=Bo2nk8LbY9BbwiMbAxgac7Ho0+DOXGvloDw+BGZhbViodBQKumttP3kFHUdGLAaQZ
	 X8/Tk+rQ4Def/7joGbA75PoqoS2aT+Tv3jXG5hekgEo7CPGxXXdGWUYgZfXKE/QwUr
	 KsHqxStuL99Uolu1eI/bRoMMg5WK44JtIjQOnDDA=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
	by lelvem-sh01.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 58D9IFL41919669
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Sat, 13 Sep 2025 04:18:15 -0500
Received: from DLEE202.ent.ti.com (157.170.170.77) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Sat, 13
 Sep 2025 04:18:14 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sat, 13 Sep 2025 04:18:14 -0500
Received: from [10.249.132.21] ([10.249.132.21])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 58D9ICM7997153;
	Sat, 13 Sep 2025 04:18:13 -0500
Message-ID: <55446d58-0ca7-4d1c-9e9c-4fcbf8dcda1f@ti.com>
Date: Sat, 13 Sep 2025 14:48:11 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>
From: T Pratham <t-pratham@ti.com>
Subject: A question on crypto_engine and a possible bug
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi,

Since the in-kernel APIs are not well documented, I got into a road bump recently with crypto engine APIs while implementing my new driver. So I thought of asking my doubts directly, and reporting a behaviour I saw which I think is not expected and possibly a bug.

So, the do_one_op function registered by the user in *_engine_alg, what is it supposed to return? Seeing the int return type, I assumed it should be 0 for success and error codes if any failure occurs (-EINVAL, -ENOMEM, etc. for appropriate failure). Before returning from this function, we also call crypto_finalize_*_request, and pass the return error code to this as well. So do we return the same error code at both places?

The above doesn't seem to be correct while working with AEADs. I was returning same error code from do_one_op function which was being passed to crypto_finalize_aead_request. This was causing selftests to fail in a peculiar way: a random test for encryption was failing with:
"alg: aead: <driver_name> encryption failed on test vector <test vector>; expected error=0, actual error=-74, cfg=<cfg>"

Now, you may recognize that -74 is the code for EBADMSG, which is only returned in decryption when the authentication tag does not match. My driver cannot return this error in encryption in any case. So the error was not coming from my code for sure.

I did some inspection, added some extra prints in testmgr as well as my code, and a pattern emerged. The failing test was always the encryption test after the first decryption test that tests for failing tag authentication (i.e. the decryption test expects -EBADMSG being returned). This was being propagated by the crypto engine queue to the next request somehow (how? a bug? an edge case?). Crypto engine also prints the log "Failed to do one request from queue: -74" for all decryptions returning -EBADMSG. When I changed the return value of do_one_op function from the error code to 0, suddenly all selftests passed (including all random tests)!

So for AEADs -EBADMSG case, are we supposed to return 0, or return 0 always, or what is the return value crypto engine expects?

Regards
T Pratham <t-pratham@ti.com>
