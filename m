Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35281C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Apr 2021 18:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E8C2613AA
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Apr 2021 18:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241092AbhDSShy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Apr 2021 14:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241082AbhDSShx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Apr 2021 14:37:53 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05566C061763
        for <linux-crypto@vger.kernel.org>; Mon, 19 Apr 2021 11:37:22 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id w8so20316660pfn.9
        for <linux-crypto@vger.kernel.org>; Mon, 19 Apr 2021 11:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=ai8urSCkfd8KqBe/Z0CzEZXhThfZtSSfYmfTJiDDXZc=;
        b=zOeIYMUtTrpCHXxfvolG7AjkjRi8mAuwUc/OALV7FkrQFMdbVfNyy7eSgA25MEz5+K
         d5St6m/cMFc2EIBcjhdTHIer7dVcDmRH+c6N2ywoofHgJ0cWsX46EDxSKyXeBuNFgKnV
         3yz4ZITALnLrH00D9Jw9m6L8HU4WRTKOJ8xrer1IR+TL9lJmzfMi45iwnzWtN9ppSycx
         DbdpqCRq5/N0G3qowU25pZaotqBOOUHwG3Uj6lCXGM5C058jIgRMMhAM9KtzG4XwHesu
         8Guaw2lW+H/8o8TO/qpmhr0JWgnvdNbLI3cluAsDQs++AoiBMiDJv067toLMNOIhba7j
         LyPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=ai8urSCkfd8KqBe/Z0CzEZXhThfZtSSfYmfTJiDDXZc=;
        b=Zx9C5FIdGumGkE7X1ZWKP93mADJ8gvc2NVWSS/XEPc+13vtZJoyeXRRWKySfE2qS0E
         GGZWCqb0XMN1a6XB9iwN7lCrbt90y2GuHNmufNWKUKDX8JINm26gYw3fXpW1/hJHznY3
         biO5yQRuEI+TvmY0HjVj9mu6pN4PX+yIWGTC4O80548fC0Bl4Z9Su0TvhmldvKCglels
         PhHrAWHZDWz9yWZv69RcgdaFX+u70cQA62uHPpF54ElABuT6Q5OW3wa0kP9Qu8Ex9yh1
         e7DOA7BKuvkbbQT+er7jh43+c9afR2XMt/iyEcLhlDcd5XGxtRuUXW9kP2XBEoLXjIL4
         HM8Q==
X-Gm-Message-State: AOAM532cL7RdBHUuTbpgKEPU8FB412RCHdI2wLjaFJJ9Dt/OF0A6Xa0B
        hOs2A9CJFvQTMd3/qMmPcopFxw==
X-Google-Smtp-Source: ABdhPJyVPfwWQ7xSRvyhvtGFAW9QR1YAvPZxOUssTc/7vRuqSzrMjl5dow9HECjNRpqslNdP9Ci/0g==
X-Received: by 2002:a63:28c2:: with SMTP id o185mr13092135pgo.40.1618857442475;
        Mon, 19 Apr 2021 11:37:22 -0700 (PDT)
Received: from ?IPv6:2600:1010:b018:f7a3:b93c:afa3:79ad:4736? ([2600:1010:b018:f7a3:b93c:afa3:79ad:4736])
        by smtp.gmail.com with ESMTPSA id 144sm8053271pfc.101.2021.04.19.11.37.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 11:37:21 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC Part2 PATCH 04/30] x86/mm: split the physmap when adding the page in RMP table
Date:   Mon, 19 Apr 2021 11:37:19 -0700
Message-Id: <D67BDFB6-84AA-4CA3-A951-7EEE0E4B4B26@amacapital.net>
References: <535400b4-0593-a7ca-1548-532ee1fefbd7@intel.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak@linux.intel.com, herbert@gondor.apana.org.au,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <535400b4-0593-a7ca-1548-532ee1fefbd7@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
X-Mailer: iPhone Mail (18D70)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On Apr 19, 2021, at 11:33 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> =EF=BB=BFOn 4/19/21 11:10 AM, Andy Lutomirski wrote:
>> I=E2=80=99m confused by this scenario. This should only affect physical p=
ages
>> that are in the 2M area that contains guest memory. But, if we have a
>> 2M direct map PMD entry that contains kernel data and guest private
>> memory, we=E2=80=99re already in a situation in which the kernel touching=

>> that memory would machine check, right?
>=20
> Not machine check, but page fault.  Do machine checks even play a
> special role in SEV-SNP?  I thought that was only TDX?

Brain fart.

>=20
> My point was just that you can't _easily_ do the 2M->4k kernel mapping
> demotion in a page fault handler, like I think Borislav was suggesting.

We are certainly toast if this hits the stack.  Or if it hits a page table o=
r the GDT or IDT :). The latter delightful choices would be triple faults.

I sure hope the code we use to split a mapping is properly NMI safe.

>=20
>> ISTM we should fully unmap any guest private page from the kernel and
>> all host user pagetables before actually making it be a guest private
>> page.
>=20
> Yes, that sounds attractive.  Then, we'd actually know if the host
> kernel was doing stray reads somehow because we'd get a fault there too.


