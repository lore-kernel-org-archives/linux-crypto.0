Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35D0C4361B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 12:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7906233FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 12:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgLGMjd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 07:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgLGMjc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 07:39:32 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081DFC0613D3
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 04:38:52 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id m5so2977914wrx.9
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 04:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dIOFLZF/ARCog985Fac1F7qO/0ylxBb0XiFsDdUBm1g=;
        b=WtvyeFwsM8WLlHSJ34tBTHVAGXq7C1F1Dp+UeEQT5v/tUJ4LJ1xXn6lDBfkmeoAMD1
         wh2oZPdrtwSFiM2Kc4lyxz2AT5YZORc+qaeUSO1olobWMpVwb5g/cqpsmCo0O68tmz3H
         Yz8p+TRh0Rh/4+brmD2YdCWURbQc7OHANqv1pUrZ+T9pXZqFr9gpAEL/9EbTQr1L5L+E
         9FRV+Amtqe70zokPfFxq1ZPRKvzrfb0z/b2EmYnfvVbQdfLkEAXsfWhpENoz0/TCLs0V
         mO6iVBsi7I/3o+v8vGqYXmU/654JrDDMOwrH7zCqEuPHAdlz153gEtstOggO0iKtTdTK
         bX8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=dIOFLZF/ARCog985Fac1F7qO/0ylxBb0XiFsDdUBm1g=;
        b=lwyNLa1xKPWz/NBAyymqn/feM5T1bGN2ZbJiWxTggWlwQO2m60NCqf5qcHAekULTYw
         CGomd98TNqnMhbMrKg1hJlYECPnAWhrxWl0cLBc8gC5FC6MhZ0AWAXqVUCHSoL9wPYE0
         kdNedjFn10IU5DWMfN8tTopoE0gU7hsb9j/VRt3lXIDGONrKM4vpnCne4HU3yctaL9Vg
         hiumUBiMRwboRDYVmH+Ek8v0HUo2iOmvWRpmV55d5aJ13u5BuqCQGImTrykY65sIukaA
         UEXqwazUqhZ4uHveNSOIAEx08tSbHic+nWue0tOROWl/NcjiOBn7s0PFStT4jCdiHFOY
         7eCA==
X-Gm-Message-State: AOAM530hPG6zrpyQRXe1I9kNzHHeWDEnoVCFZzW9C07gr8S0BdGVeim6
        k3+hJPXhsxTzWAj1Fg+5V/ZRPrBhIPOFEg==
X-Google-Smtp-Source: ABdhPJy6jqX9Il1owU37RM/oACMkvLKCKymIGpwdTgpXYCzvTDD7x9zY0sfvsJbf9wE15KgFdyFkXQ==
X-Received: by 2002:a5d:540f:: with SMTP id g15mr11354452wrv.397.1607344730728;
        Mon, 07 Dec 2020 04:38:50 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:19a7:a975:b119:8f99? ([2a01:e0a:410:bb00:19a7:a975:b119:8f99])
        by smtp.gmail.com with ESMTPSA id w3sm14078898wma.3.2020.12.07.04.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 04:38:50 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: XFRM interface and NF_INET_LOCAL_OUT hook
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Phil Sutter <phil@nwl.cc>, linux-crypto@vger.kernel.org,
        netfilter-devel@vger.kernel.org
References: <20201125112342.GA11766@orbyte.nwl.cc>
 <20201126094021.GK8805@gauss3.secunet.de>
 <20201126131200.GH4647@orbyte.nwl.cc>
 <20201127095511.GD9390@gauss3.secunet.de>
 <20201127141048.GL4647@orbyte.nwl.cc>
 <20201202131847.GB85961@gauss3.secunet.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <b2e87407-97d1-bd6b-ca82-6d34fca87b62@6wind.com>
Date:   Mon, 7 Dec 2020 13:38:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201202131847.GB85961@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le 02/12/2020 à 14:18, Steffen Klassert a écrit :
> On Fri, Nov 27, 2020 at 03:10:48PM +0100, Phil Sutter wrote:
[snip]
>> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
>> index aa4cdcf69d471..24af61c95b4d4 100644
>> --- a/net/xfrm/xfrm_interface.c
>> +++ b/net/xfrm/xfrm_interface.c
>> @@ -317,7 +317,8 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
>>         skb_dst_set(skb, dst);
>>         skb->dev = tdev;
>>  
>> -       err = dst_output(xi->net, skb->sk, skb);
>> +       err = NF_HOOK(skb_dst(skb)->ops->family, NF_INET_LOCAL_OUT, xi->net,
>> +                     skb->sk, skb, NULL, skb_dst(skb)->dev, dst_output);
>>         if (net_xmit_eval(err) == 0) {
>>                 struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
> 
> I don't mind that change, but we have to be carefull on namespace transition.
> xi->net is the namespace 'behind' the xfrm interface. I guess this is the
> namespace where you want to do the match because that is the namespace
> that has the policies and states for the xfrm interface. So I think that
> change is correct, I just wanted to point that out explicitely.
> 
I also agree with the change and the x-netns case.
