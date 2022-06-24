Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C24C43334
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jun 2022 16:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiFXQgP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jun 2022 12:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiFXQgO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jun 2022 12:36:14 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0538543EF4
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jun 2022 09:36:13 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id b23so3364028ljh.7
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jun 2022 09:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v0kR56a3js8tVSJ/80FTzZmMgZbMcBIHC4Horg01B0c=;
        b=VHI4cibUu1nlWHaj0e1TN23hEBzchsJwNJ7pRPD9JLXj/JbuL64WYgN1Dd1IRkvPac
         ygipsK+DMHwpIQRsRsbkPu/+djsjTlnueymy5PTClA6o5M5jXIqwHrOIrFtmNyXbhiAY
         kCHtINfa6mI7k46ERe3C4mRVz9huLOLE/9ERK2CbRPYKdq9/dVDOC7BDdmQJZOQ9L3rh
         kHTOpCht0iCElT4L53YjSkh8ELGmiV/61uC9oA5sOwy8KOLsBFEPRq1xqbTaVTAqzzHA
         rrsXjD2OIPdEy28yftHFvR5TnUVUVvdaKNm4ZmDwswT0iDB3YQ+h16vkjyIlglLcnDlR
         Wp6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v0kR56a3js8tVSJ/80FTzZmMgZbMcBIHC4Horg01B0c=;
        b=MsE7i0ji5nHcBEwN1Ss421RvGRZ/6OaPXKFSHio9yp9FwI2trJU9a0tBQY+kFgZc5k
         ds1lzZHVX1LnLUAt9p4xj9XXWqbsEk+ROXJCoLUC7wbaogAAqdlDfj5c6MX1kMEXsh3l
         PV0PWUpnJ6pFdjQBVr1iusomwXRfmQON2Kbg7KQow1JFH5Pi95lLswGFLzyUMSPz7WDz
         mUJx2N6FEHVI4j4CQHGDV1sBH/PZZyoThVjqdwIQy6ufQWKldUG5gn4B7UQ4c5bYwj87
         yQcqC3tMH0yKUZCitYXDZJURKlmaqKfmUEhkAmxg9SxyGsxEvmz7zMLjrrnOMvoHgkNk
         UQWA==
X-Gm-Message-State: AJIora+L1kSWlOQjpOO1YjZljZruPK2+XFhPViIm4HDR2v2KSS/CZ5sM
        DeN/ssdzG3xcvhcZc2O9esl6/r9KnHHrY+7nLiNp+Q==
X-Google-Smtp-Source: AGRyM1vL+EaPdx915agnP8RGtkdwEKmVIyCaqnwD+c2dfRqzuQVoNAkH4rIjSHdD14nbycbqpt00uWwh6peuqigJjOg=
X-Received: by 2002:a2e:22c6:0:b0:25a:8c16:baf with SMTP id
 i189-20020a2e22c6000000b0025a8c160bafmr6868072lji.132.1656088571108; Fri, 24
 Jun 2022 09:36:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <1dbc14735bbc336c171ef8fefd4aef39ddf95816.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <1dbc14735bbc336c171ef8fefd4aef39ddf95816.1655761627.git.ashish.kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 24 Jun 2022 10:35:59 -0600
Message-ID: <CAMkAt6o7jjZ9baQfTUO-r8+u0doJVqPm=fz88nQwuxh6qpBS_Q@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 47/49] *fix for stale per-cpu pointer due to
 cond_resched during ghcb mapping
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
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
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 20, 2022 at 5:15 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Michael Roth <michael.roth@amd.com>
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Can you add a commit description here? Is this a fix for existing
SEV-ES support or should this be incorporated into a patch in this
series which adds this issue?

> ---
>  arch/x86/kvm/svm/svm.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index fced6ea423ad..f78e3b1bde0e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1352,7 +1352,7 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
>  static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
> -       struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
> +       struct svm_cpu_data *sd;
>
>         if (sev_es_guest(vcpu->kvm))
>                 sev_es_unmap_ghcb(svm);
> @@ -1360,6 +1360,10 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>         if (svm->guest_state_loaded)
>                 return;
>
> +       /* sev_es_unmap_ghcb() can resched, so grab per-cpu pointer afterward. */
> +       barrier();
> +       sd = per_cpu(svm_data, vcpu->cpu);
> +
>         /*
>          * Save additional host state that will be restored on VMEXIT (sev-es)
>          * or subsequent vmload of host save area.
> --
> 2.25.1
>
