Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862ADC54EBE
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 15:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbjAJPXo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 10:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238964AbjAJPX1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 10:23:27 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8558619C21
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 07:23:15 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id m6so18963102lfj.11
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 07:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Xei/D1xFFLE5WpxaBE/Tg4Sb4JRRguY1a3omXhNRdNQ=;
        b=ksjpe3ePskHcWnV5GTQFpREDCBhu/f/GUrq/ztAX0yjA5OuQ+DutOkLZMxTHo/I+oT
         gSOsKR2CYx0y6FaPPb135ztWWumo2ihZo6Ahtz3tgU5mTzh1iUVqE/qC696Px6TF03zB
         HJ2wfcTzzjh0RCQoPte6n7r2FXr0+ml9tuu2hdvhnf1kixXGHUUotiiqqOagwsRCu4tH
         IfshrT0GjPV1fvD03OZ9Iy/w/vDEEyqakIvbgzh/c02+8JdjVRht0JGh1ozXSnsYeKhF
         ci6m6qdmPoXCnxYdZT2PubbzQgh5LkWDPkj0xHHait+gqehjaPIYZrb0xA5uQaMFqCZD
         GQXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xei/D1xFFLE5WpxaBE/Tg4Sb4JRRguY1a3omXhNRdNQ=;
        b=wFrEPARPdA4gQIPa+gUxK+RJK53Y48pA/LIpF9g+29A1uIf3bRrp711G5ejahypVMR
         DSAODnuPCLZUz6OMciMkUZb+w6kjHqxibe1GpRB7qnKOE9fczGOMqm97Heu/AkhOZgG2
         wvr4lHKy/W0wXQs7VSf2xJ/8hs9xWOyMa1vSeafdOkiGQt1lXjfJ2RvRPr2IVClaO2vL
         lpyCwcGBYhbh2xARpVHB2kng97zKogag2peraQXEjRDMhdpWCXKuJ4wl+IReyj05C1Mm
         2oebR0bbpc3zh8cF93g8AZXZgKnDfXsgHjRPv6zpWd1xMXKb6JR+4VGpdPro1r1MiBiB
         gHSg==
X-Gm-Message-State: AFqh2kp1pNHG2P1tQ9HsabBt0Lakf6xkX2Xgu1rdYWmBTn6tGDQxyIrr
        8UMs44QOpDuwsY/UF1owKcpZoSm7S/5qIYyQteesGw==
X-Google-Smtp-Source: AMrXdXutwwZyshi7xoMMAtLcru6vJQ0zecDlsCbhc0a61fPAh5s83V9KF6oInnQ7VfNNGFDxOOjHvS4HTidsTLJf/lM=
X-Received: by 2002:ac2:5e7c:0:b0:4c3:d803:4427 with SMTP id
 a28-20020ac25e7c000000b004c3d8034427mr2883098lfr.170.1673364193464; Tue, 10
 Jan 2023 07:23:13 -0800 (PST)
MIME-Version: 1.0
References: <20221214194056.161492-1-michael.roth@amd.com> <20221214194056.161492-63-michael.roth@amd.com>
 <1c02cc0d-9f0c-cf4a-b012-9932f551dd83@linux.ibm.com> <CAAH4kHbhFezeY3D_qoMQBLuFzWNDQF2YLQ-FW_dp5itHShKUWw@mail.gmail.com>
 <54ff7326-e3a4-945f-1f60-e73dd8865527@amd.com> <a3ecd9fc-11f8-49b6-09a2-349df815d2cf@linux.ibm.com>
 <1047996c-309b-6839-fdd7-265fc51eb07a@amd.com>
In-Reply-To: <1047996c-309b-6839-fdd7-265fc51eb07a@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 10 Jan 2023 08:23:01 -0700
Message-ID: <CAMkAt6rMwiHoNWLtrdN8g8Ghv8yN8f8fZQBBkXvUdDpdtovPzg@mail.gmail.com>
Subject: Re: [PATCH RFC v7 62/64] x86/sev: Add KVM commands for instance certs
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Dov Murik <dovmurik@linux.ibm.com>,
        Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 10, 2023 at 8:10 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 1/10/23 01:10, Dov Murik wrote:
> > Hi Tom,
> >
> > On 10/01/2023 0:27, Tom Lendacky wrote:
> >> On 1/9/23 10:55, Dionna Amalie Glaze wrote:
> >>>>> +
> >>>>> +static int snp_set_instance_certs(struct kvm *kvm, struct
> >>>>> kvm_sev_cmd *argp)
> >>>>> +{
> >>>> [...]
> >>>>
> >>>> Here we set the length to the page-aligned value, but we copy only
> >>>> params.cert_len bytes.  If there are two subsequent
> >>>> snp_set_instance_certs() calls where the second one has a shorter
> >>>> length, we might "keep" some leftover bytes from the first call.
> >>>>
> >>>> Consider:
> >>>> 1. snp_set_instance_certs(certs_addr point to "AAA...", certs_len=8192)
> >>>> 2. snp_set_instance_certs(certs_addr point to "BBB...", certs_len=4097)
> >>>>
> >>>> If I understand correctly, on the second call we'll copy 4097 "BBB..."
> >>>> bytes into the to_certs buffer, but length will be (4096 + PAGE_SIZE -
> >>>> 1) & PAGE_MASK which will be 8192.
> >>>>
> >>>> Later when fetching the certs (for the extended report or in
> >>>> snp_get_instance_certs()) the user will get a buffer of 8192 bytes
> >>>> filled with 4097 BBBs and 4095 leftover AAAs.
> >>>>
> >>>> Maybe zero sev->snp_certs_data entirely before writing to it?
> >>>>
> >>>
> >>> Yes, I agree it should be zeroed, at least if the previous length is
> >>> greater than the new length. Good catch.
> >>>
> >>>
> >>>> Related question (not only for this patch) regarding snp_certs_data
> >>>> (host or per-instance): why is its size page-aligned at all? why is it
> >>>> limited by 16KB or 20KB? If I understand correctly, for SNP, this buffer
> >>>> is never sent to the PSP.
> >>>>
> >>>
> >>> The buffer is meant to be copied into the guest driver following the
> >>> GHCB extended guest request protocol. The data to copy back are
> >>> expected to be in 4K page granularity.
> >>
> >> I don't think the data has to be in 4K page granularity. Why do you
> >> think it does?
> >>
> >
> > I looked at AMD publication 56421 SEV-ES Guest-Hypervisor Communication
> > Block Standardization (July 2022), page 37.  The table says:
> >
> > --------------
> >
> > NAE Event: SNP Extended Guest Request
> >
> > Notes:
> >
> > RAX will have the guest physical address of the page(s) to hold returned
> > data
> >
> > RBX
> > State to Hypervisor: will contain the number of guest contiguous
> > pages supplied to hold returned data
> > State from Hypervisor: on error will contain the number of guest
> > contiguous pages required to hold the data to be returned
> >
> > ...
> >
> > The request page, response page and data page(s) must be assigned to the
> > hypervisor (shared).
> >
> > --------------
> >
> >
> > According to this spec, it looks like the sizes are communicated as
> > number of pages in RBX.  So the data should start at a 4KB alignment
> > (this is verified in snp_handle_ext_guest_request()) and its length
> > should be 4KB-aligned, as Dionna noted.
>
> That only indicates how many pages are required to hold the data, but the
> hypervisor only has to copy however much data is present. If the data is
> 20 bytes, then you only have to copy 20 bytes. If the user supplied 0 for
> the number of pages, then the code returns 1 in RBX to indicate that one
> page is required to hold the 20 bytes.
>
> >
> > I see no reason (in the spec and in the kernel code) for the data length
> > to be limited to 16KB (SEV_FW_BLOB_MAX_SIZE) but I might be missing some
> > flow because Dionna ran into this limit.
>
> Correct, there is no limit. I believe that SEV_FW_BLOB_MAX_SIZE is a way
> to keep the memory usage controlled because data is coming from userspace
> and it isn't expected that the data would be larger than that.
>
> I'm not sure if that was in from the start or as a result of a review
> comment. Not sure what is the best approach is.

This was discussed a bit in the guest driver changes recently too that
SEV_FW_BLOB_MAX_SIZE is used in the guest driver code for the max cert
length. We discussed increasing the limit there after fixing the IV
reuse issue.

Maybe we could introduce SEV_CERT_BLOB_MAX_SIZE here to be more clear
there is no firmware based limit? Then we could switch the guest
driver to use that too. Dionna confirmed 4 pages is enough for our
current usecase, Dov would you recommend something larger to start?

>
> Thanks,
> Tom
>
> >
> >
> > -Dov
> >
> >
> >
> >> Thanks,
> >> Tom
> >>
> >>>
> >>>> [...]
> >>>>>
> >>>>> -#define SEV_FW_BLOB_MAX_SIZE 0x4000  /* 16KB */
> >>>>> +#define SEV_FW_BLOB_MAX_SIZE 0x5000  /* 20KB */
> >>>>>
> >>>>
> >>>> This has effects in drivers/crypto/ccp/sev-dev.c
> >>>>                                                                  (for
> >>>> example in alloc_snp_host_map).  Is that OK?
> >>>>
> >>>
> >>> No, this was a mistake of mine because I was using a bloated data
> >>> encoding that needed 5 pages for the GUID table plus 4 small
> >>> certificates. I've since fixed that in our user space code.
> >>> We shouldn't change this size and instead wait for a better size
> >>> negotiation protocol between the guest and host to avoid this awkward
> >>> hard-coding.
> >>>
> >>>
