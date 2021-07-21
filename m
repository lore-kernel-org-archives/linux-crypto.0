Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655CAC12002
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 12:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A7C6120F
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 12:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbhGULad (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Jul 2021 07:30:33 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:51649 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236765AbhGULac (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jul 2021 07:30:32 -0400
Received: from [192.168.0.113] ([178.252.67.224]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.163]) with ESMTPSA (Nemesis) id
 1MIMKq-1lu7qu2Piu-00EQ2C; Wed, 21 Jul 2021 14:10:48 +0200
Subject: Re: [PATCH 06/11] nvme: Implement In-Band authentication
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-7-hare@suse.de>
 <2946f3ff-bfa5-2487-4d91-c5286e3a7189@vlnb.net>
 <a728cc00-700a-203b-d229-a4592af7b936@suse.de>
From:   Vladislav Bolkhovitin <vst@vlnb.net>
Message-ID: <2bbd7b78-df4c-a106-06ec-5b0ee409f2b6@vlnb.net>
Date:   Wed, 21 Jul 2021 15:10:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <a728cc00-700a-203b-d229-a4592af7b936@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:8fX40Evi9CjcPavknM2HmotvQNm6H4z0k8Rcorz30fdwby9lg+q
 MBL3+ytramcbxWZvPWJCoj+wcPCZ6EdnfidB+3G8MFXnYeD6Myl9zQOkmN3De95yV2HQ4Xi
 Pj5Sn5ffdjwAvZGRFzZqmKmfATv0rMHHvGTY+hDO4Fg0qYOSNsy5uEsmpui9cd3pv8EWcO6
 Dnvv6SJjEovvz+ls9xFVQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vOA8wUJZz58=:VEPtDi2xoanYA1CmMIxfp9
 NZjrXWZiOQEGkkLCOANcAF8FwiZQvT0uoVWpKxVW/3JskXAmQyueXLzxb1ffml0aqKN4kd/ew
 Wv4Pt4cBe+tyrURTtqJyaEUOl1CcAJI6SYhCu1FKnX1o6chAto7YBTwiLfkXkryDpuVw6eBg4
 RR4yyGVeysZ3TxsXlHp64cOJzcq4CBhNRS2huLnw7LGQi17pFyh9DJRZpWc5Boz3BfQQz5w5n
 6YB3zEz4nZUK0IcSkoT8vuh+PnbTn1TxlYm+D19mR5qPJGpi6qpR6BF0k1Xo4wCIByL51cG+p
 KSNcOu1MTOzQwaVrhWtEb2cEg1Dvs+R34D0pUJeWIEn0TE20Ym7VQn5SrZze5LZjNiX+dg8fc
 AW9zu2kny1b7pH/QRnVBfV3TgD5FHFYL1eVlolNc9F+OzSTNGhLqAOBbDrRLfpZ3HWP5Cfeu7
 E6G/W/VJhW+9LeKFFV+PmWTsKrFbn6s4m0fzrl1Y4kPOqntWcNSd+jMtQLrFOFZRjHXgvrrHB
 4PK5Bf9JsIVML82qypov3+fH+KBIHYWF+vCYHXTbCcQgNj8XAQ1A/xCYIJeJu7cK+STzv2/i2
 OMkhk0U+cfhQ0aPdKUu1F0/njtXfcbqZbw2i2wk30qXDVeIt6Zjim6SZB12yaYgIBrCkahxFY
 6IbcqFBveSNclb3jtUGWG3q0YrZqgyDF8iXQ95IRjuUzlk2XMoKOxetU7bQuXgcCrbhbxOrVw
 h22J6+kVL6Y+lBBqs0eZkwnP/29/5JrBeySirrfvoXiTm+9rb7Oa598FBsChC+8dW2T+R/uwA
 zfA53SbOIax/zavviaQMNSf+Hqkp2Luz0tjsBTEMFVxpVmMPY9uDxWthSF0C/5DrjekMT5E
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 7/21/21 9:08 AM, Hannes Reinecke wrote:
> On 7/20/21 10:27 PM, Vladislav Bolkhovitin wrote:
>>
>> On 7/16/21 2:04 PM, Hannes Reinecke wrote:
>>
>> [...]
>>
>>> +struct nvmet_dhchap_hash_map {
>>> +	int id;
>>> +	int hash_len;
>>> +	const char hmac[15];
>>> +	const char digest[15];
>>> +} hash_map[] = {
>>> +	{.id = NVME_AUTH_DHCHAP_HASH_SHA256,
>>> +	 .hash_len = 32,
>>> +	 .hmac = "hmac(sha256)", .digest = "sha256" },
>>> +	{.id = NVME_AUTH_DHCHAP_HASH_SHA384,
>>> +	 .hash_len = 48,
>>> +	 .hmac = "hmac(sha384)", .digest = "sha384" },
>>> +	{.id = NVME_AUTH_DHCHAP_HASH_SHA512,
>>> +	 .hash_len = 64,
>>> +	 .hmac = "hmac(sha512)", .digest = "sha512" },
>>> +};
>>
>> "hmac()" is always here, so why not to just auto-generate hmac(sha512)
>> from sha512?
>>
> 
> ... all part of the learning curve ...
> If that's true then of course I can auto-generate the hmac name.

As far as I understand, this naming convention is as stable as any other
interface in the kernel.

Vlad
