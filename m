From: David Howells <dhowells@redhat.com>
Subject: Re: general protection fault in asn1_ber_decoder
Date: Mon, 06 Nov 2017 22:05:45 +0000
Message-ID: <15884.1510005945@warthog.procyon.org.uk>
References: <94eb2c1886e4e1e95e055d54b9ab@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, ebiggers3@gmail.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+04b92812698232d15d78c1e4d3bbf6fcc21eeeb1@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45630 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752769AbdKFWFt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 17:05:49 -0500
In-Reply-To: <94eb2c1886e4e1e95e055d54b9ab@google.com>
Content-ID: <15883.1510005945.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

syzbot <bot+04b92812698232d15d78c1e4d3bbf6fcc21eeeb1@syzkaller.appspotmail.com> wrote:

> syzkaller hit the following crash on 5a3517e009e979f21977d362212b7729c5165d92
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers

Does the attached patch fix it for you?

David
---
commit 41f31a32d918a97dba2ec589d24b52527c8f35b6
Author: David Howells <dhowells@redhat.com>
Date:   Mon Nov 6 21:44:00 2017 +0000

    asn1: Fix handling of zero-length ASN.1 messages
    
    The ASN.1 parser doesn't correctly handle zero-length ASN.1 data.  There
    are at least a couple of ways this can be handled.  The simplest is just to
    reject zero-length messages upfront on the basis that we don't currently
    have a grammar that permits such; a more complex way is to expand all the
    state variables to 32-bit signed so that the:
    
                    if (unlikely(dp >= datalen - 1))
    
    check on line 231 correctly detects underflow when datalen is 0.
    
    For the moment, just choose the simplest option and indicate EBADMSG for a
    zero-length message, with a comment indicating what needs to be done if the
    check is removed
    
    The bug can be reproduced by:
    
            echo -n | keyctl padd pkcs7_test "" @t
    
    The oops resulting from the bug looks like:
    
            BUG: unable to handle kernel NULL pointer dereference at (null)
            IP: asn1_ber_decoder+0xe7/0x5fa
            ...
            RIP: 0010:asn1_ber_decoder+0xe7/0x5fa
            ...
            Call Trace:
             ? pkcs7_parse_message+0x11/0x181
             ? rcu_read_lock_sched_held+0x5f/0x67
             ? kmem_cache_alloc_trace+0x275/0x2b1
             ? pkcs7_parse_message+0x9a/0x181
             pkcs7_parse_message+0xd9/0x181
             ? pkcs7_preparse+0x48/0x48
             verify_pkcs7_signature+0x2c/0x107
             pkcs7_preparse+0x44/0x48
             ? pkcs7_preparse+0x48/0x48
             key_create_or_update+0x160/0x3d5
             SyS_add_key+0x123/0x186
             do_syscall_64+0x8a/0x190
             entry_SYSCALL64_slow_path+0x25/0x25
            ...
    
    with the bug falling on line 233 of asn1_decoder.c:
    
            tag = data[dp++];
    
    Fixes: 42d5ec27f873 ("X.509: Add an ASN.1 decoder")
    Reported-by: syzkaller@googlegroups.com
    Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/lib/asn1_decoder.c b/lib/asn1_decoder.c
index fef5d2e114be..048de2c20ae9 100644
--- a/lib/asn1_decoder.c
+++ b/lib/asn1_decoder.c
@@ -201,6 +201,13 @@ int asn1_ber_decoder(const struct asn1_decoder *decoder,
 	if (datalen > 65535)
 		return -EMSGSIZE;
 
+	/* We don't currently support 0-length messages - the underrun checks
+	 * will fail if datalen is 0 because we check against datalen - 1 with
+	 * unsigned arithmetic.
+	 */
+	if (datalen == 0)
+		return -EBADMSG;
+
 next_op:
 	pr_debug("next_op: pc=\e[32m%zu\e[m/%zu dp=\e[33m%zu\e[m/%zu C=%d J=%d\n",
 		 pc, machlen, dp, datalen, csp, jsp);
