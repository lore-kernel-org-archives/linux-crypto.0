Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03394C5CFFE
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Dec 2018 18:31:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDCC320851
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Dec 2018 18:31:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDCC320851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbeLKSbD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Dec 2018 13:31:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:10758 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbeLKSbC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 13:31:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2018 10:31:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,343,1539673200"; 
   d="scan'208";a="100721643"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga008.jf.intel.com with ESMTP; 11 Dec 2018 10:31:01 -0800
Date:   Tue, 11 Dec 2018 10:31:01 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Josh Triplett <josh@joshtriplett.org>, Pavel Machek <pavel@ucw.cz>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        x86@kernel.org, platform-driver-x86@vger.kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com,
        Alexei Starovoitov <ast@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "open list:INTEL SGX" <intel-sgx-kernel-dev@lists.01.org>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:SPARSE CHECKER" <linux-sparse@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>
Subject: Re: [PATCH v11 00/13] Intel SGX1 support
Message-ID: <20181211183101.GE14731@linux.intel.com>
References: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
 <20180612105011.GA26931@amd>
 <20180619145943.GC8034@linux.intel.com>
 <20180619200414.GA3143@amd>
 <20180619214833.GA5873@localhost>
 <20181209200600.GA11608@amd>
 <20181210074717.GA9880@localhost>
 <20181210082704.GA14594@amd>
 <20181210231159.GA10718@localhost>
 <12301623-0a63-10ac-1d5e-828569a953e5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <12301623-0a63-10ac-1d5e-828569a953e5@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181211183101.7zIIcFNMNeW-HrnHY3Ld5sDDPGDx1HgVdiX9nYBVOMA@z>

On Tue, Dec 11, 2018 at 10:10:38AM -0800, Dave Hansen wrote:
> On 12/10/18 3:12 PM, Josh Triplett wrote:
> >> Or maybe even python/shell scripts? It looked to me like virtual
> >> memory will be "interesting" for enclaves.
> > Memory management doesn't seem that hard to deal with.
> 
> The problems are:
> 
> 1. SGX enclave memory (EPC) is statically allocated at boot and can't
>    grow or shrink
> 2. EPC is much smaller than regular RAM
> 3. The core VM has no comprehension of EPC use, thus can not help
>    with its algorithms, like the LRU
> 4. The SGX driver implements its own VM which is substantially simpler
>    than the core VM, but less feature-rich, fast, or scalable

I'd also add:

  5. Swapping EPC pages can only be done through SGX specific ISA that
     has strict concurrency requirements and enforces TLB flushing.
  6. There are specialized types of EPC pages that have different
     swapping requirements than regular EPC pages.
  7. EPC pages that are exposed to a KVM guest have yet another set of
     swapping requirements.

In other words, extending the core VM to SGX EPC is painfully difficult.
