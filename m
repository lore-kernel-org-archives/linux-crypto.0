Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A67BAEB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 11:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbjF3LMK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 07:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbjF3LL6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 07:11:58 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C043C35
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 04:11:34 -0700 (PDT)
Received: from fsav116.sakura.ne.jp (fsav116.sakura.ne.jp [27.133.134.243])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 35UBBXQh053897;
        Fri, 30 Jun 2023 20:11:33 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav116.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav116.sakura.ne.jp);
 Fri, 30 Jun 2023 20:11:33 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav116.sakura.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 35UBBWCA053892
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 30 Jun 2023 20:11:32 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <f5c2d592-4b97-93f8-b62e-402eeeaa70d9@I-love.SAKURA.ne.jp>
Date:   Fri, 30 Jun 2023 20:11:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] net: tls: enable __GFP_ZERO upon tls_init()
Content-Language: en-US
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
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CAMj1kXFrsc7bsjo2i0=9AqVNSCvXEnYAukzoXeaYEH9EpNviBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2023/06/30 19:18, Ard Biesheuvel wrote:
> On Fri, 30 Jun 2023 at 12:11, Alexander Potapenko <glider@google.com> wrote:
>>
>> On Fri, Jun 30, 2023 at 12:02 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>>>
>>> On Fri, 30 Jun 2023 at 11:53, Tetsuo Handa
>>> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>>>>
>>>> On 2023/06/30 18:36, Ard Biesheuvel wrote:
>>>>> Why are you sending this now?
>>>>
>>>> Just because this is currently top crasher and I can reproduce locally.
>>>>
>>>>> Do you have a reproducer for this issue?
>>>>
>>>> Yes. https://syzkaller.appspot.com/text?tag=ReproC&x=12931621900000 works.
>>>>
>>>
>>> Could you please share your kernel config and the resulting kernel log
>>> when running the reproducer? I'll try to reproduce locally as well,
>>> and see if I can figure out what is going on in the crypto layer
>>
>> The config together with the repro is available at
>> https://syzkaller.appspot.com/bug?extid=828dfc12440b4f6f305d, see the
>> latest row of the "Crashes" table that contains a C repro.

Kernel is commit e6bc8833d80f of https://github.com/google/kmsan/commits/master .
Config is available in the dashboard page, but a smaller one is available at
https://I-love.SAKURA.ne.jp/tmp/config-6.4.0-rc7-kmsan .

I'm using a debug printk() patch shown below.

----------------------------------------
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 1a53c8f481e9..b32bb015995c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1210,7 +1210,8 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 		if (!sk_stream_memory_free(sk))
 			goto wait_for_sndbuf;
 alloc_payload:
-		ret = tls_alloc_encrypted_msg(sk, required_size);
+		ret = tls_alloc_encrypted_msg(sk, required_size); /////
+		pr_info("required_size=%d ret=%d\n", required_size, ret);
 		if (ret) {
 			if (ret != -ENOSPC)
 				goto wait_for_memory;
@@ -1232,7 +1233,9 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 
 		tls_ctx->pending_open_record_frags = true;
 		if (full_record || eor || sk_msg_full(msg_pl)) {
-			ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
+			pr_info("full_record=%d eor=%d sk_msg_full(msg_pl)=%d copied=%d\n",
+				full_record, eor, sk_msg_full(msg_pl), copied);
+			ret = bpf_exec_tx_verdict(msg_pl, sk, full_record, /////
 						  record_type, &copied, flags);
 			if (ret) {
 				if (ret == -EINPROGRESS)
----------------------------------------

Output (on Ubuntu 22.04 on Oracle VM VirtualBox) is shown below.
Please check tendency of the sum of required_size= values up to the full_record= line.
It seems that the value of required_size= might vary depending on the timings, but
the sum of the values seems to have some rule.

  4125+8221+12317+16413=41076 (the lower 4 bits are 0100)
  2461+6557+10653+14749+16413=50833 (the lower 4 bits are 0001)
  2461+6573+10669+14765+16413=50881 (the lower 4 bits are 0001)

KMSAN reports this problem when the lower 4 bits became 0001 for the second time.
Unless KMSAN's reporting is asynchronous, maybe the reason of "for the second time"
part is that the previous state is relevant...

----------------------------------------
[  157.471712][ T3414] required_size=4125 ret=0
[  157.475879][ T3414] required_size=8221 ret=0
[  157.480471][ T3414] required_size=12317 ret=0
[  157.484604][ T3414] required_size=16413 ret=0
[  157.490499][ T3414] full_record=1 eor=0 sk_msg_full(msg_pl)=0 copied=4096
[  157.513772][ T3414] required_size=4125 ret=0
[  157.523782][ T3414] required_size=8221 ret=0
[  157.533658][ T3414] required_size=12317 ret=0
[  157.539579][ T3414] required_size=16413 ret=0
[  157.543785][ T3414] full_record=1 eor=0 sk_msg_full(msg_pl)=0 copied=4096
[  157.572869][ T3414] required_size=4125 ret=0
[  157.579350][ T3414] required_size=8221 ret=0
[  157.584699][ T3414] required_size=12317 ret=0
[  157.591756][ T3414] required_size=16413 ret=0
[  157.595891][ T3414] full_record=1 eor=0 sk_msg_full(msg_pl)=0 copied=4096
[  157.790734][ T3424] required_size=2461 ret=0
[  157.800725][ T3424] required_size=6557 ret=0
[  157.804560][ T3424] required_size=10653 ret=0
[  157.808433][ T3424] required_size=14749 ret=0
[  157.810125][ T3424] required_size=16413 ret=0
[  157.829564][ T3424] full_record=1 eor=0 sk_msg_full(msg_pl)=0 copied=1664
[  157.848397][ T3424] required_size=2461 ret=0
[  157.854875][ T3424] required_size=6573 ret=0
[  157.860883][ T3424] required_size=10669 ret=0
[  157.865463][ T3424] required_size=14765 ret=0
[  157.871794][ T3424] required_size=16413 ret=0
[  157.877333][ T3424] full_record=1 eor=0 sk_msg_full(msg_pl)=0 copied=1648
[  157.885187][ T3424] =====================================================
[  157.887262][ T3424] BUG: KMSAN: uninit-value in aes_encrypt+0x1692/0x1fa0
[  157.887262][ T3424]  aes_encrypt+0x1692/0x1fa0
[  157.887262][ T3424]  aesti_encrypt+0xe1/0x160
[  157.887262][ T3424]  crypto_cipher_encrypt_one+0x1d1/0x2e0
[  157.887262][ T3424]  crypto_cbcmac_digest_update+0x3ff/0x5a0
[  157.887262][ T3424]  shash_ahash_finup+0x79d/0xd00
[  157.887262][ T3424]  shash_async_finup+0xbf/0x110
[  157.887262][ T3424]  crypto_ahash_finup+0x244/0x500
[  157.887262][ T3424]  crypto_ccm_auth+0x14df/0x15a0
[  157.887262][ T3424]  crypto_ccm_encrypt+0x2ad/0x8b0
[  157.887262][ T3424]  crypto_aead_encrypt+0x116/0x1a0
[  157.887262][ T3424]  tls_push_record+0x2bbe/0x3bf0
[  157.887262][ T3424]  bpf_exec_tx_verdict+0x5ba/0x2530
[  157.887262][ T3424]  tls_sw_do_sendpage+0x1779/0x21f0
[  157.887262][ T3424]  tls_sw_sendpage+0x247/0x2b0
[  157.887262][ T3424]  inet_sendpage+0x1de/0x2f0
[  157.887262][ T3424]  kernel_sendpage+0x4cc/0x940
[  158.004827][ T3424]  sock_sendpage+0x162/0x220
[  158.004827][ T3424]  pipe_to_sendpage+0x3df/0x4f0
[  158.004827][ T3424]  __splice_from_pipe+0x5c7/0x1010
[  158.004827][ T3424]  generic_splice_sendpage+0x1c6/0x2a0
[  158.004827][ T3424]  do_splice+0x26d8/0x32f0
[  158.004827][ T3424]  __se_sys_splice+0x81f/0xba0
[  158.004827][ T3424]  __x64_sys_splice+0x1a1/0x200
[  158.004827][ T3424]  do_syscall_64+0x41/0x90
[  158.004827][ T3424]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  158.004827][ T3424] 
[  158.004827][ T3424] Uninit was stored to memory at:
[  158.004827][ T3424]  __crypto_xor+0x285/0x1700
[  158.004827][ T3424]  crypto_cbcmac_digest_update+0x2ba/0x5a0
[  158.004827][ T3424]  shash_ahash_finup+0x79d/0xd00
[  158.004827][ T3424]  shash_async_finup+0xbf/0x110
[  158.004827][ T3424]  crypto_ahash_finup+0x244/0x500
[  158.004827][ T3424]  crypto_ccm_auth+0x14df/0x15a0
[  158.004827][ T3424]  crypto_ccm_encrypt+0x2ad/0x8b0
[  158.004827][ T3424]  crypto_aead_encrypt+0x116/0x1a0
[  158.004827][ T3424]  tls_push_record+0x2bbe/0x3bf0
[  158.004827][ T3424]  bpf_exec_tx_verdict+0x5ba/0x2530
[  158.004827][ T3424]  tls_sw_do_sendpage+0x1779/0x21f0
[  158.004827][ T3424]  tls_sw_sendpage+0x247/0x2b0
[  158.004827][ T3424]  inet_sendpage+0x1de/0x2f0
[  158.004827][ T3424]  kernel_sendpage+0x4cc/0x940
[  158.004827][ T3424]  sock_sendpage+0x162/0x220
[  158.004827][ T3424]  pipe_to_sendpage+0x3df/0x4f0
[  158.004827][ T3424]  __splice_from_pipe+0x5c7/0x1010
[  158.004827][ T3424]  generic_splice_sendpage+0x1c6/0x2a0
[  158.004827][ T3424]  do_splice+0x26d8/0x32f0
[  158.004827][ T3424]  __se_sys_splice+0x81f/0xba0
[  158.004827][ T3424]  __x64_sys_splice+0x1a1/0x200
[  158.004827][ T3424]  do_syscall_64+0x41/0x90
[  158.004827][ T3424]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  158.004827][ T3424] 
[  158.004827][ T3424] Uninit was created at:
[  158.004827][ T3424]  __alloc_pages+0x925/0x1050
[  158.004827][ T3424]  alloc_pages+0xe30/0x11b0
[  158.004827][ T3424]  skb_page_frag_refill+0x362/0x910
[  158.004827][ T3424]  sk_page_frag_refill+0xa2/0x1c0
[  158.004827][ T3424]  sk_msg_alloc+0x278/0x1560
[  158.004827][ T3424]  tls_sw_do_sendpage+0xbec/0x21f0
[  158.004827][ T3424]  tls_sw_sendpage+0x247/0x2b0
[  158.004827][ T3424]  inet_sendpage+0x1de/0x2f0
[  158.004827][ T3424]  kernel_sendpage+0x4cc/0x940
[  158.004827][ T3424]  sock_sendpage+0x162/0x220
[  158.004827][ T3424]  pipe_to_sendpage+0x3df/0x4f0
[  158.004827][ T3424]  __splice_from_pipe+0x5c7/0x1010
[  158.004827][ T3424]  generic_splice_sendpage+0x1c6/0x2a0
[  158.260226][ T3424]  do_splice+0x26d8/0x32f0
[  158.260226][ T3424]  __se_sys_splice+0x81f/0xba0
[  158.260226][ T3424]  __x64_sys_splice+0x1a1/0x200
[  158.260226][ T3424]  do_syscall_64+0x41/0x90
[  158.260226][ T3424]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  158.260226][ T3424] 
[  158.260226][ T3424] CPU: 7 PID: 3424 Comm: a.out Not tainted 6.4.0-rc7-ge6bc8833d80f-dirty #26
[  158.260226][ T3424] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  158.260226][ T3424] =====================================================
[  158.260226][ T3424] Disabling lock debugging due to kernel taint
[  158.260226][ T3424] Kernel panic - not syncing: kmsan.panic set ...
[  158.260226][ T3424] CPU: 7 PID: 3424 Comm: a.out Tainted: G    B              6.4.0-rc7-ge6bc8833d80f-dirty #26
[  158.320898][ T3424] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  158.334186][ T3424] Call Trace:
[  158.334186][ T3424]  <TASK>
[  158.334186][ T3424]  dump_stack_lvl+0x1f6/0x280
[  158.334186][ T3424]  dump_stack+0x29/0x30
[  158.334186][ T3424]  panic+0x4e7/0xc60
[  158.334186][ T3424]  ? add_taint+0x185/0x210
[  158.334186][ T3424]  kmsan_report+0x2d1/0x2e0
[  158.334186][ T3424]  ? __msan_warning+0x98/0x120
[  158.334186][ T3424]  ? aes_encrypt+0x1692/0x1fa0
[  158.334186][ T3424]  ? aesti_encrypt+0xe1/0x160
[  158.334186][ T3424]  ? crypto_cipher_encrypt_one+0x1d1/0x2e0
[  158.334186][ T3424]  ? crypto_cbcmac_digest_update+0x3ff/0x5a0
[  158.334186][ T3424]  ? shash_ahash_finup+0x79d/0xd00
[  158.334186][ T3424]  ? shash_async_finup+0xbf/0x110
[  158.334186][ T3424]  ? crypto_ahash_finup+0x244/0x500
[  158.334186][ T3424]  ? crypto_ccm_auth+0x14df/0x15a0
[  158.334186][ T3424]  ? crypto_ccm_encrypt+0x2ad/0x8b0
[  158.334186][ T3424]  ? crypto_aead_encrypt+0x116/0x1a0
[  158.334186][ T3424]  ? tls_push_record+0x2bbe/0x3bf0
[  158.334186][ T3424]  ? bpf_exec_tx_verdict+0x5ba/0x2530
[  158.334186][ T3424]  ? tls_sw_do_sendpage+0x1779/0x21f0
[  158.334186][ T3424]  ? tls_sw_sendpage+0x247/0x2b0
[  158.334186][ T3424]  ? inet_sendpage+0x1de/0x2f0
[  158.334186][ T3424]  ? kernel_sendpage+0x4cc/0x940
[  158.334186][ T3424]  ? sock_sendpage+0x162/0x220
[  158.334186][ T3424]  ? pipe_to_sendpage+0x3df/0x4f0
[  158.334186][ T3424]  ? __splice_from_pipe+0x5c7/0x1010
[  158.334186][ T3424]  ? generic_splice_sendpage+0x1c6/0x2a0
[  158.334186][ T3424]  ? do_splice+0x26d8/0x32f0
[  158.334186][ T3424]  ? __se_sys_splice+0x81f/0xba0
[  158.334186][ T3424]  ? __x64_sys_splice+0x1a1/0x200
[  158.334186][ T3424]  ? do_syscall_64+0x41/0x90
[  158.334186][ T3424]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  158.334186][ T3424]  ? filter_irq_stacks+0xb9/0x230
[  158.334186][ T3424]  ? __stack_depot_save+0x22/0x490
[  158.334186][ T3424]  ? kmsan_internal_set_shadow_origin+0x66/0xe0
[  158.334186][ T3424]  ? kmsan_internal_chain_origin+0x110/0x120
[  158.334186][ T3424]  ? kmsan_get_shadow_origin_ptr+0x4d/0xa0
[  158.334186][ T3424]  __msan_warning+0x98/0x120
[  158.334186][ T3424]  aes_encrypt+0x1692/0x1fa0
[  158.334186][ T3424]  aesti_encrypt+0xe1/0x160
[  158.334186][ T3424]  crypto_cipher_encrypt_one+0x1d1/0x2e0
[  158.334186][ T3424]  ? aesti_set_key+0xb0/0xb0
[  158.334186][ T3424]  ? kmsan_get_shadow_origin_ptr+0x4d/0xa0
[  158.334186][ T3424]  crypto_cbcmac_digest_update+0x3ff/0x5a0
[  158.334186][ T3424]  ? crypto_cbcmac_digest_init+0x140/0x140
[  158.334186][ T3424]  shash_ahash_finup+0x79d/0xd00
[  158.334186][ T3424]  ? kmsan_get_shadow_origin_ptr+0x4d/0xa0
[  158.334186][ T3424]  shash_async_finup+0xbf/0x110
[  158.334186][ T3424]  crypto_ahash_finup+0x244/0x500
[  158.334186][ T3424]  ? shash_async_final+0x3d0/0x3d0
[  158.334186][ T3424]  crypto_ccm_auth+0x14df/0x15a0
[  158.334186][ T3424]  crypto_ccm_encrypt+0x2ad/0x8b0
[  158.334186][ T3424]  ? kmsan_get_shadow_origin_ptr+0x4d/0xa0
[  158.334186][ T3424]  ? crypto_ccm_setauthsize+0x100/0x100
[  158.334186][ T3424]  crypto_aead_encrypt+0x116/0x1a0
[  158.653332][ T3424]  tls_push_record+0x2bbe/0x3bf0
[  158.653332][ T3424]  bpf_exec_tx_verdict+0x5ba/0x2530
[  158.653332][ T3424]  ? _printk+0x181/0x1b0
[  158.653332][ T3424]  ? tls_sw_do_sendpage+0xc81/0x21f0
[  158.653332][ T3424]  tls_sw_do_sendpage+0x1779/0x21f0
[  158.653332][ T3424]  tls_sw_sendpage+0x247/0x2b0
[  158.653332][ T3424]  ? tls_sw_do_sendpage+0x21f0/0x21f0
[  158.653332][ T3424]  inet_sendpage+0x1de/0x2f0
[  158.653332][ T3424]  ? inet_sendmsg+0x1d0/0x1d0
[  158.653332][ T3424]  kernel_sendpage+0x4cc/0x940
[  158.653332][ T3424]  sock_sendpage+0x162/0x220
[  158.653332][ T3424]  pipe_to_sendpage+0x3df/0x4f0
[  158.653332][ T3424]  ? sock_fasync+0x240/0x240
[  158.653332][ T3424]  __splice_from_pipe+0x5c7/0x1010
[  158.653332][ T3424]  ? generic_splice_sendpage+0x2a0/0x2a0
[  158.653332][ T3424]  generic_splice_sendpage+0x1c6/0x2a0
[  158.653332][ T3424]  ? iter_file_splice_write+0x1a30/0x1a30
[  158.653332][ T3424]  do_splice+0x26d8/0x32f0
[  158.653332][ T3424]  ? kmsan_get_shadow_origin_ptr+0x4d/0xa0
[  158.653332][ T3424]  ? __se_sys_splice+0x292/0xba0
[  158.653332][ T3424]  ? __msan_metadata_ptr_for_load_8+0x24/0x40
[  158.653332][ T3424]  ? filter_irq_stacks+0xb9/0x230
[  158.653332][ T3424]  __se_sys_splice+0x81f/0xba0
[  158.870673][ T3424]  __x64_sys_splice+0x1a1/0x200
[  158.870673][ T3424]  do_syscall_64+0x41/0x90
[  158.870673][ T3424]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  158.870673][ T3424] RIP: 0033:0x7f6bbd51ea3d
[  158.895223][ T3424] Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c3 a3 0f 00 f7 d8 64 89 01 48
[  158.895223][ T3424] RSP: 002b:00007f6bbd731e08 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
[  158.895223][ T3424] RAX: ffffffffffffffda RBX: 000055ccd9ea6080 RCX: 00007f6bbd51ea3d
[  158.895223][ T3424] RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000003
[  158.895223][ T3424] RBP: 000055ccd9ea41f4 R08: 00080000fffffffc R09: 0000000000000000
[  158.895223][ T3424] R10: 0000000000000000 R11: 0000000000000246 R12: 0100000000000000
[  158.895223][ T3424] R13: e65b75b4ec4292eb R14: f2300cdb85a45425 R15: 000055ccd9ea6088
[  159.041467][ T3424]  </TASK>
[  159.041467][ T3424] Kernel Offset: disabled
[  159.041467][ T3424] Rebooting in 10 seconds..
----------------------------------------

> 
> Could you explain why that bug contains ~50 reports that seem entirely
> unrelated? AIUI, this actual issue has not been reproduced since
> 2020??

Multiple different bugs are reported as the same problem.
Reproducer is available for only bpf_exec_tx_verdict() one, and the reproducer still works.

> 
> 
>> Config: https://syzkaller.appspot.com/text?tag=KernelConfig&x=ee5f7a0b2e48ed66
>> Report: https://syzkaller.appspot.com/text?tag=CrashReport&x=1325260d900000
>> Syz repro: https://syzkaller.appspot.com/text?tag=ReproSyz&x=11af973e900000
>> C repro: https://syzkaller.appspot.com/text?tag=ReproC&x=163a1e45900000
>>
>> The bug is reproducible for me locally as well (and Tetsuo's patch
>> makes it disappear, although I have no opinion on its correctness).
> 
> What I'd like to do is run a kernel plus initrd locally in OVMF and
> reproduce the issue - can I do that without all the syzkaller
> machinery?

I'm using Ubuntu 22.04 on Oracle VM VirtualBox.
I don't know if this can be reproduced with kernel plus initrd only. But
since the C reproducer is standalone, syzkaller machinery is not involved.

