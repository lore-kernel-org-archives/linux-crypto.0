Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEE2C54EBD
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Jan 2023 21:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbjAIVSQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Jan 2023 16:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238217AbjAIVRm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2023 16:17:42 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBBD13E9F
        for <linux-crypto@vger.kernel.org>; Mon,  9 Jan 2023 13:16:15 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id z5so8557813wrt.6
        for <linux-crypto@vger.kernel.org>; Mon, 09 Jan 2023 13:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J9KM35Fv2Dw9JmJ+2t7GGA9jMoE7j/7O85W6URim/jg=;
        b=jUHKr9R1sQwJJ2bJxAnapKyyeWwjbh0ONbLgUVCE3TuUCBEiAKy24tFJxSxhrS04oE
         1pSA3H6dh/OY00v7xUleL9fx9CNo5u1hHUFeGOdx/9GOaARQDKglqB0LosYGGysuZP2A
         Ui7TFTmuyIvjIl3kJ0xumIr94MUKJLZb7rFkih9v2xYi0G7aIJpHzeos75blvPUOLW7w
         da1Hu4JZdKjqM4YcqlHqV0FRsAgOc3PIVh6IGWzHxDNBexNUHnKkYIHMY/Rppd/PI6Uv
         Uve+ynbBFDpRLFtrcLQr2ZQfruqmfREKhqmKmXL4VwdGZKl0Y/zsS7kxK3LSfTir9e+h
         Igow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J9KM35Fv2Dw9JmJ+2t7GGA9jMoE7j/7O85W6URim/jg=;
        b=3ujrAY4k6BI3wKpzX2Nc9IFXIiJUA7uRBjY/e+V+BxiGfpWJBeiCXlWDvGVmeDSNQ0
         5qjraFOR2pqXTthynA/7IAAZyMBkWgIv30CkyzclOPJmw3gZGtcVFBQo6dSuWyu3v5dL
         ktVPOPFkuNACiIE/Bl2wDc8AazpzH8z++kRpKBiEiQof+MGkXW4RetNf1ZqB3rnynCdP
         nUHGqoCbjKb6r499ro6cza//+8F7Yj1fkRtUENGc1XILS9IzXrJ+mLwsYb/ZtmYMm0aV
         q8DIGGPlx+aByag/YIyguVpk3/QMq1CwWo7E0I/pNoF3cZsVVoFxUXICdlcZkLwodBwZ
         heZg==
X-Gm-Message-State: AFqh2kp6IQMHCQuxkuITdE1vkL+FYrZKsHuNw6+BkzqRhdS7t0YW3JCK
        cwVuoihYlBlEE2pfXjKci//htw==
X-Google-Smtp-Source: AMrXdXv/cm6IaIy2SIh+NbQ31mBw1A15x3wThIGG/18avpBuj1g5CAbRI4qwwLVQyj0JSlJYYytNTA==
X-Received: by 2002:a05:6000:383:b0:242:5a80:79b8 with SMTP id u3-20020a056000038300b002425a8079b8mr43660704wrf.20.1673298974073;
        Mon, 09 Jan 2023 13:16:14 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id t10-20020a5d534a000000b00272c0767b4asm9430012wrv.109.2023.01.09.13.16.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 13:16:13 -0800 (PST)
Message-ID: <fd00d15c-e131-c0c5-9836-36887e12b44f@arista.com>
Date:   Mon, 9 Jan 2023 21:16:12 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 3/5] crypto/net/tcp: Use crypto_pool for TCP-MD5
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20230103184257.118069-1-dima@arista.com>
 <20230103184257.118069-4-dima@arista.com>
 <20230106180526.6e65b54d@kernel.org>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <20230106180526.6e65b54d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/7/23 02:05, Jakub Kicinski wrote:
> On Tue,  3 Jan 2023 18:42:55 +0000 Dmitry Safonov wrote:
>> Use crypto_pool API that was designed with tcp_md5sig_pool in mind.
>> The conversion to use crypto_pool will allow:
>> - to reuse ahash_request(s) for different users
>> - to allocate only one per-CPU scratch buffer rather than a new one for
>>   each user
>> - to have a common API for net/ users that need ahash on RX/TX fast path
> 
>>  config TCP_MD5SIG
>>  	bool "TCP: MD5 Signature Option support (RFC2385)"
>> -	select CRYPTO
>> +	select CRYPTO_POOL
> 
> Are you sure we don't need to select CRYPTO any more?
> select does not resolve dependencies.

Yeah, stumbled into it when I was rebasing TCP-AO patches on the top:
they select both and I think you're right that it still needs to select
CRYPTO here as well (noticed only after sending v2).

> 
>>  	select CRYPTO_MD5
>>  	help
>>  	  RFC2385 specifies a method of giving MD5 protection to TCP sessions.
> 
>> @@ -749,29 +746,27 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
>>  		daddr = &ip6h->daddr;
>>  	}
>>  
>> -	hp = tcp_get_md5sig_pool();
>> -	if (!hp)
>> +	if (crypto_pool_get(tcp_md5_crypto_pool_id, (struct crypto_pool *)&hp))
> 
> &hp.base ? To avoid the cast

Oh, that's nice, will do!

Thanks,
          Dmitry
