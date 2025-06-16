Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72721411EB
	for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 00:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750120137; cv=none; b=l+26sBCTMgDL2VQSV8VFQYqQWZjOjTVaUzSgWI2Gxu/2CcQNzWDnkxNSCl5ewb2HGNQbDEznNAvMnfGhcxatIe13teiM89p94Ky4+gEFcuqVJsHHYQISltTkFkDOi1WwT+ywaUKo6m7p6AT0xLajdBg05pt37gw7kls2wdOAQBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750120137; c=relaxed/simple;
	bh=8uIvppExe+TsXXPieSx7PUqI2+M7uvzYYeDJJrC18Lg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=gbr7YyzR3ewOpD8vsWNsGRBTpEzz4/P2WtWgeusHF3MOqSq5HdVsBDUO+hfBfjXS8xwIiHcUoRQKrlZaN/nePXGFOYauU97tYZLZ63x10XcZlyuRwEh4ZTqEAtcR/dcBkkJwBg2I0S8Bkyj9Bmcq0cLaxqxkURDPaVmnPFMSTH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1750120112-086e230fbd4e130001-Xm9f1P
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx1.zhaoxin.com with ESMTP id Qu9fjuOQyXZBQgOK (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Tue, 17 Jun 2025 08:28:32 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Tue, 17 Jun
 2025 08:28:31 +0800
Received: from ZXSHMBX1.zhaoxin.com ([::1]) by ZXSHMBX1.zhaoxin.com
 ([fe80::2c07:394e:4919:4dc1%7]) with mapi id 15.01.2507.044; Tue, 17 Jun 2025
 08:28:31 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from [10.32.65.156] (10.32.65.156) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Mon, 16 Jun
 2025 20:23:45 +0800
Message-ID: <0575ec9d-a6b8-4932-a1aa-9646813957a2@zhaoxin.com>
Date: Mon, 16 Jun 2025 20:23:36 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Subject: Re: [PATCH] crypto: padlock-sha - Add support for Zhaoxin processor
To: Herbert Xu <herbert@gondor.apana.org.au>
X-ASG-Orig-Subj: Re: [PATCH] crypto: padlock-sha - Add support for Zhaoxin processor
CC: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <CobeChen@zhaoxin.com>,
	<TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>, <GeorgeXue@zhaoxin.com>,
	<LeoLiu-oc@zhaoxin.com>, <HansHu@zhaoxin.com>
References: <20250611101750.6839-1-AlanSong-oc@zhaoxin.com>
 <aEpgKQ1I0VDSfhO0@gondor.apana.org.au>
In-Reply-To: <aEpgKQ1I0VDSfhO0@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 6/17/2025 8:28:30 AM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1750120112
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 4475
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.142971
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------


On 6/12/2025 1:05 PM, Herbert Xu wrote:
> 
> On Wed, Jun 11, 2025 at 06:17:50PM +0800, AlanSong-oc wrote:
>>
>> +static int padlock_sha1_update_zhaoxin(struct shash_desc *desc,
>> +                                   const u8 *src, unsigned int len)
>> +{
>> +       struct sha1_state *state = padlock_shash_desc_ctx(desc);
>> +       int blocks = len / SHA1_BLOCK_SIZE;
>> +
>> +       /* The xsha1 instruction requires a 32-byte buffer for execution for Zhaoxin processors */
>> +       u8 buf[32 + PADLOCK_ALIGNMENT - 1];
>> +       u8 *dst = PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
> 
> The padlock has always had an alignment requirement.  We already
> deal with this by using PADLOCK_ALIGNMENT.  So rather than re-inventing
> it here, you should simply change PADLOCK_ALIGNMENT to 32 for Zhaoxin.

For the Zhaoxin processor, the XSHA1 instruction requires 16-byte
alignment, as specified by PADLOCK_ALIGNMENT, rather than 32 bytes,
which remains unchanged. Instead, it requires a 32-byte output buffer
for instruction execution. Before execution, the first 20 bytes of the
output buffer must be initialized with the SHA-1 initial hash constants.
After execution, the first 20 bytes will contain the computed hash
result, while the remaining 12 bytes will be zeroed out. Explain it
using a graph as shown below:

# Before XSHA1 Execution on Zhaoxin platform
Offset:     0                      19                       31
             +----------------------+------------------------+
Buffer:     | Initial Hash Values  |        xxxxxx          |
             +----------------------+------------------------+

# After XSHA1 Execution on Zhaoxin platform
Offset:     0                      19                       31
             +----------------------+------------------------+
Buffer:     |     Hash Result      |        Zeroed          |
             +----------------------+------------------------+

> You should also fix the comment to state that 32 is for alignment
> rather than the size.  The Nano already requires an 128-byte buffer
> and we cater for that so it can't be the size that's the problem
> here.

The 128-byte buffer requirement is already included in 'descsize',
as defined by PADLOCK_SHA_DESCSIZE. In the previous version of
the padlock-sha driver, the 'struct sha1_state' variable and the buffer
resided in separate memory regions. It allowed the driver to safely
write initial hash constants into the buffer and retrieve hash results
from buffer through memcpy() operations. Crucially, when the XSHA1
instruction zeroed out the tail bytes of the buffer, it cannot affect
the contents of 'struct sha1_state'. However, in the current driver
implementation, the 'struct sha1_state' shares memory space with the
buffer. Consequently, when the XSHA1 instruction executes, it
inadvertently clears other members of 'struct sha1_state'. Specifically,
when padlock_sha1_finup() is called, the 'count' member of
'struct sha1_state' no longer reflects the actual data length processed.
Explain it using a graph as shown below:

# Previous version of driver
Offset:         0               19     27                     91
                 +---------------+-------+---------------------+
sha1_state:     |     state     | count |      buffer         |
                 +---------------+-------+---------------------+
                    |         ^
           1. Write |         | 2. Retrieve
                    |         |
Offset:         0  v         |  19                                 127
                 +---------------+----------------------------------+
Buffer:         |               |                                  |
                 +---------------+----------------------------------+

# Current version of driver
Offset:         0                                                  127
                 +--------------------------------------------------+
                 |               19      27 31                 91   |
                 |+--------------+-------+---------------------+    |
Buffer:         ||     state    | count |      buffer         |    |
                 |+--------------+-------+---------------------+    |
                 |                **********                        |
                 +--------------------------------------------------+
                 *: will cleared by instruction

Best Regards
AlanSong-oc

