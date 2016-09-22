From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH v1 05/28] KVM: SVM: prepare for new bit definition in
 nested_ctl
Date: Thu, 22 Sep 2016 16:17:39 +0200
Message-ID: <20160922141739.zgnj6gadzcdtsyut@pd.tnic>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190827232.9523.18200019204059963746.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: simon.guinot@sequanux.org, linux-efi@vger.kernel.org,
        kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk,
        linus.walleij@linaro.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, hpa@zytor.com,
        dan.j.williams@intel.com, aarcange@redhat.com,
        sfr@canb.auug.org.au, andriy.shevchenko@linux.intel.com,
        herbert@gondor.apana.org.au, bhe@redhat.com, xemul@parallels.com,
        joro@8bytes.org, x86@kernel.org, mingo@redhat.com,
        msalter@redhat.com, ross.zwisler@linux.intel.com,
        dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de,
        keescook@chromium.org, toshi.kani@hpe.com,
        mathieu.desnoyers@efficios.com, devel@linuxdriverproject.org,
        tglx@linutronix.de, mchehab@kernel.org, iamjoonsoo.kim@lge.com,
        labbott@fedoraproject.org, tony.luck@intel.com,
        alexandre.bounine@idt.c
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147190827232.9523.18200019204059963746.stgit@brijesh-build-machine>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 22, 2016 at 07:24:32PM -0400, Brijesh Singh wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Currently the nested_ctl variable in the vmcb_control_area structure is
> used to indicate nested paging support. The nested paging support field
> is actually defined as bit 0 of the this field. In order to support a new
> feature flag the usage of the nested_ctl and nested paging support must
> be converted to operate on a single bit.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/include/asm/svm.h |    2 ++
>  arch/x86/kvm/svm.c         |    7 ++++---
>  2 files changed, 6 insertions(+), 3 deletions(-)

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
