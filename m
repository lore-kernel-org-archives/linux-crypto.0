Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9A031B80C
	for <linux-crypto@vger.kernel.org>; Mon, 17 Nov 2025 09:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763372318; cv=none; b=bFZcdW7AfT46Ynrg5TxuRnKyN01THqCVqrLq+P53QCJp18s+yAEqaYlAbQuH8q1Xrr/vlBfpBc9WF4iCrOvakGFeqPBvrmGubXWn3EJzX4glhlcUzcLQmsSEyu8lMf9ou4Z5OxETlCKyE6j54iAFPXXKkNz52VxI5U+YbeM6jTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763372318; c=relaxed/simple;
	bh=0Gq1vTAls4U5lWqQVRIcTaH4k9hEnn0rjpzDd+hIbT0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=J/dxnYWkvrLVLtD/A1ZXQDqwWit6D31xDUDhyZ/fAEtnO0zWv4LWkoicQB3ZKUVJ5dDsIuZqwuoD91f5H+utbW1O4/CJ5tayIxDg0MHl6+6lWisR6uxJyUWsK59QbLxTpiOl4k8MbJNw5xYuZvv5ygfQuhAzsRIvVeyccfhXH8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1763371317-1eb14e3d8797650001-Xm9f1P
Received: from ZXSHMBX3.zhaoxin.com (ZXSHMBX3.zhaoxin.com [10.28.252.165]) by mx2.zhaoxin.com with ESMTP id UscqPKxxjogxNE8Z (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Mon, 17 Nov 2025 17:21:57 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX3.zhaoxin.com
 (10.28.252.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Mon, 17 Nov
 2025 17:21:57 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Mon, 17 Nov 2025 17:21:57 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from [10.32.65.156] (10.32.65.156) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Mon, 17 Nov
 2025 17:04:25 +0800
Message-ID: <c24d0582-ae94-4dfb-ae6f-6baafa7fe689@zhaoxin.com>
Date: Mon, 17 Nov 2025 17:03:17 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Subject: Re: [PATCH] crypto: padlock-sha - Disable broken driver
To: Eric Biggers <ebiggers@kernel.org>, <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
X-ASG-Orig-Subj: Re: [PATCH] crypto: padlock-sha - Disable broken driver
CC: <linux-kernel@vger.kernel.org>, larryw3i <larryw3i@yeah.net>,
	<stable@vger.kernel.org>, <CobeChen@zhaoxin.com>, <GeorgeXue@zhaoxin.com>,
	<HansHu@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>, <TonyWWang-oc@zhaoxin.com>,
	<YunShen@zhaoxin.com>
References: <3af01fec-b4d3-4d0c-9450-2b722d4bbe39@yeah.net>
 <20251116183926.3969-1-ebiggers@kernel.org>
In-Reply-To: <20251116183926.3969-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 11/17/2025 5:21:55 PM
X-Barracuda-Connect: ZXSHMBX3.zhaoxin.com[10.28.252.165]
X-Barracuda-Start-Time: 1763371317
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 736
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.52
X-Barracuda-Spam-Status: No, SCORE=-1.52 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_SA983
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.150256
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_SC0_SA983          Custom Rule BSF_SC0_SA983


On 11/17/2025 2:39 AM, Eric Biggers wrote:

> This driver is known broken, as it computes the wrong SHA-1 and SHA-256
> hashes.  Correctness needs to be the first priority for cryptographic
> code.  Just disable it, allowing the standard (and actually correct)
> SHA-1 and SHA-256 implementations to take priority.
> =20

Following Herbert Xu's=20
suggestion=EF=BC=88https://lore.kernel.org/linux-crypto/aFkdNoQFmr8-x4cu@go=
ndor.apana.org.au/=EF=BC=89,=20
we have prepared a new version of the patch to address this issue. Since=20
the code needs to remain compatible with older platforms, we are still=20
conducting extensive testing. Once the testing is complete, I will=20
submit the finalized patch immediately.

Best Regards
AlanSong-oc
