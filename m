From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: ccp: add check to get PSP master only when
 PSP is detected
Date: Sat, 3 Mar 2018 00:43:43 +0800
Message-ID: <20180302164343.GA21906@gondor.apana.org.au>
References: <20180221144139.4989-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, paulian@marinca.net,
        brijesh.singh@amd.com, bp@suse.de, thomas.lendacky@amd.com,
        gary.hook@amd.com, linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180221144139.4989-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Brijesh Singh <brijesh.singh@amd.com> wrote:
> Paulian reported the below kernel crash on Ryzen 5 system:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000073
> RIP: 0010:.LC0+0x41f/0xa00
> RSP: 0018:ffffa9968003bdd0 EFLAGS: 00010002
> RAX: ffffffffb113b130 RBX: 0000000000000000 RCX: 00000000000005a7
> RDX: 00000000000000ff RSI: ffff8b46dee651a0 RDI: ffffffffb1bd617c
> RBP: 0000000000000246 R08: 00000000000251a0 R09: 0000000000000000
> R10: ffffd81f11a38200 R11: ffff8b52e8e0a161 R12: ffffffffb19db220
> R13: 0000000000000007 R14: ffffffffb17e4888 R15: 5dccd7affc30a31e
> FS:  0000000000000000(0000) GS:ffff8b46dee40000(0000) knlGS:0000000000000000
> CR2: 0000000000000073 CR3: 000080128120a000 CR4: 00000000003406e0
> Call Trace:
> ? sp_get_psp_master_device+0x56/0x80
> ? map_properties+0x540/0x540
> ? psp_pci_init+0x20/0xe0
> ? map_properties+0x540/0x540
> ? sp_mod_init+0x16/0x1a
> ? do_one_initcall+0x4b/0x190
> ? kernel_init_freeable+0x19b/0x23c
> ? rest_init+0xb0/0xb0
> ? kernel_init+0xa/0x100
> ? ret_from_fork+0x22/0x40
> 
> Since Ryzen does not support PSP/SEV firmware hence i->psp_data will
> NULL in all sp instances. In those cases, 'i' will point to the
> list head after list_for_each_entry(). Dereferencing the head will
> cause kernel crash.
> 
> Add check to call get master device only when PSP/SEV is detected.
> 
> Reported-by: Paulian Bogdan Marinca <paulian@marinca.net>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> CC: Gary R Hook <gary.hook@amd.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
> 
> Changes since v1:
> 
> v1 contained a local change I used for triggering the crash on EPYC system.
> we do not need those changes in final patch.

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
