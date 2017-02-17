From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 08/10] x86: assembly, annotate aliases
Date: Fri, 17 Feb 2017 12:52:30 +0100
Message-ID: <2d17929a-c0d0-319e-f432-bac8d98aea2a@suse.com>
References: <20170217104757.28588-1-jslaby@suse.cz>
 <20170217104757.28588-8-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        jpoimboe@redhat.com, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-crypto@vger.kernel.org, xen-devel@lists.xenproject.org
To: Jiri Slaby <jslaby@suse.cz>, mingo@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933780AbdBQLwf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Feb 2017 06:52:35 -0500
In-Reply-To: <20170217104757.28588-8-jslaby@suse.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 17/02/17 11:47, Jiri Slaby wrote:
> _key_expansion_128 is an alias to _key_expansion_256a, __memcpy to
> memcpy, xen_syscall32_target to xen_sysenter_target, and so on. Annotate
> them all using the new ENTRY_ALIAS and ENTRY_LOCAL_ALIAS. This will make
> the tools generating the debuginfo happy.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: <x86@kernel.org>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: <linux-crypto@vger.kernel.org>
> Cc: <xen-devel@lists.xenproject.org>
> ---
>  arch/x86/crypto/aesni-intel_asm.S | 5 ++---
>  arch/x86/lib/memcpy_64.S          | 4 ++--
>  arch/x86/lib/memmove_64.S         | 4 ++--
>  arch/x86/lib/memset_64.S          | 4 ++--
>  arch/x86/xen/xen-asm_64.S         | 4 ++--
>  5 files changed, 10 insertions(+), 11 deletions(-)

Xen parts:

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
