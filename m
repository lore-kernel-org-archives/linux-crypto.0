From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in asn1_ber_decoder
Date: Mon, 6 Nov 2017 10:43:59 -0800
Message-ID: <20171106184359.GC50562@gmail.com>
References: <94eb2c1886e4e1e95e055d54b9ab@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, dhowells@redhat.com,
        herbert@gondor.apana.org.au, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+04b92812698232d15d78c1e4d3bbf6fcc21eeeb1@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94eb2c1886e4e1e95e055d54b9ab@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 06, 2017 at 10:36:00AM -0800, syzbot wrote:
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 3 PID: 2984 Comm: syzkaller229187 Not tainted
> 4.14.0-rc7-next-20171103+ #10
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> task: ffff88003ab66000 task.stack: ffff880039d58000
> RIP: 0010:asn1_ber_decoder+0x41e/0x1af0 lib/asn1_decoder.c:233
> RSP: 0018:ffff880039d5f8d0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffff88006981bf00 RDI: ffffffff853f1920
> RBP: ffff880039d5fb88 R08: 0000000000000060 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: ffff880039d5fb60 R15: dffffc0000000000
> FS:  00000000010ac880(0000) GS:ffff88006df00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020f49ffb CR3: 000000006aeb8000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  pkcs7_parse_message+0x2b3/0x730 crypto/asymmetric_keys/pkcs7_parser.c:139
>  verify_pkcs7_signature+0x8d/0x290 certs/system_keyring.c:216
>  pkcs7_preparse+0x7b/0xc0 crypto/asymmetric_keys/pkcs7_key_type.c:63
>  key_create_or_update+0x533/0x1040 security/keys/key.c:855
>  SYSC_add_key security/keys/keyctl.c:122 [inline]
>  SyS_add_key+0x18a/0x340 security/keys/keyctl.c:62
>  entry_SYSCALL_64_fastpath+0x1f/0xbe
> RIP: 0033:0x434f39
> RSP: 002b:00007fff51fda138 EFLAGS: 00000286 ORIG_RAX: 00000000000000f8
> RAX: ffffffffffffffda RBX: 00000000004002b0 RCX: 0000000000434f39
> RDX: 0000000020000000 RSI: 0000000020f49ffb RDI: 0000000020f4a000
> RBP: 0000000000000086 R08: ffffffffffffffff R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000286 R12: 0000000000000000
> R13: 00000000004018b0 R14: 0000000000401940 R15: 0000000000000000
> Code: 19 ff 48 8d 43 01 49 89 86 80 fe ff ff 48 89 85 a8 fd ff ff 48
> 8b 85 c0 fd ff ff 48 01 d8 48 89 c2 48 89 c1 48 c1 ea 03 83 e1 07
> <42> 0f b6 14 3a 38 ca 7f 08 84 d2 0f 85 cd 0f 00 00 0f b6 00 88
> RIP: asn1_ber_decoder+0x41e/0x1af0 lib/asn1_decoder.c:233 RSP:
> ffff880039d5f8d0

I'll be sending a fix for this.  The bug is an integer underflow in the
expression 'if (unlikely(dp >= datalen - 1))', which causes a NULL pointer
dereference if you try to add a "pkcs7_test" key with an empty payload (requires
CONFIG_PKCS7_TEST_KEY=y).

Eric
