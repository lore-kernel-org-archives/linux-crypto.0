Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D5AEB64D9
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jul 2023 13:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjGDNcI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jul 2023 09:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjGDNcH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jul 2023 09:32:07 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7C299
        for <linux-crypto@vger.kernel.org>; Tue,  4 Jul 2023 06:32:05 -0700 (PDT)
Received: from fsav117.sakura.ne.jp (fsav117.sakura.ne.jp [27.133.134.244])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 364DW3ck081698;
        Tue, 4 Jul 2023 22:32:03 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav117.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav117.sakura.ne.jp);
 Tue, 04 Jul 2023 22:32:03 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav117.sakura.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 364DW2AB081685
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 4 Jul 2023 22:32:02 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <35970e3b-8142-8e00-c12a-da8c6925c12c@I-love.SAKURA.ne.jp>
Date:   Tue, 4 Jul 2023 22:32:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] net: tls: enable __GFP_ZERO upon tls_init()
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Alexander Potapenko <glider@google.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+828dfc12440b4f6f305d@syzkaller.appspotmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <0000000000008a7ae505aef61db1@google.com>
 <20200911170150.GA889@sol.localdomain>
 <c16e9ab9-13e0-b911-e33a-c9ae81e93a8d@I-love.SAKURA.ne.jp>
 <CAMj1kXFqYozjJ+qPeSApESb0Cb6CUaGXBrs5LP81ERRvb3+TAw@mail.gmail.com>
 <59e1d5c0-aedb-7b5b-f37f-0c20185d7e9b@I-love.SAKURA.ne.jp>
 <CAMj1kXGHRUUFYL09Lm-mO6MfGc19rC=-7mSJ1eDTcbw7QuEkaw@mail.gmail.com>
 <CAG_fn=X+eU=-WLXASidBCHWS3L7RvtN=mx3Bj8GD9GcA=Htf2w@mail.gmail.com>
 <CAMj1kXFrsc7bsjo2i0=9AqVNSCvXEnYAukzoXeaYEH9EpNviBA@mail.gmail.com>
 <CAG_fn=VFa2yeiZmdyuVRmZYtWn6Tkox8UVrOrCv4tEec3BFYbQ@mail.gmail.com>
 <CAMj1kXEdwjN7Q8tKVxHz98zQ4EsWVSdLZ5tQaV-nXxc9hwRYjQ@mail.gmail.com>
 <CAG_fn=UWZWc+FZ_shCr+T9Y3gV9Bue-ZFHKJj78YXBq3JfnUKA@mail.gmail.com>
 <CAMj1kXE_PjQT6+A9a0Y=ZfbOr_H+umYSqHuRrM6AT_gFJxxP1w@mail.gmail.com>
 <8c989395-0f20-a957-6611-8a356badcf3c@I-love.SAKURA.ne.jp>
In-Reply-To: <8c989395-0f20-a957-6611-8a356badcf3c@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2023/07/01 13:12, Tetsuo Handa wrote:
> Then, where does the difference between
> 
> ----------------------------------------
> [  162.919587][ T3399] required_size=10653 ret=0
> [  162.923090][ T3399] required_size=14749 ret=0
> [  162.928686][ T3399] required_size=16413 ret=0
> ----------------------------------------
> 
> and
> 
> ----------------------------------------
> [  162.992866][ T3399] required_size=10653 ret=0
> [  162.999962][ T3399] required_size=14765 ret=0
> [  163.006420][ T3399] required_size=16413 ret=0
> ----------------------------------------
> 
> come from? Both output had the same values until 10653, but
> the next value differs by 16. This might suggest that a race between
> splice() and sendmsg() caused unexpected required_size= value...
> 

I found a simplified reproducer.
This problem happens when splice() and sendmsg() run in parallel.

----------------------------------------
#define _GNU_SOURCE
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <sys/poll.h>
#define SOL_TCP 6
#define TCP_REPAIR 19
#define TCP_ULP 31
#define TLS_TX 1

int main(int argc, char *argv[])
{
	struct iovec iov = {
		.iov_base = "@@@@@@@@@@@@@@@@",
		.iov_len = 16
	};
	struct msghdr hdr = {
		.msg_iov = &iov,
		.msg_iovlen = 1,
		.msg_flags = MSG_FASTOPEN
	};
	const struct sockaddr_in6 addr = { .sin6_family = AF_INET6, .sin6_addr = in6addr_loopback };
	const int one = 1;
	int ret_ignored = 0;
	const int fd = socket(PF_INET6, SOCK_STREAM, IPPROTO_IP);
	int pipe_fds[2] = { -1, -1 };
	static char buf[32768] = { };

	ret_ignored += pipe(pipe_fds);
	setsockopt(fd, SOL_TCP, TCP_REPAIR, &one, sizeof(one));
	connect(fd, (struct sockaddr *) &addr, sizeof(addr));
	setsockopt(fd, SOL_TCP, TCP_ULP, "tls", 4);
	setsockopt(fd, SOL_TLS, TLS_TX,"\3\0035\0%T\244\205\333\f0\362B\221\243\234\206\216\220\243u\347\342P|1\24}Q@\377\227\353\222B\354\264u[\346", 40);
	if (fork() == 0) {
		ret_ignored += splice(pipe_fds[0], NULL, fd, NULL, 1048576, SPLICE_F_MORE);
		_exit(0);
	}
	close(pipe_fds[0]);
	ret_ignored += write(pipe_fds[1], buf, sizeof(buf));
	poll(NULL, 0, 1);
	ret_ignored += sendmsg(fd, &hdr, MSG_DONTWAIT | MSG_MORE);
	return ret_ignored * 0;
}
----------------------------------------

Debug printk() patch and output are shown below.

----------------------------------------
diff --git a/net/core/sock.c b/net/core/sock.c
index 24f2761bdb1d..879c1d54deed 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2825,6 +2825,14 @@ static void sk_leave_memory_pressure(struct sock *sk)
 
 DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
 
+static inline char *kaddr(struct page *page)
+{
+	char *kaddr = kmap_atomic(page);
+
+	kunmap_atomic(kaddr);
+	return kaddr;
+}
+
 /**
  * skb_page_frag_refill - check that a page_frag contains enough room
  * @sz: minimum size of the fragment we want to get
@@ -2840,10 +2848,17 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
 	if (pfrag->page) {
 		if (page_ref_count(pfrag->page) == 1) {
 			pfrag->offset = 0;
+			if (current->comm[0] && !strcmp(current->comm + 1, ".out")) {
+				pr_info("assigned %px\n", kaddr(pfrag->page));
+			}
 			return true;
 		}
-		if (pfrag->offset + sz <= pfrag->size)
+		if (pfrag->offset + sz <= pfrag->size) {
+			if (current->comm[0] && !strcmp(current->comm + 1, ".out")) {
+				pr_info("assigned %d from %px\n", sz, kaddr(pfrag->page) + pfrag->offset);
+			}
 			return true;
+		}
 		put_page(pfrag->page);
 	}
 
@@ -2856,12 +2871,18 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
 					  __GFP_NORETRY,
 					  SKB_FRAG_PAGE_ORDER);
 		if (likely(pfrag->page)) {
+			if (current->comm[0] && !strcmp(current->comm + 1, ".out")) {
+				pr_info("allocated %px\n", kaddr(pfrag->page));
+			}
 			pfrag->size = PAGE_SIZE << SKB_FRAG_PAGE_ORDER;
 			return true;
 		}
 	}
 	pfrag->page = alloc_page(gfp);
 	if (likely(pfrag->page)) {
+		if (current->comm[0] && !strcmp(current->comm + 1, ".out")) {
+			pr_info("allocated %px\n", kaddr(pfrag->page));
+		}
 		pfrag->size = PAGE_SIZE;
 		return true;
 	}
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 1a53c8f481e9..dcf00d1f239f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -543,6 +543,22 @@ static int tls_do_encryption(struct sock *sk,
 	list_add_tail((struct list_head *)&rec->list, &ctx->tx_list);
 	atomic_inc(&ctx->encrypt_pending);
 
+	{
+		int len = aead_req->assoclen + aead_req->cryptlen;
+		struct sg_mapping_iter miter;
+
+		sg_miter_start(&miter, rec->sg_aead_in,
+			       sg_nents(rec->sg_aead_in),
+			       SG_MITER_TO_SG | SG_MITER_ATOMIC);
+
+		while (len > 0 && sg_miter_next(&miter)) {
+			pr_info("addr=%px len=%d\n", miter.addr, min(len, (int)miter.length));
+			kmsan_check_memory(miter.addr, min(len, (int)miter.length));
+			len -= miter.length;
+		}
+		sg_miter_stop(&miter);
+	}
+
 	rc = crypto_aead_encrypt(aead_req);
 	if (!rc || rc != -EINPROGRESS) {
 		atomic_dec(&ctx->encrypt_pending);
@@ -1211,6 +1227,7 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 			goto wait_for_sndbuf;
 alloc_payload:
 		ret = tls_alloc_encrypted_msg(sk, required_size);
+		pr_info("required_size=%d ret=%d\n", required_size, ret);
 		if (ret) {
 			if (ret != -ENOSPC)
 				goto wait_for_memory;
@@ -1232,6 +1249,8 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 
 		tls_ctx->pending_open_record_frags = true;
 		if (full_record || eor || sk_msg_full(msg_pl)) {
+			pr_info("full_record=%d eor=%d sk_msg_full(msg_pl)=%d copied=%d\n",
+				full_record, eor, sk_msg_full(msg_pl), copied);
 			ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
 						  record_type, &copied, flags);
 			if (ret) {
----------------------------------------

skb_page_frag_refill() assigned  32 bytes from ffff88810d40901d
but tls_do_encryption() accesses 16 bytes from ffff88810d40900d !?

----------------------------------------
[  159.777428][ T3405] sock: allocated ffff88810d408000
[  159.792685][ T3405] required_size=4125 ret=0
[  159.802047][ T3395] sock: allocated ffff88810b000000
[  159.799656][ T3405] sock: assigned 32 from ffff88810d40901d
[  159.828229][ T3405] required_size=8237 ret=0
[  159.848161][ T3405] sock: assigned 32 from ffff88810d40a01d
[  159.849298][ T3405] required_size=12333 ret=0
[  159.849382][ T3405] sock: assigned 32 from ffff88810d40b01d
[  159.849416][ T3405] required_size=16413 ret=0
[  159.849434][ T3405] full_record=1 eor=0 sk_msg_full(msg_pl)=0 copied=4080
[  159.849472][ T3405] addr=ffff888115aa4658 len=13
[  159.849492][ T3405] addr=ffff88811da48000 len=4096
[  159.849513][ T3405] addr=ffff88810d40900d len=16
[  159.849530][ T3405] =====================================================
[  159.849618][ T3405] BUG: KMSAN: uninit-value in tls_push_record+0x2cff/0x4040
[  159.849654][ T3405]  tls_push_record+0x2cff/0x4040
[  159.849686][ T3405]  bpf_exec_tx_verdict+0x5ba/0x2530
[  159.849715][ T3405]  tls_sw_do_sendpage+0x1779/0x21f0
[  159.849744][ T3405]  tls_sw_sendpage+0x247/0x2b0
[  159.849772][ T3405]  inet_sendpage+0x1de/0x2f0
[  159.849807][ T3405]  kernel_sendpage+0x4cc/0x940
[  159.849837][ T3405]  sock_sendpage+0x162/0x220
[  159.849864][ T3405]  pipe_to_sendpage+0x3df/0x4f0
[  159.849891][ T3405]  __splice_from_pipe+0x5c7/0x1010
[  159.849916][ T3405]  generic_splice_sendpage+0x1c6/0x2a0
[  159.849943][ T3405]  do_splice+0x26d8/0x32f0
[  159.849966][ T3405]  __se_sys_splice+0x81f/0xba0
[  159.849991][ T3405]  __x64_sys_splice+0x1a1/0x200
[  159.850016][ T3405]  do_syscall_64+0x41/0x90
[  159.850044][ T3405]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  159.850082][ T3405] 
[  159.850088][ T3405] Uninit was created at:
[  159.850136][ T3405]  __alloc_pages+0x925/0x1050
[  159.850171][ T3405]  alloc_pages+0xe30/0x11b0
[  159.850204][ T3405]  skb_page_frag_refill+0x539/0x1030
[  159.850238][ T3405]  sk_page_frag_refill+0xa2/0x1c0
[  159.850271][ T3405]  sk_msg_alloc+0x278/0x1560
[  159.850307][ T3405]  tls_sw_do_sendpage+0xbec/0x21f0
[  159.850336][ T3405]  tls_sw_sendpage+0x247/0x2b0
[  159.850363][ T3405]  inet_sendpage+0x1de/0x2f0
[  159.850392][ T3405]  kernel_sendpage+0x4cc/0x940
[  159.850418][ T3405]  sock_sendpage+0x162/0x220
[  159.850446][ T3405]  pipe_to_sendpage+0x3df/0x4f0
[  159.850470][ T3405]  __splice_from_pipe+0x5c7/0x1010
[  159.850495][ T3405]  generic_splice_sendpage+0x1c6/0x2a0
[  159.850522][ T3405]  do_splice+0x26d8/0x32f0
[  159.850545][ T3405]  __se_sys_splice+0x81f/0xba0
[  159.850570][ T3405]  __x64_sys_splice+0x1a1/0x200
[  159.850595][ T3405]  do_syscall_64+0x41/0x90
[  159.850619][ T3405]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  159.850654][ T3405] 
[  159.850659][ T3405] Bytes 0-15 of 16 are uninitialized
[  159.850672][ T3405] Memory access of size 16 starts at ffff88810d40900d
[  159.850685][ T3405] 
[  159.850694][ T3405] CPU: 2 PID: 3405 Comm: a.out Not tainted 6.4.0-rc7-ge6bc8833d80f-dirty #32
[  159.850725][ T3405] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  159.850741][ T3405] =====================================================
[  159.850749][ T3405] Disabling lock debugging due to kernel taint
[  159.850761][ T3405] Kernel panic - not syncing: kmsan.panic set ...
[  159.850774][ T3405] CPU: 2 PID: 3405 Comm: a.out Tainted: G    B              6.4.0-rc7-ge6bc8833d80f-dirty #32
[  159.850801][ T3405] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  159.850814][ T3405] Call Trace:
[  159.850824][ T3405]  <TASK>
[  159.850833][ T3405]  dump_stack_lvl+0x1f6/0x280
[  159.850863][ T3405]  dump_stack+0x29/0x30
[  159.850888][ T3405]  panic+0x4e7/0xc60
[  159.850928][ T3405]  ? add_taint+0x185/0x210
[  159.850969][ T3405]  kmsan_report+0x2d1/0x2e0
[  159.851008][ T3405]  ? kmsan_internal_unpoison_memory+0x14/0x20
[  159.851048][ T3405]  ? __msan_metadata_ptr_for_load_4+0x24/0x40
[  159.851089][ T3405]  ? kmsan_internal_check_memory+0x47d/0x540
[  159.851128][ T3405]  ? kmsan_check_memory+0x1a/0x20
[  159.851166][ T3405]  ? tls_push_record+0x2cff/0x4040
[  159.851197][ T3405]  ? bpf_exec_tx_verdict+0x5ba/0x2530
[  159.851228][ T3405]  ? tls_sw_do_sendpage+0x1779/0x21f0
[  159.851258][ T3405]  ? tls_sw_sendpage+0x247/0x2b0
[  159.851288][ T3405]  ? inet_sendpage+0x1de/0x2f0
[  159.851318][ T3405]  ? kernel_sendpage+0x4cc/0x940
[  159.851346][ T3405]  ? sock_sendpage+0x162/0x220
[  159.851374][ T3405]  ? pipe_to_sendpage+0x3df/0x4f0
[  159.851399][ T3405]  ? __splice_from_pipe+0x5c7/0x1010
[  159.851427][ T3405]  ? generic_splice_sendpage+0x1c6/0x2a0
[  159.851455][ T3405]  ? do_splice+0x26d8/0x32f0
[  159.851479][ T3405]  ? __se_sys_splice+0x81f/0xba0
[  159.851506][ T3405]  ? __x64_sys_splice+0x1a1/0x200
[  159.851532][ T3405]  ? do_syscall_64+0x41/0x90
[  159.851557][ T3405]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  159.851598][ T3405]  ? vprintk_default+0x8a/0xa0
[  159.851634][ T3405]  ? vprintk+0x163/0x180
[  159.851669][ T3405]  ? _printk+0x181/0x1b0
[  159.851706][ T3405]  kmsan_internal_check_memory+0x47d/0x540
[  159.851748][ T3405]  ? kmsan_get_shadow_origin_ptr+0x4d/0xa0
[  159.851790][ T3405]  kmsan_check_memory+0x1a/0x20
[  159.851828][ T3405]  tls_push_record+0x2cff/0x4040
[  159.851873][ T3405]  bpf_exec_tx_verdict+0x5ba/0x2530
[  159.851926][ T3405]  ? _printk+0x181/0x1b0
[  159.851965][ T3405]  ? tls_sw_do_sendpage+0xbd1/0x21f0
[  159.851998][ T3405]  tls_sw_do_sendpage+0x1779/0x21f0
[  159.852045][ T3405]  tls_sw_sendpage+0x247/0x2b0
[  159.852078][ T3405]  ? tls_sw_do_sendpage+0x21f0/0x21f0
[  159.852110][ T3405]  inet_sendpage+0x1de/0x2f0
[  159.852143][ T3405]  ? inet_sendmsg+0x1d0/0x1d0
[  159.852173][ T3405]  kernel_sendpage+0x4cc/0x940
[  159.852206][ T3405]  sock_sendpage+0x162/0x220
[  159.852238][ T3405]  pipe_to_sendpage+0x3df/0x4f0
[  159.852264][ T3405]  ? sock_fasync+0x240/0x240
[  159.852296][ T3405]  __splice_from_pipe+0x5c7/0x1010
[  159.852324][ T3405]  ? generic_splice_sendpage+0x2a0/0x2a0
[  159.852360][ T3405]  generic_splice_sendpage+0x1c6/0x2a0
[  159.852393][ T3405]  ? iter_file_splice_write+0x1a30/0x1a30
[  159.852421][ T3405]  do_splice+0x26d8/0x32f0
[  159.852446][ T3405]  ? kmsan_internal_set_shadow_origin+0x66/0xe0
[  159.852487][ T3405]  ? _raw_spin_lock_irqsave+0x91/0x110
[  159.852527][ T3405]  ? kmsan_get_shadow_origin_ptr+0x4d/0xa0
[  159.852567][ T3405]  ? _raw_spin_lock_irqsave+0x91/0x110
[  159.852606][ T3405]  ? _raw_spin_unlock_irqrestore+0x76/0xb0
[  159.852652][ T3405]  __se_sys_splice+0x81f/0xba0
[  159.852696][ T3405]  __x64_sys_splice+0x1a1/0x200
[  159.852735][ T3405]  do_syscall_64+0x41/0x90
[  159.852767][ T3405]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  159.852813][ T3405] RIP: 0033:0x7f5a347261aa
[  159.852840][ T3405] Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e fa 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 13 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 7e c3 0f 1f 44 00 00 41 54 48 83 ec 30 44 89
[  159.852873][ T3405] RSP: 002b:00007ffe1b674588 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
[  159.852905][ T3405] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f5a347261aa
[  159.852926][ T3405] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000004
[  159.852942][ T3405] RBP: 0000000000000001 R08: 0000000000100000 R09: 0000000000000004
[  159.852959][ T3405] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
[  159.852975][ T3405] R13: 000055675f9631c0 R14: 000055675f965d58 R15: 00007f5a348e8040
[  159.853001][ T3405]  </TASK>
[  159.858725][ T3405] Kernel Offset: disabled
[  159.858725][ T3405] Rebooting in 10 seconds..
----------------------------------------


