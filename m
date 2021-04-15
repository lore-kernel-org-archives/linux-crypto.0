Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA7F1C433ED
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Apr 2021 16:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9475861152
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Apr 2021 16:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbhDOQJi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Apr 2021 12:09:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233734AbhDOQJh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Apr 2021 12:09:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618502954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W03gzn95lmQwBjXKVAhaFhaZhIzVrvHdOQqbqadkdVs=;
        b=XghCFnRWSUb3vwMv3bMQsJyEuOoZyez/v02RaL/sd0hgAOjAvwCunwc0RNPzOJ3dqC5fI6
        CB1l3njkmvAdQ+v43QTnwnLJxT0B+v2lS587hMBZTnRPAmIv/Nklb+KtN31TELDiONz6aN
        F3aJ251XSzV6ptWkzggM5zjDfdcSLDA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-hit3DVHEOnej_Tda5sbSaA-1; Thu, 15 Apr 2021 12:09:12 -0400
X-MC-Unique: hit3DVHEOnej_Tda5sbSaA-1
Received: by mail-ed1-f72.google.com with SMTP id z3-20020a05640240c3b029037fb0c2bd3bso5493832edb.23
        for <linux-crypto@vger.kernel.org>; Thu, 15 Apr 2021 09:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W03gzn95lmQwBjXKVAhaFhaZhIzVrvHdOQqbqadkdVs=;
        b=dWqb7zVHSP9nMUNS41iHRbP0WK+3/1Dc9QHQxXh0ROA/DUe0D7pQgibfCg/8YixSqK
         k3f34NwAH6poWRHaFRLiT4RUX67tBmeovbMy+zvGlPnCrOyUWQf/+nR7Xq0FOtmOgVXP
         cTbrgDYr7q/cq0RYwIZr77JIG5T+N4U2mIfcYZcI9Rmg53CMB/WYhqK7T8goHdB5x6nC
         mOdP4I36WlDexFUe9DM4jpFG6HPZ9YW8yPtakvD6DmoWQoRCzMsxa/S5f8b2rWZsk7IP
         5POptF9548v2OnzIVbKc0VdSb6WJateILBVefmlKqZzXBPJ2mmvw7s87k6zsNQHQfUMW
         C3bQ==
X-Gm-Message-State: AOAM533cmk4rokdKVxHqFB0uITsV8VRaAgWqnB173oB9+ALWVJkqvikh
        peIy41G3g6puKPTlRxCn0mkmAY+dHn5F9RSgSjNyrKjCfEd2OWxw9Xnd0F+unTG18cLtzkn66yD
        nlC/du3VsuZz9ggZksn8s20Hi
X-Received: by 2002:a05:6402:441:: with SMTP id p1mr5124885edw.298.1618502951040;
        Thu, 15 Apr 2021 09:09:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzV22NsXbsmnW4eVxT5pHeM545ePFvzvr1Wdd3ttFnbZCyVMXKHBg1lLlAtWJY18Pa0LC02/Q==
X-Received: by 2002:a05:6402:441:: with SMTP id p1mr5124867edw.298.1618502950901;
        Thu, 15 Apr 2021 09:09:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id t15sm2297260edr.55.2021.04.15.09.09.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 09:09:10 -0700 (PDT)
Subject: Re: [PATCH v2 0/8] ccp: KVM: SVM: Use stack for SEV command buffers
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20210406224952.4177376-1-seanjc@google.com>
 <3d4ae355-1fc9-4333-643f-f163d32fbe17@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <88eef561-6fd8-a495-0d60-ff688070cc9e@redhat.com>
Date:   Thu, 15 Apr 2021 18:09:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <3d4ae355-1fc9-4333-643f-f163d32fbe17@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 07/04/21 20:00, Tom Lendacky wrote:
> For the series:
> 
> Acked-by: Tom Lendacky<thomas.lendacky@amd.com>

Shall I take this as a request (or permission, whatever :)) to merge it 
through the KVM tree?

Paolo

