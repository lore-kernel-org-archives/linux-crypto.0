Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A222BC433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Nov 2022 22:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiKHWFe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Nov 2022 17:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiKHWFd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2022 17:05:33 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE111EEF2
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 14:05:31 -0800 (PST)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20221108220529euoutp024ec985b4d9085eb9f77014a46548ae2b~lu0ImulWK1950819508euoutp02e
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 22:05:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20221108220529euoutp024ec985b4d9085eb9f77014a46548ae2b~lu0ImulWK1950819508euoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667945129;
        bh=zgfBTVSsOB3lBvcdFekwuhYytB28N8PDh5Agtj7NqKM=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=aYfKb7zhscRHvVD0b8HR9ouWTYOXirgFpMjZAzV6ZasmgyyNKD4E3Jv2/1tB6yJBZ
         RB3cGGWftrc6LHUnWtcaj7mBaLMsWzwyarTnNLsZEODLuNR+UZh4flhNW9NWlIHr6A
         wav+3z7QSXBlLkEMQu5BZXaUdbFbD8dAxDwNNruA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221108220529eucas1p1d00b305b354f96d3655efc70d421cd87~lu0IKqOyw0223402234eucas1p11;
        Tue,  8 Nov 2022 22:05:29 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 26.5F.10112.9A2DA636; Tue,  8
        Nov 2022 22:05:29 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20221108220529eucas1p215c0154f12de5f83b5b5072be3e51cf6~lu0H8P-iu3124331243eucas1p2j;
        Tue,  8 Nov 2022 22:05:29 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221108220529eusmtrp2aa5474c8dd1715c6fc22856355114d6f~lu0H7uiXT1241112411eusmtrp23;
        Tue,  8 Nov 2022 22:05:29 +0000 (GMT)
X-AuditID: cbfec7f4-cf3ff70000002780-12-636ad2a954ad
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 47.EE.08916.8A2DA636; Tue,  8
        Nov 2022 22:05:28 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221108220528eusmtip11ad068dc543c23350266f166c59ca682~lu0HhIH_v2864728647eusmtip1Y;
        Tue,  8 Nov 2022 22:05:28 +0000 (GMT)
Message-ID: <5fbe28fd-b14d-6622-93e7-780e2f01fb6a@samsung.com>
Date:   Tue, 8 Nov 2022 23:05:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0)
        Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH v4] hw_random: use add_hwgenerator_randomness() for
 early entropy
Content-Language: en-US
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     Dominik Brodowski <linux@dominikbrodowski.net>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <76971346-73bf-f9b8-3434-f06ef991f328@collabora.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsWy7djP87orL2UlG0xpELS4tFLCovuVjMWD
        q1IW9+/9ZLJY0PKB1YHVY8fdJYweF3Zye2w7oOrxeZOcx+S/T5kDWKO4bFJSczLLUov07RK4
        Mj6c6WUp6OKq+LHjNHsD426OLkZODgkBE4mTndNZuhi5OIQEVjBK/Gh8xgbhfGGUWPDvCzuE
        85lRYsarI4wwLa3TvjJCJJYzSsw5/J0VwvnIKPF5/0mwKl4BO4m+z/fYQGwWARWJSe2LWCHi
        ghInZz5hAbFFBVIkdndvA7OFBcIlFi2HqGEWEJe49WQ+E8hQEYH1jBKb1lxhh0gYSfz9towZ
        xGYTMJToetsFtoBTwFHixb23UM3yEtvfzmGGOPUMh8Sdk5oQtovExpUtLBC2sMSr41vYIWwZ
        if87IZZJCLQDPf37PpQzgVGi4fktqKetJe6c+wW0jQNog6bE+l36EGFHiRmTV7OChCUE+CRu
        vBWEuIFPYtK26cwQYV6JjjYhiGo1iVnH18GtPXjhEvMERqVZSMEyC8n7s5B8Mwth7wJGllWM
        4qmlxbnpqcVGeanlesWJucWleel6yfm5mxiBieb0v+NfdjAuf/VR7xAjEwfjIUYJDmYlEd41
        67KShXhTEiurUovy44tKc1KLDzFKc7AoifOyzdBKFhJITyxJzU5NLUgtgskycXBKNTBZbz42
        k83lWW+q6hfPbVZJP+dMnRz7lSvt/Jv/ZhEpSW/143dMFlj8bD+3RUzwioVu4oc63/y+0/Ri
        f/NZlku9mtrJXh2Xt8yY/KLuZvj02zzO/zJiHUK2/guZeCXqyhS+31PqKn9+zzrBVLNg+WN7
        sbsPTp0Xv7hMZq2K5T5XbfG0FKPm7dHu8otevfne/X36Z01rzrxpy7/bGSh7pKYePu30KU9e
        cMrNwDvbZjLlRezY12LPbBo9xyNVYcqLm7wT7qSVlkXfuFIcv5JNzkJCf//dHd9ZXD6rfJrd
        Vjm7iWXS6bN11Q+XJWbr1zrOYhN1O/YuNV1+4Q31wrgXL+v/LI23/LHYUHh5hCRPoRuPEktx
        RqKhFnNRcSIAntyPJaMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t/xu7orLmUlGxyeZWVxaaWERfcrGYsH
        V6Us7t/7yWSxoOUDqwOrx467Sxg9Luzk9th2QNXj8yY5j8l/nzIHsEbp2RTll5akKmTkF5fY
        KkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSWpRbp2yXoZXw408tS0MVV8WPHafYGxt0c
        XYycHBICJhKt074ydjFycQgJLGWUeDhnOiNEQkbi5LQGVghbWOLPtS42iKL3jBKr1m0GK+IV
        sJPo+3yPDcRmEVCRmNS+iBUiLihxcuYTli5GDg5RgRSJb+fqQMLCAuESb77MYgexmQXEJW49
        mc8EMlNEYD2jxJaObkaIhJHE32/LmCGWdTNKHP59iQkkwSZgKNH1tgtsGaeAo8SLe29ZIRrM
        JLq2dkE1y0tsfzuHeQKj0Cwkd8xCsnAWkpZZSFoWMLKsYhRJLS3OTc8tNtQrTswtLs1L10vO
        z93ECIysbcd+bt7BOO/VR71DjEwcjIcYJTiYlUR416zLShbiTUmsrEotyo8vKs1JLT7EaAoM
        jInMUqLJ+cDYziuJNzQzMDU0MbM0MLU0M1YS5/Us6EgUEkhPLEnNTk0tSC2C6WPi4JRqYBIw
        y8h6W+ydOYX/62PZA5G5z/+yTazI1Y6aFP7v6+W9+0oX3l8tHqacF/z5VNyb1+WlKy4d/n/8
        Z3hAqcd31knTr/RXnLuzazvrji0TD1Zc3vFi5ses54tXLeT7MKfl3eGkzafmP2k105h9JSt7
        h3/QM6He3W7NHv+T137f5clSKvVH1dxT5O2Rg9dcnMPNF2ye8n5XVOO1t1Ubln7a9+am80Or
        hNkmZ1TfHax5P79pio61xbeZHWauEwt//n9Zr7NnlrAV+2Ih7gCT6UVnd7Vfzj/19ul9ox4/
        3ufuG92mPdP5em3tNU3fbZ6t0YnSbC87ZNp1rtu8Si1QdWcOcnj26+D1WLnCqKj1AqHvzJxD
        lFiKMxINtZiLihMBX5Ks/jUDAAA=
X-CMS-MailID: 20221108220529eucas1p215c0154f12de5f83b5b5072be3e51cf6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20221108220529eucas1p215c0154f12de5f83b5b5072be3e51cf6
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221108220529eucas1p215c0154f12de5f83b5b5072be3e51cf6
References: <Y2o22ODqUZNO4NsR@zx2c4.com>
        <20221108112413.199669-1-Jason@zx2c4.com>
        <76971346-73bf-f9b8-3434-f06ef991f328@collabora.com>
        <CGME20221108220529eucas1p215c0154f12de5f83b5b5072be3e51cf6@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08.11.2022 12:44, AngeloGioacchino Del Regno wrote:
> Il 08/11/22 12:24, Jason A. Donenfeld ha scritto:
>> Rather than calling add_device_randomness(), the add_early_randomness()
>> function should use add_hwgenerator_randomness(), so that the early
>> entropy can be potentially credited, which allows for the RNG to
>> initialize earlier without having to wait for the kthread to come up.
>>
>> This requires some minor API refactoring, by adding a `sleep_after`
>> parameter to add_hwgenerator_randomness(), so that we don't hit a
>> blocking sleep from add_early_randomness().
>>
>> Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
>> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>
> Reviewed-by: AngeloGioacchino Del Regno 
> <angelogioacchino.delregno@collabora.com>
>
> On MT8192 Asurada, MT8195 Tomato Chromebooks:
> Tested-by: AngeloGioacchino Del Regno 
> <angelogioacchino.delregno@collabora.com>
>
> Thanks for the fast fix!

I also confirm that this version fixed the boot issue observed on most 
of my test systems with Linux next-20221108.

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

