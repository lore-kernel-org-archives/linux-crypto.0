Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED28C4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 20:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6933760F26
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 20:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhGWTWo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Jul 2021 15:22:44 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:35667 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWTWo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jul 2021 15:22:44 -0400
Received: from [192.168.0.113] ([178.252.67.224]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.179]) with ESMTPSA (Nemesis) id
 1MTiHb-1lfIPd23ED-00Tz9u; Fri, 23 Jul 2021 22:02:48 +0200
Subject: Re: [PATCH 09/11] nvmet: Implement basic In-Band Authentication
To:     Stephan Mueller <smueller@chronox.de>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <2510347.locV8n3378@positron.chronox.de>
 <a4d4bda0-2bc8-0d0c-3e81-55adecd6ce52@suse.de>
 <6538288.aohFRl0Q45@positron.chronox.de>
 <59695981-9edc-6b7a-480a-94cca95a0b8c@suse.de>
 <463a191b9896dd708015645cfc125988cd5deaef.camel@chronox.de>
 <2af95a8e-50d9-7e2d-a556-696e9404fee4@suse.de>
 <740af9f7334c294ce879bef33985dfab6d0523b3.camel@chronox.de>
From:   Vladislav Bolkhovitin <vst@vlnb.net>
Message-ID: <5eb59cb2-75c7-f21c-b0a2-c5d6b8bec53c@vlnb.net>
Date:   Fri, 23 Jul 2021 23:02:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <740af9f7334c294ce879bef33985dfab6d0523b3.camel@chronox.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:6kCqBtG5jsfxD5zTrmlNFZV7U01GfmgfMq8knZTmjxPZGZJ2Tj+
 7eb3/qB2HkCWfz3t9sv1PZKZEgKnThQRYEATAu6juN1BLyy3zh8K00jkOwGVH/gYhzuJQHY
 oGGyA/qnG+UaaygImUYHZKLUBf1KgVlqUjh/I3MYyIkLjGDmBaJZlcRgeX98qyBsks2NtVW
 Yax+rZ9fL9/V3RrJrO82Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vvPfKYNtUX4=:0hP+AbxlgHWDDw6ou7RYAg
 i0SBJDZzrHqLj82UZBF5lno40pU1RpyremPecoMkmKTvsIgy4T6AkfEkdWWIgXAQcIYChv05D
 /xFnLHVS+HrP/Kgac9Sjd6B7mh5Vhr9aMJAd6u2l/hwMW1j5I3SLjLnLHiVSFXci4Iejh6BGJ
 Kke+9VWsbD2gjH4yVvXBvYlTorwof8DPbqzGsq7/E+Z8dIuxhUB3dgIEncsx08lLEHo2RxLYW
 Jj8bNU4JS3kVE3mro26sO+WCuAwyhj74tMZ71kmZGCBlOnY2VaikFDJUOz4XFDlGM1l+uiS5/
 DsYTF62eqQT//JHPFj9rFkUMJQWli9rWjXthOE8olalHW3nqKxt/oqDOBIJY0SAdsAV98W+JS
 ypJd9gxSQqmPNpP8KN/C90q5DBXAEIiAk2Beapcbda+RZlaeMKDGtdHJeujMRKiWYYIq+sZxB
 zM/EIuisSZlbQvfADsXI0n6sWIi9++thlW1zOURqT0psKSniAKAaeP2WJNng35MtM4U4W7yd4
 Y+BXXe0tcIUONVME7oz4iQdrosRdZ/K7Zkci8Nv3lotHg3ov/amu7A7Ql+YC5aUqo0Ms6eFU+
 oidulEggU9/axRh8Y2aOCwvjmxtSSX86ZVbFwHZvdJxYvim/17JejTYDMFhX+48ZUlAb/IDTq
 +WnmJ/DCNrF/gv4OWSO2mAtI4cTVxez4UXiRUnbP78t1LYDAEDuvLyFAtygj9ItFjJ4+/IsXG
 ZlK8isqU+uqsiEM3KfzNBpytCosGLo4HSJXVMUr/ZSzCeqchSIWXZ1bRVuos0FatBZJFn+d49
 d2du/LWef0lipaOAWiB9J0COAslSRUM1wjEUTHtId66OjZ5WPDU7u/wFtVTphVRJtI/u3y8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 7/19/21 1:19 PM, Stephan Mueller wrote:
> Am Montag, dem 19.07.2021 um 11:57 +0200 schrieb Hannes Reinecke:
>> On 7/19/21 10:51 AM, Stephan Mueller wrote:
>>> Am Montag, dem 19.07.2021 um 10:15 +0200 schrieb Hannes Reinecke:
>>>> On 7/18/21 2:56 PM, Stephan Müller wrote:
>>>>> Am Sonntag, 18. Juli 2021, 14:37:34 CEST schrieb Hannes Reinecke:
>>>
>>>>>> The key is also used when using the ffdhe algorithm.
>>>>>> Note: I _think_ that I need to use this key for the ffdhe algorithm,
>>>>>> because the implementation I came up with is essentially plain DH
>>>>>> with
>>>>>> pre-defined 'p', 'q' and 'g' values. But the DH implementation also
>>>>>> requires a 'key', and for that I'm using this key here.
>>>>>>
>>>>>> It might be that I'm completely off, and don't need to use a key for
>>>>>> our
>>>>>> DH implementation. In that case you are correct.
>>>>>> (And that's why I said I'll need a review of the FFDHE
>>>>>> implementation).
>>>>>> But for now I'll need the key for FFDHE.
>>>>>
>>>>> Do I understand you correctly that the dhchap_key is used as the input
>>>>> to
>>>>> the 
>>>>> DH - i.e. it is the remote public key then? It looks strange that this
>>>>> is
>>>>> used 
>>>>> for DH but then it is changed here by hashing it together with
>>>>> something
>>>>> else 
>>>>> to form a new dhchap_key. Maybe that is what the protocol says. But it
>>>>> sounds 
>>>>> strange to me, especially when you think that dhchap_key would be,
>>>>> say,
>>>>> 2048 
>>>>> bits if it is truly the remote public key and then after the hashing
>>>>> it is
>>>>> 256 
>>>>> this dhchap_key cannot be used for FFC-DH.
>>>>>
>>>>> Or are you using the dhchap_key for two different purposes?
>>>>>
>>>>> It seems I miss something here.
>>>>>
>>>> No, not entirely. It's me who buggered it up.
>>>> I got carried away by the fact that there is a crypto_dh_encode_key()
>>>> function, and thought I need to use it here.
>>>
>>> Thank you for clarifying that. It sounds to me that there is no defined
>>> protocol (or if there, I would be wondering how the code would have worked
>>> with a different implementation). Would it make sense to first specify a
>>> protocol for authentication and have it discussed? I personally think it
>>> is a
>>> bit difficult to fully understand the protocol from the code and discuss
>>> protocol-level items based on the code.
>>>
>> Oh, the protocol _is_ specified:
>>
>> https://nvmexpress.org/wp-content/uploads/NVM-Express-Base-Specification-2_0-2021.06.02-Ratified-5.pdf
>>
>> It's just that I have issues translating that spec onto what the kernel
>> provides.
> 
> according to the naming conventions there in figures 447 and following:
> 
> - x and y: DH private key (kernel calls it secret set with dh_set_secret or
> encoded into param.key)

x and y are defined in Figure 444: "Random numbers used as exponents in
a DH exchange". Sections 8.13.5.3 "DH-HMAC-CHAP_Challenge Message" and
8.13.5.4 "DH-HMAC-CHAP_Reply Message" additionally specify that "x is a
random number selected by the controller that shall be at least 256 bits
long" and "y is a random number selected by the host that shall be at
least 256 bits long".

So, x and y are just random numbers, no need to overcomplicate their
generation in the way that is beyond of the standard scope.

Vlad
