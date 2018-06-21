From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v11 00/13] Intel SGX1 support
Date: Thu, 21 Jun 2018 14:55:11 +0200
Message-ID: <20180621125511.GA4287@gmail.com>
References: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
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
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:INTEL SGX" <intel-sgx-kernel-dev@lists.01.org>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)"
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


* Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:

>  create mode 100644 drivers/platform/x86/intel_sgx/Kconfig
>  create mode 100644 drivers/platform/x86/intel_sgx/Makefile
>  create mode 100644 drivers/platform/x86/intel_sgx/le/Makefile
>  create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/Makefile
>  create mode 120000 drivers/platform/x86/intel_sgx/le/enclave/aesni-intel_asm.S
>  create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/cmac_mode.c
>  create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/cmac_mode.h
>  create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/encl_bootstrap.S
>  create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/main.c
>  create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/main.h
>  create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/sgx_le.lds
>  create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/sgxsign.c
>  create mode 120000 drivers/platform/x86/intel_sgx/le/enclave/string.c
>  create mode 100644 drivers/platform/x86/intel_sgx/le/entry.S
>  create mode 100644 drivers/platform/x86/intel_sgx/le/include/sgx_asm.h
>  create mode 100644 drivers/platform/x86/intel_sgx/le/main.c
>  create mode 100644 drivers/platform/x86/intel_sgx/le/main.h
>  create mode 100644 drivers/platform/x86/intel_sgx/le/sgx_le_piggy.S
>  create mode 100644 drivers/platform/x86/intel_sgx/le/string.c
>  create mode 100644 drivers/platform/x86/intel_sgx/sgx.h
>  create mode 100644 drivers/platform/x86/intel_sgx/sgx_encl.c
>  create mode 100644 drivers/platform/x86/intel_sgx/sgx_encl_page.c
>  create mode 100644 drivers/platform/x86/intel_sgx/sgx_fault.c
>  create mode 100644 drivers/platform/x86/intel_sgx/sgx_ioctl.c
>  create mode 100644 drivers/platform/x86/intel_sgx/sgx_le.c
>  create mode 100644 drivers/platform/x86/intel_sgx/sgx_le_proxy_piggy.S
>  create mode 100644 drivers/platform/x86/intel_sgx/sgx_main.c
>  create mode 100644 drivers/platform/x86/intel_sgx/sgx_vma.c

Just some quick feedback: these are core kernel functionality and should be in 
arch/x86/, not in drivers/platform/.

Thanks,

	Ingo
