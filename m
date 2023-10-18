Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8FA7CDB482
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Oct 2023 21:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjJRVni (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjJRVnh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Oct 2023 17:43:37 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B614111
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 14:43:36 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6b496e1e53bso4924346b3a.0
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 14:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697665415; x=1698270215; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yHOjPmOC7r0r+5ar9NobWThJ75pkt4P9q/gadRDvKdc=;
        b=Ke9fOIQfNae3ftZLLmympM1XYECAxszzFRrzroJaGMwPnyeTOZDmy2tp1HtPN7+9Q3
         qvvTT9H/Dv7o7x4Tv7EITPFYtwkYmnhXxbn7h4owHPxG7tC7YYb53Sc/Wl14/WOltPBM
         WRn/26sKy3HhwiNt7O5aMLhf9OyymvyGY44RoYCulW4V2FCwBo1Qt+5bSNq7K/FCkA8H
         xy/H/8iF27fGsA996fCxyhZLGfYh+No86z6/Hw0aFktqtM9GbQUCv4arZi68+8eTsU4m
         xErJJl4HpLOlUq5Ar59hgAQVjN3pWGOxhhWp1mKGj9RNar7WVSlYSkP6WO48UqVjq1wr
         b3Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697665415; x=1698270215;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yHOjPmOC7r0r+5ar9NobWThJ75pkt4P9q/gadRDvKdc=;
        b=TpmEOxu2bw/leDq38OdYz2JKZtLauVyBW4rpZPDNrSlYFpRDosfCAx8knj8ExVU2Cr
         wL6H76n5yH3cQHlh7TBqdjUpRScyUF8r4oyqryU8JE0yqhvjR8gLbx26xivlXPthQ+0i
         HnyxtVLyFiDlXq8sSkzHIgZIfecrnaF1YMeID67PTivRhzbSGRh1xy4B8NjAlwfxAPoH
         0NClxikLd3+SljfT1zAc8qxCyzrIwl1eBL40sMwz0aD/9ThTd8L2qSEu4/+Ge3gUhotw
         BDfjD7mxCuEH1ME49nI4jnhQoxsW8e1qA3ilP3LhvjGsBVbkzDAOtKNUEDcVwXC+ff8B
         TXig==
X-Gm-Message-State: AOJu0Yw6sJl7hPB0Mw7MXW2sstujXt3M4kLM4GrVOnga9eSqBGeMCJkS
        r4WjxOSe27iffpN4ZmFIH7xS4kbqLzU=
X-Google-Smtp-Source: AGHT+IGUIkCQe1UK/QW99mdDBgVsiaYRLV507eIWp4Sq8wCBVUL0fhdbBBlk6yGAr+Sqlx1A3Hmy2I+nx8s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8f96:0:b0:68f:cb69:8e76 with SMTP id
 t22-20020aa78f96000000b0068fcb698e76mr7929pfs.2.1697665415538; Wed, 18 Oct
 2023 14:43:35 -0700 (PDT)
Date:   Wed, 18 Oct 2023 14:43:33 -0700
In-Reply-To: <4f8bb755-e208-fd8c-f948-f7d64260f8a7@amd.com>
Mime-Version: 1.0
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com> <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com> <09556ee3-3d9c-0ecc-0b4a-3df2d6bb5255@amd.com>
 <ZTBCVpXaGcyFaozo@google.com> <4f8bb755-e208-fd8c-f948-f7d64260f8a7@amd.com>
Message-ID: <ZTBRhbCwgZVcKwkP@google.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Alexey Kardashevskiy <aik@amd.com>,
        Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
        liam.merwick@oracle.com, zhi.a.wang@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 18, 2023, Ashish Kalra wrote:
>=20
> On 10/18/2023 3:38 PM, Sean Christopherson wrote:
> > On Wed, Oct 18, 2023, Ashish Kalra wrote:
> > > > static int snp_handle_ext_guest_request(struct vcpu_svm *svm)
> > > > {
> > > > 	struct kvm_vcpu *vcpu =3D &svm->vcpu;
> > > > 	struct kvm *kvm =3D vcpu->kvm;
> > > > 	struct kvm_sev_info *sev;
> > > > 	unsigned long exitcode;
> > > > 	u64 data_gpa;
> > > >=20
> > > > 	if (!sev_snp_guest(vcpu->kvm)) {
> > > > 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_GUEST);
> > > > 		return 1;
> > > > 	}
> > > >=20
> > > > 	data_gpa =3D vcpu->arch.regs[VCPU_REGS_RAX];
> > > > 	if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
> > > > 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_ADDRESS=
);
> > > > 		return 1;
> > > > 	}
> > > >=20

Doh, I forget to set

		vcpu->run->exit_reason        =3D KVM_EXIT_HYPERCALL;

> > > > 	vcpu->run->hypercall.nr		 =3D KVM_HC_SNP_GET_CERTS;
> > > > 	vcpu->run->hypercall.args[0]	 =3D data_gpa;
> > > > 	vcpu->run->hypercall.args[1]	 =3D vcpu->arch.regs[VCPU_REGS_RBX];
> > > > 	vcpu->run->hypercall.flags	 =3D KVM_EXIT_HYPERCALL_LONG_MODE;
> > > > 	vcpu->arch.complete_userspace_io =3D snp_complete_ext_guest_reques=
t;
> > > > 	return 0;
> > > > }
> > > >=20
> > >=20
> > > IIRC, the important consideration here is to ensure that getting the
> > > attestation report and retrieving the certificates appears atomic to =
the
> > > guest. When SNP live migration is supported we don't want a case wher=
e the
> > > guest could have migrated between the call to obtain the certificates=
 and
> > > obtaining the attestation report, which can potentially cause failure=
 of
> > > validation of the attestation report.
> >=20
> > Where does "obtaining the attestation report" happen?  I see the guest =
request
> > and the certificate stuff, I don't see anything about attestation repor=
ts (though
> > I'm not looking very closely).
> >=20
>=20
> The guest requests that the firmware construct an attestation report via =
the
> SNP_GUEST_REQUEST command. The certificates are piggy-backed to the guest
> along with the attestation report (retrieved from the FW via the
> SNP_GUEST_REQUEST command) as part of the SNP Extended Guest Request NAE
> handling.

Ah, thanks!

In that case, my proposal should more or less Just Work=E2=84=A2, we simply=
 need to define
KVM's ABI to be that userspace is responsible for doing KVM_RUN with
vcpu->run->immediate_exit set before migrating if the previous exit was
KVM_EXIT_HYPERCALL with KVM_HC_SNP_GET_CERTS.  This is standard operating p=
rocedure
for userspace exits where KVM needs to "complete" the VM-Exit, e.g. for MMI=
O, I/O,
etc. that are punted to userspace.
