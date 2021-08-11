Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75FE6C4338F
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Aug 2021 13:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D21260FA0
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Aug 2021 13:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhHKNmo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Aug 2021 09:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbhHKNmo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Aug 2021 09:42:44 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0237C0613D5;
        Wed, 11 Aug 2021 06:42:20 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id e13-20020a9d63cd0000b02904fa42f9d275so3393549otl.1;
        Wed, 11 Aug 2021 06:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hz+p4gP3lCXrc+gD0f6i+2Jz++hhSm2TSQk8dx4ur28=;
        b=nZ2UF4T4GhHt2s2B7v/GSlVVwtT+DjhKHTiV6Wn3U8mXrGGvoY3UYvf35wcy1CCp9l
         CxCibh/b01vnsLBIbmODsBKNO/kDYZQyopXPOilGmcf+kyAK1xbuWRjMpzQ7/gsQaWgd
         KQ/Bm7CQsdrQpmEimCF0gRtnO9/0JD+xQEurbh8r7r76Q/ABcO3rF+WrUqNRX0lHojCQ
         PSkm9Tq0jn4YkwyIXWOTk8AP12kJOqKxvwexxWuD3qeShQ5HkJgJr1jBAd+7JdCykhaQ
         1N1hzET8J+mWn+F/lgrSReg0eBM9vva0ogAjQ37ZpDhe0uxvDCTtJslDu5Z4+M6Isbwe
         oS7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hz+p4gP3lCXrc+gD0f6i+2Jz++hhSm2TSQk8dx4ur28=;
        b=fCYomNCdG6aOGecLPvht7ZdH9eYkiW7hLHh8W8UBHp5lklggMYKuAQM4SyU7gezOV1
         ZlNRbLQ+Ocy1ocwuVmM1Y6VmQyWoP7ANr6bAqrVU/AwqSpnAn1SWMIBw7lTqdO7AWDFd
         orV5ZNiDtqf3yrGF3OeDqw5X96a1fHOASOaPQpz02JfXhUVagJ6e1o07kTA+BVecqB1t
         M7wkxeO7QlWL2KjCk/epD+GbAfO/fnUNksxg35pNReo6EXB3P/lP3sTGeePSilGN/+6Z
         ejpGh5l1q5XqEvBGEXcYhGrT6DKUQRl9Qk8up1IP9Z+FIVQQLrliefiGJBLeM1vu7TGD
         SysA==
X-Gm-Message-State: AOAM532zRAPhyrw8OysCnwllvVy8kvkJaJgrO/P4bgC+NI4zxgtp0Rws
        QdZSh9aSEdngDpAbHzz1KRM=
X-Google-Smtp-Source: ABdhPJxdODF9OoSlnIa5RL/vRy5NZLti/s0RzpXrEpOHVCNgHsyK/KkpSQPBtALY6NwdtYHGK6Z5Sw==
X-Received: by 2002:a9d:a72:: with SMTP id 105mr23573290otg.99.1628689340070;
        Wed, 11 Aug 2021 06:42:20 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id w13sm2730559otl.41.2021.08.11.06.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 06:42:19 -0700 (PDT)
Subject: Re: [RFCv2 1/9] tcp: authopt: Initial support and key management
To:     Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        open list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        Dmitry Safonov <dima@arista.com>
References: <cover.1628544649.git.cdleonard@gmail.com>
 <67c1471683200188b96a3f712dd2e8def7978462.1628544649.git.cdleonard@gmail.com>
 <CAJwJo6aicw_KGQSM5U1=0X11QfuNf2dMATErSymytmpf75W=tA@mail.gmail.com>
 <1e2848fb-1538-94aa-0431-636fa314a36d@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8d656f85-6f66-6c40-c4af-b05c6639b9ab@gmail.com>
Date:   Wed, 11 Aug 2021 07:42:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1e2848fb-1538-94aa-0431-636fa314a36d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/11/21 2:29 AM, Leonard Crestez wrote:
> On 8/10/21 11:41 PM, Dmitry Safonov wrote:
>> Hi Leonard,
>>
>> On Tue, 10 Aug 2021 at 02:50, Leonard Crestez <cdleonard@gmail.com>
>> wrote:
>> [..]
>>> +/* Representation of a Master Key Tuple as per RFC5925 */
>>> +struct tcp_authopt_key_info {
>>> +       struct hlist_node node;
>>> +       /* Local identifier */
>>> +       u32 local_id;
>>
>> There is no local_id in RFC5925, what's that?
>> An MKT is identified by (send_id, recv_id), together with
>> (src_addr/src_port, dst_addr/dst_port).
>> Why introducing something new to already complicated RFC?
> 
> It was there to simplify user interface and initial implementation.
> 
> But it seems that BGP listeners already needs to support multiple
> keychains for different peers so identifying the key by (send_id,
> recv_id, binding) is easier for userspace to work with. Otherwise they
> need to create their own local_id mapping internally.
> 

any proposed simplification needs to be well explained and how it
relates to the RFC spec.

