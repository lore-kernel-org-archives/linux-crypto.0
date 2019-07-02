Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93389C5B57D
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 00:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BA47218A5
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 00:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562114286;
	bh=Ed+V3TIIDTnClTbpLgAqUanLKLZrzlND7+0lmgD7UgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hwbjbq3jvpCm9YQ/IXZHkB1JvaqVJ3ZCmif8H6GhI2RDN62DyaUn4KYRUE2pc3jSj
	 ISxD9vmwY2uf1UxIMC/7x4sVbuVhEL7kAX7/W6mxiecghCuz/GB8tkt60Yuet4/qIb
	 aSpSpnV9+Yiu4wi7GC4B4CstkE/fTvsQwgAUxY8U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfGCAiF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 20:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbfGCAiF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 20:38:05 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D91B1218DA;
        Tue,  2 Jul 2019 22:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562105482;
        bh=Ed+V3TIIDTnClTbpLgAqUanLKLZrzlND7+0lmgD7UgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e75unzzTApuKpibxObNNHHIsTXMa08GNS/B+cyulbwsFQJ6iLSW3y16ZHdoB2liii
         eYtJE7ZhJYo3YzU7UfiArfiCW0m5kd8Vr5xqDP2Undo7YVTViWbsv0DNsh5TxCismo
         OAW1acBAxLzKrIV1CwF6uPQb8t6kpCv8sU5IOMmg=
Date:   Tue, 2 Jul 2019 15:11:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
Cc:     linux-crypto@vger.kernel.org, chetjain@in.ibm.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: algapi - guard against uninitialized spawn list
 in crypto_remove_spawns
Message-ID: <20190702221119.GB69157@gmail.com>
References: <20190625071624.27039-1-msuchanek@suse.de>
 <20190625164052.GA81914@gmail.com>
 <20190701153154.1569c2dc@kitsune.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190701153154.1569c2dc@kitsune.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 01, 2019 at 03:31:54PM +0200, Michal Suchánek wrote:
> On Tue, 25 Jun 2019 09:40:54 -0700
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > Hi Michal,
> > 
> > On Tue, Jun 25, 2019 at 09:16:24AM +0200, Michal Suchanek wrote:
> > > Reportedly on Linux 4.12 the LTP testsuite crashes at pcrypt_aead01 infrequently.
> > > 
> > > To get it reproduce more frequently I tried
> > > 
> > > n=0 ; while true ; do /opt/ltp/testcases/bin/pcrypt_aead01 >& /dev/null ; n=$(expr $n + 1) ; echo -ne $n\\r ; done
> > > 
> > > but this is quite stable. However, holding ^C in the terminal where the loop is running tends to trigger the crash.
> > > 
> 
> > > 
> > > The code looks like this:
> > > 
> > >    0xc000000000520e10 <+0>:     c8 00 4c 3c     addis   r2,r12,200
> > >    0xc000000000520e14 <+4>:     f0 9b 42 38     addi    r2,r2,-25616
> > >    0xc000000000520e18 <+8>:     a6 02 08 7c     mflr    r0
> > >    0xc000000000520e1c <+12>:    00 00 00 60     nop
> > >    0xc000000000520e20 <+16>:    79 2b ab 7c     mr.     r11,r5
> > >    0xc000000000520e24 <+20>:    f0 ff c1 fb     std     r30,-16(r1)
> > >    0xc000000000520e28 <+24>:    e8 ff a1 fb     std     r29,-24(r1)
> > >    0xc000000000520e2c <+28>:    f8 ff e1 fb     std     r31,-8(r1)
> > >    0xc000000000520e30 <+32>:    91 ff 21 f8     stdu    r1,-112(r1)
> > >    0xc000000000520e34 <+36>:    78 1b 69 7c     mr      r9,r3
> > >    0xc000000000520e38 <+40>:    78 23 9e 7c     mr      r30,r4
> > >    0xc000000000520e3c <+44>:    08 00 82 41     beq     0xc000000000520e44 <crypto_remove_spawns+52>
> > >    0xc000000000520e40 <+48>:    78 5b 69 7d     mr      r9,r11
> > >    0xc000000000520e44 <+52>:    40 00 e1 3b     addi    r31,r1,64
> > >    0xc000000000520e48 <+56>:    30 00 c1 38     addi    r6,r1,48
> > >  # 0xc000000000520e4c <+60>:    10 00 43 e9     ld      r10,16(r3)
> > >    0xc000000000520e50 <+64>:    20 00 a9 83     lwz     r29,32(r9)
> > >    0xc000000000520e54 <+68>:    20 00 a1 38     addi    r5,r1,32
> > >    0xc000000000520e58 <+72>:    40 00 e1 fb     std     r31,64(r1)
> > >    0xc000000000520e5c <+76>:    48 00 e1 fb     std     r31,72(r1)
> > >    0xc000000000520e60 <+80>:    30 00 c1 f8     std     r6,48(r1)
> > >    0xc000000000520e64 <+84>:    38 00 c1 f8     std     r6,56(r1)
> > >    0xc000000000520e68 <+88>:    20 00 a1 f8     std     r5,32(r1)
> > >    0xc000000000520e6c <+92>:    28 00 a1 f8     std     r5,40(r1)
> > >    0xc000000000520e70 <+96>:    10 00 03 38     addi    r0,r3,16
> > >  & 0xc000000000520e74 <+100>:   40 50 a0 7f     cmpld   cr7,r0,r10
> > >    0xc000000000520e78 <+104>:   78 53 47 7d     mr      r7,r10
> > >  * 0xc000000000520e7c <+108>:   00 00 0a e9     ld      r8,0(r10)
> > >    0xc000000000520e80 <+112>:   64 00 9e 41     beq     cr7,0xc000000000520ee4 <crypto_remove_spawns+212>
> > > 
> > >  #) This looks like alg->cra_users.next is loaded to r10
> > >  &) This looks like r10 is compared with &alg->cra_users calculated on the line
> > >     above to terminate the loop
> > >  *) This looks like *alg->cra_users.next loaded into r8 which causes the null
> > >     pointer dereference
> > > 
> > > So the fixup needs to be applied to the first dereference of
> > > alg->cra_users.next as well to prevent crash.
> > > 
> > > Fixes: 9a00674213a3 ("crypto: algapi - fix NULL dereference in crypto_remove_spawns()")
> > > 
> > > Reported-by: chetjain@in.ibm.com
> 
> > 
> > The stack trace shows that crypto_remove_spawns() is being called from
> > crypto_unregister_instance().  Therefore, the instance should already be
> > registered and have initialized cra_users.  Now, I don't claim to understand the
> > spawn lists stuff that well, so I could have missed something; but if there *is*
> > a bug, I'd like to see a proper explanation.
> > 
> > Did you check whether this is actually reproducible on mainline, and not just
> > the SUSE v4.12 based kernel?
> 
> This is the crash with mainline:
> 
> BUG: Kernel NULL pointer dereference at 0x00000000
> Faulting instruction address: 0xc0000000005bb280
> Oops: Kernel access of bad area, sig: 11 [#1]
> LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
> Modules linked in: authenc pcrypt crypto_user kvm_pr kvm ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables af_packet ibmveth(xX) vmx_crypto rtc_generic gf128mul btrfs libcrc32c xor zstd_decompress(nN) zstd_compress(nN) raid6_pq sd_mod sg dm_multipath dm_mod ibmvscsi(xX) scsi_dh_rdac scsi_dh_emc scsi_transport_srp scsi_dh_alua crc32c_vpmsum scsi_mod autofs4
> Supported: No, Unreleased kernel
> CPU: 6 PID: 24816 Comm: pcrypt_aead01 Kdump: loaded Tainted: G                  5.2.0-rc6-11.g9d2be15-default #1 SLE15 (unreleased)
> NIP:  c0000000005bb280 LR: c0000000005bc108 CTR: c0000000005bc0b0
> REGS: c0000005b574b590 TRAP: 0300   Tainted: G                   (5.2.0-rc6-11.g9d2be15-default)
> MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 44002840  XER: 20040000
> CFAR: c00000000000e244 DAR: 0000000000000000 DSISR: 40000000 IRQMASK: 0
> GPR00: c0000000005bc108 c0000005b574b820 c000000001406900 c0000005b2eabc00
> GPR04: c0000005b574b8b0 0000000000000000 c0000005b574b850 0000000000000000
> GPR08: 0000000000000000 c0000005b2eabc00 ffffffff00000001 c0000005b574b860
> GPR12: c0000005b2eabc10 c000000007fa7800 0000000131b90ee0 00007fffc975b748
> GPR16: 0000000131bb2d80 0000000131bb2d88 00007fffc975b5e0 00007fffc975b5d4
> GPR20: 00007fffc975b628 00007fffc975b5f0 0000000000000010 0000000000000000
> GPR24: 0000000000000000 0000000000000000 fffffffffffff000 0000000000000000
> GPR28: c0000005b574b8b0 0000000000000cb3 c0000000013366f8 c0000005b574b840
> CFAR: c00000000000e244 DAR: 0000000000000000 DSISR: 40000000 IRQMASK: 0
> GPR00: c0000000005bc108 c0000005b574b820 c000000001406900 c0000005b2eabc00
> GPR04: c0000005b574b8b0 0000000000000000 c0000005b574b850 0000000000000000
> GPR08: 0000000000000000 c0000005b2eabc00 ffffffff00000001 c0000005b574b860
> GPR12: c0000005b2eabc10 c000000007fa7800 0000000131b90ee0 00007fffc975b748
> GPR16: 0000000131bb2d80 0000000131bb2d88 00007fffc975b5e0 00007fffc975b5d4
> GPR20: 00007fffc975b628 00007fffc975b5f0 0000000000000010 0000000000000000
> GPR24: 0000000000000000 0000000000000000 fffffffffffff000 0000000000000000
> GPR28: c0000005b574b8b0 0000000000000cb3 c0000000013366f8 c0000005b574b840
> NIP [c0000000005bb280] crypto_remove_spawns+0x70/0x2e0
> LR [c0000000005bc108] crypto_unregister_instance+0x58/0xa0
> Call Trace:
> [c0000005b574b820] [000000000000000c] 0xc (unreliable)
> [c0000005b574b890] [fffffffffffff000] 0xfffffffffffff000
> [c0000005b574b8d0] [c0080000048811c4] crypto_del_alg+0xdc/0x110 [crypto_user]
> [c0000005b574b900] [c0080000048802b8] crypto_user_rcv_msg+0xe0/0x270 [crypto_user]
> [c0000005b574ba00] [c00000000095d8e4] netlink_rcv_skb+0x84/0x1a0
> [c0000005b574ba70] [c008000004880074] crypto_netlink_rcv+0x4c/0x80 [crypto_user]
> [c0000005b574baa0] [c00000000095ce1c] netlink_unicast+0x1dc/0x2a0
> [c0000005b574bb00] [c00000000095d25c] netlink_sendmsg+0x20c/0x430
> [c0000005b574bba0] [c0000000008a09d0] sock_sendmsg+0x60/0x90
> [c0000005b574bbd0] [c0000000008a151c] ___sys_sendmsg+0x31c/0x370
> [c0000005b574bd80] [c0000000008a320c] __sys_sendmsg+0x6c/0xe0
> [c0000005b574be20] [c00000000000b688] system_call+0x5c/0x70
> Instruction dump:
> e9030010 83a90020 39610040 fbe10020 fbe10028 f8c10030 f8c10038 f9610040
> f9610048 39830010 7c2c4040 7d074378 <e9480000> 41820060 60000000 60000000
> ---[ end trace 4ff8403d5fbae222 ]---
> 
> Attaching config and dmesg.
> 

Thanks, I was able to reproduce this, and I came up with a different fix.

I sent it out, but for some reason it doesn't seem to have reached any of the
lists...  If I still don't see after a little while, I'll resend it.

- Eric
