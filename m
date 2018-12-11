Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53163 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbeLKSKk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 13:10:40 -0500
Subject: Re: [PATCH v11 00/13] Intel SGX1 support
To: Josh Triplett <josh@joshtriplett.org>, Pavel Machek <pavel@ucw.cz>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, Alexei Starovoitov <ast@kernel.org>,
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
References: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
 <20180612105011.GA26931@amd> <20180619145943.GC8034@linux.intel.com>
 <20180619200414.GA3143@amd> <20180619214833.GA5873@localhost>
 <20181209200600.GA11608@amd> <20181210074717.GA9880@localhost>
 <20181210082704.GA14594@amd> <20181210231159.GA10718@localhost>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <12301623-0a63-10ac-1d5e-828569a953e5@intel.com>
Date: Tue, 11 Dec 2018 10:10:38 -0800
MIME-Version: 1.0
In-Reply-To: <20181210231159.GA10718@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/10/18 3:12 PM, Josh Triplett wrote:
>> Or maybe even python/shell scripts? It looked to me like virtual
>> memory will be "interesting" for enclaves.
> Memory management doesn't seem that hard to deal with.

The problems are:

1. SGX enclave memory (EPC) is statically allocated at boot and can't
   grow or shrink
2. EPC is much smaller than regular RAM
3. The core VM has no comprehension of EPC use, thus can not help
   with its algorithms, like the LRU
4. The SGX driver implements its own VM which is substantially simpler
   than the core VM, but less feature-rich, fast, or scalable
