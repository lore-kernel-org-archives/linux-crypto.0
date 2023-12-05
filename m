Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B62EFF
	for <linux-crypto@vger.kernel.org>; Mon,  4 Dec 2023 22:56:41 -0800 (PST)
X-ASG-Debug-ID: 1701759397-086e236ff030db0001-Xm9f1P
Received: from ZXSHMBX2.zhaoxin.com (ZXSHMBX2.zhaoxin.com [10.28.252.164]) by mx1.zhaoxin.com with ESMTP id pmQpXwhzRwz4v1k7 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Tue, 05 Dec 2023 14:56:37 +0800 (CST)
X-Barracuda-Envelope-From: LeoLiu-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from ZXBJMBX03.zhaoxin.com (10.29.252.7) by ZXSHMBX2.zhaoxin.com
 (10.28.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 5 Dec
 2023 14:56:37 +0800
Received: from [192.168.1.204] (125.76.214.122) by ZXBJMBX03.zhaoxin.com
 (10.29.252.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 5 Dec
 2023 14:56:35 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Message-ID: <5d2e6354-1430-4c24-83b9-ebd0648792b9@zhaoxin.com>
X-Barracuda-RBL-Trusted-Forwarder: 192.168.1.204
Date: Tue, 5 Dec 2023 14:56:34 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] hwrng: add Zhaoxin rng driver base on rep_xstore
 instruction
To: Herbert Xu <herbert@gondor.apana.org.au>
X-ASG-Orig-Subj: Re: [PATCH v2] hwrng: add Zhaoxin rng driver base on rep_xstore
 instruction
CC: <olivia@selenic.com>, <martin@kaiser.cx>, <jiajie.ho@starfivetech.com>,
	<jenny.zhang@starfivetech.com>, <mmyangfl@gmail.com>, <robh@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<CobeChen@zhaoxin.com>, <TonyWWang@zhaoxin.com>, <YunShen@zhaoxin.com>,
	<LeoLiu@zhaoxin.com>
References: <20231107070900.496827-1-LeoLiu-oc@zhaoxin.com>
 <20231121032939.610048-1-LeoLiu-oc@zhaoxin.com>
 <ZWmpo7r2MGlw4ux2@gondor.apana.org.au>
From: LeoLiu-oc <leoliu-oc@zhaoxin.com>
In-Reply-To: <ZWmpo7r2MGlw4ux2@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 ZXBJMBX03.zhaoxin.com (10.29.252.7)
X-Barracuda-Connect: ZXSHMBX2.zhaoxin.com[10.28.252.164]
X-Barracuda-Start-Time: 1701759397
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 785
X-Barracuda-BRTS-Status: 0
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.117670
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------



在 2023/12/1 17:38, Herbert Xu 写道:
> On Tue, Nov 21, 2023 at 11:29:39AM +0800, LeoLiu-oc wrote:
>> From: LeoLiuoc <LeoLiu-oc@zhaoxin.com>
>>
>> Add support for Zhaoxin hardware random number generator.
>> This driver base on rep_xstore instruction and uses the same
>> X86_FEATURE_XSTORE as via-rng driver. Therefore, modify the x86_cpu_id
>> array in the via-rng driver, so that the corresponding driver can be
>> correctly loader on respective platforms.
> 
> The patch cc list is still different from your other patch.  Please
> make sure that both patches have the same cc list next time.
> 
> Thanks,

Yes, I see what you mean,and will send the next version combined with 
the cc list of the other zhaoxin rng patch in July.

Sincerely,
Leoliu-oc


