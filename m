Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D89BC43217
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 00:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AD506326B
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 00:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbhKPAfL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 19:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345176AbhKOT1V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 14:27:21 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754E4C09E004
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 10:44:53 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id n26so11213643pff.3
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 10:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YnA5RxswdR0pXIdDfw42jEIDMfa1Anknf8jHYLDLebQ=;
        b=b2wJRkAtOs8VLbM0lZNMe/RxwW3htbsJhf+JSJaqKtTxUt1keDFKRzlcUNWyPRBoxr
         LBU9Tn21V6eNtb8W2Ualydb/xatXcwyrVl137vORscIWpZaHyqhtaJ4PL//nGRBuvlVf
         5Lk0OB2dy54Hh7saCw2v3Mzu3qwwaI2j4DGdC76QW8zGmrexY7HRIYzc4TLXnHc/XzER
         piGaJLzdwxwiNPpaBVCWww3uXt8XWY3x2Qzr69DlQN7DsLjKBaIJfEtq5ll5aehSHh79
         9DNaDrov5aBJp9lHbu2laW/mwNkbPco4mg1trxgMYI0j2IaFvXiSMYscDWB6oXCmZKp4
         AdyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YnA5RxswdR0pXIdDfw42jEIDMfa1Anknf8jHYLDLebQ=;
        b=DUD6Xb8MNX57ya1w5+B97cNVnLJmtgvspuVBmMfaqDTTZawGUOvHkjoZCdsvomIKxg
         nHyQkMmLehjI0BsYKj066Et8dg6c4W7T3MwFIwjrRMj+lue6H8VTV3E8xlO+YyRSAsCN
         9lsTn09goQEEDewohWRSF+xZEmgYmc/ZrVu74ydtuPUc8/UQutYQevGbzfJEje8MowLy
         enNwdlcdLnQc8KR/pqyWc6thkTipreUnQ2JEFD4gFmuY4FSEUaqVAcHnzKKyuhsjnd6v
         a6bQVmO6tvCo3q7JhAQCVbNcWXDFL86mEptBF+IJKEsyl41W0R02ATwf+l6zGSFkYVts
         lCIA==
X-Gm-Message-State: AOAM530z+3Thak+sa88xWhtlrg91bfEcsTRbthu4SO1+H2hKvdkljUix
        hsKU/swEwfbO6VAEe8v7WJRrJA==
X-Google-Smtp-Source: ABdhPJwv65aVu6kpZNGGw0N7gTXRvONlRDhXoyAUv+VgR6kFzqLSM/NP5wts15+VyzsP2RdH5A+iaA==
X-Received: by 2002:a63:33cc:: with SMTP id z195mr669715pgz.339.1637001892769;
        Mon, 15 Nov 2021 10:44:52 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id on6sm72382pjb.47.2021.11.15.10.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 10:44:52 -0800 (PST)
Date:   Mon, 15 Nov 2021 18:44:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZKqoPAoMCqPZymh@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YY7I6sgqIPubTrtA@zn.tnic>
 <YY7Qp8c/gTD1rT86@google.com>
 <f2edf71e-f3b5-f8e3-a75e-e0f811fe6a14@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2edf71e-f3b5-f8e3-a75e-e0f811fe6a14@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 15, 2021, Brijesh Singh wrote:
> 
> On 11/12/21 2:37 PM, Sean Christopherson wrote:
> > This is the direction KVM TDX support is headed, though it's obviously still a WIP.
> > 
> 
> Just curious, in this approach, how do you propose handling the host
> kexec/kdump? If a kexec/kdump occurs while the VM is still active, the new
> kernel will encounter the #PF (RMP violation) because some pages are still
> marked 'private' in the RMP table.

There are two basic options: a) eagerly purge the RMP or b) lazily fixup the RMP
on #PF.  Either approach can be made to work.  I'm not opposed to fixing up the RMP
on #PF in the kexec/kdump case, I'm opposed to blindly updating the RMP on _all_
RMP #PFs, i.e. the kernel should modify the RMP if and only if it knows that doing
so is correct.  E.g. a naive lazy-fixup solution would be to track which pages have
been sanitized and adjust the RMP on #PF to a page that hasn't yet been sanitized.
