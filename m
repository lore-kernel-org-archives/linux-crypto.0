Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF61C07E9B
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 20:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B530861019
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 20:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236630AbhGTUJE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 16:09:04 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:38157 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237286AbhGTTsx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 15:48:53 -0400
Received: from [192.168.0.113] ([178.252.67.224]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.163]) with ESMTPSA (Nemesis) id
 1M6YEz-1m3SJE2PNp-0070ir; Tue, 20 Jul 2021 22:28:41 +0200
Subject: Re: [PATCH 06/11] nvme: Implement In-Band authentication
To:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-7-hare@suse.de>
 <bd588839-8acc-91cf-5946-f702007b0c7d@grimberg.me>
 <d74c29b8-1c64-e439-9015-6c424baad3d3@suse.de>
From:   Vladislav Bolkhovitin <vst@vlnb.net>
Message-ID: <a3098fb2-2127-6f81-97e9-ab5de503508e@vlnb.net>
Date:   Tue, 20 Jul 2021 23:28:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <d74c29b8-1c64-e439-9015-6c424baad3d3@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:PbE+rqglmpjeNnT05S+5EUIqm2w3pEbGcHIffWpSRXX9biz2QeV
 tyUB8AS6Qo55qo8uqL+5neAoyx0kl4F3UmzVph2ILPwNpFPn0VjNwYyIoz5/1Dt8xFXgonN
 2eJvzYyQvpQ/1FVMyjYrmTAs1csH0ukTHK/n28AF12USDkhfH7DhVKWbtOxBL8UfwJoyPcS
 AZxLVpm0hqpr96iosFLjg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9Mgyzmns+BA=:iubR+6YagoGNIqn9YX1i2M
 g5kcs/ivnzTG88BCmuhVAbgXGL1XZsCdN2brkgZQ4WZGYJWivoQB4r66CkhvIZUW4QhD5uxMz
 hRUgUXg5cdqR9MHXse/8HSMDle+iiYrVYt7iE7jIBsEszu1O1QxO+fwXDhJLxJXDjcEyvqkgb
 dh6HcshaaUNE3pSBLHG6oudBeMJv0RQxfgwl9jA2vYvQddB911nURptWKOIlM4zT72/8Ncoh1
 LcCmC7YPCZyVN3z22fuLe/97QJAYY6Gc80fH5X2r4hV22CPIFl1/q0oVfmfbe7t8T49tGk8J4
 hhze9qKix37cXVKsdyEuzAIeLmzfPW4UdXIbiVmE0B9AVaB2Q1o9BxCgIuw+utWIjnqAB8Lln
 yFpbdf2IG+x4Oy8NB0uYgk59TXqaxW2icuaB4Ldas+t5fS/WYmOuwvk+eaJfS3pjY4m3lyMqP
 2WyOkcund5irMV/dqpkbvWfOckEqrR1kcQtCu6a3vjhAk9dYY53MwE5oMSBTvTGiXRjY6vOlb
 XkoNFCP2LofC842BjZuHqO8j0WCZuj7MOCJ0fAkcH1u+FRhB1VGYoyA217CCLRmDGcX8AdEuX
 L3pnZpSUQvHt+iASgepTP1ESghteGyzTl7Afp2gTprRkDqe60qk2j2vov84bYho+A7MP7tG66
 J2EKPpUXMF61RzTWbj2v32q5F52txiS4mUXRkjF+uLdu/VUbgzMoq2//clb4C2XKgFjMB1F8+
 fKXCG8119kWQTz9ts+6gT/bZ+3yUHOmr4XUVaJH274qrsVbKaxEZ5ajwDiqeP0kEeBuZiYsTL
 dRrp9v0kPMzGnIEWOg7trNguI+fQ3TNTvuozpwhA3UfmlRc/DdaaXwh36fy8obUsvbuuXiw
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 7/18/21 3:21 PM, Hannes Reinecke wrote:
> On 7/17/21 9:22 AM, Sagi Grimberg wrote:
>>> Implement NVMe-oF In-Band authentication. This patch adds two new
>>> fabric options 'dhchap_key' to specify the PSK
>>
>> pre-shared-key.
>>
>> Also, we need a sysfs knob to rotate the key that will trigger
>> re-authentication or even a simple controller(s-plural) reset, so this
>> should go beyond just the connection string.
>>
> 
> Yeah, re-authentication currently is not implemented. I first wanted to
> get this patchset out such that we can settle on the userspace interface
> (both from host and target).
> I'll have to think on how we should handle authentication; one of the
> really interesting cases would be when one malicious admin will _just_
> send a 'negotiate' command to the controller. As per spec the controller
> will be waiting for an 'authentication receive' command to send a
> 'challenge' payload back to the host. But that will never come, so as it
> stands currently the controller is required to abort the connection.
> Not very nice.

Yes, in this case after some reasonable timeout (I would suggest 10-15
seconds) the controller expected to abort connection and clean up all
allocated resources.

To handle DoS possibility to make too many such "orphan" negotiations,
hence consume all controller memory, some additional handling is needed.
For simplicity as a first step I would suggest to have a global limit on
number of currently being authenticated connections.

[...]

>>> +    chap->key = nvme_auth_extract_secret(ctrl->opts->dhchap_secret,
>>> +                         &chap->key_len);
>>> +    if (IS_ERR(chap->key)) {
>>> +        ret = PTR_ERR(chap->key);
>>> +        chap->key = NULL;
>>> +        return ret;
>>> +    }
>>> +
>>> +    if (key_hash == 0)
>>> +        return 0;
>>> +
>>> +    hmac_name = nvme_auth_hmac_name(key_hash);
>>> +    if (!hmac_name) {
>>> +        pr_debug("Invalid key hash id %d\n", key_hash);
>>> +        return -EKEYREJECTED;
>>> +    }
>>
>> Why does the user influence the hmac used? isn't that is driven
>> by the susbsystem?
>>
>> I don't think that the user should choose in this level.
>>
> 
> That is another weirdness of the spec.
> The _secret_ will be hashed with a specific function, and that function
> is stated in the transport representation.
> (Cf section "DH-HMAC-CHAP Security Requirements").
> This is _not_ the hash function used by the authentication itself, which
> will be selected by the protocol.
> So it's not the user here, but rather the transport specification of the
> key which selects the hash algorithm.

Yes, good catch. It looks as a minor errata material to specify that
hash function here is implementation specific.

I would suggest to just hardcode SHA512 here. Users don't have to be
confused by this.

Vlad
