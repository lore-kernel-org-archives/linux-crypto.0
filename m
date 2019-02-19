Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B31C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 09:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F9AF2146F
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 09:58:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Uz5YR1Zi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfBSJ6w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 04:58:52 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44114 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbfBSJ6v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 04:58:51 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190219095848euoutp01e0f905ddb7c3da3e77c4dc2bd2563a29~Eu3_38od-0272402724euoutp01e
        for <linux-crypto@vger.kernel.org>; Tue, 19 Feb 2019 09:58:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190219095848euoutp01e0f905ddb7c3da3e77c4dc2bd2563a29~Eu3_38od-0272402724euoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1550570328;
        bh=/sf1NHZ7+oJ7qe/eHWDQoDHIEq9weiuK8Lm9ifhgRZo=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Uz5YR1ZiR6+VzV3C+MTgU7GJVX3xDBYC/AIVjcwdJrWErceceH+UmQk5hwql6J4Cr
         43riDQtOWUc4bJnL3ovvGq1admdpwovGPF6V87WUpXUrd4MB31yDcwDtoD5yoWcrtF
         18iAAKbUQECewdjRBsQFEPa4/0/H0KFoBOIpad1Q=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190219095848eucas1p258c1305e4ecc9e67ed062d5e04f88a88~Eu3_HJkBA0423204232eucas1p2H;
        Tue, 19 Feb 2019 09:58:48 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id CC.DC.04441.753DB6C5; Tue, 19
        Feb 2019 09:58:47 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190219095847eucas1p2ef30e90730ae85c96f9c2e3e65778e3a~Eu39SN6Ii0622206222eucas1p2h;
        Tue, 19 Feb 2019 09:58:47 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190219095846eusmtrp2be3197a384d1af4001c1740a2a6dc058~Eu39D7rXp0716107161eusmtrp2R;
        Tue, 19 Feb 2019 09:58:46 +0000 (GMT)
X-AuditID: cbfec7f2-5c9ff70000001159-7d-5c6bd35708dc
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 43.A0.04128.653DB6C5; Tue, 19
        Feb 2019 09:58:46 +0000 (GMT)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190219095846eusmtip1d69c9235a639f97ad28924994b5a4296~Eu38t3EAf1094510945eusmtip1J;
        Tue, 19 Feb 2019 09:58:46 +0000 (GMT)
Subject: Re: [Bug] s5p-sss crypto driver doesn't set next AES-CBC IV
To:     Eric Biggers <ebiggers@kernel.org>,
        Christoph Manszewski <c.manszewski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        linux-samsung-soc@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
Message-ID: <a78f8033-954f-8b59-b361-557acef3acdd@partner.samsung.com>
Date:   Tue, 19 Feb 2019 10:58:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190215185058.GB12909@gmail.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsWy7djP87rhl7NjDE40mFoc372U0WLtnj/M
        FufPb2C32PT4GqvF/Xs/mSxmnN/HZPH/VzOzA7vHplWdbB6bl9R7/Fs4hcWjb8sqRo/Pm+QC
        WKO4bFJSczLLUov07RK4Mv7NXM5WcJC74kPjOvYGxnccXYycHBICJhKNE2+xdjFycQgJrGCU
        WLrsGjOE84VR4vfKr1DOZ0aJ9pe3mWFazh9fwgaRWM4o8bz7CiOE85ZRYv+BkywgVcICLhIT
        Nq4EqxIROMEosXllLytIglnATWLK6l9sIDabgLnEo+1nmEBsXqD4nVmfwFawCKhK7FuyDqxe
        VCBC4nDvO0aIGkGJkzOfgC3gFNCX6Nr3hR1iprjErSfzmSBseYntb+eA3S0hsIpdYtXkDewQ
        d7tI3Jh/kg3CFpZ4dXwLVFxG4v9OiGYJgXKJ3VufsUM0tzBKzJ28CCphLXH4+EWgiziANmhK
        rN+lDxF2lLjbv5sFJCwhwCdx460gxA18EpO2TWeGCPNKdLQJQVTrSsz7f4YVwpaW6Pq/jnUC
        o9IsJJ/NQvLNLCTfzELYu4CRZRWjeGppcW56arFhXmq5XnFibnFpXrpecn7uJkZgEjr97/in
        HYxfLyUdYhTgYFTi4V2wPCtGiDWxrLgy9xCjBAezkgiv/onsGCHelMTKqtSi/Pii0pzU4kOM
        0hwsSuK81QwPooUE0hNLUrNTUwtSi2CyTBycUg2MgYkz1c6eMzr2zCjL1nHukukqOpcDHv87
        +KyjuDQl+UuKFy/bHO76FSmWJ82be5Kf7J30nk8kafHKrI06AZZTBZpcugpq+MQvmjaoRC6R
        uKQiJsMS8/7/NItpYnGxx7jemtm3BPzsO/iw+mgtA3+SQ11o6iT+rueOqqsUn2VIvhAoli03
        blZiKc5INNRiLipOBAAYquc+PgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t/xu7phl7NjDJ5st7I4vnspo8XaPX+Y
        Lc6f38BusenxNVaL+/d+MlnMOL+PyeL/r2ZmB3aPTas62Tw2L6n3+LdwCotH35ZVjB6fN8kF
        sEbp2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSWpRbp2yXoZfyb
        uZyt4CB3xYfGdewNjO84uhg5OSQETCTOH1/CBmILCSxllOiYZQYRl5ZoPL2aCcIWlvhzrQuo
        hguo5jWjxNO7vawgCWEBF4kJG1eCJUQETjFKnPo2HWwSs4CbxJTVv6A6mhglZvTOYAZJsAmY
        SzzafgZsLC9Q0Z1Zn8DiLAKqEvuWrAObKioQIfHx6T6oGkGJkzOfsIDYnAL6El37vrBDLFCX
        +DPvEjOELS5x68l8JghbXmL72znMExiFZiFpn4WkZRaSlllIWhYwsqxiFEktLc5Nzy020itO
        zC0uzUvXS87P3cQIjLptx35u2cHY9S74EKMAB6MSD++C5VkxQqyJZcWVuYcYJTiYlUR49U9k
        xwjxpiRWVqUW5ccXleakFh9iNAV6biKzlGhyPjAh5JXEG5oamltYGpobmxubWSiJ8543qIwS
        EkhPLEnNTk0tSC2C6WPi4JRqYIyMP+oXfcVFwuvCx6RPe4/s/n+8Ut7Eu73ddv+BA8qd9zpv
        z115o5E5WD/dvLcm+/peJu/Yt9c6bnz1sXWbVWR8suwyu8DnLyapCfuPrt+V37Qv79O5s65l
        rCuPyoRO4H+/9Lf23+Ce3B0Fr1dYpkt2W1cmeDD+F7R9uf379eUpjSqXJLy8mpRYijMSDbWY
        i4oTAY8C8yDQAgAA
X-CMS-MailID: 20190219095847eucas1p2ef30e90730ae85c96f9c2e3e65778e3a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190215185148epcas3p23960bfe37c629ebb2103e673509949f4
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190215185148epcas3p23960bfe37c629ebb2103e673509949f4
References: <CGME20190215185148epcas3p23960bfe37c629ebb2103e673509949f4@epcas3p2.samsung.com>
        <20190215185058.GB12909@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 15.02.2019 19:51, Eric Biggers wrote:
> Hello,
> 
> The AES-CBC implementation in the s5p-sss crypto driver is failing the improved
> crypto self-tests I currently have out for review.  The improved tests check
> that all CBC implementations update the IV buffer to be the last ciphertext
> block.  This has always been required so that requests can be chained, but
> unfortunately it wasn't tested for by the self-tests until now.
> 
> See the boot logs for Exynos platforms from the KernelCI job here:
> https://kernelci.org/boot/all/job/ardb/branch/for-kernelci/kernel/v5.0-rc1-149-g64c945c018af/
> 
> alg: skcipher: cbc-aes-s5p encryption test failed (wrong output IV) on test vector 0, cfg=\"in-place\"
> 00000000: 3d af ba 42 9d 9e b4 30 b4 22 da 80 2c 9f ac 41
> [...]

I checked dmesg logs after my patch with:

root@target:~# dmesg |grep alg: |grep aes                                       
[    4.087168] crypto: alg: self-tests for aes-generic (aes) passed             
[    6.305202] crypto: alg: self-tests for ecb-aes-s5p (ecb(aes)) passed        
[    6.405489] crypto: alg: self-tests for cbc-aes-s5p (cbc(aes)) passed        
[    6.505000] crypto: alg: self-tests for ctr-aes-s5p (ctr(aes)) passed

and I noticed there are no cbc-aes-generic nor ctr-aes-generic

Did you test them in separate tree ? Why they are not registered in /proc/crypto ?

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

