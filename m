Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B52C43460
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 12:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71BA261207
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 12:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236324AbhDQMqT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Apr 2021 08:46:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236205AbhDQMqS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Apr 2021 08:46:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618663552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UoC+7ilmBcEmJCJwQI3vwr6Z/+vKUfNZ6vKqvqIxm3s=;
        b=Za7CcH9bdoAWTdLm6gzjEKwH897YKQy9rtkGoUp5KSmV8LS9G62/dVv+P81DEscQ5VmhZO
        8PAzX6F+HQLiT0vZM6NE5lsClx/E68sboBkV4f3OJWNriIalVGHTd3iLX6c21oo1XgK+v0
        ThQpSIa98oU1/Y/Z6+pX8G4SEXGmATg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-1C9MG4vUOIy6v-CMPuuAkg-1; Sat, 17 Apr 2021 08:45:50 -0400
X-MC-Unique: 1C9MG4vUOIy6v-CMPuuAkg-1
Received: by mail-ed1-f71.google.com with SMTP id v5-20020a0564023485b029037ff13253bcso8587012edc.3
        for <linux-crypto@vger.kernel.org>; Sat, 17 Apr 2021 05:45:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UoC+7ilmBcEmJCJwQI3vwr6Z/+vKUfNZ6vKqvqIxm3s=;
        b=dcQBY0M0Xsec9RCKKyfB7FNtbMwojJP/dWuuXkOBb0wqfN1bx346ACieJ/FdRvHcJQ
         kzMnYJwLv1mbVLtt+TXsAYKXiL3SeNmnIcj3czV3sQ1PhAbp3mtGLvdyOez01UhBJ6de
         h5uUq9eDp8G187ES+hXQVpjNWbY5MHVKtzrPxCwE6kAzPRf5UNwjopSHRCGj0ddjVV1K
         ccfkPIWNqXjATLzRfG12Xwl4uEhas6rBpWrh3ENEw26S5shjkUXjgww9UtsMoUYx8GZT
         MGnvN67nhNjFgZctaGydPPNWXZ86ZpG5GqP96AbyPevu1v+T+JzQFKo5EWniDPB/kcFw
         hujw==
X-Gm-Message-State: AOAM532M9UbfEbbGBk+gCLM8klTEnTHzk0HsC1UThalxHkCsFhdiAXwi
        RaY4bPVkCbyrUBGJt2KewBxV4I1XZPEf2b+Ry3k39dz5p8uLRf3lez01YyEj0jMloXmGsJXRsc3
        dxMlQuc+L3YnMFNyBt90bybiD
X-Received: by 2002:aa7:d541:: with SMTP id u1mr15332128edr.95.1618663549217;
        Sat, 17 Apr 2021 05:45:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxu3V/xkz7i5j8tGWXxBT3bekNVADAjTz8NvcTBB8JDHTTw3q/brCheVYPsMy6PHSOwStAGew==
X-Received: by 2002:aa7:d541:: with SMTP id u1mr15332118edr.95.1618663549034;
        Sat, 17 Apr 2021 05:45:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t15sm7530395edr.55.2021.04.17.05.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 05:45:48 -0700 (PDT)
Subject: Re: [PATCH v2 8/8] KVM: SVM: Allocate SEV command structures on local
 stack
To:     Borislav Petkov <bp@suse.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210406224952.4177376-1-seanjc@google.com>
 <20210406224952.4177376-9-seanjc@google.com>
 <9df3b755-d71a-bfdf-8bee-f2cd2883ea2f@csgroup.eu>
 <20210407102440.GA25732@zn.tnic> <YG3mQ+U6ZnoWIZ9a@google.com>
 <20210407173407.GB25732@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <32b9a108-c7f8-885b-9cee-783d63aea794@redhat.com>
Date:   Sat, 17 Apr 2021 14:45:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210407173407.GB25732@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 07/04/21 19:34, Borislav Petkov wrote:
> On Wed, Apr 07, 2021 at 05:05:07PM +0000, Sean Christopherson wrote:
>> I used memset() to defer initialization until after the various sanity
>> checks,
> 
> I'd actually vote for that too - I don't like doing stuff which is not
> going to be used. I.e., don't change what you have.

It's three votes for that then. :)

Sean, I squashed in this change

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ec4c01807272..a4d0ca8c4710 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1039,21 +1039,14 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
  static int sev_send_cancel(struct kvm *kvm, struct kvm_sev_cmd *argp)
  {
  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct sev_data_send_cancel *data;
+	struct sev_data_send_cancel data;
  	int ret;
  
  	if (!sev_guest(kvm))
  		return -ENOTTY;
  
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	data->handle = sev->handle;
-	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_CANCEL, data, &argp->error);
-
-	kfree(data);
-	return ret;
+	data.handle = sev->handle;
+	return sev_issue_cmd(kvm, SEV_CMD_SEND_CANCEL, &data, &argp->error);
  }
  
  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)

to handle SV_CMD_SEND_CANCEL which I merged before this series.

Paolo

