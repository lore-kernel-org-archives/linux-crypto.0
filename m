Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBBB1C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Oct 2022 18:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJCSB5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Oct 2022 14:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiJCSBh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Oct 2022 14:01:37 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA482BB33
        for <linux-crypto@vger.kernel.org>; Mon,  3 Oct 2022 11:01:33 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id b6so12663991ljr.10
        for <linux-crypto@vger.kernel.org>; Mon, 03 Oct 2022 11:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=D28XvKTv00teVfLwfyN9M9/AZIufFU4k2cieAlFfcPU=;
        b=JcyhKWsgCnYxPgaWsHHffDyudEL3s19lLgvoma891PS50XIYA8Q1I6Qj3806CkR5QX
         fSv8It+f/TW2tXXqcCUQ7TxUSYPfNe8+8N5Bj5S3UXuze44v1O8BJzpkS9mkbdteBiLu
         aSCE7q78XIVq8PxbqWk0bKpBWA0yNOZiKA/lI6N+FCmHJ9T8cfW4lEp5wGbUSjfKOI0Z
         a2+5EY+hoxySnbW4SBcjwLdCvMZ1G/HCykEqo8Q8PbJIArj9FtV/AUEo1kHH5moRUZB/
         VbN4atttazrqqWo+h0VQpAPKpxkf81kdlYojEVeANjKaqxtJl1x3ykgLW3zO2w5Y+IW4
         Q1aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=D28XvKTv00teVfLwfyN9M9/AZIufFU4k2cieAlFfcPU=;
        b=SvFHN3jeEvO2oJz5EcyBqzHOWj9M1jLmn37Onk3VRwF+KpLU5LtMJavvpHD8LnLl5f
         vYoqvd9JdFH5n3KIvdpS9+k0GR1HWE3XAwuTmBHBlIr1INJZJxGa6y2AlwfFb2W9IkI/
         C4UQr7tTD33QexMRYIu1+7btr+VmzKqOiL6QBSmXGzVOY6a2FdKkslKDRbNzZYcHY7xI
         3yMGlVqszxjc/crP8SO9/SQFGeBbc8hYZaK3JPH30fp/F/84tpKTR/K5tNIWkDb4SVUi
         bqsI99ESU0ss2ceL68YpamqweNpsIqPs1O4r2lK3wGWWogfixFsxdcZXAXrNUMresdoR
         +Rgw==
X-Gm-Message-State: ACrzQf0CqH96dYMpnO4y6rXEyzSZ+7f4nZ2DBZmvy757oErzOAZxtPLa
        +cBbeVQbMrs76VGb91/c2G/IGyS4SmF0HZOFhQW3lw==
X-Google-Smtp-Source: AMsMyM5M6uuSJYdYJkQ0du2kR5gu7HOYyUAaIPU4am61T5nEJo87sAVKGohiuCMu/kOpo2mdhzNUGNGB7bAsVkCoVdc=
X-Received: by 2002:a05:651c:1510:b0:26d:cd1d:cc4d with SMTP id
 e16-20020a05651c151000b0026dcd1dcc4dmr3496274ljf.502.1664820091240; Mon, 03
 Oct 2022 11:01:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <a63de5e687c530849312099ee02007089b67e92f.1655761627.git.ashish.kalra@amd.com>
 <YzigaOHddWU706H5@zn.tnic> <SN6PR12MB2767062CAD241C0BAFB7FAD98E5B9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YzsK+szsWoAlMsrR@zn.tnic> <SN6PR12MB276753083B811B1055FDE6408E5B9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YzsfroL1/6D8rVTF@zn.tnic>
In-Reply-To: <YzsfroL1/6D8rVTF@zn.tnic>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 3 Oct 2022 12:01:19 -0600
Message-ID: <CAMkAt6pnqWWA8pc6uY5g1o076VLgjy1K1ZagDOgcuQfh=hnf3Q@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 13/49] crypto:ccp: Provide APIs to issue SEV-SNP commands
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 3, 2022 at 11:45 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Mon, Oct 03, 2022 at 05:11:05PM +0000, Kalra, Ashish wrote:
> > They are basically providing the APIs for the hypervisor to manage a
> > SNP guest.
>
> Yes, I know. But that is not my question. Lemme try again.
>
> My previous comment was:
>
> "I think you should simply export sev_do_cmd() and call it instead."
>
> In this case, the API is a single function - sev_do_cmd() - which the
> hypervisor calls.
>
> So my question still stands: why is it better to have silly wrappers
> of sev_do_cmd() instead of having the hypervisor call sev_do_cmd()
> directly?

We already have sev_issue_cmd_external_user() exported right?

Another option could be to make these wrappers more helpful and less
silly. For example callers need to know the PSP command format right
now, see  sev_guest_decommission().

int sev_guest_decommission(struct sev_data_decommission *data, int *error)

Instead of taking @data this function could just take inputs to create
sev_data_decommission:

int sev_guest_decommission(u32 handle, int *error)
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
