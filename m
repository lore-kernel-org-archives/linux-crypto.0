Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [203.110.167.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD996996A
	for <linux-crypto@vger.kernel.org>; Wed, 31 Jan 2024 10:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.110.167.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706695370; cv=none; b=o8XB2LbpWu5Dk0k6OEl1zicq9/7q3zR6tHBbFtRdORfFVOoJY4D9ZGnMjcdWKio1az4d8tcpZ51qzNRIgtI5NRZ1ezYbtfniARoyubR99uGCzCRb0fjGUeu+GG90IlXj71kxM79W7OT3f+XKMidGfyrXWhmH4fonZ23toqZ6tU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706695370; c=relaxed/simple;
	bh=F5mGUoW48xzXAZjc5e38EOEQmw7xZuGlse21UFTk0ZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=gYy2pTlJ033yJKbkit7My/rgIa/qlt7wl0sTDByoKyPkO9jNr9DibbR3hVyWInOWitJtWSJRikElrmpf67JGpA5J3dIRwoExVMCPFIlKiZPuqVsQSykLmUNEIKR0ohvrrW+eNWheeGs9G7Bpgur39w3qzfuWUZbzf1kA6qLhbQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=203.110.167.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1706694341-1eb14e0c7f32630001-Xm9f1P
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id 9Am2KIjGkuhD23mh (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Wed, 31 Jan 2024 17:45:41 +0800 (CST)
X-Barracuda-Envelope-From: TonyWWang-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 31 Jan
 2024 17:45:41 +0800
Received: from [10.32.57.248] (10.32.57.248) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 31 Jan
 2024 17:45:38 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Message-ID: <40e74749-fa9d-4089-ae23-e9aefdd3549f@zhaoxin.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.32.57.248
Date: Wed, 31 Jan 2024 17:45:37 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] crypto: padlock-sha: Matches CPU with Family with
 6 explicitly
Content-Language: en-US
X-ASG-Orig-Subj: Re: [PATCH v2 1/3] crypto: padlock-sha: Matches CPU with Family with
 6 explicitly
To: Dave Hansen <dave.hansen@intel.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <seanjc@google.com>, <kim.phillips@amd.com>,
	<kirill.shutemov@linux.intel.com>, <jmattson@google.com>,
	<babu.moger@amd.com>, <kai.huang@intel.com>, <acme@redhat.com>,
	<aik@amd.com>, <namhyung@kernel.org>
CC: <CobeChen@zhaoxin.com>, <TimGuo@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>,
	<GeorgeXue@zhaoxin.com>
References: <20240123022852.2475-1-TonyWWang-oc@zhaoxin.com>
 <20240123022852.2475-2-TonyWWang-oc@zhaoxin.com>
 <54d4fe7f-2e36-4bb3-8b51-4a68510010d5@intel.com>
From: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
In-Reply-To: <54d4fe7f-2e36-4bb3-8b51-4a68510010d5@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1706694341
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 1370
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.120184
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------


On 2024/1/24 00:33, Dave Hansen wrote:
>
> [这封邮件来自外部发件人 谨防风险]
>
> On 1/22/24 18:28, Tony W Wang-oc wrote:
>> Updates the supporting qualification for packlock-sha driver, making
>> it support CPUs whose vendor ID is Centaur and Famliy is 6.
> This changelog isn't telling us very much.  *Why* is this a good change?
>
>> diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
>> index 6865c7f1fc1a..2e82c5e77f7a 100644
>> --- a/drivers/crypto/padlock-sha.c
>> +++ b/drivers/crypto/padlock-sha.c
>> @@ -491,7 +491,7 @@ static struct shash_alg sha256_alg_nano = {
>>   };
>>
>>   static const struct x86_cpu_id padlock_sha_ids[] = {
>> -     X86_MATCH_FEATURE(X86_FEATURE_PHE, NULL),
>> +     X86_MATCH_VENDOR_FAM_FEATURE(CENTAUR, 6, X86_FEATURE_PHE, NULL),
>>        {}
>>   };
> Logically, this is saying that there are non-CENTAUR or non-family-6
> CPUs that set X86_FEATURE_PHE, but don't support X86_FEATURE_PHE.  Is
> that the case?

Not exactly.

Zhaoxin CPU supports X86_FEATURE_PHE and X86_FEATURE_PHE2.

We expect the Zhaoxin CPU to use the zhaoxin_sha driver introduced in 
the third patch of this patch set.

Without this patch Zhaoxin CPU will also match the padlock-sha driver too.


> The one Intel use of X86_MATCH_VENDOR_FAM_FEATURE() also looks a bit
> suspect, btw.
