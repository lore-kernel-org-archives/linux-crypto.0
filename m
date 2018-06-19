From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v11 00/13] Intel SGX1 support
Date: Tue, 19 Jun 2018 17:59:43 +0300
Message-ID: <20180619145943.GC8034@linux.intel.com>
References: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
 <20180612105011.GA26931@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: x86@kernel.org, platform-driver-x86@vger.kernel.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
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
        "open list:KERNEL VIRTUAL M
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180612105011.GA26931@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 12, 2018 at 12:50:12PM +0200, Pavel Machek wrote:
> On Fri 2018-06-08 19:09:35, Jarkko Sakkinen wrote:
> > Intel(R) SGX is a set of CPU instructions that can be used by applications
> > to set aside private regions of code and data. The code outside the enclave
> > is disallowed to access the memory inside the enclave by the CPU access
> > control.  In a way you can think that SGX provides inverted sandbox. It
> > protects the application from a malicious host.
> 
> Do you intend to allow non-root applications to use SGX?
> 
> What are non-evil uses for SGX?
> 
> ...because it is quite useful for some kinds of evil:

The default permissions for the device are 600.

/Jarkko
