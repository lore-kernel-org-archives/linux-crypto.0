From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC PATCH v1 02/28] kvm: svm: Add kvm_fast_pio_in support
Date: Wed, 21 Sep 2016 12:58:57 +0200
Message-ID: <20160921105857.p4euktwugt7evj77@pd.tnic>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190823395.9523.16184607551630730040.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: simon.guinot-jKBdWWKqtFpg9hUCZPvPmw@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org,
        linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
        paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org,
        dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org,
        herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org,
        joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org,
        dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, jroedel-l3A5Bk7waGM@public.gmane.org,
        keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, toshi.kani-ZPxbGqLxI0U@public.gmane.org,
        mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org,
        tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org,
        labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
        alexandre.bounine@idt.c
To: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <147190823395.9523.16184607551630730040.stgit@brijesh-build-machine>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 22, 2016 at 07:23:54PM -0400, Brijesh Singh wrote:
> From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> 
> Update the I/O interception support to add the kvm_fast_pio_in function
> to speed up the in instruction similar to the out instruction.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> ---
>  arch/x86/include/asm/kvm_host.h |    1 +
>  arch/x86/kvm/svm.c              |    5 +++--
>  arch/x86/kvm/x86.c              |   43 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 47 insertions(+), 2 deletions(-)

FWIW: Reviewed-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
