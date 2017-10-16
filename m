From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v5] crypto: s5p-sss: Add HASH support for Exynos
Date: Mon, 16 Oct 2017 18:40:16 +0200
Message-ID: <4ed6e790-891a-42de-8b6b-7318c8a891fd@partner.samsung.com>
References: <CGME20171009111232eucas1p1d17afaae66931a7dd234dbfa1d5a193f@eucas1p1.samsung.com>
        <afa6482f-dc1e-6aab-5754-fa86f554e0b2@partner.samsung.com>
        <4e9717c5-43d1-46d1-60ed-ea8168a91cc4@mentor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <4e9717c5-43d1-46d1-60ed-ea8168a91cc4@mentor.com>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Vladimir,

>>[snip]

>> -static struct s5p_aes_dev *s5p_dev;
>> +enum hash_op {
>> +	HASH_OP_UPDATE = 1,
>> +	HASH_OP_FINAL = 2
>> +};
> 
> If this type is not going to be extended, then I'd rather suggest to
> use a boolean correspondent field in the struct s5p_hash_reqctx instead
> of a new introduced type. [...]

In prevoious mail I wrote 'op_final', but this will actually be 'op_update'.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
