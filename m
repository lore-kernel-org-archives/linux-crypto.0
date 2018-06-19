From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v11 00/13] Intel SGX1 support
Date: Tue, 19 Jun 2018 22:23:36 +0200
Message-ID: <20180619202336.GU2458@hirez.programming.kicks-ass.net>
References: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
 <20180612105011.GA26931@amd>
 <20180619145943.GC8034@linux.intel.com>
 <20180619200414.GA3143@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, dave.hansen@intel.com,
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
        Konrad Rzeszutek Wilk <konrad.wi
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180619200414.GA3143@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 19, 2018 at 10:04:15PM +0200, Pavel Machek wrote:
> What are some non-evil uses for SGX?

Soft-TPM is one that was proposed at some time.
