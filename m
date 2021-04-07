Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF929C433B4
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 17:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A508C61262
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 17:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354868AbhDGReX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Apr 2021 13:34:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:43568 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354864AbhDGReW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Apr 2021 13:34:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A6A82ADB3;
        Wed,  7 Apr 2021 17:34:11 +0000 (UTC)
Date:   Wed, 7 Apr 2021 19:34:07 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] KVM: SVM: Allocate SEV command structures on
 local stack
Message-ID: <20210407173407.GB25732@zn.tnic>
References: <20210406224952.4177376-1-seanjc@google.com>
 <20210406224952.4177376-9-seanjc@google.com>
 <9df3b755-d71a-bfdf-8bee-f2cd2883ea2f@csgroup.eu>
 <20210407102440.GA25732@zn.tnic>
 <YG3mQ+U6ZnoWIZ9a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YG3mQ+U6ZnoWIZ9a@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 07, 2021 at 05:05:07PM +0000, Sean Christopherson wrote:
> I used memset() to defer initialization until after the various sanity
> checks,

I'd actually vote for that too - I don't like doing stuff which is not
going to be used. I.e., don't change what you have.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
