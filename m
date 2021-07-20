Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6DEC636C9
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 20:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58C896100C
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 20:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbhGTUJC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 16:09:02 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:35357 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237202AbhGTTsD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 15:48:03 -0400
Received: from [192.168.0.113] ([178.252.67.224]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.163]) with ESMTPSA (Nemesis) id
 1M26iv-1m7s9U1YhV-002aGq; Tue, 20 Jul 2021 22:27:49 +0200
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
From:   Vladislav Bolkhovitin <vst@vlnb.net>
Message-ID: <2946f3ff-bfa5-2487-4d91-c5286e3a7189@vlnb.net>
Date:   Tue, 20 Jul 2021 23:27:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210716110428.9727-7-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:dV4jZRVKUd80jgKdUBVpml2f835ViidI6XcAZn8BhG3MNtWLP2Q
 f0nt3S6gKnEZywn1Q2PE04M5RZ4hU/RLIBKqBZCXo7U1F3Gi/gv50xCWOCOS/bZP7BApTkc
 G7TnqruzRNjD3dDL9DN3VGAjsL6WnHMb+BeNqjwKPjxu3VLsIv9KLABTVBMkiOeKKt1On0j
 DwvrM1+0f51OGxKS4g9xA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/6Y1UxJomSU=:RyE9yXts4luQ9BIQMHPL8N
 P5Ku7iHEKWgWY8Bka+p86GcUcWxCnrlKJ9g7NaxEUf9tEOW8yGcM3z0H7tnVGaLIY6kPtwfEk
 RptMvMocpxI1pXCUAlyhrSFTZgbfErf+gTG0DumntrzUpDVb0NpfnBae/zoWWIvQjxF3W3PmB
 BD3zOW4dbhM79iZt9VSHGMMDtK12dTkR0sqQeQm59c6j+EzV9ngbMHmwiRezUJhZ2UGKHrwVf
 tUe7yc+m9gvz6fpZGeHcZKEL/uOttbGJUY0hzOdk+6Cw1qURKeDYH3ZpxPq6yeK/RBLHyeBuF
 NLqLTuZc6qjolJufzxGSMB5SheNrKZ3qftLZMhgJFJO5pZxC0fWZXQcu2YPB91DVzGBFBZh22
 SyVmMrCmvKCizsLMJ0RZVMu/Jq5jijvOe5ZbBtb/n3ZjoZTPXhIkOd4ZVane9pN4LFil+YSL0
 YKKQj0TJIwhGfOvULBv+YzVmU1zj9NYiWWoiBhjiLhYvyct6Q6/Yk1gjKRlDh8bQHPubv5P9b
 fjYxOkD+lCbNwSg3PNVUvIdwlNC1PoKrVUqqIuXIZWktKrFTJE+dmBiTKuNE9estkhCkOANff
 z7qMERmY2D0Ad5vpmFIg/SsD/TBeQ3k8kAQxtH5U7+REzvWMvhQ4VqUxqYFqIPIFfFsXCtet6
 WxQH/XgEAlF1JEs/DojmKgT7CueCXEp45ST8gJQJHH3Zd6xfKBwfcVkKpBpffwpU7HXjoU6IC
 mPtLmdITVqLAdA92lBY5DoBdr0sUpm8+bgeRo5MOdlah84btKZXjlSeCxwudMJd068SegzVgE
 PgsRiVK4U+e0rt9IjdWjMf8e9CxhF6ALZ6cShw0Byr91Dq/R9OtJKruGFS754hYtRhVc8e5
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 7/16/21 2:04 PM, Hannes Reinecke wrote:

[...]

> +struct nvmet_dhchap_hash_map {
> +	int id;
> +	int hash_len;
> +	const char hmac[15];
> +	const char digest[15];
> +} hash_map[] = {
> +	{.id = NVME_AUTH_DHCHAP_HASH_SHA256,
> +	 .hash_len = 32,
> +	 .hmac = "hmac(sha256)", .digest = "sha256" },
> +	{.id = NVME_AUTH_DHCHAP_HASH_SHA384,
> +	 .hash_len = 48,
> +	 .hmac = "hmac(sha384)", .digest = "sha384" },
> +	{.id = NVME_AUTH_DHCHAP_HASH_SHA512,
> +	 .hash_len = 64,
> +	 .hmac = "hmac(sha512)", .digest = "sha512" },
> +};

"hmac()" is always here, so why not to just auto-generate hmac(sha512)
from sha512?

Vlad
