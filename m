Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22591C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jul 2022 14:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbiGMO7x (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Jul 2022 10:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbiGMO7x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Jul 2022 10:59:53 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E6313F25
        for <linux-crypto@vger.kernel.org>; Wed, 13 Jul 2022 07:59:51 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id d12so19483878lfq.12
        for <linux-crypto@vger.kernel.org>; Wed, 13 Jul 2022 07:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6Y8GbLmVYsqOjAmk1Y1MFoYDRm1tANijToQSxmqM/Z0=;
        b=Zy2W9NCe+isY/WHx1n36fgDq35tWZP4AnyK3U5sdhE0Expg9sXawpS8p6vOHWmV/Kp
         8QTdb8LrYvSXfxOiA0OYH0n/v4ioxsiAtO98MdBHw1uUuLUS6b39WggfSytIvPzWLCbx
         nXxQuEi/C/ziDw4cgxp0ryFFbb+OfTmx0iP94pfR4Y8qOhojY+IE/IXIeXFGKoZtXvkz
         8KF+XiU0aYlnu3Q67hg8V6jDk7EG5mNQQdaYrFVFdVKrV2O43A3pYJ+afvW7ZMAgX9R/
         rQvnY5DLaLEjmCaN3+K2aY1QDY3CvXszw0mOHJKjzXb4ZBbcU29+byDR9nBIT6szJKIy
         xUrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6Y8GbLmVYsqOjAmk1Y1MFoYDRm1tANijToQSxmqM/Z0=;
        b=wn/aqiFdJ4yRr6ZlqB6gG/JwOy6G4X+MsHOYtP5vPopE+7CTwsI9H89ksklue+sHCz
         irzZDgxYHccW5oqoqJlppbhqXCDiQursIK85D5H4mGcy108HD0MUNE+2vnv+SmbZW1L8
         qMDHgPrJ2l0LOaAhxmLb/P1hzU7oh5awA6muZbEpdTZ7cCPe33g5vU2i2ue0HZH1vKjI
         1jLRdgb9GiXA4Z2YtHHbMCKFEFPaO/R4dknsBGegbA5MODLq3vTHusNolVBBXCNrWQkT
         Uh9wxbJ6tMNRpxzGU9kYRxUZh+xIrbJxjfOSM/PzoggUovCUQy8rEx5dZJE/ShIC5+2k
         Y9gQ==
X-Gm-Message-State: AJIora8oP1S3BEgJHuqWKVXCWXdl/8pn/uC6HG1kNjiY1qOiKBp9BlLB
        CtZdshmtd1Y9rge/HZb0RpdoqknqCzUGpFHUCGGEmw==
X-Google-Smtp-Source: AGRyM1uZws6zrw+EwRedSRLPe8kTBrDm1VGX+neUwHH+c4FgJ6hUI0BWQ33Rc/4Gx1bXbbzdU+TXBZWZajnle0ErRnE=
X-Received: by 2002:a05:6512:32c5:b0:481:1822:c41f with SMTP id
 f5-20020a05651232c500b004811822c41fmr2320675lfg.373.1657724389943; Wed, 13
 Jul 2022 07:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <6a513cf79bf71c479dbd72165faf1d804d77b3af.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6obGwyiJh7J34Vt8tC+XXMNm8YPrv4gV=TVoF2Xga5GjQ@mail.gmail.com>
 <SN6PR12MB27672AA31E96179256235C338E879@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6ryLr6a5iQnwZQT3hqwEpZpb7bn-T8SDY6=5zYs_5NBow@mail.gmail.com> <c3b80f5d-a0e6-ad5d-1c28-c08aded21a11@amd.com>
In-Reply-To: <c3b80f5d-a0e6-ad5d-1c28-c08aded21a11@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 13 Jul 2022 08:59:37 -0600
Message-ID: <CAMkAt6q2ff8pZ2n_j5O59OrH5jWCdU6FUDxy5sS4x+9tkyiTEw@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 28/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 12, 2022 at 11:40 AM Tom Lendacky <thomas.lendacky@amd.com> wro=
te:
>
> On 7/12/22 09:45, Peter Gonda wrote:
> > On Mon, Jul 11, 2022 at 4:41 PM Kalra, Ashish <Ashish.Kalra@amd.com> wr=
ote:
> >>
> >> [AMD Official Use Only - General]
> >>
> >> Hello Peter,
> >>
> >>>> The KVM_SEV_SNP_LAUNCH_FINISH finalize the cryptographic digest and
> >>>> stores it as the measurement of the guest at launch.
> >>>>
> >>>> While finalizing the launch flow, it also issues the LAUNCH_UPDATE
> >>>> command to encrypt the VMSA pages.
> >>
> >>> Given the guest uses the SNP NAE AP boot protocol we were expecting t=
hat there would be some option to add vCPUs to the VM but mark them as "pen=
ding AP boot creation protocol" state. This would allow the LaunchDigest of=
 a VM doesn't change >just because its vCPU count changes. Would it be poss=
ible to add a new add an argument to KVM_SNP_LAUNCH_FINISH to tell it which=
 vCPUs to LAUNCH_UPDATE VMSA pages for or similarly a new argument for KVM_=
CREATE_VCPU?
> >>
> >> But don't we want/need to measure all vCPUs using LAUNCH_UPDATE_VMSA b=
efore we issue SNP_LAUNCH_FINISH command ?
> >>
> >> If we are going to add vCPUs and mark them as "pending AP boot creatio=
n" state then how are we going to do LAUNCH_UPDATE_VMSAs for them after SNP=
_LAUNCH_FINISH ?
> >
> > If I understand correctly we don't need or even want the APs to be
> > LAUNCH_UPDATE_VMSA'd. LAUNCH_UPDATEing all the VMSAs causes VMs with
> > different numbers of vCPUs to have different launch digests. Its my
> > understanding the SNP AP Creation protocol was to solve this so that
> > VMs with different vcpu counts have the same launch digest.
> >
> > Looking at patch "[Part2,v6,44/49] KVM: SVM: Support SEV-SNP AP
> > Creation NAE event" and section "4.1.9 SNP AP Creation" of the GHCB
> > spec. There is no need to mark the LAUNCH_UPDATE the AP's VMSA or mark
> > the vCPUs runnable. Instead we can do that only for the BSP. Then in
> > the guest UEFI the BSP can: create new VMSAs from guest pages,
> > RMPADJUST them into the RMP state VMSA, then use the SNP AP Creation
> > NAE to get the hypervisor to mark them runnable. I believe this is all
> > setup in the UEFI patch:
> > https://www.mail-archive.com/devel@edk2.groups.io/msg38460.html.
>
> Not quite...  there isn't a way to (easily) retrieve the APIC IDs for all
> of the vCPUs, which are required in order to use the AP Create event.
>
> For this version of SNP, all of the vCPUs are measured and started by OVM=
F
> in the same way as SEV-ES. However, once the vCPUs have run, we now have
> the APIC ID associated with each vCPU and the AP Create event can be used
> going forward.
>
> The SVSM support will introduce a new NAE event to the GHCB spec to
> retrieve all of the APIC IDs from the hypervisor. With that, then you
> would be able be required to perform a LAUNCH_UPDATE_VMSA against the BSP=
.

Thank you Tom I missed that we needed to run the APs to set up their
APIC IDs for OVMF. Is there any reason we need to wait for the SVSM to
do what you describe? Couldn't the OVMF use an NAE to get all the APIC
IDs?

>
> Thanks,
> Tom
>
