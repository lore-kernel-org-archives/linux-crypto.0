Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD611C433ED
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 12:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81C93611AF
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 12:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbhDQMnU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Apr 2021 08:43:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236205AbhDQMnT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Apr 2021 08:43:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618663373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v6Mb+PkPBBrnApLNLzo6vlvHUrWkry8FXhN/7p3cu+A=;
        b=IBGkRIwZphjkbI/mk+yR0kPID1XFQMLRzNBm1hQrxIoDb4CElmutR2tAiZY9EJLT0+HFkw
        N3VRG2gCuzYU0MbPcpmxko9s93wlPllIVwIenm5JsUqsQCJ/G/hCGzucNo9X7XOT+E6fi1
        D5WZreWAKukFDl+QpM3U8s/EWBvCFPk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-FjNSt5IYOSibZxNo66hmtg-1; Sat, 17 Apr 2021 08:42:51 -0400
X-MC-Unique: FjNSt5IYOSibZxNo66hmtg-1
Received: by mail-ed1-f71.google.com with SMTP id r4-20020a0564022344b0290382ce72b7f9so8596463eda.19
        for <linux-crypto@vger.kernel.org>; Sat, 17 Apr 2021 05:42:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v6Mb+PkPBBrnApLNLzo6vlvHUrWkry8FXhN/7p3cu+A=;
        b=Je1Y0JgQ1jThadobSA+VJ5mfWxWPLTbfj8h8GF5Vn0JBd2WjXspIkLYH9gzsYBAVZF
         blRG9rI0E5zfq6thDXoh2Dtqw0lEMkXe7UAlCkTX6L8D5OYO8D2jlJzqnE46LfeB+6tr
         lKfScQJ40bWeFrBUqnfq86MIm+t5g2kgQYoDCLb4BUKuS0+dnxKAPivrBdaGGP807Olf
         43MjKN10R2RQcaRFJgJ7qUV/nKCKxXpjvuo1BTFp9xKogRSSP9li1EfCfPqd7hNYqCgi
         rIJHExnltxXAbUaZkJVnvO75Dxbj0kcUmqiq7KPbm8oAMge+I3nIAgNRIlOLFkHNFvZi
         QjdA==
X-Gm-Message-State: AOAM533HqcQeX0cQq+NbPtpbUkXFKI9dDEbmL99hX9a4LbCQh7EqsjkH
        uBz7+cTg3NOo4rCvfoyAMEqLY0Qib7waYvbbCxJfV6t/ixtBSwnYouE3xPGN3OeIumtU3S0v4PI
        S6pB2jhD/7iIkXvC2/MWTpQmK
X-Received: by 2002:a17:906:af84:: with SMTP id mj4mr12538609ejb.195.1618663370337;
        Sat, 17 Apr 2021 05:42:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/rAGnhUeAhuXmI4Iows5d3uO86rHJLc+07xpKXycm1wPXBa+McxEFaQqCM2U2gMNK5/UkXg==
X-Received: by 2002:a17:906:af84:: with SMTP id mj4mr12538594ejb.195.1618663370133;
        Sat, 17 Apr 2021 05:42:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ca1sm8198395edb.76.2021.04.17.05.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 05:42:49 -0700 (PDT)
Subject: Re: [PATCH v2 7/8] crypto: ccp: Use the stack and common buffer for
 INIT command
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
References: <20210406224952.4177376-1-seanjc@google.com>
 <20210406224952.4177376-8-seanjc@google.com>
 <29bd7f5d-ebee-b78e-8ba6-fd8e21ec1dc8@csgroup.eu>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a75c54d5-d4af-5d67-ef35-025d3e4a3f51@redhat.com>
Date:   Sat, 17 Apr 2021 14:42:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <29bd7f5d-ebee-b78e-8ba6-fd8e21ec1dc8@csgroup.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 07/04/21 07:20, Christophe Leroy wrote:
>>
>> +    struct sev_data_init data;
> 
> struct sev_data_init data = {0, 0, 0, 0};

Having to count the number of items is suboptimal.  The alternative 
could be {} (which however is technically not standard C), {0} (a bit 
mysterious, but it works) and memset.  I kept the latter to avoid 
touching the submitter's patch too much.

Paolo

