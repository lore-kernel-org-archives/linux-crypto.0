From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v2] crypto: s5p-sss: Add HASH support for Exynos
Date: Mon, 25 Sep 2017 14:08:34 +0200
Message-ID: <0d5028d7-6559-abe5-0825-01da230ce01c@partner.samsung.com>
References: <CGME20170915175007eucas1p2912e7a9e1b44e976f96a53d8c8e442ec@eucas1p2.samsung.com>
        <ee7efd48-434b-e07f-b391-9ceeee980e3e@partner.samsung.com>
        <20170919190341.5vi5icaxnmynywre@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20170919190341.5vi5icaxnmynywre@kozik-lap>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On 19.09.2017 21:03, Krzysztof Kozlowski wrote:
> On Fri, Sep 15, 2017 at 07:50:06PM +0200, Kamil Konieczny wrote:
>> Add support for MD5, SHA1, SHA256 hash algorithms for Exynos HW.
>> It uses the crypto framework asynchronous hash api.
>> It is based on omap-sham.c driver.
>> S5P has some HW differencies and is not implemented.
>>
>> Modifications in s5p-sss: [...]

Below I will address only 'const' questions.

>>[...]
>> +	struct crypto_queue		hash_queue;
>> +	struct ahash_request		*hash_req;
>> +	struct scatterlist		*hash_sg_iter;
>> +	int				hash_sg_cnt;
>> +
>> +	struct samsung_aes_variant	*pdata;
> 
> This should be const as pdata should not be modified.

I will remove this.

>>  [...]
>> -static const struct samsung_aes_variant s5p_aes_data = {
>> +static struct samsung_aes_variant s5p_aes_data = {
> 
> Why do you need to drop the const? This should not be modified.

OK, I will not modify this.

> [...]
>> [...]
>> + */
>> +static struct sss_hash_algs_info exynos_hash_algs_info[] = {
> 
> Can it be const?

No, it contains '.registered' var, used at probe/error path/remove.

>>[...]

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
