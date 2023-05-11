Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F53DC77B7F
	for <linux-crypto@archiver.kernel.org>; Thu, 11 May 2023 23:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239181AbjEKXdC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 May 2023 19:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238949AbjEKXdC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 May 2023 19:33:02 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931B76187
        for <linux-crypto@vger.kernel.org>; Thu, 11 May 2023 16:33:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b9a7e3fc659so20610078276.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 May 2023 16:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683847980; x=1686439980;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nS6iEDTOVPKXI4+UjpZyIPwKEGgdgovZohVYNbQWeU4=;
        b=m1mTn2XPoYvYXNYJmfzWbIDXWq4bYYqRuSCzsqBrmXOyn0iTSW1mGChChBz38nWBh0
         /YSu9i0Bb6HmByvNbI7ZobUCRNgitVQYeYkZ28Olsr2kku2etC+KRSnaLV37gSC9NNoE
         J3UlQ9E/lehVq2TxQmiEHcWIyLQKKBpYYY+dBzQvNKqGITGF765K6JIP200Gg32JpwLO
         H+2eHiQq2bHEsJm3WaQW1ox9sUuCfjgkFLErfCQKAD4zQw1/4UOVGm8nGrJaI+HIZFdl
         22Nup8SaEUuyrR8htD0XbmubnyMDg1dnO7tQPh1/wXKOgcuzyWMD1+1f2n3evlgiQJVg
         G4fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683847980; x=1686439980;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nS6iEDTOVPKXI4+UjpZyIPwKEGgdgovZohVYNbQWeU4=;
        b=G0BEfcTXsnuKGnIhoO9O0QT1iZZohsAky01TOOtVfCjKKFrefn74PNjmyz+XvVjnUg
         7Fo/HZ/R2mKRQL4UDxncCCWgHrvRIjAB0JK178GuRLbmfRiQGoi3YF7cUoYV4MvrsrF5
         FdgDO4+vu1ugiYHV8i7uBxNstB6PHHmKik8O54HSO3M9/LCwcIAupg1JkWE7kxW0X2gS
         PD8glQp//RPhAD/+V44Lc8vPpIqR7GS5ZKSrBuAQC3VJbuQ1M3p+8TqOgPHDjnNFK5ud
         InklkObHLLOC2WD+FnvEKbV2IFRJgsLvzDJnfuc2SNU4Q9zjEAl0Br5hRhtvwqOmxZwB
         24jA==
X-Gm-Message-State: AC+VfDynmt8N2iNHMyMVc7N43mACtUduDjiJYxfNqjQ3RXOGK5qCCy/R
        hUQDm2MnFEyXmHR5JfbI7DKgFn3ar6Q=
X-Google-Smtp-Source: ACHHUZ6oeZZ4oIRO3xJnqGtROFKuNKUystxK+0hUJRXTtXXFtT43eUPsNAi2aQTXHdTD16qAMRx6ZKAEsJE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:188c:b0:b96:a18:1b4c with SMTP id
 cj12-20020a056902188c00b00b960a181b4cmr10800373ybb.13.1683847979833; Thu, 11
 May 2023 16:32:59 -0700 (PDT)
Date:   Thu, 11 May 2023 16:32:58 -0700
In-Reply-To: <CAAH4kHYDUGnUnZt2HUVcGqOYyzsyUhBXUqW+iDyvKCtQW9XuEQ@mail.gmail.com>
Mime-Version: 1.0
References: <385016f9-e948-4f7f-8db3-24a0c0543b3d@amd.com> <55e5f02f-4c1f-e6b0-59ba-07abc4d3408f@amd.com>
 <81037a58-6b5c-cde4-79fe-3686d9b8a551@amd.com> <b0baa6ee-ea6d-3a30-d5fb-3ec395896750@amd.com>
 <dbcb6666-270a-4867-6de7-73812d32fd8c@amd.com> <7fb25176-3752-1be3-66d4-a7f5a0e1617a@amd.com>
 <682c0bf9-ccf7-9660-21fe-925ef63c5fbb@amd.com> <4c642bd1-5f1c-292e-398f-eed699db590d@amd.com>
 <65cb8f0f-7e8b-6df6-6bb1-a9f1add027bb@amd.com> <CAAH4kHYDUGnUnZt2HUVcGqOYyzsyUhBXUqW+iDyvKCtQW9XuEQ@mail.gmail.com>
Message-ID: <ZF17KuHV5VIpT8DG@google.com>
Subject: Re: [PATCH RFC v7 52/64] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
From:   Sean Christopherson <seanjc@google.com>
To:     Dionna Amalie Glaze <dionnaglaze@google.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 11, 2023, Dionna Amalie Glaze wrote:
> Would it be okay to request that we add a KVM stat for how often there
> are GUEST_REQUEST_NAE exits? I think it'd be good for service
> operators to get a better idea how valued the feature is.

Heh, it's always ok to request something, but sometimes the answer will be no.

And in the case, the answer is likely "no stat for you".  A year or so ago, in the
context of us (Google) trying to upstream a pile of stats, we (KVM folks) came to
a rough consensus that KVM should only add upstream stats if they are relatively
generic and (almost) universally useful[*].  IMO, a one-off stat for a specific exit
reason is too narrowly focused, e.g. collecting information on all exit reasons is
superior.  And no, that won't be accepted upstream either, because for some environments
gathering detailed information on all exits is too much overhead (also covered in
the link).

FWIW, we (GCE) plan on carrying stats like this in out-of-tree patches, i.e. your
request for stats is likely something that would get accepted internally (if it
isn't already captured through our generic stats collection).

[*] https://lore.kernel.org/all/87czp0voqg.wl-maz@kernel.org
