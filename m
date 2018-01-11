From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: kernel failure while loading X.509 certificate
Date: Thu, 11 Jan 2018 23:37:38 +0100
Message-ID: <CAK8P3a1E6YOXK2heCz0eiaQLpzpb6jjnvyNK_Y4Fu8bjZuPDZw@mail.gmail.com>
References: <F5505112-180F-4889-A73E-D0AB9054E58E@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        David Howells <dhowells@redhat.com>,
        crypto <linux-crypto@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
To: Paolo Valente <paolo.valente@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:38860 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933175AbeAKWhk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 17:37:40 -0500
Received: by mail-oi0-f47.google.com with SMTP id m65so2750440oig.5
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2018 14:37:40 -0800 (PST)
In-Reply-To: <F5505112-180F-4889-A73E-D0AB9054E58E@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 11, 2018 at 7:29 PM, Paolo Valente <paolo.valente@linaro.org> wrote:
> Hi guys,
> this is a help request, for a problem that has been driving me crazy
> all day long, without any success :(
>
> I've compiled a 4.15-rc7 custom kernel on a freshly-installed Fedora
> 27, using the usual "make ; make modules_install ; make install"
> procedure. No error reported while building.  But at boot the
> kernel immediately fails as follows, apparently while loading/parsing
> an X.509 certificate:

The BUG_ON() you hit is this one in public_key_verify_signature():

        BUG_ON(!sig->digest);

There was a patch series by Eric Biggers that touched these files to
add some fixes
after v4.15-rc1.  I'm not runnig that code myself, but it sounds like
a real regression,
so I'm adding Eric (to look at the code), the corresponding mailing
list and Thorsten
(for regression tracking) to Cc.

x509_cert_parse() allocates the 'cert->sig' structure, and calls
x509_get_sig_params(),
which may or may not allocate a digest. It returns with
cert->unsupported_sig=true
in case it fails to allocate a digest for some reason (crypto_alloc_shash failed
or no sig->hash_algo).

The full set of Eric's patches is

54c1fb39fe04 X.509: fix comparisons of ->pkey_algo
18026d866801 KEYS: reject NULL restriction string when type is specified
3d1f0255426a security: keys: remove redundant assignment to key_ref
aa3300362060 X.509: use crypto_shash_digest()
72f9a07b6bfa KEYS: be careful with error codes in public_key_verify_signature()
a80745a6de51 pkcs7: use crypto_shash_digest()
7204eb8590c7 pkcs7: fix check for self-signed certificate
8ecb506d3476 pkcs7: return correct error code if pkcs7_check_authattrs() fails
8dfd2f22d3bf 509: fix printing uninitialized stack memory when OID is empty
47e0a208fb9d X.509: fix buffer overflow detection in sprint_oid()
0f30cbea005b X.509: reject invalid BIT STRING for subjectPublicKey
81a7be2cd69b ASN.1: check for error from ASN1_OP_END__ACT actions
e0058f3a874e ASN.1: fix out-of-bounds read when parsing indefinite length item
4dca6ea1d943 KEYS: add missing permission check for request_key() destination
a2d8737d5c78 KEYS: remove unnecessary get/put of explicit dest_keyring

and it's based on -rc2. If you want to do a quicker bisection, I'd
suggest you try
4.15-rc2 and 54c1fb39fe04 to start with.

> ...
> [    2.078978] Loading compiled-in X.509 certificates
> [    2.080890] ------------[ cut here ]------------
> [    2.081240] kernel BUG at /mnt/linux-dev/linux/crypto/asymmetric_keys/public_key.c:82!
> [    2.081808] invalid opcode: 0000 [#1] SMP PTI
> [    2.082105] Modules linked in:
> [    2.082333] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.15.0-bfq-mq-rc7+ #6
> [    2.082851] Hardware name: Parallels Software International Inc. Parallels Virtual Platform/Parallels Virtual Platform, BIOS 1.3.0 (19714) 12/15/2017
> [    2.083778] RIP: 0010:public_key_verify_signature+0x2cc/0x300
> [    2.084178] RSP: 0018:ffffba42c0327b50 EFLAGS: 00010246
> [    2.084549] RAX: 0000000000000000 RBX: ffff9887f4ed00c0 RCX: 0000000000000000
> [    2.085045] RDX: ffff9887f4e9d1b6 RSI: ffff9887f4e9c780 RDI: ffff9887f4e9dc60
> [    2.085544] RBP: ffff9887f4e9c780 R08: 0000000000000001 R09: 697542230c030455
> [    2.086036] R10: 656e65676f747561 R11: 20656d697420646c R12: ffff9887f4e9dc60
> [    2.086534] R13: ffffffff908a5f78 R14: 0000000000000542 R15: 0000000000000542
> [    2.087036] FS:  0000000000000000(0000) GS:ffff98883ce40000(0000) knlGS:0000000000000000
> [    2.087591] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.087989] CR2: 00007fc579bc1000 CR3: 000000005020a003 CR4: 00000000001606e0
> [    2.088488] Call Trace:
> [    2.088668]  ? cryptomgr_notify+0xe7/0x4f0
> [    2.088956]  ? asymmetric_key_generate_id+0x2f/0x70
> [    2.089365]  ? crypto_larval_lookup+0x20/0x20
> [    2.089672]  ? __slab_alloc+0x1c/0x30
> [    2.089931]  ? __kmalloc+0x1ae/0x210
> [    2.090187]  ? asymmetric_key_generate_id+0x2f/0x70
> [    2.090532]  x509_check_for_self_signed+0x8f/0xe0
> [    2.090862]  x509_cert_parse+0x16f/0x1c0
> [    2.091149]  x509_key_preparse+0x23/0x1d0
> [    2.091450]  asymmetric_key_preparse+0x57/0xc0
> [    2.091764]  key_create_or_update+0x143/0x430
> [    2.092071]  load_system_certificate_list+0x8f/0xea
> [    2.092424]  ? context_tracking_cpu_set+0x57/0x57
> [    2.092764]  ? set_debug_rodata+0x11/0x11
> [    2.093047]  do_one_initcall+0x4b/0x190
> [    2.093326]  kernel_init_freeable+0x19b/0x23c
> [    2.093688]  ? rest_init+0xb0/0xb0
> [    2.094038]  kernel_init+0xa/0xfc
> [    2.094431]  ret_from_fork+0x1f/0x30
> [    2.094797] Code: ff ff 0f ff b8 ea ff ff ff e9 13 ff ff ff 4c 89 f7 e8 89 3c 4a 00 c7 44 24 48 00 00 00 00 8b 44 24 68 e9 c0 fe ff ff 0f 0b 0f 0b <0f> 0b 0f 0b 48 89 ee 48 89 ef e8 b5 80 fd ff b8 f4 ff ff ff e9
> [    2.096692] RIP: public_key_verify_signature+0x2cc/0x300 RSP: ffffba42c0327b50
> [    2.097475] ---[ end trace 6ad74f81d3fa3473 ]---
> [    2.097916] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> [    2.097916]
> [    2.099011] Kernel Offset: 0xe000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [    2.100385] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
>
> I've tried even using the config of the latest stock-kernel available
> for the distro (a 4.14), without any streamlining.  Same result.  I
> didn't find anything useful on the WEB either.
>
> Did something like this happen to any of you too?
>
> Thanks,
> Paolo
>
